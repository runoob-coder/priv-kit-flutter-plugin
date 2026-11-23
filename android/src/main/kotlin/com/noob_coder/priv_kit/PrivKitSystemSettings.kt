package com.noob_coder.priv_kit

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.provider.Settings
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

/**
 * Detection and settings navigation for Android Wi-Fi, Developer options,
 * USB debugging and Wireless debugging.
 *
 * All checks read `Settings.Global` or `ConnectivityManager`, so they work
 * without a Privileged Server. Navigation uses AOSP's
 * `:settings:fragment_args_key` extra to highlight the requested switch, with
 * a plain-Intent fallback for ROMs that ignore it.
 */
internal object PrivKitSystemSettings {
    private const val TAG = "PrivKitSystemSettings"
    private const val FRAGMENT_ARGS_KEY = ":settings:fragment_args_key"
    private const val WIRELESS_PREFERENCE_KEY = "toggle_adb_wireless"
    private const val USB_PREFERENCE_KEY = "enable_adb"
    private const val BUILD_NUMBER_PREFERENCE_KEY = "build_number"
    private const val WIFI_PREFERENCE_KEY = "main_toggle_wifi"
    private const val ADB_WIFI_ENABLED = "adb_wifi_enabled"
    private const val WIFI_ON = "wifi_on"

    private val methods = setOf(
        "isWifiEnabled",
        "isWifiConnected",
        "isWifiReady",
        "isDeveloperModeEnabled",
        "isUsbDebuggingEnabled",
        "isWirelessDebuggingEnabled",
        "openWifiSettings",
        "openDeveloperSettings",
        "openUsbDebuggingSettings",
        "openWirelessDebuggingSettings",
    )

    fun handles(method: String): Boolean = method in methods

    suspend fun invoke(method: String, context: Context): Any = withContext(Dispatchers.IO) {
        when (method) {
            "isWifiEnabled" -> isWifiEnabled(context)
            "isWifiConnected" -> isWifiConnected(context)
            "isWifiReady" -> isWifiEnabled(context) && isWifiConnected(context)
            "isDeveloperModeEnabled" -> readGlobalSetting(
                context,
                Settings.Global.DEVELOPMENT_SETTINGS_ENABLED,
            )

            "isUsbDebuggingEnabled" -> readGlobalSetting(
                context,
                Settings.Global.ADB_ENABLED,
            )

            "isWirelessDebuggingEnabled" -> readGlobalSetting(context, ADB_WIFI_ENABLED)
            "openWifiSettings" -> openWifiSettings(context)
            "openDeveloperSettings" -> openDeveloperSettings(context)
            "openUsbDebuggingSettings" -> openDeveloperSettingsAt(context, USB_PREFERENCE_KEY)
            "openWirelessDebuggingSettings" -> openWirelessDebuggingSettings(context)
            else -> throw IllegalArgumentException("Unknown system settings method: $method")
        }
    }

    /** Reads a `Settings.Global` int as a boolean; malformed reads mean "off". */
    private fun readGlobalSetting(context: Context, key: String): Boolean = try {
        Settings.Global.getInt(context.contentResolver, key, 0) != 0
    } catch (t: Throwable) {
        Log.w(TAG, "read $key failed: $t")
        false
    }

    private fun isWifiEnabled(context: Context): Boolean = readGlobalSetting(context, WIFI_ON)

    /**
     * Whether a Wi-Fi network is present.
     *
     * Does not require NET_CAPABILITY_INTERNET: mDNS and ADB over Wi-Fi work
     * on captive or local-only networks. `allNetworks` also covers devices
     * where Wi-Fi is not the default network.
     */
    @Suppress("DEPRECATION")
    private fun isWifiConnected(context: Context): Boolean {
        val manager = context.getSystemService(ConnectivityManager::class.java) ?: return false
        return try {
            manager.allNetworks.any { network ->
                manager.getNetworkCapabilities(network)
                    ?.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) == true
            }
        } catch (t: Throwable) {
            Log.w(TAG, "query wifi connection failed: $t")
            false
        }
    }

    /**
     * Developer options are a prerequisite for both debugging switches. When
     * they are off, the Developer options Activity finishes immediately on
     * AOSP, so guide the user to About phone and highlight the build number.
     */
    private fun openDeveloperSettings(context: Context): Boolean {
        if (readGlobalSetting(context, Settings.Global.DEVELOPMENT_SETTINGS_ENABLED)) {
            return startActivity(
                context,
                Intent(Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
            )
        }
        val aboutIntent = Intent(Settings.ACTION_DEVICE_INFO_SETTINGS)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            .putExtra(FRAGMENT_ARGS_KEY, BUILD_NUMBER_PREFERENCE_KEY)
        if (startActivity(context, aboutIntent)) return true
        return startActivity(
            context,
            Intent(Settings.ACTION_DEVICE_INFO_SETTINGS)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
        )
    }

    /**
     * Wireless debugging cannot be enabled without a connected Wi-Fi network.
     * Send the user to Wi-Fi settings first when that prerequisite is missing.
     */
    private fun openWirelessDebuggingSettings(context: Context): Boolean =
        if (isWifiEnabled(context) && isWifiConnected(context)) {
            openDeveloperSettingsAt(context, WIRELESS_PREFERENCE_KEY)
        } else {
            openWifiSettings(context)
        }

    private fun openDeveloperSettingsAt(context: Context, preferenceKey: String): Boolean {
        val intent = developerSettingsIntent(context, preferenceKey)
        if (startActivity(context, intent)) return true
        return if (intent.hasExtra(FRAGMENT_ARGS_KEY)) {
            val fallback = Intent(intent)
            fallback.removeExtra(FRAGMENT_ARGS_KEY)
            startActivity(context, fallback)
        } else {
            false
        }
    }

    private fun developerSettingsIntent(context: Context, preferenceKey: String): Intent {
        val enabled = readGlobalSetting(context, Settings.Global.DEVELOPMENT_SETTINGS_ENABLED)
        val action = if (enabled) {
            Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS
        } else {
            Settings.ACTION_DEVICE_INFO_SETTINGS
        }
        return Intent(action)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            .putExtra(
                FRAGMENT_ARGS_KEY,
                if (enabled) preferenceKey else BUILD_NUMBER_PREFERENCE_KEY,
            )
    }

    private fun openWifiSettings(context: Context): Boolean {
        val intent = Intent(Settings.ACTION_WIFI_SETTINGS)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            .putExtra(FRAGMENT_ARGS_KEY, WIFI_PREFERENCE_KEY)
        if (startActivity(context, intent)) return true
        val fallback = Intent(intent)
        fallback.removeExtra(FRAGMENT_ARGS_KEY)
        return startActivity(context, fallback)
    }

    private fun startActivity(context: Context, intent: Intent): Boolean = try {
        context.startActivity(intent)
        true
    } catch (e: ActivityNotFoundException) {
        Log.w(TAG, "no settings activity for ${intent.action}", e)
        false
    } catch (e: SecurityException) {
        Log.w(TAG, "not allowed to start ${intent.action}", e)
        false
    }
}
