package com.noob_coder.priv_kit_example

import android.app.Application
import android.content.Context
import android.os.Build
import org.lsposed.hiddenapibypass.HiddenApiBypass
import priv.kit.core.PrivilegeConfig
import java.io.File

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
        // Crash-report directories, in write order. Set before any startup;
        // external storage may be unavailable.
        PrivilegeConfig.crashLogDirectories = listOfNotNull(
            File(filesDir, CRASH_LOG_DIRECTORY).apply { mkdirs() },
            getExternalFilesDir(CRASH_LOG_DIRECTORY),
        )
    }

    private companion object {
        const val CRASH_LOG_DIRECTORY = "privilege-crashes"
    }
}
