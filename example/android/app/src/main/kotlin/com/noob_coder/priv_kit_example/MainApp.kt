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
        // crash reports. The directory travels to the privileged process in
        // the native startup command, so it has to be set before any startup
        // — including the manual command the demo prints.
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
