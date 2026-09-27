package com.noob_coder.priv_kit

import android.os.Handler
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.CoroutineStart
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import priv.kit.core.Privilege
import priv.kit.core.file.PrivilegeFile
import priv.kit.core.file.PrivilegeFileEntry
import priv.kit.core.file.PrivilegeFileMetadata
import java.io.Closeable
import java.io.InputStream
import java.io.OutputStream

/**
 * Bridges `priv.kit.core.file` to Dart.
 *
 * Most operations are synchronous Binder calls returning a scalar, so they map
 * one-to-one onto method calls. Streams and walks cannot cross the channel, so
 * streams are exposed through integer handles and walks through a per-walk
 * [EventChannel].
 */
internal class PrivKitFiles(
    private val messenger: BinaryMessenger,
    private val scope: CoroutineScope,
    private val mainHandler: Handler,
) {
    private class WalkEntry(
        val channel: EventChannel,
    ) {
        @Volatile
        var job: Job? = null
    }

    private val lock = Any()
    private val streams = HashMap<Int, Closeable>()
    private val walks = HashMap<String, WalkEntry>()
    private var nextHandle = 1

    fun handles(method: String): Boolean = method.startsWith("file")

    /**
     * Dispatches every `file*` method except [startWalk], which must run on the
     * main thread so its event channel is registered before Dart listens.
     */
    suspend fun invoke(
        method: String,
        call: MethodCall,
    ): Any? = withContext(Dispatchers.IO) {
        val file = { Privilege.file(call.requireString("path")) }
        when (method) {
            "fileMetadata" -> file().metadata(
                call.argument<Boolean>("followSymbolicLinks") ?: false,
            ).toMap()

            "fileExists" -> file().exists()
            "fileIsFile" -> file().isFile()
            "fileIsDirectory" -> file().isDirectory()
            "fileIsSymbolicLink" -> file().isSymbolicLink()
            "fileCanRead" -> file().canRead()
            "fileCanWrite" -> file().canWrite()
            "fileCanExecute" -> file().canExecute()
            "fileLength" -> file().length()
            "fileLastModified" -> file().lastModified()
            "fileCreateNewFile" -> file().createNewFile()
            "fileMkdir" -> file().mkdir()
            "fileMkdirs" -> file().mkdirs()
            "fileDelete" -> file().delete()
            "fileDeleteRecursively" -> file().deleteRecursively()
            "fileRenameTo" -> file().renameTo(destination(call))

            "fileReplaceAtomically" -> {
                file().replaceAtomically(destination(call))
                null
            }

            "fileOpenRead" -> openStream(file().openInputStream())

            "fileOpenWrite" -> openStream(
                file().openOutputStream(
                    append = call.argument<Boolean>("append") ?: false,
                    syncOnClose = call.argument<Boolean>("syncOnClose") ?: false,
                ),
            )

            "fileRead" -> readChunk(call)
            "fileWrite" -> writeChunk(call)
            "fileClose" -> closeStream(call)

            else -> throw IllegalArgumentException("Unknown file method: $method")
        }
    }

    /** Registers the walk's event channel; the traversal runs on subscribe. */
    fun startWalk(call: MethodCall) {
        val id = call.requireString("operationId")
        val path = call.requireString("path")
        val maxDepth = call.optionalInt("maxDepth")
        val globs = call.argument<List<String>>("skipDirectoryGlobs")
        val flushBatchSize = call.optionalInt("flushBatchSize")

        val channel = EventChannel(messenger, channelName(id))
        synchronized(lock) { walks[id] = WalkEntry(channel) }
        channel.setStreamHandler(
            WalkStreamHandler(id, path, maxDepth, globs, flushBatchSize),
        )
    }

    fun closeAll() {
        val openStreams = synchronized(lock) {
            streams.values.toList().also { streams.clear() }
        }
        openStreams.forEach { runCatching(it::close) }

        val entries = synchronized(lock) {
            walks.values.toList().also { walks.clear() }
        }
        entries.forEach { entry ->
            entry.job?.cancel()
            entry.channel.setStreamHandler(null)
        }
    }

    private fun destination(call: MethodCall): PrivilegeFile =
        Privilege.file(call.requireString("destination"))

    private fun openStream(stream: Closeable): Int = synchronized(lock) {
        val id = nextHandle++
        streams[id] = stream
        id
    }

    private fun readChunk(call: MethodCall): ByteArray {
        val stream = streamOf(call) as? InputStream
            ?: throw PrivKitNotFoundException("Handle is not open for reading")
        val maxBytes = call.optionalInt("maxBytes") ?: DEFAULT_READ_CHUNK_BYTES
        require(maxBytes > 0) { "maxBytes must be positive: $maxBytes" }
        val buffer = ByteArray(maxBytes)
        val count = stream.read(buffer)
        return if (count > 0) buffer.copyOf(count) else ByteArray(0)
    }

    private fun writeChunk(call: MethodCall): Any? {
        val stream = streamOf(call) as? OutputStream
            ?: throw PrivKitNotFoundException("Handle is not open for writing")
        val bytes = call.argument<ByteArray>("bytes")
            ?: throw IllegalArgumentException("bytes is required")
        stream.write(bytes)
        return null
    }

    private fun closeStream(call: MethodCall): Any? {
        val stream = synchronized(lock) { streams.remove(requireHandle(call)) }
        // OutputStream.close blocks until the server has consumed every byte
        // and closed the destination, which is why this runs on Dispatchers.IO.
        stream?.close()
        return null
    }

    private fun streamOf(call: MethodCall): Closeable {
        val handle = requireHandle(call)
        return synchronized(lock) { streams[handle] }
            ?: throw PrivKitNotFoundException("Unknown file stream handle: $handle")
    }

    private fun requireHandle(call: MethodCall): Int =
        call.optionalInt("handle")
            ?: throw IllegalArgumentException("handle is required")

    private inner class WalkStreamHandler(
        private val id: String,
        private val path: String,
        private val maxDepth: Int?,
        private val globs: List<String>?,
        private val flushBatchSize: Int?,
    ) : EventChannel.StreamHandler {
        override fun onListen(
            arguments: Any?,
            events: EventChannel.EventSink?,
        ) {
            val entry = synchronized(lock) { walks[id] }
            if (entry == null) {
                events?.error(
                    PrivKitErrorCodes.NOT_FOUND,
                    "No pending walk for id=$id",
                    null,
                )
                return
            }
            // LAZY so entry.job is assigned before the body can run.
            val job = scope.launch(start = CoroutineStart.LAZY) {
                try {
                    val file = Privilege.file(path)
                    val depth = maxDepth ?: Int.MAX_VALUE
                    val batch = flushBatchSize ?: DEFAULT_WALK_FLUSH_BATCH_SIZE
                    val flow = if (globs == null) {
                        file.walk(maxDepth = depth, flushBatchSize = batch)
                    } else {
                        file.walk(
                            skipDirectoryGlobs = globs,
                            maxDepth = depth,
                            flushBatchSize = batch,
                        )
                    }
                    flow.collect { item ->
                        // collect resumes on Dispatchers.IO, and EventSink must
                        // be driven from the main thread.
                        mainHandler.post { events?.success(item.toMap()) }
                    }
                    mainHandler.post { events?.endOfStream() }
                } catch (throwable: Throwable) {
                    if (throwable is CancellationException) throw throwable
                    val error = throwable.toPrivKitError()
                    mainHandler.post {
                        events?.error(error.code, error.message, error.details)
                    }
                } finally {
                    finishWalk(id)
                }
            }
            entry.job = job
            job.start()
        }

        override fun onCancel(arguments: Any?) {
            synchronized(lock) { walks.remove(id) }?.let { entry ->
                entry.job?.cancel()
                entry.channel.setStreamHandler(null)
            }
        }
    }

    private fun finishWalk(id: String) {
        synchronized(lock) { walks.remove(id) }?.channel?.setStreamHandler(null)
    }

    internal companion object {
        internal const val CHANNEL_PREFIX = "priv_kit/file_walk/"
        internal const val DEFAULT_READ_CHUNK_BYTES = 64 * 1024
        internal const val DEFAULT_WALK_FLUSH_BATCH_SIZE = 32

        internal fun channelName(id: String): String = "$CHANNEL_PREFIX$id"
    }
}

private fun PrivilegeFileMetadata.toMap(): Map<String, Any?> = mapOf(
    "absolutePath" to absolutePath,
    "sizeBytes" to sizeBytes,
    "lastModifiedMillis" to lastModifiedMillis,
    "unixMode" to unixMode,
    "uid" to uid,
    "gid" to gid,
    "type" to type.name,
)

private fun PrivilegeFileEntry.toMap(): Map<String, Any?> = mapOf(
    "absolutePath" to absolutePath,
    "depth" to depth,
    "metadata" to metadata?.toMap(),
)
