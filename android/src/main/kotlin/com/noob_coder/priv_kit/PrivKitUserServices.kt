package com.noob_coder.priv_kit

import io.flutter.plugin.common.MethodCall
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.NonCancellable
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import priv.kit.core.Privilege
import priv.kit.core.PrivilegeUserServiceConnection
import priv.kit.core.userservice.PrivilegeUserServiceSpec

/**
 * Bridges `priv.kit.core.userservice` to Dart.
 *
 * A UserService runs the app's own Kotlin code with the server's privileges.
 * The Binder returned by [Privilege.bindUserService] cannot cross the platform
 * channel, so Dart can only manage the lifecycle here; calling the service's
 * own AIDL methods has to happen in Kotlin, see the example app.
 */
internal class PrivKitUserServices {
    private val lock = Any()
    private val connections = HashMap<Int, PrivilegeUserServiceConnection>()
    private var nextHandle = 1

    // Dart names these startUserService / bindUserService / ... so match on the
    // shared suffix rather than a prefix.
    fun handles(method: String): Boolean = method.endsWith("UserService")

    suspend fun start(call: MethodCall) {
        withContext(Dispatchers.IO) {
            Privilege.startUserService(call.spec())
        }
    }

    /** Binds the service and returns a handle Dart can later unbind. */
    suspend fun bind(call: MethodCall): Int {
        val connection = withContext(Dispatchers.IO) {
            Privilege.bindUserService(call.spec())
        }
        return synchronized(lock) {
            val handle = nextHandle++
            connections[handle] = connection
            handle
        }
    }

    suspend fun unbind(call: MethodCall) {
        val handle = call.optionalInt("connectionHandle")
            ?: throw IllegalArgumentException("connectionHandle is required")
        val connection = synchronized(lock) { connections.remove(handle) }
        // unbind() is idempotent and finishes in a non-cancellable context, so
        // a cancelled caller still gets its resources released.
        withContext(Dispatchers.IO) { connection?.unbind() }
    }

    suspend fun stop(call: MethodCall) {
        withContext(Dispatchers.IO) {
            Privilege.stopUserService(call.spec())
        }
    }

    /**
     * Releases every held connection.
     *
     * [PrivilegeUserServiceConnection.unbind] is suspend, and plugin detach can
     * be followed by the scope being cancelled, so this runs on
     * [NonCancellable] to make sure the server is told about the unbind.
     */
    fun closeAll(scope: CoroutineScope) {
        val snapshot = synchronized(lock) {
            connections.values.toList().also { connections.clear() }
        }
        snapshot.forEach { connection ->
            scope.launch(NonCancellable + Dispatchers.IO) {
                runCatching { connection.unbind() }
            }
        }
    }

    private fun MethodCall.spec(): PrivilegeUserServiceSpec = PrivilegeUserServiceSpec(
        serviceClassName = requireString("serviceClassName"),
        tag = argument<String>("tag") ?: DEFAULT_TAG,
        version = optionalInt("version") ?: 1,
        embedded = argument<Boolean>("embedded") ?: false,
        daemon = argument<Boolean>("daemon") ?: false,
    )

    private companion object {
        private const val DEFAULT_TAG = "default"
    }
}
