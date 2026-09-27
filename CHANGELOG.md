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
