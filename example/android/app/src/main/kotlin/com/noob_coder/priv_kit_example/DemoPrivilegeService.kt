package com.noob_coder.priv_kit_example

import android.content.Context
import android.util.Log
import androidx.annotation.Keep
import kotlin.system.exitProcess
import priv.kit.core.userservice.PrivilegeUserServiceEnvironment

/**
 * A minimal UserService: app code that runs with the server's privileges.
 *
 * Priv Kit instantiates the service through either a no-arg constructor or a
 * `Context` constructor, so both are provided and both are marked `@Keep` to
 * survive shrinking.
 *
 * Both are secondary constructors rather than delegating to a
 * `private constructor(context: Context?)`: on the JVM `Context?` and
 * `Context` erase to the same signature, so a primary constructor taking
 * `Context?` clashes with a secondary one taking `Context`.
 */
class DemoPrivilegeService : IDemoPrivilegeService.Stub {
    private var appContext: Context? = null

    // The supertype is listed without parentheses, so each secondary
    // constructor delegates to Stub() explicitly.
    @Keep
    constructor() : super()

    @Keep
    constructor(context: Context) : super() {
        appContext = context
    }

    override fun getUid(): String {
        val uid = android.os.Process.myUid()
        Log.i(TAG, "getUid() called, uid=$uid")
        return "uid=$uid (the app itself runs as ${appContext?.applicationInfo?.uid ?: "?"})"
    }

    override fun isEmbedded(): Boolean = PrivilegeUserServiceEnvironment.isEmbedded

    override fun add(
        a: Int,
        b: Int,
    ): Int = a + b

    override fun destroy() {
        Log.i(TAG, "destroy() called, embedded=${PrivilegeUserServiceEnvironment.isEmbedded}")
        // A dedicated process owns its own lifetime, so it has to exit. An
        // embedded service shares the Privileged Server process and may only
        // release its own resources.
        if (!PrivilegeUserServiceEnvironment.isEmbedded) {
            exitProcess(0)
        }
    }

    private companion object {
        private const val TAG = "DemoPrivilegeService"
    }
}
