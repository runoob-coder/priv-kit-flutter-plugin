# Priv Kit

<div align="center">
   <img src="https://raw.githubusercontent.com/runoob-coder/priv-kit-flutter-plugin/main/android.svg" width="200" style="width: 200px;" alt="Priv Kit">
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
- **External start providers** — register a Core `PrivilegeExternalStartProvider`
  (e.g. the optional Shizuku module), check/request authorization and run the
  starter from Dart.
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
- **UserService** — run your own Kotlin class or priv-core's built-in Binder
  forwarding service in a selected process/UID, with the lifecycle driven from
  Dart.
- **Binder access** — resolve system services and the server's lifecycle
  Binder, optionally forwarding through a UserService connection. Transactions
  themselves stay in Kotlin.

A Binder cannot cross the platform channel, so Dart receives handles rather
than Binders. See [Binder access](#-binder-access) for what that leaves on each
side.

## 📋 Requirements

|              |                                |
|--------------|--------------------------------|
| Platform     | Android only                   |
| Android API  | 26+ (Android 8.0)              |
| `compileSdk` | 37.1+ (required by `priv-core`) |
| Dart SDK     | ^3.12.0                        |
| Flutter      | >=3.44.0                       |

## 📦 Installation

```bash
flutter pub add priv_kit
```

## ⚙️ Host app setup

The plugin depends on [`io.github.priv-kit:priv-core`][priv-core] (0.25.0) and
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

priv-core 0.25.0 also requires compile SDK 37.1+:

```kotlin
android {
    compileSdk {
        version = release(37) {
            minorApiLevel = 1
        }
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
    implementation("org.lsposed.hiddenapibypass:hiddenapibypass:6.2")
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

### 5️⃣ System settings detection (optional)

`isWifiConnected()` / `isWifiReady()` query `ConnectivityManager`, so the host
app must declare:

```xml
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

Developer options, USB debugging and Wireless debugging checks read
`Settings.Global` and need no permission. Navigation uses
`:settings:fragment_args_key` extras and gracefully falls back to plain
System Settings Intents on ROMs that ignore them.

### 6️⃣ Host runtime permissions (optional)

Needed only when using `privKit.permissions`:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.ACCESS_LOCAL_NETWORK" />
```

Both calls return `true` below their API level (33 and 37 respectively); the
plugin asks the current Flutter Activity and reports the result to Dart.

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

Discovery is passive: since priv-core 0.17.6 it never opens the system network
device picker on Android 17, and it pauses instead of failing while the local
network permission is missing, resuming once the permission is granted. Pass a
`port` or use the static TCP/IP port when you need a call that does not depend
on that discovery.

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

`PrivilegeExternalStartProvider` is available in priv-core. The optional
`priv-external-shizuku:0.23.0` module implements it; add it to the host app and
register the provider:

```kotlin
PrivKitExternalStartProviders.register(PrivilegeExternalShizuku)
```

```dart
final providers = await privKit.externalStartProviderIds();
if (providers.isNotEmpty) {
  final id = providers.first;
  final status = await privKit.externalStartCheckAuthorization(id);
  if (status.authorized == true) {
    final command = await privKit.getNativeStarterCommand();
    await privKit.externalStartRun(providerId: id, commandLine: command);
  } else {
    await privKit.externalStartRequestAuthorization(id);
  }
}
```

`authorized` is `null` when unavailable. See the [example](https://github.com/runoob-coder/priv-kit-flutter-plugin/tree/main/example)
for a complete Shizuku demo.

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
  process: PrivUserServiceProcess.embedded,
);

// Dart holds a handle, not the Binder.
final handle = await privKit.bindUserService(spec, daemon: true);
print(await privKit.userServiceIsConnected(handle));
await privKit.unbindUserService(handle);

// Reconnect to the daemon instance without creating a new one.
final again = await privKit.peekUserService(spec);
if (again != null) await privKit.unbindUserService(again);

await privKit.stopUserService(spec);
```

An instance is identified by `serviceClassName` plus `tag`. `daemon` belongs to
`bindUserService`; rebinding with `false` clears daemon. Use `peekUserService`
to reconnect without changing the policy. `stopUserService` destroys the
instance and invalidates all its connections.

Omit `serviceClassName` to use priv-core's built-in Binder forwarding service,
which needs no app-defined class or AIDL:

```dart
const forwarding = PrivUserServiceSpec(
  tag: 'shell-binder',
  process: PrivUserServiceProcess.shell,
);
final connection = await privKit.bindUserService(forwarding);
// ... use `userServiceHandle: connection` on the Binder calls below ...
await privKit.unbindUserService(connection);
```

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

### Choosing the process and UID

`process` mirrors `PrivilegeUserServiceProcess`:

| Selection | `uid` | Execution |
|-----------|-------|-----------|
| `PrivUserServiceProcess.embedded` (default) | `-1` | privileged server process |
| `PrivUserServiceProcess.inherit` | `-2` | dedicated child inheriting the server UID |
| `PrivUserServiceProcess.root` | `0` | dedicated root process |
| `PrivUserServiceProcess.system` | `1000` | dedicated `android` process |
| `PrivUserServiceProcess.shell` | `2000` | dedicated `com.android.shell` process |

Changing the UID does not change the inherited SELinux domain. A dedicated
process owns its lifetime, so its `destroy()` can call `exitProcess(0)`. An
embedded service shares the server process and may only release its own
resources.

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
  source: PrivBinderServiceSource.remoteProcess,
);
```

Defaults to `currentProcess`. Binder transactions still run through the privileged server; pass `remoteProcess` to resolve the service there.

- `currentProcess` — through `ServiceManager` in your own process.
- `remoteProcess` — inside the connected remote process: the Privileged Server,
  or a selected UserService process when `userServiceHandle` is supplied. Use
  it for services only published to `shell` or root. `serverProcess` remains as
  a deprecated alias sending the same `REMOTE_PROCESS` wire value.

A `null` result is normal, not a failure: the service may be absent on this
device, or hidden from the process doing the lookup.

### Forwarding through a UserService

priv-core 0.18.0 can route both the lookup and the resulting wrapper's
transactions through a bound UserService process. Pass the connection handle
from `bindUserService`:

```dart
final connection = await privKit.bindUserService(
  const PrivUserServiceSpec(
    tag: 'shell-binder',
    process: PrivUserServiceProcess.shell,
  ),
);
try {
  final handle = await privKit.binderFromSystemService(
    'activity',
    source: PrivBinderServiceSource.remoteProcess,
    userServiceHandle: connection,
  );
  // ... inspect the handle ...
  if (handle != null) await privKit.binderClose(handle);
} finally {
  await privKit.unbindUserService(connection);
}
```

`binderHasSystemService` takes the same parameter. Keep the connection bound
for as long as you use the handle: unbinding invalidates the wrapper instead of
falling back to the main server. In Kotlin, use
`PrivilegeBinderWrapper.fromSystemService(name, userService = connection)` —
or `fromBinder(binder, userService = connection)` for an existing Binder —
and `connection.callingPackageName` when the target API needs a package
identity. Returned Binders and callbacks are not wrapped recursively.

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
falling back is safe, `PrivilegeBinderCall.orElse` separates an unavailable
channel (`Unavailable`) from a dead target Binder (`BinderDied`) and leaves
other failures propagating unchanged:

```kotlin
PrivilegeBinderCall.orElse(
    fallback = { failure ->
        when (failure) {
            is PrivilegeBinderCallFailure.Unavailable -> fallbackValue
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
print(config.crashLogDirectories); // default: [], i.e. fallback only

await privKit.configureRuntime(
  followDeathDelayMillis: 60000, // wait 1 minute for the owner to come back
  activeReconnectOnOwnerDeath: true,
  crashLogDirectories: [
    '/data/user/0/com.example/files/crashes',
    '/sdcard/Android/data/com.example/files/crashes',
  ],
);
```

Omitted fields keep their current value. Changes are pushed to the connected
server and apply to the **next** owner death — a reconnect flow that has
already started keeps the values it captured when the owner died.

Set `crashLogDirectories` before any startup call. Pass existing absolute
directories owned by one app and Android user, e.g. Kotlin's
`File(filesDir, "privilege-crashes")` and
`getExternalFilesDir("privilege-crashes")`. priv-core tries them in order and
stops at the first successful write; an empty list clears them. `startRoot`,
`startAdb` and external startup pass the list in the launch command; **manual
startup does not** — such a server learns it at the first owner handshake.

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

`readCrashLogs()` merges two sources, de-duplicates by path and returns the
newest first:

- Configured `crashLogDirectories` (or `directories:`), scanned via the file
  proxy. Skipped when no server is connected.
- This app's fallback reports under
  `/data/local/tmp/priv-kit/<applicationId>/<userId>/crashes/`, read with the
  app's own permissions — **no server needed**. Disable with
  `includeFallbackCrashLogs: false`.

Only `priv-crash_uid<uid>_<timestamp>.json` files below 1 MiB are decoded;
`.json.tmp` and malformed files are skipped. Real listing failures still throw
`FILE_ERROR`; only a lost connection is downgraded. Native crashes, `SIGKILL`
and failures before config parsing leave no file — use Logcat. Nothing deletes
these files: remove them with [`fileDelete`](#-file-proxy) after reading.

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

## 📶 Android system settings

Android-only helpers for detecting and opening the switches needed by ADB
startup. They work without a connected Privileged Server; `false` means "off",
"not connected" or "no Activity could handle the Intent", depending on the call.

| Call                                | Purpose                                                    |
|-------------------------------------|------------------------------------------------------------|
| `isRootAvailable`                   | pre-flight check for a usable `su` binary                  |
| `isWifiEnabled`                     | Wi-Fi switch (`Settings.Global.wifi_on`)                   |
| `isWifiConnected`                   | connected to a Wi-Fi network, Internet capability not needed |
| `isWifiReady`                       | Wi-Fi on **and** connected                                 |
| `isDeveloperModeEnabled`            | Developer options enabled                                  |
| `isUsbDebuggingEnabled`             | USB debugging switch on                                    |
| `isWirelessDebuggingEnabled`        | Wireless debugging switch on (API 30+)                     |
| `openWifiSettings`                  | open Wi-Fi settings, highlight the Wi-Fi switch            |
| `openDeveloperSettings`             | Developer options, or About phone when still disabled      |
| `openUsbDebuggingSettings`          | highlight the USB debugging switch                         |
| `openWirelessDebuggingSettings`     | highlight Wireless debugging, or open Wi-Fi if not ready   |
| `checkDeveloperModeStatus`          | combined live state for a wireless debugging flow          |
| `checkUsbDebugStatus`               | combined live state for a manual `adb shell` flow          |

```dart
if (await privKit.isWifiReady()) {
  if (await privKit.checkDeveloperModeStatus() ==
      PrivDeveloperModeStatus.ready) {
    await privKit.startAdb();
  } else {
    await privKit.openWirelessDebuggingSettings();
  }
} else {
  await privKit.openWifiSettings();
}
```

`openWirelessDebuggingSettings()` already redirects to Wi-Fi settings when
Wi-Fi is off or disconnected, because Android refuses to enable Wireless
debugging without a Wi-Fi connection.

`isRootAvailable()` is a pre-flight check only: it never prompts for
authorization and does not mean a root server is connected. Check
`serverState` / `PrivServerInfo.isRoot` for that.

## 🔐 Host app permissions

Runtime permissions for **this app** live in their own class,
`PrivKitPermissions`, available as `privKit.permissions`. Do not confuse them
with `checkPermission` / `grantRuntimePermission`, which act on a package
through a connected Privileged Server.

| Call                                          | Purpose                                      |
|-----------------------------------------------|----------------------------------------------|
| `hasNotificationPermission`                   | `POST_NOTIFICATIONS` state (true below API 33) |
| `requestNotificationPermission`               | ask the current Activity for notifications   |
| `openNotificationPermissionSettings`          | notification settings, app-details fallback  |
| `hasLocalNetworkPermission`                   | `ACCESS_LOCAL_NETWORK` state (true below API 37) |
| `requestLocalNetworkPermission`               | ask the current Activity for local network   |
| `openAppDetailsSettings`                      | app details page                             |

```dart
if (!await privKit.permissions.hasNotificationPermission()) {
  final granted = await privKit.permissions.requestNotificationPermission();
  if (!granted) {
    await privKit.permissions.openNotificationPermissionSettings();
  }
}
```

## 🧩 Kotlin settings Intents

Dart's `open*Settings` methods start the Activity directly, so they cannot give
you an `Intent`. Host Kotlin code can use the public `PrivKitSettingsIntents`
object when it needs the Intent itself, for example for a notification
`PendingIntent`:

```kotlin
import android.app.PendingIntent
import com.noob_coder.priv_kit.PrivKitSettingsIntents

val intent = PrivKitSettingsIntents.wirelessDebugging(context)
val pendingIntent = PendingIntent.getActivity(
    context,
    0,
    intent,
    PendingIntent.FLAG_IMMUTABLE,
)
```

| Builder                          | Result                                                     |
|----------------------------------|------------------------------------------------------------|
| `wifi(context)`                  | Wi-Fi settings, Wi-Fi switch highlighted                   |
| `developer(context)`             | Developer options, or About phone when still disabled      |
| `developerAt(context, key)`      | Developer options with an arbitrary preference highlighted |
| `usbDebugging(context)`          | USB debugging switch highlighted                           |
| `wirelessDebugging(context)`     | Wireless debugging switch highlighted                      |

All builders add `FLAG_ACTIVITY_NEW_TASK`. The highlighted variants also add
`FLAG_ACTIVITY_CLEAR_TASK` and `:settings:fragment_args_key`.

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

- Build your authorization UI on top of the API above: this plugin exposes
  platform channels only, so Flutter apps render their own screens.
- `PrivilegeServerInfo.lifecycleBinder` is not sent across the channel. Dart
  receives `uid`, `pid`, `protocolVersion` and `selinuxContext` only. Use
  [binderServerLifecycle](#-binder-access) when you need it as a handle.
- A UserService's Binder stays in Kotlin: only the lifecycle calls and an
  integer connection handle cross the channel. `fromBinder(target,
  userService = connection)` is therefore Kotlin-only; Dart uses
  `userServiceHandle` on the Binder calls above.

## 🔗 Related Projects

* [shizuku_api_plugin](https://pub.dev/packages/shizuku_api_plugin) — A Flutter plugin to interact
  with the [Shizuku API](https://github.com/RikkaApps/Shizuku-API), allowing your application to
  execute `shell` commands with system or `ADB` privileges.

## 💛 Support

If [`priv_kit`][pub] helps you build better Apps, please consider supporting it.  
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