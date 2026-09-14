package com.noob_coder.priv_kit

import java.io.Closeable

/** Holds ADB sessions opened from Dart so they can be polled and closed. */
internal class PrivKitSessions {
    private val lock = Any()
    private val sessions = HashMap<Int, Any>()
    private var nextId = 1

    fun add(session: Any): Int = synchronized(lock) {
        val id = nextId++
        sessions[id] = session
        id
    }

    fun get(id: Int): Any? = synchronized(lock) { sessions[id] }

    fun close(id: Int) {
        val removed = synchronized(lock) { sessions.remove(id) }
        (removed as? Closeable)?.close()
    }

    fun closeAll() {
        val removed = synchronized(lock) {
            val values = sessions.values.toList()
            sessions.clear()
            values
        }
        removed.forEach { (it as? Closeable)?.close() }
    }
}
