package com.noob_coder.priv_kit_example

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import priv.kit.core.Privilege
import priv.kit.core.userservice.PrivilegeUserServiceProcess
import priv.kit.core.userservice.PrivilegeUserServiceSpec

/** Calls the app's AIDL service in Kotlin; Binder cannot cross the channel. */
internal class DemoUserServiceBridge(
    messenger: BinaryMessenger,
) {
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)

    init {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler(::onMethodCall)
    }

    private fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        when (call.method) {
            "call" -> {
                val processName = call.argument<String>("process")
                val method = call.argument<String>("method")
                val args = call.argument<Map<String, Any?>>("args").orEmpty()
                if (processName == null || method == null) {
                    result.error("INVALID_ARGUMENT", "process and method are required", null)
                    return
                }
                scope.launch {
                    try {
                        result.success(
                            withContext(Dispatchers.IO) { invoke(processName, method, args) },
                        )
                    } catch (throwable: Throwable) {
                        result.error(
                            "DEMO_USER_SERVICE",
                            throwable.message ?: throwable.javaClass.simpleName,
                            null,
                        )
                    }
                }
            }

            else -> result.notImplemented()
        }
    }

    private suspend fun invoke(
        processName: String,
        method: String,
        args: Map<String, Any?>,
    ): Any? {
        val process = PrivilegeUserServiceProcess.valueOf(processName)
        val spec = PrivilegeUserServiceSpec(
            serviceClassName = DemoPrivilegeService::class.java.name,
            tag = "demo-${process.name.lowercase()}",
            process = process,
        )
        val connection = Privilege.bindUserService(spec)
        return try {
            val service = IDemoPrivilegeService.Stub.asInterface(connection.binder)
            when (method) {
                "getUid" -> service.uid
                "isEmbedded" -> service.isEmbedded
                "add" -> service.add(
                    (args["a"] as Number).toInt(),
                    (args["b"] as Number).toInt(),
                )

                else -> throw IllegalArgumentException("Unknown demo method: $method")
            }
        } finally {
            connection.unbind()
        }
    }

    private companion object {
        private const val CHANNEL = "priv_kit_example/user_service"
    }
}
