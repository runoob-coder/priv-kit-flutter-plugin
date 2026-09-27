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
import priv.kit.core.userservice.PrivilegeUserServiceSpec

/**
 * Shows how an app actually *calls* a UserService.
 *
 * Priv Kit returns a Binder, and a Binder cannot cross the Flutter platform
 * channel. The plugin's `bindUserService` therefore only lets Dart manage the
 * connection lifetime. Reaching the service's own AIDL methods has to happen
 * here, in Kotlin, and the results are handed back over this small channel.
 *
 * The example app drives the lifecycle through the plugin
 * (`startUserService` / `stopUserService`); this bridge only binds, calls and
 * unbinds.
 */
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
                val embedded = call.argument<Boolean>("embedded") ?: false
                val method = call.argument<String>("method")
                val args = call.argument<Map<String, Any?>>("args").orEmpty()
                if (method == null) {
                    result.error("INVALID_ARGUMENT", "method is required", null)
                    return
                }
                scope.launch {
                    try {
                        result.success(withContext(Dispatchers.IO) { invoke(embedded, method, args) })
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
        embedded: Boolean,
        method: String,
        args: Map<String, Any?>,
    ): Any? {
        val spec = PrivilegeUserServiceSpec(
            serviceClassName = DemoPrivilegeService::class.java.name,
            // Separate instances per mode, so switching modes does not replace
            // a running service.
            tag = if (embedded) "demo-embedded" else "demo-standalone",
            version = 1,
            embedded = embedded,
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
