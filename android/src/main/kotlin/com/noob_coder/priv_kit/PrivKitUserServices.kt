package com.noob_coder.priv_kit

import io.flutter.plugin.common.MethodCall
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.NonCancellable
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import priv.kit.core.Privilege
import priv.kit.core.PrivilegeUserServiceConnection
import priv.kit.core.userservice.PrivilegeUserServiceProcess
import priv.kit.core.userservice.PrivilegeUserServiceSpec

/** Bridges `priv.kit.core` UserService lifecycle calls to Dart. */
internal class PrivKitUserServices {
    private val lock = Any()
    private val connections = HashMap<Int, PrivilegeUserServiceConnection>()
    private val identities = HashMap<Int, Pair<String?, String?>>()
    private var nextHandle = 1

    fun handles(method: String): Boolean =
        method.endsWith("UserService") || method == "userServiceIsConnected"

    suspend fun bind(call: MethodCall): Int {
        val spec = call.spec()
        val daemon = call.argument<Boolean>("daemon") ?: false
        val connection = withContext(Dispatchers.IO) {
            Privilege.bindUserService(spec, daemon = daemon)
        }
        return remember(spec, connection)
    }

    suspend fun peek(call: MethodCall): Int? {
        val spec = call.spec()
        val connection = withContext(Dispatchers.IO) {
            Privilege.peekUserService(spec)
        } ?: return null
        return remember(spec, connection)
    }

    fun isConnected(call: MethodCall): Boolean =
        connectionFor(call.connectionHandle()).isConnected.value

    /** Resolves a Dart handle for Binder forwarding. */
    fun connectionFor(handle: Int): PrivilegeUserServiceConnection =
        synchronized(lock) { connections[handle] }
            ?: throw PrivKitNotFoundException("Unknown UserService connection handle: $handle")

    suspend fun unbind(call: MethodCall) {
        val connection = synchronized(lock) {
            identities.remove(call.connectionHandle())
            connections.remove(call.connectionHandle())
        } ?: return
        withContext(Dispatchers.IO + NonCancellable) { connection.unbind() }
    }

    suspend fun stop(call: MethodCall) {
        val spec = call.spec()
        withContext(Dispatchers.IO) { Privilege.stopUserService(spec) }
        val identity = spec.serviceClassName to spec.tag
        synchronized(lock) {
            identities.filterValues { it == identity }.keys.toList().forEach { handle ->
                identities.remove(handle)
                connections.remove(handle)
            }
        }
    }

    fun closeAll(scope: CoroutineScope) {
        val snapshot = synchronized(lock) {
            val all = connections.values.toList()
            connections.clear()
            identities.clear()
            all
        }
        snapshot.forEach { connection ->
            scope.launch(NonCancellable + Dispatchers.IO) {
                runCatching { connection.unbind() }
            }
        }
    }

    private fun remember(
        spec: PrivilegeUserServiceSpec,
        connection: PrivilegeUserServiceConnection,
    ): Int = synchronized(lock) {
        val handle = nextHandle++
        connections[handle] = connection
        identities[handle] = spec.serviceClassName to spec.tag
        handle
    }

    private fun MethodCall.spec(): PrivilegeUserServiceSpec = PrivilegeUserServiceSpec(
        serviceClassName = argument<String>("serviceClassName"),
        tag = argument<String>("tag"),
        process = PrivilegeUserServiceProcess.valueOf(
            argument<String>("process") ?: PrivilegeUserServiceProcess.EMBEDDED.name,
        ),
    )

    private fun MethodCall.connectionHandle(): Int =
        optionalInt("connectionHandle")
            ?: throw IllegalArgumentException("connectionHandle is required")
}
