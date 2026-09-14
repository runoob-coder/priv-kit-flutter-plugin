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
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import priv.kit.core.Privilege
import priv.kit.core.command.PrivilegeCommand
import priv.kit.core.command.PrivilegeCommandEvent
import priv.kit.core.command.PrivilegeCommandProcess
import priv.kit.core.command.PrivilegeCommandResult

/**
 * Bridges `priv.kit.core.command` to Dart.
 *
 * `PrivilegeCommandProcess` allows exactly one output-consumption method per
 * process, so the two Dart entry points map onto the two native ones:
 * [run] uses `awaitResult`, and [start] plus a per-command [EventChannel] uses
 * `stream`.
 */
internal class PrivKitCommands(
    private val messenger: BinaryMessenger,
    private val scope: CoroutineScope,
    private val mainHandler: Handler,
) {
    private class Entry(
        val process: PrivilegeCommandProcess,
        val channel: EventChannel,
    ) {
        @Volatile
        var job: Job? = null
    }

    private val lock = Any()
    private val entries = HashMap<String, Entry>()

    /** Drains both streams and returns the bounded capture plus exit code. */
    suspend fun run(call: MethodCall): Map<String, Any?> {
        val process = startProcess(call)
        val maxBytes = call.optionalInt("maxBytesPerStream")
            ?: PrivilegeCommandProcess.DEFAULT_MAX_BYTES_PER_STREAM
        // awaitResult releases local resources on completion and cancels the
        // remote process when it does not, so no extra cleanup is needed here.
        return process.awaitResult(maxBytes).toMap()
    }

    /**
     * Starts a process for streaming consumption.
     *
     * Must be running on the main thread when the process starts, so the event
     * channel is registered before this call returns and Dart can subscribe
     * to it without racing the registration.
     */
    suspend fun start(call: MethodCall) {
        val id = call.requireString("commandId")
        val process = withContext(Dispatchers.IO) { startProcess(call) }
        val channel = EventChannel(messenger, channelName(id))
        val entry = Entry(process, channel)
        synchronized(lock) { entries[id] = entry }
        channel.setStreamHandler(CommandStreamHandler(id))
    }

    /** Cancels a running command, whether or not its stream was consumed. */
    fun cancel(id: String) {
        val entry = synchronized(lock) { entries.remove(id) } ?: return
        entry.job?.cancel()
        entry.process.cancel()
        entry.channel.setStreamHandler(null)
    }

    fun closeAll() {
        val snapshot = synchronized(lock) {
            val values = entries.values.toList()
            entries.clear()
            values
        }
        snapshot.forEach { entry ->
            entry.job?.cancel()
            entry.process.cancel()
            entry.channel.setStreamHandler(null)
        }
    }

    private suspend fun startProcess(call: MethodCall): PrivilegeCommandProcess {
        val arguments = call.argument<List<String>>("arguments").orEmpty()
        val rawEnvironment = call.argument<Map<String, Any?>>("environment").orEmpty()
        val environment = rawEnvironment.entries.associate { (key, value) ->
            key to value.toString()
        }
        val command = PrivilegeCommand(
            arguments = arguments,
            environment = environment,
            workingDirectory = call.argument<String>("workingDirectory"),
        )
        // A null timeout means "use the 30s default"; a negative one disables
        // the deadline, matching Privilege.startCommand(timeoutMillis = null).
        val timeoutMillis = call.argument<Number>("timeoutMillis")?.toLong()
        return when {
            timeoutMillis == null -> Privilege.startCommand(command)
            timeoutMillis < 0L -> Privilege.startCommand(command, null)
            else -> Privilege.startCommand(command, timeoutMillis)
        }
    }

    private fun finish(id: String) {
        val entry = synchronized(lock) { entries.remove(id) } ?: return
        entry.channel.setStreamHandler(null)
    }

    private inner class CommandStreamHandler(
        private val id: String,
    ) : EventChannel.StreamHandler {
        override fun onListen(
            arguments: Any?,
            events: EventChannel.EventSink?,
        ) {
            val entry = synchronized(lock) { entries[id] }
            if (entry == null) {
                events?.error(
                    PrivKitErrorCodes.NOT_FOUND,
                    "No running command for id=$id",
                    null,
                )
                return
            }
            // LAZY makes sure entry.job is assigned before the body can run.
            val job = scope.launch(start = CoroutineStart.LAZY) {
                try {
                    entry.process.stream().collect { event ->
                        mainHandler.post { events?.success(event.toMap()) }
                    }
                    mainHandler.post { events?.endOfStream() }
                } catch (throwable: Throwable) {
                    if (throwable is CancellationException) throw throwable
                    val error = throwable.toPrivKitError()
                    mainHandler.post {
                        events?.error(error.code, error.message, error.details)
                    }
                } finally {
                    entry.process.cancel()
                    mainHandler.post { finish(id) }
                }
            }
            entry.job = job
            job.start()
        }

        override fun onCancel(arguments: Any?) {
            cancel(id)
        }
    }

    internal companion object {
        internal const val CHANNEL_PREFIX = "priv_kit/command/"

        internal fun channelName(id: String): String = "$CHANNEL_PREFIX$id"
    }
}

private fun PrivilegeCommandResult.toMap(): Map<String, Any?> = mapOf(
    "exitCode" to exitCode,
    "stdout" to stdout,
    "stderr" to stderr,
    "stdoutTruncated" to stdoutTruncated,
    "stderrTruncated" to stderrTruncated,
)

private fun PrivilegeCommandEvent.toMap(): Map<String, Any?> = when (this) {
    is PrivilegeCommandEvent.Stdout -> mapOf(
        "type" to "stdout",
        "data" to bytes,
    )

    is PrivilegeCommandEvent.Stderr -> mapOf(
        "type" to "stderr",
        "data" to bytes,
    )

    is PrivilegeCommandEvent.Exited -> mapOf(
        "type" to "exit",
        "exitCode" to exitCode,
    )
}
