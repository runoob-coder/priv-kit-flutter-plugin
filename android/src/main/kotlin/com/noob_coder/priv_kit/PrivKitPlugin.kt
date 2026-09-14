package com.noob_coder.priv_kit

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.currentCoroutineContext
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import priv.kit.core.Privilege
import priv.kit.core.PrivilegeExternalStartup
import priv.kit.core.adb.PrivilegeAdbConnectionOptions
import priv.kit.core.PrivilegeExternalStartupBridgeOptions
import priv.kit.core.PrivilegeExternalStartupOptions
import priv.kit.core.PrivilegeStartupLogListener

/**
 * Flutter bindings for the Priv Kit Android runtime.
 *
 * Method channel: `priv_kit`
 * Event channels: `priv_kit/server_state`, `priv_kit/startup_log`
 */
class PrivKitPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var methodChannel: MethodChannel
    private lateinit var serverStateChannel: EventChannel
    private lateinit var startupLogChannel: EventChannel

    private val mainHandler = Handler(Looper.getMainLooper())
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)
    private val sessions = PrivKitSessions()
    private val adb = PrivKitAdb(sessions)
    private lateinit var commands: PrivKitCommands
    private val operations = HashMap<String, Job>()
    private val operationLock = Any()
    private var serverStateJob: Job? = null

    @Volatile
    private var startupLogSink: EventChannel.EventSink? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val messenger = flutterPluginBinding.binaryMessenger
        methodChannel = MethodChannel(messenger, METHOD_CHANNEL)
        methodChannel.setMethodCallHandler(this)

        serverStateChannel = EventChannel(messenger, SERVER_STATE_CHANNEL)
        serverStateChannel.setStreamHandler(ServerStateStreamHandler())

        startupLogChannel = EventChannel(messenger, STARTUP_LOG_CHANNEL)
        startupLogChannel.setStreamHandler(StartupLogStreamHandler())

        commands = PrivKitCommands(messenger, scope, mainHandler)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        when (call.method) {
            "startRoot" -> runAsync(result) {
                val listener = call.startupLogListener()
                val timeout = call.argument<Number>("timeoutMillis")?.toLong()
                withOperation(call) {
                    if (timeout == null) {
                        Privilege.startRoot(startupLogListener = listener)
                    } else {
                        Privilege.startRoot(timeoutMillis = timeout, startupLogListener = listener)
                    }
                }.toMap()
            }

            "startAdb" -> runAsync(result) {
                val listener = call.startupLogListener()
                val timeout = call.argument<Number>("timeoutMillis")?.toLong()
                val options = call.adbConnectionOptions() ?: PrivilegeAdbConnectionOptions()
                val deviceName = call.argument<String>("adbDeviceName")
                withOperation(call) {
                    if (timeout == null) {
                        Privilege.startAdb(
                            options = options,
                            adbDeviceName = deviceName,
                            startupLogListener = listener,
                        )
                    } else {
                        Privilege.startAdb(
                            options = options,
                            timeoutMillis = timeout,
                            adbDeviceName = deviceName,
                            startupLogListener = listener,
                        )
                    }
                }.toMap()
            }

            "connectReadyServer" -> runAsync(result) {
                withContext(Dispatchers.IO) { Privilege.connectReadyServer() }?.toMap()
            }

            "getServerState" -> runAsync(result) {
                Privilege.serverState.value?.toMap()
            }

            "getServerInfo" -> runAsync(result) {
                withContext(Dispatchers.IO) { Privilege.getServerInfo() }.toMap()
            }

            "pingServer" -> runAsync(result) {
                withContext(Dispatchers.IO) { Privilege.pingServer() }
            }

            "shutdownServer" -> runAsync(result) {
                withContext(Dispatchers.IO) { Privilege.shutdownServer() }
                null
            }

            "prepareOwnerRestart" -> runAsync(result) {
                val timeout = call.argument<Number>("passiveReconnectTimeoutMillis")?.toLong()
                    ?: throw IllegalArgumentException(
                        "passiveReconnectTimeoutMillis is required and must be positive",
                    )
                withContext(Dispatchers.IO) { Privilege.prepareOwnerRestart(timeout) }
                null
            }

            "getDeniedServerPermissions" -> runAsync(result) {
                withContext(Dispatchers.IO) { Privilege.getDeniedServerPermissions() }
            }

            "checkServerPermission" -> runAsync(result) {
                val permission = call.requireString("permission")
                withContext(Dispatchers.IO) { Privilege.checkServerPermission(permission) }
            }

            "isPermissionRestricted" -> runAsync(result) {
                withContext(Dispatchers.IO) { Privilege.isPermissionRestricted() }
            }

            "getNativeStarterCommand" -> runAsync(result) {
                // First access inspects the installed APK and must run off the main thread.
                withContext(Dispatchers.IO) { Privilege.nativeStarterCommand }
            }

            "cancelOperation" -> {
                val id = call.requireString("operationId")
                val job = synchronized(operationLock) { operations.remove(id) }
                job?.cancel()
                result.success(null)
            }

            "runCommand" -> runAsync(result) {
                commands.run(call)
            }

            "startCommandStream" -> runAsync(result) {
                commands.start(call)
                null
            }

            "cancelCommand" -> {
                commands.cancel(call.requireString("commandId"))
                result.success(null)
            }

            "externalStartupRunInCurrentProcess" -> runAsync(result) {
                val listener = call.startupLogListener()
                withOperation(call) {
                    PrivilegeExternalStartup.runInCurrentProcess(
                        commandLine = call.requireString("commandLine"),
                        options = call.externalStartupOptions(),
                        startupLogListener = listener,
                    )
                }
            }

            "externalStartupRunThroughBridge" -> runAsync(result) {
                val listener = call.startupLogListener()
                val bridgeId = call.requireString("bridgeId")
                withOperation(call) {
                    PrivilegeExternalStartup.runThroughBridge(
                        commandLine = call.requireString("commandLine"),
                        bridge = PrivKitExternalStartupBridges.require(bridgeId),
                        options = call.externalStartupBridgeOptions(),
                        startupLogListener = listener,
                    )
                }
            }

            else -> if (adb.handles(call.method)) {
                runAsync(result) { adb.invoke(call.method, call) }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        serverStateChannel.setStreamHandler(null)
        startupLogChannel.setStreamHandler(null)
        startupLogSink = null
        serverStateJob?.cancel()
        serverStateJob = null
        synchronized(operationLock) { operations.clear() }
        sessions.closeAll()
        commands.closeAll()
        scope.cancel()
    }

    private fun runAsync(
        result: MethodChannel.Result,
        block: suspend () -> Any?,
    ) {
        scope.launch {
            try {
                result.success(block())
            } catch (throwable: Throwable) {
                val error = throwable.toPrivKitError()
                result.error(error.code, error.message, error.details)
            }
        }
    }

    private suspend fun <T> withOperation(
        call: MethodCall,
        block: suspend () -> T,
    ): T {
        val operationId = call.argument<String>("operationId")
        val job = currentCoroutineContext()[Job]
        if (operationId != null && job != null) {
            synchronized(operationLock) { operations[operationId] = job }
        }
        return try {
            block()
        } finally {
            if (operationId != null) {
                synchronized(operationLock) { operations.remove(operationId) }
            }
        }
    }

    private fun MethodCall.startupLogListener(): PrivilegeStartupLogListener? {
        val operationId = argument<String>("operationId") ?: return null
        return PrivilegeStartupLogListener { line ->
            val event = mapOf<String, Any?>(
                "source" to line.source,
                "message" to line.message,
                "ctime" to line.ctime,
                "operationId" to operationId,
            )
            mainHandler.post { startupLogSink?.success(event) }
        }
    }

    private fun MethodCall.externalStartupOptions(): PrivilegeExternalStartupOptions {
        val map = argument<Map<String, Any?>>("options") ?: return PrivilegeExternalStartupOptions()
        return PrivilegeExternalStartupOptions(
            shellPath = map["shellPath"] as? String ?: "/system/bin/sh",
            timeoutMillis = (map["timeoutMillis"] as? Number)?.toLong() ?: 2_000L,
            maxCapturedLines = (map["maxCapturedLines"] as? Number)?.toInt() ?: 80,
        )
    }

    private fun MethodCall.externalStartupBridgeOptions():
        PrivilegeExternalStartupBridgeOptions {
        val map = argument<Map<String, Any?>>("options")
            ?: return PrivilegeExternalStartupBridgeOptions()
        return PrivilegeExternalStartupBridgeOptions(
            timeoutMillis = (map["timeoutMillis"] as? Number)?.toLong() ?: 10_000L,
            maxCapturedLines = (map["maxCapturedLines"] as? Number)?.toInt() ?: 80,
            sourcePrefix = map["sourcePrefix"] as? String,
        )
    }

    private inner class ServerStateStreamHandler : EventChannel.StreamHandler {
        override fun onListen(
            arguments: Any?,
            events: EventChannel.EventSink?,
        ) {
            serverStateJob?.cancel()
            serverStateJob = scope.launch {
                try {
                    // Accessing the getter also arms process-wide connection handling.
                    Privilege.serverState.collect { info -> events?.success(info?.toMap()) }
                } catch (throwable: Throwable) {
                    if (throwable is CancellationException) throw throwable
                    val error = throwable.toPrivKitError()
                    events?.error(error.code, error.message, error.details)
                }
            }
        }

        override fun onCancel(arguments: Any?) {
            serverStateJob?.cancel()
            serverStateJob = null
        }
    }

    private inner class StartupLogStreamHandler : EventChannel.StreamHandler {
        override fun onListen(
            arguments: Any?,
            events: EventChannel.EventSink?,
        ) {
            startupLogSink = events
        }

        override fun onCancel(arguments: Any?) {
            startupLogSink = null
        }
    }

    internal companion object {
        internal const val METHOD_CHANNEL = "priv_kit"
        internal const val SERVER_STATE_CHANNEL = "priv_kit/server_state"
        internal const val STARTUP_LOG_CHANNEL = "priv_kit/startup_log"
    }
}
