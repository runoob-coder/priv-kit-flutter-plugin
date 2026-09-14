package com.noob_coder.priv_kit

import android.os.Build
import io.flutter.plugin.common.MethodCall
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import priv.kit.core.Privilege
import priv.kit.core.adb.PRIVILEGE_ADB_DEFAULT_TCP_PORT
import priv.kit.core.adb.PrivilegeAdbConnectionOptions
import priv.kit.core.adb.PrivilegeAdbManager
import priv.kit.core.adb.PrivilegeAdbPairingCheckSession
import priv.kit.core.adb.PrivilegeAdbTcpAuthorizationCheckSession
import priv.kit.core.adb.PrivilegeAdbWirelessDebuggingControl

/** Default Wireless Debugging port discovery timeout used by priv-core. */
internal const val DEFAULT_PORT_DISCOVERY_TIMEOUT_MILLIS = 15_000L

/** Dispatches every `adb*` method to `priv.kit.core.adb.PrivilegeAdbManager`. */
internal class PrivKitAdb(
    private val sessions: PrivKitSessions,
) {
    fun handles(method: String): Boolean =
        method.startsWith("adb") || method == "closeSession"

    suspend fun invoke(
        method: String,
        call: MethodCall,
    ): Any? = when (method) {
        "adbGetIdentityInfo" -> call.manager().getIdentityInfo().toMap()

        "adbGetActiveTcpPort" -> withContext(Dispatchers.IO) {
            call.manager().getActiveTcpPort()
        }

        "adbGetConfiguredTcpPort" -> withContext(Dispatchers.IO) {
            call.manager().getConfiguredTcpPort()
        }

        "adbGetWirelessDebuggingControlStatus" -> requireApiLevel30 {
            call.manager().getWirelessDebuggingControlStatus().toMap()
        }

        "adbDiscoverPairingPort" -> requireApiLevel30 {
            call.manager().discoverPairingPort(
                timeoutMillis = call.timeoutMillis(DEFAULT_PORT_DISCOVERY_TIMEOUT_MILLIS),
            )
        }

        "adbDiscoverConnectPort" -> requireApiLevel30 {
            call.manager().discoverConnectPort(
                timeoutMillis = call.timeoutMillis(DEFAULT_PORT_DISCOVERY_TIMEOUT_MILLIS),
            )
        }

        "adbPair" -> requireApiLevel30 {
            call.manager().pair(
                pairingCode = call.requireString("pairingCode"),
                port = call.optionalInt("port"),
                portDiscoveryTimeoutMillis = call.timeoutMillis(
                    DEFAULT_PORT_DISCOVERY_TIMEOUT_MILLIS,
                ),
            ).toMap()
        }

        "adbCheckPairing" -> requireApiLevel30 {
            call.manager().checkPairing(
                port = call.optionalInt("port"),
                portDiscoveryTimeoutMillis = call.timeoutMillis(
                    DEFAULT_PORT_DISCOVERY_TIMEOUT_MILLIS,
                ),
            ).toMap()
        }

        "adbOpenPairingCheckSession" -> requireApiLevel30 {
            sessions.add(
                call.manager().openPairingCheckSession(
                    port = call.optionalInt("port"),
                    portDiscoveryTimeoutMillis = call.timeoutMillis(
                        DEFAULT_PORT_DISCOVERY_TIMEOUT_MILLIS,
                    ),
                ),
            )
        }

        "adbCheckPairingSession" -> {
            val session = sessions.get(call.requireInt("sessionId"))
                    as? PrivilegeAdbPairingCheckSession
                ?: throw PrivKitNotFoundException(
                    "No open ADB pairing check session for the given id",
                )
            session.check().toMap()
        }

        "adbPrepareTcpForStart" -> call.manager().prepareTcpForStart(
            tcpPort = call.tcpPort(),
        ).toMap()

        "adbCheckTcpAuthorization" -> call.manager().checkTcpAuthorization(
            tcpPort = call.tcpPort(),
        ).toMap()

        "adbRequestTcpAuthorization" -> call.manager().requestTcpAuthorization(
            tcpPort = call.tcpPort(),
            timeoutMillis = call.timeoutMillis(15_000L),
        ).toMap()

        "adbOpenTcpAuthorizationCheckSession" -> sessions.add(
            call.manager().openTcpAuthorizationCheckSession(
                tcpPort = call.tcpPort(),
            ),
        )

        "adbCheckTcpAuthorizationSession" -> {
            val session = sessions.get(call.requireInt("sessionId"))
                    as? PrivilegeAdbTcpAuthorizationCheckSession
                ?: throw PrivKitNotFoundException(
                    "No open ADB TCP authorization check session for the given id",
                )
            session.check().toMap()
        }

        "adbSwitchToTcp" -> call.manager().switchToTcp(
            tcpPort = call.tcpPort(),
            options = call.adbConnectionOptions(),
        ).toMap()

        "adbStopTcp" -> call.manager().stopTcp(
            tcpPort = call.tcpPort(),
            options = call.adbConnectionOptions(),
        ).toMap()

        "adbRestartTcp" -> call.manager().restartTcp(
            tcpPort = call.tcpPort(),
            options = call.adbConnectionOptions(),
        ).toMap()

        "closeSession" -> {
            sessions.close(call.requireInt("sessionId"))
            null
        }

        else -> throw IllegalArgumentException("Unknown ADB method: $method")
    }

    private suspend fun MethodCall.manager(): PrivilegeAdbManager =
        withContext(Dispatchers.IO) {
            Privilege.createAdbManager(adbDeviceName = argument<String>("adbDeviceName"))
        }

    private fun MethodCall.tcpPort(): Int =
        optionalInt("tcpPort") ?: PRIVILEGE_ADB_DEFAULT_TCP_PORT

    private fun MethodCall.timeoutMillis(default: Long): Long =
        (argument<Number>("timeoutMillis"))?.toLong() ?: default

    private inline fun <T> requireApiLevel30(block: () -> T): T {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
            throw PrivKitUnsupportedApiException(
                "This ADB API requires Android 11 (API 30); device runs API " +
                        "${Build.VERSION.SDK_INT}",
            )
        }
        return block()
    }
}

