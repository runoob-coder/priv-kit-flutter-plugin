# Priv Kit

<div align="center">
   <img src="https://raw.githubusercontent.com/runoob-coder/priv-kit-flutter-plugin/main/priv-kit-mark.svg" width="200" style="width: 200px;" alt="Priv Kit">
</div>

An app-owned privileged Android runtime

Priv Kit supports startup through Root, ADB, Manual, and external authorization bridges

[![Pub Version](https://img.shields.io/pub/v/priv_kit.svg)][pub]
[![API Reference](https://img.shields.io/badge/API-Reference-0175C2.svg)](https://pub.dev/documentation/priv_kit/latest/)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/runoob-coder/priv-kit-flutter-plugin)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![CI](https://img.shields.io/github/actions/workflow/status/runoob-coder/priv-kit-flutter-plugin/build_apk.yml?label=CI)](https://github.com/runoob-coder/priv-kit-flutter-plugin/actions/workflows/build_apk.yml)
[![GitHub stars](https://img.shields.io/github/stars/runoob-coder/priv-kit-flutter-plugin.svg?style=social)][GitHub]

English | [简体中文](https://github.com/runoob-coder/priv-kit-flutter-plugin/blob/main/README_CN.md)

Built on Flutter, this plugin seamlessly bridges [Priv Kit][Priv Kit]'s
Android runtime, [`priv-core`][priv-core], to the Dart side over platform channels.

> **Status:** pre-release. Android only. The API may still change.

## 💡 What this gives you

Priv Kit starts a separate Privileged Server process and hands your app a
Binder to it. Once connected you can run privileged commands and query the
server, without your own app holding the privilege.

This plugin covers the parts of [`priv-core`][priv-core] that make sense to drive from Dart:

- **Startup** — Root, ADB Wireless Debugging, ADB static TCP/IP, manual, and
  external startup (for example through Shizuku).
- **Connection state** — a process-wide stream, plus startup diagnostics.
- **Server lifecycle and permissions** — ping, shutdown, owner restart,
  permission queries.
- **ADB pairing and TCP control** — pairing, authorization checks, `adb tcpip`
  and friends.
- **Command execution** — non-interactive processes with aggregated or
  streamed output.

Not covered yet: file proxy, UserService, and direct Binder access.

## 📋 Requirements

| | |
| --- | --- |
| Platform | Android only|
| Android API | 26+ (Android 8.0) |
| `compileSdk` | 37+ (required by `priv-core` ) |
| Dart SDK | ^3.12.0 |
| Flutter | >=3.44.0 |

## 📦 Installation

```bash
flutter pub add priv_kit
```

## ⚙️ Host app setup

The plugin already depends on [`io.github.priv-kit:priv-core`][priv-core]. 
Your app only needs the platform-side pieces that Priv Kit requires.

See the [Android Example Project][Android Example].

### 1️⃣ Minimum SDK

```kotlin
// android/app/build.gradle.kts
android {
    defaultConfig {
        minSdk = 26
    }
}
```

### 2️⃣ Native library packaging

With `minSdk < 29` the native starter must be extracted from the APK, otherwise
it cannot be executed:

```kotlin
// android/app/build.gradle.kts
android {
    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }
}
```

### 3️⃣ [Hidden API][Hidden API] access

Priv Kit reaches platform APIs that are hidden on Android 9+:

```kotlin
// MainApp.kt
import android.app.Application
import android.content.Context
import android.os.Build
import org.lsposed.hiddenapibypass.HiddenApiBypass

class MainApp : Application() {
    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            HiddenApiBypass.addHiddenApiExemptions("L")
        }
    }
}
```

```kotlin
// android/app/build.gradle.kts
dependencies {
    implementation("org.lsposed.hiddenapibypass:hiddenapibypass:6.1")
}
```

Declare it in the manifest:

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<application android:name=".MainApp" ...>
```

### 4️⃣ Wireless Debugging management (optional)

Only needed if you want the runtime to toggle Wireless Debugging and discover
the connect port during startup:

```xml
<uses-permission android:name="android.permission.WRITE_SECURE_SETTINGS"
    tools:ignore="ProtectedPermissions" />
```

## 🚀 Quick start

```dart
import 'package:priv_kit/priv_kit.dart';

final privKit = PrivKit();

// 1. Watch the connection. New listeners immediately get the current value.
privKit.serverState.listen((server) {
  if (server == null) {
    // disconnected
  } else {
    // connected; server.uid == 0 means root
  }
});

// 2. Start a server.
try {
  final info = await privKit.startRoot();
  print('connected: uid=${info.uid} pid=${info.pid}');
} on PrivKitException catch (e) {
  print('${e.code}: ${e.message}');
}

// 3. Run a command in it.
final result = await privKit.runCommand(
  PrivCommand(arguments: const ['/system/bin/id']),
);
print(result.stdoutText);
```

## 🔌 Channels

| Type | Name | Payload |
| --- | --- | --- |
| `MethodChannel` | `priv_kit` | every call |
| `EventChannel` | `priv_kit/server_state` | `Privilege.serverState` |
| `EventChannel` | `priv_kit/startup_log` | startup diagnostics |
| `EventChannel` | `priv_kit/command/<id>` | streamed output of one command |

Each streamed command gets its own channel, because a Flutter `EventChannel`
name can only back one active broadcast at a time.

## 🔧 Startup

Docs: [getting started](https://priv-kit.pages.dev/guide/getting-started),
[startup methods](https://priv-kit.pages.dev/guide/activation).

### Root

```dart
final info = await privKit.startRoot();
```

Root startup checks the available `su` path, launches the shared server command, 
and waits for the normal Binder handoff.

### ADB Wireless Debugging

Wireless Debugging requires Android 11 or later. Priv Kit stores one ADB key for the application. 
The device must authorize that key before it can start a Privileged Server.

Ask the user to open Developer options > Wireless debugging > Pair device with pairing code. 
While the pairing screen is open, pass its six-digit code to `privKit.adbPair(pairingCode: )`:

Pairing and starting are independent operations — a successful pair never
starts the server:

```dart
final pairing = await privKit.adbCheckPairing();
if (!pairing.paired) {
  await privKit.adbPair(pairingCode: '123456');
}

final info = await privKit.startAdb();
```

`adbPair()` discovers the Wireless Debugging pairing port by default. 
A host that already discovered the port can make the endpoint explicit:

```dart
await privKit.adbPair(pairingCode: '123456', port: 5555);
```

### ADB static TCP/IP port

```dart
const port = privilegeAdbDefaultTcpPort; // 5555

final prepared = await privKit.adbPrepareTcpForStart(tcpPort: port);
if (!prepared.isAuthorized) {
  await privKit.adbRequestTcpAuthorization(tcpPort: port);
}

final info = await privKit.startAdb(
  options: const PrivAdbConnectionOptions(port: port),
);
```

### Manual startup

For when the user runs the starter from a development machine:

```dart
final command = await privKit.getNativeStarterCommand();
// show: adb shell $command
```

The server completes the handshake on its own; `serverState` emits the new
value.

### External startup

Register a bridge natively — this is how an external authorizer such as a
Shizuku UserService can run the starter:

```kotlin
PrivKitExternalStartupBridges.register("shizuku") { commandLine, stdout, stderr, receiver ->
    shizukuService.start(commandLine, stdout, stderr, receiver)
}
```

```dart
final command = await privKit.getNativeStarterCommand();
final output = await privKit.externalStartupRunThroughBridge(
  commandLine: command,
  bridgeId: 'shizuku',
);
```

### Cancelling a startup

Pass your own `operationId` to make the startup cancellable:

```dart
final id = privKit.nextStartOperationId('adb');
final future = privKit.startAdb(operationId: id);
await privKit.cancelOperation(id); // future throws CANCELLED
```

### Startup diagnostics

```dart
privKit.startupLog.listen((line) {
  print('[${line.source}] ${line.message}');
});
```

## 💻 Command execution

Docs: [commands](https://priv-kit.pages.dev/guide/commands).

Commands run non-interactive processes in the connected server. Arguments are
executed directly — **no shell is added implicitly**:

```dart
final result = await privKit.runCommand(
  PrivCommand(
    arguments: const ['/system/bin/id'],
    environment: const {'LANG': 'C'},
    workingDirectory: '/data/local/tmp',
  ),
);
print(result.exitCode);
print(result.stdoutText);
```

Need shell parsing? Ask for it:

```dart
final result = await privKit.runCommand(
  PrivCommand(arguments: const ['/system/bin/sh', '-c', 'ls /data/local/tmp']),
);
```

### 📊 Two consumption modes (mutually exclusive)

Each process supports exactly one.

**Aggregated** — drains both streams, then reports:

```dart
final result = await privKit.runCommand(
  PrivCommand(arguments: const ['/system/bin/cat', '/proc/version']),
  maxBytesPerStream: 1 << 20, // default 1 MiB
);
print(result.stdoutTruncated); // excess is still drained, just not kept
```

**Streamed** — emits output as it arrives. Cancelling the subscription kills
the remote process:

```dart
final sub = privKit
    .startCommand(
      PrivCommand(arguments: const ['/system/bin/sh', '-c', 'logcat -v brief']),
    )
    .listen((event) {
  event.when(
    stdout: stdout.add,
    stderr: stderr.add,
    exit: (code) => print('exit: $code'),
  );
});

await sub.cancel(); // terminates the remote process
```

A chunk is not a line and does not respect UTF-8 boundaries — decode
incrementally when rendering text.

### ⏱️ Timeout and cancellation

The default is 30 seconds, counted from when the remote process starts. New
output does **not** reset the countdown.

```dart
await privKit.runCommand(cmd, timeoutMillis: 120000);        // longer
await privKit.runCommand(cmd, timeoutMillis: noCommandTimeout); // disabled
```

An unfinished command is also terminated when the owner process dies or the
server shuts down. **At most four commands run at once**; the fifth fails
immediately rather than queueing.

### 🚫 Explicit limitations

There is no stdin and no PTY. No interactive shells, terminal sizing, terminal
signals, ANSI rendering, or daemon management. Some programs buffer when
stdout is a pipe rather than a terminal, so data may arrive in bursts.

## 🔄 Server lifecycle

```dart
await privKit.connectReadyServer(); // attach to a server that announced itself
await privKit.getServerState();     // current server, or null
await privKit.getServerInfo();      // throws when not connected
await privKit.pingServer();         // false clears a dead connection
await privKit.shutdownServer();

// Before your app restarts itself:
await privKit.prepareOwnerRestart(passiveReconnectTimeoutMillis: 10_000);
// then terminate the process immediately
```

## 🔐 Server permissions

```dart
final denied = await privKit.getDeniedServerPermissions();
final granted = await privKit.checkServerPermission(
  'android.permission.GRANT_RUNTIME_PERMISSIONS',
);
final restricted = await privKit.isPermissionRestricted();
```

`getDeniedServerPermissions` only covers Android permissions declared by the
server's packages. It does not cover AppOps, SELinux policy, or the service's
own authorization, so an empty list does not guarantee that every privileged
operation succeeds.

## 🛠️ ADB helpers

| Call | Purpose |
| --- | --- |
| `adbGetIdentityInfo` | this app's ADB identity and key fingerprint |
| `adbGetActiveTcpPort` / `adbGetConfiguredTcpPort` | static port state |
| `adbGetWirelessDebuggingControlStatus` | whether Wireless Debugging can be managed |
| `adbDiscoverPairingPort` / `adbDiscoverConnectPort` | port discovery (API 30+) |
| `adbPair` / `adbCheckPairing` | pairing |
| `adbOpenPairingCheckSession` / `adbCheckPairingSession` | polling without reconnecting |
| `adbPrepareTcpForStart` / `adbCheckTcpAuthorization` / `adbRequestTcpAuthorization` | authorization |
| `adbSwitchToTcp` / `adbStopTcp` / `adbRestartTcp` | control the static port |
| `closeSession` | release a session handle |

Sessions are held behind integer handles — always `closeSession` when polling
stops:

```dart
final sessionId = await privKit.adbOpenPairingCheckSession();
final result = await privKit.adbCheckPairingSession(sessionId);
await privKit.closeSession(sessionId);
```

`adbSwitchToTcp`, `adbStopTcp` and `adbRestartTcp` affect every process that
depends on ADB, so confirm with the user first.

## ⚠️ Error handling

Every failure throws `PrivKitException`:

| code | meaning |
| --- | --- |
| `STARTUP_ERROR` | `PrivilegeStartupException` — the server could not start |
| `SERVER_UNAVAILABLE` | the server Binder is missing or dead |
| `COMMAND_ERROR` | a command could not start or complete |
| `COMMAND_TIMEOUT` | a command exceeded its deadline |
| `INVALID_ARGUMENT` | an argument failed validation |
| `ILLEGAL_STATE` | the call is not allowed in the current state |
| `SECURITY_ERROR` | a required Android permission is missing |
| `CANCELLED` | cancelled via `cancelOperation` |
| `UNSUPPORTED_API` | the ADB call needs Android 11 (API 30) |
| `NOT_FOUND` | unknown session handle or external startup bridge id |
| `NATIVE_ERROR` | any other native failure |

```dart
try {
  await privKit.startRoot();
} on PrivKitException catch (e) {
  switch (e.code) {
    case PrivKitErrorCode.serverUnavailable:
      // prompt the user to start the server
    case PrivKitErrorCode.cancelled:
      // the user backed out
    default:
      print('${e.code}: ${e.message}');
  }
}
```

## 🛠️ Development

Models in `lib/src/models/` are generated with
[freezed](https://pub.dev/packages/freezed), which provides `==`, `hashCode`,
`toString` and `copyWith`. Command events are a freezed union:

```dart
event.when(
  stdout: (bytes) => ...,
  stderr: (bytes) => ...,
  exit: (code) => ...,
);
```

After changing a model, regenerate (generated files are committed, so
publishing does not require this):

```bash
dart run build_runner build
```

`json_serializable` is deliberately **not** used: platform channel maps are not
JSON, and values like `Uint8List` should not round-trip through a JSON codec.
`fromMap`/`toMap` stay hand-written so field names line up with the Kotlin side.

## 📝 Notes

- `priv-ui`'s `PrivilegeScaffold` is a Compose component and is not exposed
  through a `PlatformView`. Build your own authorization UI on top of the API
  above, which matches the "custom UI with priv-core" approach in the docs.
- `PrivilegeServerInfo.lifecycleBinder` is not sent across the channel. Dart
  receives `uid`, `pid`, `protocolVersion` and `selinuxContext` only.
- File proxy, UserService and Binder access are not covered by this plugin.

## 💛 Support

If [`priv_kit`][pub] helps you build better UIs, please consider supporting it.  
It only takes a few seconds and helps other Flutter developers discover the library.

- ⭐ [Star on GitHub][GitHub]
- 👍 [Like on pub.dev][pub]

## ☕️ Buy Me a Coffee

<a href="https://ko-fi.com/noob_coder" target="_blank">
  <img src="https://storage.ko-fi.com/cdn/kofi6.png" alt="Buy Me a Coffee at ko-fi.com" />
</a>

[Priv Kit]: https://priv-kit.pages.dev
[priv-core]: https://github.com/priv-kit/priv-kit/tree/main/priv-core
[pub]: https://pub.dev/packages/priv_kit
[API Reference]: https://pub.dev/documentation/priv_kit/latest/
[GitHub]: https://github.com/runoob-coder/priv-kit-flutter-plugin
[Android Example]: https://github.com/runoob-coder/priv-kit-flutter-plugin/tree/main/example/android
[Hidden API]: https://github.com/LSPosed/AndroidHiddenApiBypass