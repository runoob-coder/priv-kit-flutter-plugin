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
- **Server lifecycle** — ping, shutdown, owner restart, runtime configuration.
- **Permissions** — server permission queries, plus runtime permission
  management for any package.
- **ADB pairing and TCP control** — pairing, authorization checks, `adb tcpip`
  and friends.
- **Command execution** — non-interactive processes with aggregated or
  streamed output.
- **File proxy** — read, write and traverse paths your app itself cannot reach.
- **Crash logs** — read the report a privileged process wrote when it died.
- **UserService** — run your own Kotlin class with the server's privileges,
  with the lifecycle driven from Dart.
- **Binder access** — resolve system services and the server's lifecycle
  Binder. Transactions themselves stay in Kotlin.

A Binder cannot cross the platform channel, so Dart receives handles rather
than Binders. See [Binder access](#-binder-access) for what that leaves on each
side.

## 📋 Requirements

|              |                                |
|--------------|--------------------------------|
| Platform     | Android only                   |
| Android API  | 26+ (Android 8.0)              |
| `compileSdk` | 37+ (required by `priv-core` ) |
| Dart SDK     | ^3.12.0                        |
| Flutter      | >=3.44.0                       |

## 📦 Installation

```bash
flutter pub add priv_kit
```

## ⚙️ Host app setup

The plugin depends on [`io.github.priv-kit:priv-core`][priv-core] (0.17.4) and
exposes it as an `api` dependency, so priv-core types are on your compile
classpath. Writing a UserService or registering an external startup bridge
needs no extra declaration.

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

| Type            | Name                    | Payload                        |
|-----------------|-------------------------|--------------------------------|
| `MethodChannel` | `priv_kit`              | every call                     |
| `EventChannel`  | `priv_kit/server_state` | `Privilege.serverState`        |
| `EventChannel`  | `priv_kit/startup_log`  | startup diagnostics            |
| `EventChannel`  | `priv_kit/command/<id>` | streamed output of one command |

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

## 📁 File proxy

Docs: [file proxy](https://priv-kit.pages.dev/guide/file-proxy).

Every operation runs inside the connected server, so Dart can reach paths the
app itself is not allowed to read or write. Paths are plain strings and must be
absolute; there is no local path handling.

### Querying

```dart
final exists = await privKit.fileExists('/data/local/tmp/a.txt');
final size = await privKit.fileLength(path);
final isDir = await privKit.fileIsDirectory(path);

final meta = await privKit.fileMetadata('/data/local/tmp');
print(meta.type); // PrivFileType.directory
print(meta.lastModified);
```

Also available: `fileIsFile`, `fileIsSymbolicLink`, `fileCanRead`,
`fileCanWrite`, `fileCanExecute`, `fileLastModified`.

### Mutating

```dart
await privKit.fileMkdirs('/data/local/tmp/demo/nested');
await privKit.fileCreateNewFile('/data/local/tmp/demo/a.txt');
await privKit.fileRenameTo(from, to);
await privKit.fileDelete(path);

// A directory is deleted together with its contents.
await privKit.fileDeleteRecursively('/data/local/tmp/demo');
```

`fileDeleteRecursively` does not follow symbolic links, and a missing target
counts as deleted. A `false` result means at least one entry could not be
removed; others may already be gone.

`fileReplaceAtomically(from, to)` maps to Linux `rename(2)`: both paths must be
on the same mounted filesystem and there is no copy-and-delete fallback.

### Reading and writing

For whole files, the `*AllBytes` helpers open, transfer and close:

```dart
await privKit.fileWriteAllBytes(path, bytes, syncOnClose: true);
final data = await privKit.fileReadAllBytes(path);
```

For large files, drive the stream yourself. Always close the handle — closing a
write handle waits until the server has consumed every byte:

```dart
final handle = await privKit.fileOpenWrite(path, append: true);
try {
  await privKit.fileWrite(handle, chunk);
} finally {
  await privKit.fileClose(handle);
}
```

### Walking a directory

```dart
await for (final entry in privKit.fileWalk('/data/local/tmp', maxDepth: 1)) {
  print('${entry.depth} ${entry.name} ${entry.metadata?.sizeBytes}');
}
```

`maxDepth: 1` is a non-recursive listing; omit it to walk the whole subtree.
`skipDirectoryGlobs` prunes matching directory names. Cancelling the
subscription stops the walk.

Since priv-core 0.17.3 the root itself may be a symbolic link — `/sdcard`
works — and its parent does not have to be listable, so `/storage/emulated/0`
can be opened directly.

`entry.metadata` is null when the server can enumerate a name but cannot read
its attributes — such entries are emitted but never entered.

## 🔌 UserService

Docs: [UserService](https://priv-kit.pages.dev/guide/user-service).

A UserService runs **your own Kotlin class** with the server's privileges. It
is the only mechanism here that executes app-defined code — the file proxy,
command execution and Binder access all use capabilities priv-core already
provides.

> **Read this first:** a UserService returns a Binder, and **a Binder cannot
> cross the platform channel**. Dart can drive the lifecycle, but calling your
> AIDL methods has to happen in Kotlin.

### Defining the service

Put the interface under `android/app/src/main/aidl/<your/package>/` and switch
AIDL compilation on — it is **off by default**, and without it the generated
interface does not exist:

```kotlin
// android/app/build.gradle.kts
android {
    buildFeatures {
        aidl = true
    }
}
```

No extra dependency is needed for `kotlinx-coroutines-android`: priv-core
publishes it in its `api` variant, so it already reaches your app.

AIDL interface — the `destroy` transaction code must be `16777114`:

```java
interface IMyPrivilegeService {
    void destroy() = 16777114;
    String getUid() = 1;
}
```

Kotlin implementation:

```kotlin
class MyPrivilegeService : IMyPrivilegeService.Stub {
    private var appContext: Context? = null

    @Keep constructor() : super()
    @Keep constructor(context: Context) : super() { appContext = context }

    override fun getUid() = "uid=${Process.myUid()}"

    override fun destroy() {
        // A dedicated process owns its lifetime; an embedded one must not exit.
        if (!PrivilegeUserServiceEnvironment.isEmbedded) exitProcess(0)
    }
}
```

Both constructors are secondary on purpose: on the JVM `Context?` and `Context`
erase to the same signature, so a primary constructor taking `Context?` clashes
with a secondary constructor taking `Context`.

### Driving the lifecycle from Dart

```dart
const spec = PrivUserServiceSpec(
  serviceClassName: 'com.example.MyPrivilegeService',
  tag: 'main',
  version: 1,
  embedded: false,
  daemon: false,
);

await privKit.startUserService(spec);

// Dart can hold the connection handle, but cannot call the service with it.
final handle = await privKit.bindUserService(spec);
await privKit.unbindUserService(handle);

await privKit.stopUserService(spec);
```

An instance is identified by `serviceClassName` plus `tag`. Bump `version` when
the implementation is no longer compatible, and the runtime replaces the
running instance.

### Calling your service

Convert the Binder in Kotlin and expose the result over a channel of your own.
The example app does exactly this in `DemoUserServiceBridge`:

```kotlin
val connection = Privilege.bindUserService(spec)
try {
    val service = IMyPrivilegeService.Stub.asInterface(connection.binder)
    service.uid
} finally {
    connection.unbind()
}
```

### Embedded vs dedicated

- **Default** — a dedicated `app_process` child process. Its `destroy()` owns
  the process and exits with `exitProcess(0)`.
- **`embedded = true`** — runs inside the Privileged Server process. Binding is
  faster and skips process startup, but `destroy()` may only release the
  service's own resources.

## 🔗 Binder access

Docs: [Binder](https://priv-kit.pages.dev/guide/binder).

Reach Binder services and system services through the connected server. The
transaction format is unchanged — your app supplies the matching system
interface and owns whatever the calls mean.

> **A Binder cannot cross the platform channel.** Dart gets an integer handle,
> never the Binder itself. Issuing a service's own transactions is Kotlin work,
> exactly like calling a UserService.

### Resolving a system service

```dart
// Is the service available at all? Cheaper than resolving it.
final has = await privKit.binderHasSystemService('activity');

final handle = await privKit.binderFromSystemService('activity');
if (handle != null) {
  print(await privKit.binderGetInterfaceDescriptor(handle));
  print(await privKit.binderPing(handle));
  await privKit.binderClose(handle); // release it when you are done
}
```

`PrivBinderServiceSource` picks which process does the lookup:

```dart
await privKit.binderFromSystemService(
  'miui.mqsas.IMQSNative',
  source: PrivBinderServiceSource.serverProcess,
);
```

- `currentProcess` — through `ServiceManager` in your own process.
- `serverProcess` — inside the Privileged Server. Use it for services only
  published to `shell` or root.

A `null` result is normal, not a failure: the service may be absent on this
device, or hidden from the process doing the lookup.

### Issuing transactions

Kotlin only. The example app's `DemoBinderBridge` drives the DUMP transaction —
the one behind `dumpsys`, which every system service already implements, so no
app-specific AIDL is needed:

```kotlin
val binder = PrivilegeBinderWrapper.fromSystemService("activity", source)
ParcelFileDescriptor.open(output, MODE_WRITE_ONLY).use {
    binder.dump(it.fileDescriptor, args)
}
```

Any other transaction works the same way: resolve the Binder, convert it with
your AIDL's `Stub.asInterface(...)` and call it. Report the result to Dart over
a channel of your own.

### The server lifecycle Binder

Some privileged APIs take an owner or death token, so the remote process can
release resources when the owner goes away. Hand them this Binder to tie those
resources to the current server process instead:

```dart
final handle = await privKit.binderServerLifecycle();
```

It exposes no privileged operations and no custom transactions — Dart can only
ping it, watch it and drop it. Its identity is stable only for as long as this
server process lives, so take a fresh handle after every `serverState` change
rather than caching one across reconnections.

### Handling failures

Calls forwarded through a wrapper keep the Binder's own exceptions. When
falling back is safe, `PrivilegeBinderCall.orElse` separates the two death
cases — `ServerUnavailable` and `BinderDied` — and leaves every other failure
propagating unchanged:

```kotlin
PrivilegeBinderCall.orElse(
    fallback = { failure ->
        when (failure) {
            is PrivilegeBinderCallFailure.ServerUnavailable -> fallbackValue
            is PrivilegeBinderCallFailure.BinderDied -> fallbackValue
        }
    },
    call = { binder.transact(...) },
)
```

Only use it when the original call's outcome is genuinely unknown *and*
substituting a value is harmless: the remote process may have completed the
change before dying.

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

## ⚙️ Runtime configuration

Controls what the server does when the owner process dies, and where it writes
crash reports:

```dart
final config = await privKit.getRuntimeConfig();
print(config.followDeathDelay); // default: 10 minutes
print(config.crashLogDirectory); // default: null, i.e. /data/local/tmp

await privKit.configureRuntime(
  followDeathDelayMillis: 60000, // wait 1 minute for the owner to come back
  activeReconnectOnOwnerDeath: true,
  crashLogDirectory: '/sdcard/Android/data/com.example/files/crashes',
);
```

Omitted fields keep their current value. Changes are pushed to the connected
server and apply to the **next** owner death — a reconnect flow that has
already started keeps the values it captured when the owner died.

Set `crashLogDirectory` during startup, before you start the server or read
`getNativeStarterCommand()`: the directory travels to the privileged process in
its launch command. Use one directory per app and Android user — for example
the Kotlin-side `getExternalFilesDir("privilege-crashes")` — because reports
written there are not tagged with an application id.

## 💥 Crash logs

When the Privileged Server or a dedicated UserService dies on an uncaught
Java/Kotlin exception, it writes the report as UTF-8 JSON and this API reads it
back:

```dart
final reports = await privKit.readCrashLogs(); // newest first
for (final report in reports) {
  print('${report.crashedAt} ${report.exceptionType}: '
      '${report.exceptionMessage}');
  print(report.stackTrace);
}
```

`readCrashLogs()` scans the configured `crashLogDirectory` and the shared
fallback `/data/local/tmp`, which is where reports land when no directory is
configured. Everything goes through the file proxy, so **a server has to be
connected**. Given that:

- Only `priv-crash_*.json` files below 1 MiB are decoded, so half-written
  temporary files and unrelated output are ignored.
- `/data/local/tmp` is shared between apps and users, so check
  `report.applicationId` and `report.userId` before showing anything.
- Native crashes, `SIGKILL` and failures before launch configuration is parsed
  produce no file at all: Logcat remains the diagnostic path there.
- Nothing deletes these files. Remove them yourself with
  [`fileDelete`](#-file-proxy) once you have read them.

Docs: [Crash logs](https://priv-kit.pages.dev/guide/activation#crash-logs).

## 🔐 Server permissions

```dart
final denied = await privKit.getDeniedServerPermissions();
final granted = await privKit.checkServerPermission(
  'android.permission.GRANT_RUNTIME_PERMISSIONS',
);
final restricted = await privKit.isPermissionRestricted();
```

`getDeniedServerPermissions` only covers Android permissions that are declared
by the server's packages **and defined on the current device** — permissions
the system does not define are excluded. It does not cover AppOps, SELinux
policy, or the service's own authorization, so an empty list does not guarantee
that every privileged operation succeeds.

Since `priv-core` 0.12.1 these results no longer go stale: changing a vendor USB
debugging security setting is picked up without restarting the server.

### Root servers

A root server (`PrivServerInfo.isRoot`, UID 0) short-circuits these queries:
`checkServerPermission` returns `privilegePermissionGranted` without asking the
system, `getDeniedServerPermissions` returns an empty list, and
`isPermissionRestricted` returns `false`. `checkServerPermission` still
validates the connection, so it keeps working as a liveness check.

### Runtime permissions for any package

`checkServerPermission` inspects the server itself. To inspect — or change —
permissions for an arbitrary package, use these instead:

```dart
// Returns privilegePermissionGranted (0) or privilegePermissionDenied (-1).
final result = await privKit.checkPermission(
  permission: 'android.permission.CAMERA',
  packageName: 'com.example.app',
);

// Boolean convenience wrapper.
final ok = await privKit.isPermissionGranted(
  permission: 'android.permission.CAMERA',
  packageName: 'com.example.app',
);

await privKit.grantRuntimePermission(
  packageName: 'com.example.app',
  permission: 'android.permission.CAMERA',
);

await privKit.revokeRuntimePermission(
  packageName: 'com.example.app',
  permission: 'android.permission.CAMERA',
);
```

`grantRuntimePermission` and `revokeRuntimePermission` require the connected
server to hold `android.permission.GRANT_RUNTIME_PERMISSIONS`, so check
`isPermissionRestricted()` first. All three accept an optional `userId` for
multi-user devices; omitting it uses the current Android user.

## 🛠️ ADB helpers

| Call                                                                                | Purpose                                     |
|-------------------------------------------------------------------------------------|---------------------------------------------|
| `adbGetIdentityInfo`                                                                | this app's ADB identity and key fingerprint |
| `adbGetActiveTcpPort` / `adbGetConfiguredTcpPort`                                   | static port state                           |
| `adbGetWirelessDebuggingControlStatus`                                              | whether Wireless Debugging can be managed   |
| `adbDiscoverPairingPort` / `adbDiscoverConnectPort`                                 | port discovery (API 30+)                    |
| `adbPair` / `adbCheckPairing`                                                       | pairing                                     |
| `adbOpenPairingCheckSession` / `adbCheckPairingSession`                             | polling without reconnecting                |
| `adbOpenTcpAuthorizationCheckSession` / `adbCheckTcpAuthorizationSession`           | polling without reconnecting                |
| `adbPrepareTcpForStart` / `adbCheckTcpAuthorization` / `adbRequestTcpAuthorization` | authorization                               |
| `adbSwitchToTcp` / `adbStopTcp` / `adbRestartTcp`                                   | control the static port                     |
| `closeSession`                                                                      | release a session handle                    |

Both pairing and TCP-authorization checks have a session variant, which reuses
one ADB connection across polls. Sessions are held behind integer handles —
always `closeSession` when polling stops:

```dart
final sessionId = await privKit.adbOpenPairingCheckSession();
final result = await privKit.adbCheckPairingSession(sessionId);
await privKit.closeSession(sessionId);
```

`adbSwitchToTcp`, `adbStopTcp` and `adbRestartTcp` affect every process that
depends on ADB, so confirm with the user first.

## ⚠️ Error handling

Every failure throws `PrivKitException`:

| code                 | meaning                                                  |
|----------------------|----------------------------------------------------------|
| `STARTUP_ERROR`      | `PrivilegeStartupException` — the server could not start |
| `SERVER_UNAVAILABLE` | the server Binder is missing or dead                     |
| `BINDER_DIED`        | the called Binder endpoint itself died                   |
| `COMMAND_ERROR`      | a command could not start or complete                    |
| `COMMAND_TIMEOUT`    | a command exceeded its deadline                          |
| `FILE_ERROR`         | a filesystem operation failed (`IOException`/`ErrnoException`) |
| `INVALID_ARGUMENT`   | an argument failed validation                            |
| `ILLEGAL_STATE`      | the call is not allowed in the current state             |
| `SECURITY_ERROR`     | a required Android permission is missing                 |
| `CANCELLED`          | cancelled via `cancelOperation`                          |
| `UNSUPPORTED_API`    | the ADB call needs Android 11 (API 30)                   |
| `NOT_FOUND`          | unknown session handle or external startup bridge id     |
| `NATIVE_ERROR`       | any other native failure                                 |

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
  receives `uid`, `pid`, `protocolVersion` and `selinuxContext` only. Use
  [binderServerLifecycle](#-binder-access) when you need it as a handle.
- A UserService's Binder stays in Kotlin: only the lifecycle calls and an
  integer connection handle cross the channel.

## 🔗 Related Projects

* [shizuku_api_plugin](https://pub.dev/packages/shizuku_api_plugin) — A Flutter plugin to interact
  with the [Shizuku API](https://github.com/RikkaApps/Shizuku-API), allowing your application to
  execute `shell` commands with system or `ADB` privileges.

## 💛 Support

If [`priv_kit`][pub] helps you build better UIs, please consider supporting it.  
It only takes a few seconds and helps other Flutter developers discover the library.

- ⭐ [Star on GitHub][GitHub]
- 👍 [Like on pub.dev][pub]

## [☕️ Buy Me a Coffee](https://www.noob-coder.com/buy-me-a-coffee)

|                                                                                   Buy Me a Coffee                                                                                   |                                                                                    Donate with PayPal                                                                                     |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| <a href="https://ko-fi.com/noob_coder" target="_blank"><img src="https://github.com/runoob-coder/runoob-coder/raw/main/public/kofi6.webp" alt="Buy Me a Coffee at ko-fi.com" /></a> | <a href="https://paypal.me/runoobcoder" target="_blank"><img src="https://github.com/runoob-coder/runoob-coder/raw/main/public/paypal-donate-button.avif" alt="Donate with PayPal" /></a> |

[Priv Kit]: https://priv-kit.pages.dev

[priv-core]: https://github.com/priv-kit/priv-kit/tree/main/priv-core

[pub]: https://pub.dev/packages/priv_kit

[API Reference]: https://pub.dev/documentation/priv_kit/latest/

[GitHub]: https://github.com/runoob-coder/priv-kit-flutter-plugin

[Android Example]: https://github.com/runoob-coder/priv-kit-flutter-plugin/tree/main/example/android

[Hidden API]: https://github.com/LSPosed/AndroidHiddenApiBypass