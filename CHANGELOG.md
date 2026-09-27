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
