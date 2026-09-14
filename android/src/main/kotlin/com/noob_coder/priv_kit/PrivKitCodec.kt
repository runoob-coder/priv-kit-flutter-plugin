package com.noob_coder.priv_kit

import priv.kit.core.PrivilegeServerInfo
import priv.kit.core.PrivilegeStartupException
import priv.kit.core.adb.PrivilegeAdbAuthorizationCheckResult
import priv.kit.core.adb.PrivilegeAdbAuthorizationRequestResult
import priv.kit.core.adb.PrivilegeAdbIdentityInfo
import priv.kit.core.adb.PrivilegeAdbPairingCheckResult
import priv.kit.core.adb.PrivilegeAdbPairingResult
import priv.kit.core.adb.PrivilegeAdbTcpResult
import priv.kit.core.adb.PrivilegeAdbWirelessDebuggingControlStatus
import priv.kit.core.binder.PrivilegeServerUnavailableException
import priv.kit.core.command.PrivilegeCommandException
import priv.kit.core.command.PrivilegeCommandTimeoutException

/** Thrown when the device does not satisfy the minimum API level of a call. */
internal class PrivKitUnsupportedApiException(
    message: String,
) : RuntimeException(message)

/** Thrown when a session handle or bridge id is unknown. */
internal class PrivKitNotFoundException(
    message: String,
) : RuntimeException(message)

internal data class PrivKitError(
    val code: String,
    val message: String?,
    val details: String?,
)

internal object PrivKitErrorCodes {
    const val STARTUP = "STARTUP_ERROR"
    const val SERVER_UNAVAILABLE = "SERVER_UNAVAILABLE"
    const val COMMAND = "COMMAND_ERROR"
    const val COMMAND_TIMEOUT = "COMMAND_TIMEOUT"
    const val INVALID_ARGUMENT = "INVALID_ARGUMENT"
    const val ILLEGAL_STATE = "ILLEGAL_STATE"
    const val SECURITY = "SECURITY_ERROR"
    const val CANCELLED = "CANCELLED"
    const val UNSUPPORTED_API = "UNSUPPORTED_API"
    const val NOT_FOUND = "NOT_FOUND"
    const val NATIVE = "NATIVE_ERROR"
}

internal fun Throwable.toPrivKitError(): PrivKitError {
    val code = when (this) {
        is PrivilegeStartupException -> PrivKitErrorCodes.STARTUP
        is PrivilegeServerUnavailableException -> PrivKitErrorCodes.SERVER_UNAVAILABLE
        is PrivilegeCommandTimeoutException -> PrivKitErrorCodes.COMMAND_TIMEOUT
        is PrivilegeCommandException -> PrivKitErrorCodes.COMMAND
        is PrivKitUnsupportedApiException -> PrivKitErrorCodes.UNSUPPORTED_API
        is PrivKitNotFoundException -> PrivKitErrorCodes.NOT_FOUND
        is kotlinx.coroutines.CancellationException -> PrivKitErrorCodes.CANCELLED
        is SecurityException -> PrivKitErrorCodes.SECURITY
        is IllegalArgumentException -> PrivKitErrorCodes.INVALID_ARGUMENT
        is IllegalStateException -> PrivKitErrorCodes.ILLEGAL_STATE
        else -> PrivKitErrorCodes.NATIVE
    }
    val cause = cause
    val details = buildString {
        append(javaClass.simpleName)
        if (cause != null && cause !== this@toPrivKitError) {
            append(" / ").append(cause.javaClass.simpleName)
            cause.message?.let { append(": ").append(it) }
        }
    }
    return PrivKitError(code = code, message = message, details = details)
}

internal fun PrivilegeServerInfo.toMap(): Map<String, Any?> = mapOf(
    "uid" to uid,
    "pid" to pid,
    "protocolVersion" to protocolVersion,
    "selinuxContext" to selinuxContext,
)

internal fun PrivilegeAdbIdentityInfo.toMap(): Map<String, Any?> = mapOf(
    "deviceName" to identity.deviceName,
    "publicKeyFingerprint" to publicKeyFingerprint,
)

internal fun PrivilegeAdbPairingResult.toMap(): Map<String, Any?> = mapOf(
    "port" to port,
    "deviceName" to identity.deviceName,
    "publicKeyFingerprint" to publicKeyFingerprint,
)

internal fun PrivilegeAdbPairingCheckResult.toMap(): Map<String, Any?> = mapOf(
    "port" to port,
    "paired" to paired,
    "outputText" to outputText,
    "deviceName" to identity.deviceName,
    "publicKeyFingerprint" to publicKeyFingerprint,
    "failureMessage" to failureMessage,
    "status" to status.name,
)

internal fun PrivilegeAdbTcpResult.toMap(): Map<String, Any?> = mapOf(
    "port" to port,
    "outputText" to outputText,
    "deviceName" to identity.deviceName,
    "publicKeyFingerprint" to publicKeyFingerprint,
)

internal fun PrivilegeAdbAuthorizationCheckResult.toMap(): Map<String, Any?> = mapOf(
    "status" to status.name,
    "outputText" to outputText,
    "deviceName" to identity.deviceName,
    "publicKeyFingerprint" to publicKeyFingerprint,
    "failureMessage" to failureMessage,
)

internal fun PrivilegeAdbAuthorizationRequestResult.toMap(): Map<String, Any?> = mapOf(
    "authorized" to authorized,
    "endReason" to endReason?.name,
    "outputText" to outputText,
    "failureMessage" to failureMessage,
)

internal fun PrivilegeAdbWirelessDebuggingControlStatus.toMap(): Map<String, Any?> = mapOf(
    "supported" to supported,
    "permissionDeclared" to permissionDeclared,
    "permissionGranted" to permissionGranted,
    "wirelessDebuggingEnabled" to wirelessDebuggingEnabled,
    "canManage" to canManage,
    "failureMessage" to failureMessage,
)
