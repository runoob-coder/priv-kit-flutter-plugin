package com.noob_coder.priv_kit

import priv.kit.core.PrivilegeExternalStartProvider

/** Registry for Core external start providers, e.g. the optional Shizuku module. */
public object PrivKitExternalStartProviders {
    private val lock = Any()
    private val providers = LinkedHashMap<String, PrivilegeExternalStartProvider>()

    @JvmStatic
    public fun register(provider: PrivilegeExternalStartProvider) {
        synchronized(lock) { providers[provider.id] = provider }
    }

    @JvmStatic
    public fun unregister(id: String) {
        synchronized(lock) { providers.remove(id) }
    }

    @JvmStatic
    public fun find(id: String): PrivilegeExternalStartProvider? =
        synchronized(lock) { providers[id] }

    @JvmStatic
    public fun ids(): List<String> = synchronized(lock) { providers.keys.toList() }

    internal fun require(id: String): PrivilegeExternalStartProvider =
        find(id) ?: throw PrivKitNotFoundException("No external start provider registered for id=$id")
}
