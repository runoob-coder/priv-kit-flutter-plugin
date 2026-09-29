package com.noob_coder.priv_kit

import android.os.IBinder
import io.flutter.plugin.common.MethodCall
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import priv.kit.core.Privilege
import priv.kit.core.binder.PrivilegeBinderWrapper
import priv.kit.core.binder.PrivilegeSystemServiceSource

/**
 * Bridges `priv.kit.core.binder` to Dart.
 *
 * A Binder cannot cross the platform channel, so Dart never receives one: it
 * gets an integer handle and can only ask the Binder about itself — ping,
 * liveness, interface descriptor. Issuing a service's own transactions is
 * Kotlin work, exactly like calling a UserService; the example app shows the
 * split in `DemoBinderBridge`.
 *
 * Handles store a plain [IBinder] rather than a wrapper so that the server's
 * lifecycle Binder, which is not a [PrivilegeBinderWrapper], fits the same map.
 */
internal class PrivKitBinders {
    private val lock = Any()
    private val binders = HashMap<Int, IBinder>()
    private var nextHandle = 1

    fun handles(method: String): Boolean = method.startsWith("binder")

    /** Whether [serviceName] resolves from the requested source. */
    suspend fun hasSystemService(call: MethodCall): Boolean = withContext(Dispatchers.IO) {
        PrivilegeBinderWrapper.hasSystemService(
            serviceName = call.requireString("serviceName"),
            source = call.serviceSource(),
        )
    }

    /**
     * Resolves [serviceName] into a handle, or null when it is unavailable.
     *
     * Null is a normal outcome, not a failure: a service can be absent on this
     * device, or hidden from the process the lookup runs in.
     */
    suspend fun fromSystemService(call: MethodCall): Int? {
        val wrapper = withContext(Dispatchers.IO) {
            PrivilegeBinderWrapper.fromSystemService(
                serviceName = call.requireString("serviceName"),
                source = call.serviceSource(),
            )
        } ?: return null
        return remember(wrapper)
    }

    /**
     * The connected server's lifecycle Binder.
     *
     * Privileged Binder APIs that take an owner or death token use it to release
     * resources when the owner goes away; handing them this Binder ties those
     * resources to the current server process instead.
     *
     * It exposes no privileged operations and no custom transactions, so Dart
     * can only ping it, watch it and drop it. Its identity is stable only for
     * this server process — take a fresh handle after every reconnection.
     */
    suspend fun serverLifecycle(): Int? {
        val lifecycle = withContext(Dispatchers.IO) {
            // Throws PrivilegeServerUnavailableException when nothing is
            // connected, which the plugin already maps for Dart.
            Privilege.getServerInfo().lifecycleBinder
        }
        return remember(lifecycle)
    }

    suspend fun interfaceDescriptor(call: MethodCall): String? = withContext(Dispatchers.IO) {
        binderFor(call).interfaceDescriptor
    }

    suspend fun ping(call: MethodCall): Boolean = withContext(Dispatchers.IO) {
        // A dead endpoint is a reported result here, not an error: false is what
        // callers branch on.
        runCatching { binderFor(call).pingBinder() }.getOrDefault(false)
    }

    suspend fun isAlive(call: MethodCall): Boolean = withContext(Dispatchers.IO) {
        runCatching { binderFor(call).isBinderAlive }.getOrDefault(false)
    }

    fun close(call: MethodCall) {
        synchronized(lock) { binders.remove(call.handle()) }
    }

    fun closeAll() {
        synchronized(lock) { binders.clear() }
    }

    private fun remember(binder: IBinder): Int = synchronized(lock) {
        val handle = nextHandle++
        binders[handle] = binder
        handle
    }

    private fun binderFor(call: MethodCall): IBinder {
        val handle = call.handle()
        return synchronized(lock) { binders[handle] }
            ?: throw PrivKitNotFoundException("Unknown Binder handle: $handle")
    }

    private fun MethodCall.handle(): Int =
        optionalInt("handle") ?: throw IllegalArgumentException("handle is required")

    private fun MethodCall.serviceSource(): PrivilegeSystemServiceSource =
        PrivilegeSystemServiceSource.valueOf(
            argument<String>("source") ?: PrivilegeSystemServiceSource.CURRENT_PROCESS.name,
        )
}
