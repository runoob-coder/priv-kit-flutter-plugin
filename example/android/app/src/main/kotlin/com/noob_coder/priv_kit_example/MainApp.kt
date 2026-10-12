package com.noob_coder.priv_kit_example

import android.app.Application
import android.content.Context
import android.os.Build
import org.lsposed.hiddenapibypass.HiddenApiBypass
import priv.kit.core.PrivilegeConfig

/**
 * Releases the hidden API restrictions that the Privileged Server relies on.
 *
 * See https://priv-kit.pages.dev/zh/guide/getting-started
 */
class MainApp : Application() {
    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            HiddenApiBypass.addHiddenApiExemptions("L")
        }
    }

    override fun onCreate() {
        super.onCreate()
        // Where the server and every dedicated UserService write their own
        // crash reports. Set it once before any startup: the start calls managed
        // by priv-core hand the directory to the new process, while a manually
        // started server learns it at its owner handshake.
        //
        // This directory belongs to one app and Android user, which is what
        // PrivilegeConfig requires. When storage is unavailable the result is
        // null and priv-core falls back to `/data/local/tmp`, where only the
        // server itself can read the report back.
        getExternalFilesDir(CRASH_LOG_DIRECTORY)
            ?.let { PrivilegeConfig.crashLogDirectory = it }
    }

    private companion object {
        const val CRASH_LOG_DIRECTORY = "privilege-crashes"
    }
}
