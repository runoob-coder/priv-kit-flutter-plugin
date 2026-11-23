package com.noob_coder.priv_kit

import android.content.Context
import android.content.Intent
import android.provider.Settings

/**
 * Public builders for Android settings Intents used by Priv Kit.
 *
 * The Dart API starts these screens directly and cannot return an [Intent], so
 * host apps can use this object when they need the Intent itself, for example
 * to create a notification `PendingIntent`. All builders add the flags needed
 * to start a Settings Activity from a non-Activity context.
 */
object PrivKitSettingsIntents {
    /** AOSP extra used to scroll to and highlight a preference. */
    const val FRAGMENT_ARGS_KEY: String = ":settings:fragment_args_key"

    const val WIRELESS_DEBUGGING_KEY: String = "toggle_adb_wireless"
    const val USB_DEBUGGING_KEY: String = "enable_adb"
    const val BUILD_NUMBER_KEY: String = "build_number"
    const val WIFI_KEY: String = "main_toggle_wifi"

    /** Whether Developer options are enabled (`Settings.Global`). */
    fun developerOptionsEnabled(context: Context): Boolean = try {
        Settings.Global.getInt(
            context.contentResolver,
            Settings.Global.DEVELOPMENT_SETTINGS_ENABLED,
            0,
        ) != 0
    } catch (t: Throwable) {
        false
    }

    /** Opens Developer options, or About phone when they are still disabled. */
    fun developer(context: Context): Intent = if (developerOptionsEnabled(context)) {
        Intent(Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    } else {
        Intent(Settings.ACTION_DEVICE_INFO_SETTINGS)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            .putExtra(FRAGMENT_ARGS_KEY, BUILD_NUMBER_KEY)
    }

    /**
     * Opens Developer options and highlights [preferenceKey].
     *
     * When Developer options are disabled, About phone is opened with the
     * build number highlighted instead: on AOSP the Developer options Activity
     * finishes immediately in that state.
     */
    fun developerAt(context: Context, preferenceKey: String): Intent {
        val enabled = developerOptionsEnabled(context)
        return Intent(
            if (enabled) {
                Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS
            } else {
                Settings.ACTION_DEVICE_INFO_SETTINGS
            },
        )
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            .putExtra(
                FRAGMENT_ARGS_KEY,
                if (enabled) preferenceKey else BUILD_NUMBER_KEY,
            )
    }

    /** Highlights the USB debugging switch inside Developer options. */
    fun usbDebugging(context: Context): Intent =
        developerAt(context, USB_DEBUGGING_KEY)

    /** Highlights the Wireless debugging switch inside Developer options. */
    fun wirelessDebugging(context: Context): Intent =
        developerAt(context, WIRELESS_DEBUGGING_KEY)

    /** Opens Wi-Fi settings and highlights the Wi-Fi switch. */
    fun wifi(context: Context): Intent =
        Intent(Settings.ACTION_WIFI_SETTINGS)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            .putExtra(FRAGMENT_ARGS_KEY, WIFI_KEY)
}
