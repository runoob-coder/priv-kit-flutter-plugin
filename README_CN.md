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
- **服务端生命周期与权限** — ping、关闭、owner 重启、权限查询。
- **ADB 配对与 TCP 控制** — 配对、授权检查、`adb tcpip` 等。
- **命令执行** — 非交互进程，支持汇总输出与流式输出。

尚未接入：文件代理、UserService、Binder 直接访问。

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

插件已经依赖 [`io.github.priv-kit:priv-core`][priv-core]，宿主 App 只需要完成
Priv Kit 要求的平台侧配置。

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

## 🔐 服务端权限

```dart
final denied = await privKit.getDeniedServerPermissions();
final granted = await privKit.checkServerPermission(
  'android.permission.GRANT_RUNTIME_PERMISSIONS',
);
final restricted = await privKit.isPermissionRestricted();
```

`getDeniedServerPermissions` 只覆盖服务端包已声明的 Android 权限，不覆盖
AppOps、SELinux 策略或服务内部授权。因此返回空列表并不代表所有特权操作都能成功。

## 🛠️ ADB 辅助能力

| 调用                                                                                  | 用途                  |
|-------------------------------------------------------------------------------------|---------------------|
| `adbGetIdentityInfo`                                                                | 本 App 的 ADB 身份与密钥指纹 |
| `adbGetActiveTcpPort` / `adbGetConfiguredTcpPort`                                   | 静态端口状态              |
| `adbGetWirelessDebuggingControlStatus`                                              | 是否能管理无线调试           |
| `adbDiscoverPairingPort` / `adbDiscoverConnectPort`                                 | 端口发现（API 30+）       |
| `adbPair` / `adbCheckPairing`                                                       | 配对                  |
| `adbOpenPairingCheckSession` / `adbCheckPairingSession`                             | 轮询时复用连接             |
| `adbPrepareTcpForStart` / `adbCheckTcpAuthorization` / `adbRequestTcpAuthorization` | 授权                  |
| `adbSwitchToTcp` / `adbStopTcp` / `adbRestartTcp`                                   | 控制静态端口              |
| `closeSession`                                                                      | 释放会话句柄              |

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
- 文件代理、UserService、Binder 访问尚未接入本插件。

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

|                                            赞赏码     WeChat                                             |                                          支付宝     Alipay                                           |
|:-----------------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------------:|
| ![赞赏码WeChat](https://raw.githubusercontent.com/runoob-coder/runoob-coder/main/public/appreciate.avif) | ![支付宝Alipay](https://raw.githubusercontent.com/runoob-coder/runoob-coder/main/public/alipay.avif) |

[Priv Kit]: https://priv-kit.pages.dev

[priv-core]: https://github.com/priv-kit/priv-kit/tree/main/priv-core

[pub]: https://pub.dev/packages/priv_kit

[API Reference]: https://pub.dev/documentation/priv_kit/latest/

[GitHub]: https://github.com/runoob-coder/priv-kit-flutter-plugin

[Android Example]: https://github.com/runoob-coder/priv-kit-flutter-plugin/tree/main/example/android

[Hidden API]: https://github.com/LSPosed/AndroidHiddenApiBypass
