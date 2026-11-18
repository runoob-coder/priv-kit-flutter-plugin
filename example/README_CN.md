# priv_kit_example

`priv_kit` 插件示例。英文文档见 [README.md](README.md)。

## 运行

```sh
flutter pub get
flutter run
```

## Shizuku 演示

`MainApp` 注册了 `PrivilegeExternalShizuku`。应用内面板可检查授权、请求授权，并通过 provider 启动特权服务端。

非 root 设备：在 Shizuku 管理器选择「通过连接电脑启动（使用 adb）」，执行页面给出的命令。

状态来自 provider 会话。部分 Shizuku 版本管理器仍显示「已授权 0 个应用」，可用命令确认权限：

```sh
adb shell dumpsys package com.noob_coder.priv_kit_example | grep API_V23
# moe.shizuku.manager.permission.API_V23: granted=true
```
