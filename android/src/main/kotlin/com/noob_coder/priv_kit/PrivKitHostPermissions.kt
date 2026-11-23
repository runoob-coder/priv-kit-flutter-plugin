package com.noob_coder.priv_kit

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import io.flutter.plugin.common.MethodChannel

/**
 * Runtime permissions for the **host app** itself.
 *
 * Different from `PrivKit.checkPermission` / `grantRuntimePermission`, which
 * operate on a package through the connected Privileged Server. Here the
 * current Flutter Activity must grant a permission to this app, so the plugin
 * implements `ActivityAware` and forwards the result to the waiting Dart call.
 */
internal class PrivKitHostPermissions(private val context: Context) {
    companion object {
        private const val TAG = "PrivKitHostPermissions"
        private const val POST_NOTIFICATIONS = "android.permission.POST_NOTIFICATIONS"
        private const val ACCESS_LOCAL_NETWORK = "android.permission.ACCESS_LOCAL_NETWORK"
        private const val REQ_NOTIFICATIONS = 0x4B01
        private const val REQ_LOCAL_NETWORK = 0x4B02
        private const val LOCAL_NETWORK_API = 37
    }

    private val pending = HashMap<Int, MethodChannel.Result>()
    private val lock = Any()

    fun handles(method: String): Boolean = method in setOf(
        "hasNotificationPermission",
        "requestNotificationPermission",
        "openNotificationPermissionSettings",
        "hasLocalNetworkPermission",
        "requestLocalNetworkPermission",
        "openAppDetailsSettings",
    )

    fun hasNotificationPermission(): Boolean =
        Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU ||
            context.checkSelfPermission(POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED

    fun hasLocalNetworkPermission(): Boolean =
        Build.VERSION.SDK_INT < LOCAL_NETWORK_API ||
            context.checkSelfPermission(ACCESS_LOCAL_NETWORK) == PackageManager.PERMISSION_GRANTED

    fun requestNotificationPermission(
        activity: Activity?,
        result: MethodChannel.Result,
    ) = request(
        permission = POST_NOTIFICATIONS,
        requestCode = REQ_NOTIFICATIONS,
        alreadyGranted = hasNotificationPermission(),
        activity = activity,
        result = result,
    )

    fun requestLocalNetworkPermission(
        activity: Activity?,
        result: MethodChannel.Result,
    ) = request(
        permission = ACCESS_LOCAL_NETWORK,
        requestCode = REQ_LOCAL_NETWORK,
        alreadyGranted = hasLocalNetworkPermission(),
        activity = activity,
        result = result,
    )

    /** Consumes the Activity result; `false` means the code was not ours. */
    fun onRequestPermissionsResult(code: Int, grantResults: IntArray): Boolean {
        val result = synchronized(lock) { pending.remove(code) } ?: return false
        result.success(grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED)
        return true
    }

    /** Fails any in-flight request when the Activity or engine goes away. */
    fun cancelPending() {
        synchronized(lock) {
            pending.values.forEach { it.success(false) }
            pending.clear()
        }
    }

    fun openNotificationPermissionSettings(): Boolean {
        val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            .putExtra(Settings.EXTRA_APP_PACKAGE, context.packageName)
        if (start(intent)) return true
        return startAppDetailsSettings()
    }

    fun openAppDetailsSettings(): Boolean = startAppDetailsSettings()

    private fun request(
        permission: String,
        requestCode: Int,
        alreadyGranted: Boolean,
        activity: Activity?,
        result: MethodChannel.Result,
    ) {
        if (alreadyGranted) {
            result.success(true)
            return
        }
        if (activity == null || activity.isFinishing || activity.isDestroyed) {
            result.success(false)
            return
        }
        synchronized(lock) { pending[requestCode] = result }
        activity.requestPermissions(arrayOf(permission), requestCode)
    }

    private fun startAppDetailsSettings(): Boolean = start(
        Intent(
            Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
            Uri.parse("package:${context.packageName}"),
        ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
    )

    private fun start(intent: Intent): Boolean = try {
        context.startActivity(intent)
        true
    } catch (e: Exception) {
        Log.w(TAG, "cannot start settings activity for ${intent.action}", e)
        false
    }
}
