package com.noob_coder.priv_kit_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var userServiceBridge: DemoUserServiceBridge? = null
    private var binderBridge: DemoBinderBridge? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        // Lets Dart reach the demo UserService's AIDL methods, which cannot be
        // driven from Dart directly.
        userServiceBridge = DemoUserServiceBridge(messenger)
        // Same reason, for Binder transactions: the plugin only exposes a
        // handle, so calling a system service happens here.
        binderBridge = DemoBinderBridge(messenger, cacheDir)
    }
}
