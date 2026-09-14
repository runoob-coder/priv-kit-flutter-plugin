package com.noob_coder.priv_kit_example

import android.app.Application
import android.content.Context
import android.os.Build
import org.lsposed.hiddenapibypass.HiddenApiBypass

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
}
