# priv_kit_example

Flutter demo for the `priv_kit` plugin. See [README_CN.md](README_CN.md) for Chinese.

## Run

```sh
flutter pub get
flutter run
```

## Shizuku demo

`MainApp` registers `PrivilegeExternalShizuku`. The Shizuku panel can check
authorization, request it, and start the privileged server through the provider.

On a non-rooted device, use **Start via computer (adb)** in Shizuku Manager and
run the command shown there.

The in-app status comes from the provider session. Some Shizuku builds still
show `0 authorized apps` in Manager after granting. Verify with:

```sh
adb shell dumpsys package com.noob_coder.priv_kit_example | grep API_V23
# moe.shizuku.manager.permission.API_V23: granted=true
```
