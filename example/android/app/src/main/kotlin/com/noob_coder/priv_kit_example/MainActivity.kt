package com.noob_coder.priv_kit_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var userServiceBridge: DemoUserServiceBridge? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Lets Dart reach the demo UserService's AIDL methods, which cannot be
        // driven from Dart directly.
        userServiceBridge = DemoUserServiceBridge(flutterEngine.dartExecutor.binaryMessenger)
    }
}
