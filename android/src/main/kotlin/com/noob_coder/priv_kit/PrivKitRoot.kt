package com.noob_coder.priv_kit

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.File

/** Pre-flight Root detection: does this device expose a usable `su` binary? */
internal object PrivKitRoot {
    private const val METHOD = "isRootAvailable"

    /** Magisk dynamically mounts `su`, so PATH is checked as a fallback. */
    private val rootMarkers = listOf(
        "/system/bin/su",
        "/system/xbin/su",
        "/system/sbin/su",
        "/sbin/su",
        "/vendor/bin/su",
        "/vendor/xbin/su",
        "/data/local/su",
        "/data/local/bin/su",
        "/data/local/xbin/su",
        "/su/bin/su",
        "/magisk/.core/bin/su",
        "/data/adb/magisk",
        "/data/adb/apatch",
        "/data/adb/ksu",
    )

    fun handles(method: String): Boolean = method == METHOD

    suspend fun invoke(): Boolean = withContext(Dispatchers.IO) {
        rootMarkers.any { File(it).exists() } || commandAvailable("su")
    }

    /** Read stdout so the pipe cannot block, then use the shell exit code. */
    private fun commandAvailable(name: String): Boolean = try {
        val process = Runtime.getRuntime().exec(
            arrayOf("/system/bin/sh", "-c", "command -v $name"),
        )
        process.inputStream.use { it.readBytes() }
        process.waitFor() == 0
    } catch (t: Throwable) {
        false
    }
}
