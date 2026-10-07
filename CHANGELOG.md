## 0.0.10

### Upgrade priv-core 0.17.2 → 0.17.4

The server and dedicated UserServices now write a report when they die on an
uncaught Java/Kotlin exception: `readCrashLogs()` returns them as `PrivCrashLog`
values, newest first, and `configureRuntime(crashLogDirectory:)` chooses where
they land. They are read through the file proxy, so a server must be connected,
and nothing deletes them. `fileWalk()` additionally accepts a symbolic-link root
such as `/sdcard`. Otherwise nothing changes: a rejected ADB setting write only
reports a better message.

## 0.0.9

### Upgrade priv-core 0.17.1 → 0.17.2

`PrivilegeBinderWrapper.shellCommand()` is now kept under R8, so it stays
callable from Kotlin in release builds. No API changed and the Dart surface is
untouched.

## 0.0.8

### Upgrade priv-core 0.17.0 → 0.17.1

`checkServerPermission()` now returns `PERMISSION_GRANTED` directly for root
servers (UID 0), skipping the system permission query. The connection is still
validated, so the call keeps failing when the server is gone.

This matches the behaviour already documented for `getDeniedServerPermissions()`
(empty list for root) and `isPermissionRestricted()` (`false` for root); the Dart
docs and both READMEs now state the root short-circuit for all three.

## 0.0.7

### Binder access

Exposes `priv.kit.core.binder`, so Dart can resolve system services and the
connected server's lifecycle Binder:

- `binderHasSystemService(name, source)` — whether the service resolves.
- `binderFromSystemService(name, source)` — an integer handle, or `null` when
  the service is unavailable.
- `binderServerLifecycle()` — the server's lifecycle Binder, an ownership token
  for privileged APIs that release resources when their owner dies.
- `binderGetInterfaceDescriptor` / `binderPing` / `binderIsAlive` — what Dart
  is allowed to ask a Binder about itself.
- `binderClose(handle)` — release a handle.

`PrivBinderServiceSource` selects which process does the lookup:
`currentProcess` uses `ServiceManager` in the app, `serverProcess` looks inside
the Privileged Server for services only published to `shell` or root.

**A Binder cannot cross the platform channel**, so Dart only ever holds an
integer handle. Issuing a service's own transactions stays in Kotlin — the same
split as a UserService: resolve with
`PrivilegeBinderWrapper.fromSystemService` and convert the Binder with your
AIDL's `Stub.asInterface(...)`.

The example app adds `DemoBinderBridge`, which drives the DUMP transaction (the
one behind `dumpsys`, implemented by every system service) so the round trip
needs no app-specific AIDL, and uses `PrivilegeBinderCall.orElse` to separate
`ServerUnavailable` from `BinderDied`.

New error code `BINDER_DIED` for `DeadObjectException`, where the endpoint died
rather than the server.

## 0.0.6

### UserService

Exposes `priv.kit.core.userservice` — the only mechanism here that runs
**app-defined code** with the server's privileges:

- `startUserService` / `stopUserService` — drive the lifecycle from Dart.
- `bindUserService` / `unbindUserService` — bind and release a connection,
  identified by an integer handle.

`PrivUserServiceSpec` carries `serviceClassName`, `tag`, `version`, `embedded`
and `daemon`.

**A Binder cannot cross the platform channel**, so Dart cannot call the
service's own AIDL methods — `bindUserService` exists only so Dart can manage
the connection lifetime. Invoking the service has to happen in Kotlin:

```kotlin
val service = IMyService.Stub.asInterface(connection.binder)
```

The example app adds `IDemoPrivilegeService.aidl`, `DemoPrivilegeService` and
`DemoUserServiceBridge` (its own method channel) to show that split.

The plugin now depends on priv-core with `api` instead of `implementation`: its
public API exposes priv-core types, and host apps that write a UserService or
register an external startup bridge need them on the compile classpath.

## 0.0.5

### File proxy

Exposes `priv.kit.core.file`, so Dart can read, write and traverse paths the
app itself cannot reach. Every operation runs inside the connected server.

- Query: `fileExists`, `fileIsFile`, `fileIsDirectory`, `fileIsSymbolicLink`,
  `fileCanRead`, `fileCanWrite`, `fileCanExecute`, `fileLength`,
  `fileLastModified`, `fileMetadata`.
- Mutate: `fileCreateNewFile`, `fileMkdir`, `fileMkdirs`, `fileDelete`,
  `fileRenameTo`, `fileReplaceAtomically`, `fileDeleteRecursively`.
- Streams: `fileOpenRead` / `fileRead` / `fileOpenWrite` / `fileWrite` /
  `fileClose`, plus the `fileReadAllBytes` and `fileWriteAllBytes` helpers.
- Traversal: `fileWalk`, which streams `PrivFileEntry` values.

Streams cannot cross a platform channel, so they are exposed through integer
handles; walks get a per-walk `EventChannel`, the same approach already used
for command output. Cancelling a walk subscription stops the traversal.

New error code `FILE_ERROR` covers `IOException` and `ErrnoException`, e.g. a
cross-filesystem `rename(2)` or a permission failure.

## 0.0.4

### Runtime configuration

Exposes `priv.kit.core.PrivilegeConfig`, the owner-death reconnect policy:

- `getRuntimeConfig()` — current `PrivRuntimeConfig`
  (`followDeathDelayMillis`, `activeReconnectOnOwnerDeath`).
- `configureRuntime(followDeathDelayMillis:, activeReconnectOnOwnerDeath:)`
  — replaces it atomically. Omitted fields keep their current value.

Upstream defaults are 10 minutes and `false`, also exported as
`privilegeDefaultFollowDeathDelayMillis` /
`privilegeDefaultActiveReconnectOnOwnerDeath`.

Changes are pushed to the connected server and apply to the next owner death;
a reconnect flow already in progress keeps the values it captured.

## 0.0.3

### Runtime permission management for any package

Adds three calls that operate on arbitrary packages, where the existing
`checkServerPermission` only inspects the connected server itself:

- `checkPermission(permission, packageName, userId)` — returns
  `privilegePermissionGranted` (0) or `privilegePermissionDenied` (-1).
- `grantRuntimePermission(packageName, permission, userId)`
- `revokeRuntimePermission(packageName, permission, userId)`

Also adds `isPermissionGranted(...)`, a boolean convenience wrapper over
`checkPermission`.

`userId` is optional and defaults to the current Android user. Grant and
revoke require the connected server to hold
`android.permission.GRANT_RUNTIME_PERMISSIONS`, so check
`isPermissionRestricted()` first.

## 0.0.2

### Upgrade priv-core 0.12.0 → 0.15.0

- v0.14.0 — `getDeniedServerPermissions()` now only returns permissions that
  are **defined on the current device**; permissions the system does not define
  are excluded.
- v0.12.1 — Permission checks and denied-permission lists no longer go stale
  after changing a vendor USB debugging security setting; they update without
  restarting the server.

## 0.0.1

* Initial release: Flutter platform channels for the Priv Kit Android runtime
  (`priv-core` 0.12.0), covering Root / ADB wireless / ADB TCP-IP / manual /
  external startup, server state and startup log event channels, server
  lifecycle and permission queries, ADB pairing and TCP control calls, and
  command execution (`runCommand` / `startCommand`).
