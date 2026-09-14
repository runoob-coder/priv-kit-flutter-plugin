package com.noob_coder.priv_kit

import priv.kit.core.PrivilegeExternalStartupBridge

/**
 * Registry for app-owned external startup bridges.
 *
 * External startup needs a privileged process that is not owned by priv-core,
 * for example a Shizuku UserService. The host app implements
 * [PrivilegeExternalStartupBridge] in Kotlin, registers it here with a stable
 * id, and Dart then calls
 * `PrivKit.externalStartupRunThroughBridge(bridgeId: id, ...)`.
 *
 * ```kotlin
 * PrivKitExternalStartupBridges.register("shizuku") { commandLine, out, err, receiver ->
 *     shizukuService.start(commandLine, out, err, receiver)
 * }
 * ```
 */
public object PrivKitExternalStartupBridges {
    private val lock = Any()
    private val bridges = HashMap<String, PrivilegeExternalStartupBridge>()

    @JvmStatic
    public fun register(
        id: String,
        bridge: PrivilegeExternalStartupBridge,
    ) {
        synchronized(lock) { bridges[id] = bridge }
    }

    @JvmStatic
    public fun unregister(id: String) {
        synchronized(lock) { bridges.remove(id) }
    }

    @JvmStatic
    public fun find(id: String): PrivilegeExternalStartupBridge? =
        synchronized(lock) { bridges[id] }

    internal fun require(id: String): PrivilegeExternalStartupBridge =
        find(id) ?: throw PrivKitNotFoundException(
            "No external startup bridge registered for id=$id",
        )
}
