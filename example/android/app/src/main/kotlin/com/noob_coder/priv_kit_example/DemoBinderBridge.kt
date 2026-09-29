package com.noob_coder.priv_kit_example

import android.os.ParcelFileDescriptor
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import priv.kit.core.binder.PrivilegeBinderCall
import priv.kit.core.binder.PrivilegeBinderCallFailure
import priv.kit.core.binder.PrivilegeBinderWrapper
import priv.kit.core.binder.PrivilegeSystemServiceSource
import java.io.File

/**
 * Shows how an app actually *uses* a Binder.
 *
 * The plugin gives Dart an integer handle, because a Binder cannot cross the
 * platform channel. Issuing the service's own transactions — which is what
 * Binder access is really for — has to happen here, in Kotlin, and the results
 * go back over this small channel. The same split applies to a UserService.
 *
 * The example drives the DUMP transaction, the one behind `dumpsys`. Every
 * system service already implements it, so this needs no app-specific AIDL and
 * still proves the transaction really travelled through the Privileged Server.
 */
internal class DemoBinderBridge(
    messenger: BinaryMessenger,
    private val cacheDir: File,
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
            "dump" -> {
                val serviceName = call.argument<String>("serviceName")
                if (serviceName == null) {
                    result.error("INVALID_ARGUMENT", "serviceName is required", null)
                    return
                }
                val sourceName = call.argument<String>("source") ?: "CURRENT_PROCESS"
                val args = call.argument<List<String>>("args").orEmpty()
                scope.launch {
                    try {
                        result.success(
                            withContext(Dispatchers.IO) {
                                dump(serviceName, sourceName, args)
                            },
                        )
                    } catch (throwable: Throwable) {
                        result.error(
                            "DEMO_BINDER",
                            throwable.message ?: throwable.javaClass.simpleName,
                            null,
                        )
                    }
                }
            }

            else -> result.notImplemented()
        }
    }

    private fun dump(
        serviceName: String,
        sourceName: String,
        args: List<String>,
    ): String {
        val source = PrivilegeSystemServiceSource.valueOf(sourceName)
        val binder = PrivilegeBinderWrapper.fromSystemService(
            serviceName = serviceName,
            source = source,
        ) ?: return "service not available: $serviceName"

        // DUMP needs somewhere to write, and a file descriptor cannot cross the
        // channel either, so write into the cache and read the text back.
        val output = File(cacheDir, "binder_dump.txt")

        // A call can fail because the Privileged Server went away or because the
        // endpoint itself died. When falling back is safe, orElse separates the
        // two; anything else keeps propagating.
        return PrivilegeBinderCall.orElse(
            fallback = { failure ->
                when (failure) {
                    is PrivilegeBinderCallFailure.ServerUnavailable ->
                        "server unavailable: ${failure.exception.message}"

                    is PrivilegeBinderCallFailure.BinderDied ->
                        "binder died: ${failure.exception.message}"
                }
            },
            call = {
                ParcelFileDescriptor.open(
                    output,
                    ParcelFileDescriptor.MODE_WRITE_ONLY or ParcelFileDescriptor.MODE_TRUNCATE,
                ).use { pfd ->
                    binder.dump(pfd.fileDescriptor, args.toTypedArray())
                }
                val text = output.readText().trim()
                if (text.isEmpty()) "(no dump output)" else text
            },
        )
    }

    private companion object {
        private const val CHANNEL = "priv_kit_example/binder"
    }
}
