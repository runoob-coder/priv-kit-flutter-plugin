# Priv Kit

<div align="center">
   <img src="https://raw.githubusercontent.com/runoob-coder/priv-kit-flutter-plugin/main/priv-kit-mark.svg" width="200" style="width: 200px;" alt="Priv Kit">
</div>

Android 应用自有特权运行时

支持通过 Root、ADB、手动命令和外部授权器启动

[![Pub Version](https://img.shields.io/pub/v/priv_kit.svg)][pub]
[![API Reference](https://img.shields.io/badge/API-Reference-0175C2.svg)](https://pub.dev/documentation/priv_kit/latest/)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/runoob-coder/priv-kit-flutter-plugin)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![CI](https://img.shields.io/github/actions/workflow/status/runoob-coder/priv-kit-flutter-plugin/build_apk.yml?label=CI)](https://github.com/runoob-coder/priv-kit-flutter-plugin/actions/workflows/build_apk.yml)
[![GitHub stars](https://img.shields.io/github/stars/runoob-coder/priv-kit-flutter-plugin.svg?style=social)][GitHub]

[English](README.md) | 简体中文

本插件基于 Flutter 实现，通过平台通道将 [Priv Kit][Priv Kit]
的 Android 运行时 [`priv-core`][priv-core] 无缝桥接到 Dart 侧。

> **状态**：预发布阶段。仅支持 Android，API 仍可能调整。

## 🎯 它解决什么问题

Priv Kit 会启动一个独立的 Privileged Server 进程，并把它的 Binder 交给你的 App。
连接建立后，你的 App 本身无需持有特权，即可执行特权命令、查询服务端状态。

本插件覆盖了 [`priv-core`][priv-core] 中适合由 Dart 驱动的部分：

- **启动方式** — Root、ADB 无线调试、ADB 静态 TCP/IP 端口、手动启动、外部启动
  （例如通过 Shizuku）。
- **连接状态** — 进程级状态流，以及启动过程的诊断日志。
- **服务端生命周期** — ping、关闭、owner 重启、运行时配置。
- **权限** — 服务端权限查询，以及任意包的运行时权限管理。
- **ADB 配对与 TCP 控制** — 配对、授权检查、`adb tcpip` 等。
- **命令执行** — 非交互进程，支持汇总输出与流式输出。
- **文件代理** — 读写与遍历 App 自身无权访问的路径。
- **UserService** — 让自写的 Kotlin 类以服务端权限运行，生命周期由 Dart 驱动。

Binder 直接访问刻意不对外暴露：Binder 无法通过平台通道传递。替代做法见
[UserService](#-userservice)——在 Kotlin 侧自行架桥。

## 📋 平台要求

|              |                     |
|--------------|---------------------|
| 平台           | 仅 Android           |
| Android API  | 26+（Android 8.0）    |
| `compileSdk` | 37+（`priv-core` 要求） |
| Dart SDK     | ^3.12.0             |
| Flutter      | >=3.44.0            |

## 📦 安装

```bash
flutter pub add priv_kit
```

## ⚙️ 宿主 App 配置

插件依赖 [`io.github.priv-kit:priv-core`][priv-core]（0.17.0），并以 `api`
方式暴露，因此 priv-core 的类型就在宿主的编译 classpath 上：编写 UserService
或注册外部启动 bridge 都无需额外声明。

宿主 App 只需要完成 Priv Kit 要求的平台侧配置。
请参阅 [Flutter安卓示例项目][Android Example]。

### 1️⃣ 最低系统版本

```kotlin
// android/app/build.gradle.kts
android {
    defaultConfig {
        minSdk = 26
    }
}
```

### 2️⃣ NATIVE 库打包

`minSdk < 29` 时必须解压 SO，否则 native starter 无法执行：

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

### 3️⃣ [HIDDEN API][Hidden API] 访问

Priv Kit 需要访问 Android 9+ 上的隐藏 API：

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

并在 manifest 中声明：

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<application android:name=".MainApp" ...>
```

### 4️⃣ 无线调试管理（可选）

只有希望运行时在启动期间自动开关无线调试、发现连接端口时才需要：

```xml

<uses-permission android:name="android.permission.WRITE_SECURE_SETTINGS"
    tools:ignore="ProtectedPermissions" />
```

## 🚀 快速开始

```dart
import 'package:priv_kit/priv_kit.dart';

final privKit = PrivKit();

// 1. 监听连接状态。新监听器会立即收到当前值。
privKit.serverState.listen((server) {
  if (server == null) {
    // 已断开
  } else {
    // 已连接，server.uid == 0 表示 root
  }
});

// 2. 启动服务端。
try {
  final info = await privKit.startRoot();
  print('connected: uid=${info.uid} pid=${info.pid}');
} on PrivKitException catch (e) {
  print('${e.code}: ${e.message}');
}

// 3. 在其中执行命令。
final result = await privKit.runCommand(
  PrivCommand(arguments: const ['/system/bin/id']),
);
print(result.stdoutText);
```

## 🔌 通道

| 类型              | 名称                      | 内容                      |
|-----------------|-------------------------|-------------------------|
| `MethodChannel` | `priv_kit`              | 全部调用                    |
| `EventChannel`  | `priv_kit/server_state` | `Privilege.serverState` |
| `EventChannel`  | `priv_kit/startup_log`  | 启动过程诊断日志                |
| `EventChannel`  | `priv_kit/command/<id>` | 单个命令的流式输出               |

每个流式命令独占一条通道，因为 Flutter 的 `EventChannel` 同名通道同一时刻
只能支撑一个广播监听。

## 🔧 启动方式

文档：[快速接入](https://priv-kit.pages.dev/zh/guide/getting-started)、
[启动方式](https://priv-kit.pages.dev/zh/guide/activation)。

### Root 启动

```dart
final info = await privKit.startRoot();
```

Root 启动会检查可用 `su` 路径，执行共享服务端命令，然后等待服务端建立 Binder 连接。

### 无线调试启动

无线调试要求 Android 11 或更高版本。Priv Kit 会为应用保存一组 ADB 密钥，设备授权这组密钥后，
应用才能通过无线调试启动 Privileged Server。

让用户打开“开发者选项 > 无线调试 > 使用配对码配对设备”。配对页面保持打开时，
将页面显示的六位配对码传给 `privKit.adbPair(pairingCode: )`：

配对与启动是两个独立操作——配对成功不会启动服务端：

```dart
final pairing = await privKit.adbCheckPairing();
if (!pairing.paired) {
  await privKit.adbPair(pairingCode: '123456');
}

final info = await privKit.startAdb();
```

`adbPair()` 默认自动发现无线调试的配对端口。应用已经取得端口时，可以直接传入：

```dart
await privKit.adbPair(pairingCode: '123456', port: 5555);
```

### TCP/IP 静态端口启动

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

### 手动启动

适用于用户从开发设备执行 starter 的场景：

```dart
final command = await privKit.getNativeStarterCommand();
// 展示给用户：adb shell $command
```

执行后 Privileged Server 会自行完成 Binder 握手，`serverState` 会收到新值。

### 外部启动

外部授权器（例如 Shizuku UserService）由宿主 App 在 Kotlin 侧注册：

```kotlin
PrivKitExternalStartupBridges.register("shizuku") { commandLine, stdout, stderr, receiver ->
    shizukuService.start(commandLine, stdout, stderr, receiver)
}
```

Dart 侧执行：

```dart
final command = await privKit.getNativeStarterCommand();
final output = await privKit.externalStartupRunThroughBridge(
  commandLine: command,
  bridgeId: 'shizuku',
);
```

### 取消启动

传入自定义 `operationId` 后启动才可取消：

```dart
final id = privKit.nextStartOperationId('adb');
final future = privKit.startAdb(operationId: id);
await privKit.cancelOperation(id); // future 抛出 CANCELLED
```

### 启动诊断日志

```dart
privKit.startupLog.listen((line) {
  print('[${line.source}] ${line.message}');
});
```

## 💻 命令执行

文档：[命令执行](https://priv-kit.pages.dev/zh/guide/commands)。

命令在已连接的 Privileged Server 中启动非交互进程，直接执行参数列表，
**不会隐式增加 shell**。需要 shell 解析时必须显式传入：

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

需要 shell 时：

```dart
final result = await privKit.runCommand(
  PrivCommand(arguments: const ['/system/bin/sh', '-c', 'ls /data/local/tmp']),
);
```

### 📊 两种消费方式（互斥）

每个进程只能选择其中一种。

**汇总输出** — 排空两条流后返回：

```dart
final result = await privKit.runCommand(
  PrivCommand(arguments: const ['/system/bin/cat', '/proc/version']),
  maxBytesPerStream: 1 << 20, // 默认 1 MiB
);
print(result.stdoutTruncated); // 超出部分仍会排空，只是不保留
```

**流式输出** — 边产生边输出，取消订阅即终止远端进程：

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

await sub.cancel(); // 终止远端进程
```

字节块不代表一行，也不保证 UTF-8 字符边界，展示文本时应增量解码。

### ⏱️ 超时与取消

默认 30 秒，从远端进程启动成功后计算，**新输出不会重置倒计时**：

```dart
await privKit.runCommand(cmd, timeoutMillis: 120000);        // 放宽
await privKit.runCommand(cmd, timeoutMillis: noCommandTimeout); // 禁用
```

owner 进程死亡、服务端关闭也会终止未完成的命令。**最多同时运行四个命令**，
超出立即失败，不进入等待队列。

### 🚫 明确限制

不提供 stdin 或 PTY：不支持交互式 shell、终端尺寸、终端信号、ANSI 渲染或
daemon 管理。部分程序在 stdout 连接 pipe 而非终端时会自行缓存，数据可能成批到达。

## 📁 文件代理

文档：[文件代理](https://priv-kit.pages.dev/zh/guide/file-proxy)。

所有操作都在已连接的服务端内执行，因此 Dart 可以访问 App 自身无权读写的路径。
路径是普通字符串且必须是绝对路径，没有本地路径处理能力。

### 🔍 查询

```dart
final exists = await privKit.fileExists('/data/local/tmp/a.txt');
final size = await privKit.fileLength(path);
final isDir = await privKit.fileIsDirectory(path);

final meta = await privKit.fileMetadata('/data/local/tmp');
print(meta.type); // PrivFileType.directory
print(meta.lastModified);
```

另有：`fileIsFile`、`fileIsSymbolicLink`、`fileCanRead`、`fileCanWrite`、
`fileCanExecute`、`fileLastModified`。

### ✏️ 修改

```dart
await privKit.fileMkdirs('/data/local/tmp/demo/nested');
await privKit.fileCreateNewFile('/data/local/tmp/demo/a.txt');
await privKit.fileRenameTo(from, to);
await privKit.fileDelete(path);

// 目录连同内容一起删除
await privKit.fileDeleteRecursively('/data/local/tmp/demo');
```

`fileDeleteRecursively` 不跟随符号链接，目标不存在也算删除成功。返回 `false`
表示至少有一个条目未能删除，其余可能已经删除。

`fileReplaceAtomically(from, to)` 对应 Linux `rename(2)`：两个路径必须在同一
挂载的文件系统上，且不会退化成复制后删除。

### 📖 读写

整文件读写用 `*AllBytes` 便捷方法，内部会打开、传输并关闭：

```dart
await privKit.fileWriteAllBytes(path, bytes, syncOnClose: true);
final data = await privKit.fileReadAllBytes(path);
```

大文件建议自己驱动流。务必关闭句柄——关闭写句柄会一直阻塞，直到服务端消费完
所有字节：

```dart
final handle = await privKit.fileOpenWrite(path, append: true);
try {
  await privKit.fileWrite(handle, chunk);
} finally {
  await privKit.fileClose(handle);
}
```

### 🌳 遍历目录

```dart
await for (final entry in privKit.fileWalk('/data/local/tmp', maxDepth: 1)) {
  print('${entry.depth} ${entry.name} ${entry.metadata?.sizeBytes}');
}
```

`maxDepth: 1` 是非递归的一层列表；省略则遍历整棵子树。`skipDirectoryGlobs`
用于剪掉匹配的目录名。取消订阅即停止遍历。

`entry.metadata` 为 null 表示服务端能枚举该名字但读不到它的属性——这类条目
会被发出但不会进入。

## 🔌 UserService

文档：[UserService](https://priv-kit.pages.dev/zh/guide/user-service)。

UserService 让**你自己写的 Kotlin 类**以服务端权限运行。它是本插件里唯一能执行
「应用自定义代码」的机制——文件代理、命令执行、Binder 访问用的都是 priv-core
已经提供好的能力。

> **先读这条**：UserService 返回的是 Binder，而 **Binder 无法通过平台通道传递**。
> Dart 可以驱动生命周期，但调用你自己的 AIDL 方法必须写在 Kotlin 侧。

### 定义服务

把接口放在 `android/app/src/main/aidl/<你的包名>/` 下，并开启 AIDL 编译——
它**默认是关闭的**，不开启则生成的接口类根本不存在：

```kotlin
// android/app/build.gradle.kts
android {
    buildFeatures {
        aidl = true
    }
}
```

`kotlinx-coroutines-android` 不需要额外声明：priv-core 把它发布在 `api`
变体里，会自动传递到你的 App。

AIDL 接口——`destroy` 的 transaction code 必须是 `16777114`：

```java
interface IMyPrivilegeService {
    void destroy() = 16777114;
    String getUid() = 1;
}
```

Kotlin 实现：

```kotlin
class MyPrivilegeService : IMyPrivilegeService.Stub {
    private var appContext: Context? = null

    @Keep constructor() : super()
    @Keep constructor(context: Context) : super() { appContext = context }

    override fun getUid() = "uid=${Process.myUid()}"

    override fun destroy() {
        // 独立进程拥有自己的生命周期；嵌入式服务不能退出共享进程
        if (!PrivilegeUserServiceEnvironment.isEmbedded) exitProcess(0)
    }
}
```

两个构造器**刻意都写成次级构造器**：在 JVM 上 `Context?` 与 `Context` 擦除后
签名相同，若主构造器取 `Context?`，会与取 `Context` 的次级构造器冲突。

### 由 Dart 驱动生命周期

```dart
const spec = PrivUserServiceSpec(
  serviceClassName: 'com.example.MyPrivilegeService',
  tag: 'main',
  version: 1,
  embedded: false,
  daemon: false,
);

await privKit.startUserService(spec);

// Dart 能持有连接句柄，但无法用它调用服务方法
final handle = await privKit.bindUserService(spec);
await privKit.unbindUserService(handle);

await privKit.stopUserService(spec);
```

实例由 `serviceClassName` + `tag` 标识。实现不再兼容时提升 `version`，运行时会
替换掉旧的运行实例。

### 调用你自己的服务

在 Kotlin 侧把 Binder 转成 AIDL 接口，再通过你自己的通道回传结果。示例 App 的
`DemoUserServiceBridge` 就是这么做的：

```kotlin
val connection = Privilege.bindUserService(spec)
try {
    val service = IMyPrivilegeService.Stub.asInterface(connection.binder)
    service.uid
} finally {
    connection.unbind()
}
```

### 嵌入式与独立进程

- **默认** —— 独立的 `app_process` 子进程。它的 `destroy()` 拥有进程，用
  `exitProcess(0)` 退出。
- **`embedded = true`** —— 跑在 Privileged Server 进程内。绑定更快、省去进程
  启动，但 `destroy()` 只能清理服务自身资源。

## 🔄 服务端生命周期

```dart
await privKit.connectReadyServer(); // 连接已自行宣告的服务端
await privKit.getServerState();     // 当前服务端，未连接时为 null
await privKit.getServerInfo();      // 未连接时抛异常
await privKit.pingServer();         // false 表示连接已死并被清理
await privKit.shutdownServer();

// App 主动重启自身前：
await privKit.prepareOwnerRestart(passiveReconnectTimeoutMillis: 10_000);
// 随后立即结束进程
```

## ⚙️ 运行时配置

控制服务端在 owner 进程死亡时的行为：

```dart
final config = await privKit.getRuntimeConfig();
print(config.followDeathDelay); // 默认 10 分钟

await privKit.configureRuntime(
  followDeathDelayMillis: 60000, // 只等 1 分钟
  activeReconnectOnOwnerDeath: true,
);
```

省略的字段保持当前值。变更会推送到已连接的服务端，并作用于**下一次** owner
死亡——已经启动的重连流程会沿用它在 owner 死亡时捕获的值。

## 🔐 服务端权限

```dart
final denied = await privKit.getDeniedServerPermissions();
final granted = await privKit.checkServerPermission(
  'android.permission.GRANT_RUNTIME_PERMISSIONS',
);
final restricted = await privKit.isPermissionRestricted();
```

`getDeniedServerPermissions` 只覆盖服务端包已声明**且当前系统已定义**的
Android 权限——系统未定义的权限会被排除。它不覆盖 AppOps、SELinux 策略或
服务内部授权，因此返回空列表并不代表所有特权操作都能成功。

从 `priv-core` 0.12.1 起，该结果不再陈旧：修改厂商 USB 调试安全设置后，
无需重启服务端即可反映到结果中。

### 任意包的运行时权限

`checkServerPermission` 检查的是服务端自身。要检查或修改**任意包**的权限，
使用下面这些：

```dart
// 返回 privilegePermissionGranted (0) 或 privilegePermissionDenied (-1)
final result = await privKit.checkPermission(
  permission: 'android.permission.CAMERA',
  packageName: 'com.example.app',
);

// 布尔便捷方法
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

`grantRuntimePermission` 与 `revokeRuntimePermission` 需要服务端持有
`android.permission.GRANT_RUNTIME_PERMISSIONS`，建议先调用
`isPermissionRestricted()` 确认。三者都接受可选的 `userId`（多用户设备），
省略时使用当前 Android 用户。

## 🛠️ ADB 辅助能力

| 调用                                                                                  | 用途                  |
|-------------------------------------------------------------------------------------|---------------------|
| `adbGetIdentityInfo`                                                                | 本 App 的 ADB 身份与密钥指纹 |
| `adbGetActiveTcpPort` / `adbGetConfiguredTcpPort`                                   | 静态端口状态              |
| `adbGetWirelessDebuggingControlStatus`                                              | 是否能管理无线调试           |
| `adbDiscoverPairingPort` / `adbDiscoverConnectPort`                                 | 端口发现（API 30+）       |
| `adbPair` / `adbCheckPairing`                                                       | 配对                  |
| `adbOpenPairingCheckSession` / `adbCheckPairingSession`                             | 轮询时复用连接             |
| `adbOpenTcpAuthorizationCheckSession` / `adbCheckTcpAuthorizationSession`           | 轮询时复用连接             |
| `adbPrepareTcpForStart` / `adbCheckTcpAuthorization` / `adbRequestTcpAuthorization` | 授权                  |
| `adbSwitchToTcp` / `adbStopTcp` / `adbRestartTcp`                                   | 控制静态端口              |
| `closeSession`                                                                      | 释放会话句柄              |

配对检查与 TCP 授权检查都提供会话变体，用于在多次轮询之间复用同一条 ADB 连接。
会话以整型句柄持有，停止轮询后务必 `closeSession`：

```dart
final sessionId = await privKit.adbOpenPairingCheckSession();
final result = await privKit.adbCheckPairingSession(sessionId);
await privKit.closeSession(sessionId);
```

`adbSwitchToTcp`、`adbStopTcp`、`adbRestartTcp` 会影响所有依赖 ADB 的进程，
执行前应先征得用户确认。

## ⚠️ 错误处理

所有失败都会抛出 `PrivKitException`：

| code                 | 含义                               |
|----------------------|----------------------------------|
| `STARTUP_ERROR`      | `PrivilegeStartupException`，启动失败 |
| `SERVER_UNAVAILABLE` | 服务端 Binder 不存在或已死亡               |
| `COMMAND_ERROR`      | 命令无法启动或执行失败                      |
| `COMMAND_TIMEOUT`    | 命令超过执行时限                         |
| `FILE_ERROR`         | 文件操作失败（`IOException`/`ErrnoException`） |
| `INVALID_ARGUMENT`   | 参数校验失败                           |
| `ILLEGAL_STATE`      | 当前状态下不允许该调用                      |
| `SECURITY_ERROR`     | 缺少 Android 权限                    |
| `CANCELLED`          | 被 `cancelOperation` 取消           |
| `UNSUPPORTED_API`    | 该 ADB 能力需要 Android 11（API 30）    |
| `NOT_FOUND`          | 会话句柄或外部启动 bridge id 不存在          |
| `NATIVE_ERROR`       | 其他原生异常                           |

```dart
try {
  await privKit.startRoot();
} on PrivKitException catch (e) {
  switch (e.code) {
    case PrivKitErrorCode.serverUnavailable:
      // 提示用户启动服务端
    case PrivKitErrorCode.cancelled:
      // 用户主动取消
    default:
      print('${e.code}: ${e.message}');
  }
}
```

## 🛠️ 开发

`lib/src/models/` 下的模型由 [freezed](https://pub.dev/packages/freezed) 生成
`==` / `hashCode` / `toString` / `copyWith`，命令事件是 freezed union：

```dart
event.when(
  stdout: (bytes) => ...,
  stderr: (bytes) => ...,
  exit: (code) => ...,
);
```

改动模型后重新生成（生成文件已提交，发布包不需要再跑一次）：

```bash
dart run build_runner build
```

刻意没有启用 `json_serializable`：平台通道传的 `Map` 不是 JSON，
`Uint8List` 之类的二进制值不该走 JSON 编解码，因此 `fromMap` / `toMap`
保留手写，字段名与 Kotlin 侧一一对齐。

## 📝 说明

- `priv-ui` 的 `PrivilegeScaffold` 是 Compose 组件，本插件没有通过
  `PlatformView` 暴露它；Flutter App 应基于上面的 API 自行实现授权界面，
  这与文档「使用 priv-core 构建自定义界面」一节一致。
- `PrivilegeServerInfo.lifecycleBinder` 不跨通道传递，Dart 侧只拿到
  `uid` / `pid` / `protocolVersion` / `selinuxContext`。
- UserService 的 Binder 始终留在 Kotlin 侧，跨通道的只有生命周期调用和
  一个整型连接句柄。

## 🔗 相关项目

* [shizuku_api_plugin](https://pub.dev/packages/shizuku_api_plugin) — 一个用于对接
  [Shizuku API](https://github.com/RikkaApps/Shizuku-API) 的 Flutter 插件，让你的应用可以以系统权限或
  `ADB` 权限执行 `shell` 命令。

## 💛 Support

If [`priv_kit`][pub] helps you build better UIs, please consider supporting it.  
It only takes a few seconds and helps other Flutter developers discover the library.

- ⭐ [Star on GitHub][GitHub]
- 👍 [Like on pub.dev][pub]


## [☕️ 请我喝奶茶](https://www.noob-coder.com/buy-me-a-coffee)

<table>
<thead>
<tr>
    <th style="text-align:center;">赞赏码 WeChat</th>
    <th style="text-align:center;">支付宝 Alipay</th>
</tr>
</thead>
<tbody>
<tr>
    <td width="50%"><img src="https://raw.githubusercontent.com/runoob-coder/runoob-coder/main/public/appreciate.avif" alt="赞赏码WeChat" /></td>
    <td width="50%"><img src="https://raw.githubusercontent.com/runoob-coder/runoob-coder/main/public/alipay.avif" alt="支付宝Alipay" /></td>
  </tr>
</tbody>
</table>

[Priv Kit]: https://priv-kit.pages.dev

[priv-core]: https://github.com/priv-kit/priv-kit/tree/main/priv-core

[pub]: https://pub.dev/packages/priv_kit

[API Reference]: https://pub.dev/documentation/priv_kit/latest/

[GitHub]: https://github.com/runoob-coder/priv-kit-flutter-plugin

[Android Example]: https://github.com/runoob-coder/priv-kit-flutter-plugin/tree/main/example/android

[Hidden API]: https://github.com/LSPosed/AndroidHiddenApiBypass
