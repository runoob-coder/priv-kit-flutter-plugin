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