/** Reads the `options` argument as [PrivilegeAdbConnectionOptions], if present. */
internal fun MethodCall.adbConnectionOptions(): PrivilegeAdbConnectionOptions? {
    val map = argument<Map<String, Any?>>("options") ?: return null
    val control = (map["wirelessDebuggingControl"] as? String)
        ?.let { PrivilegeAdbWirelessDebuggingControl.valueOf(it) }
        ?: PrivilegeAdbWirelessDebuggingControl.IF_AVAILABLE
    return PrivilegeAdbConnectionOptions(
        port = (map["port"] as? Number)?.toInt(),
        wirelessDebuggingControl = control,
        disableWirelessDebuggingAfterUse =
            map["disableWirelessDebuggingAfterUse"] as? Boolean ?: true,
        portDiscoveryTimeoutMillis =
            (map["portDiscoveryTimeoutMillis"] as? Number)?.toLong()
                ?: DEFAULT_PORT_DISCOVERY_TIMEOUT_MILLIS,
        connectRetryCount = (map["connectRetryCount"] as? Number)?.toInt() ?: 5,
        connectRetryDelayMillis =
            (map["connectRetryDelayMillis"] as? Number)?.toLong() ?: 1_000L,
    )
}

internal fun MethodCall.requireString(key: String): String =
    argument<String>(key)?.takeIf { it.isNotBlank() }
        ?: throw IllegalArgumentException("$key is required")

internal fun MethodCall.optionalInt(key: String): Int? =
    (argument<Number>(key))?.toInt()

internal fun MethodCall.requireInt(key: String): Int =
    optionalInt(key) ?: throw IllegalArgumentException("$key is required")
