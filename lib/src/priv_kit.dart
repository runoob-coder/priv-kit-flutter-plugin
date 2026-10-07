import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import '../priv_kit_platform_interface.dart';
import 'exceptions.dart';
import 'models/adb.dart';
import 'models/binder.dart';
import 'models/command.dart';
import 'models/config.dart';
import 'models/crash_log.dart';
import 'models/external_startup.dart';
import 'models/file.dart';
import 'models/permission.dart';
import 'models/server_info.dart';
import 'models/startup_log.dart';
import 'models/user_service.dart';

/// Dart entry point of the Priv Kit plugin.
///
/// Every call is forwarded to `priv-core` on Android through a method channel.
/// All [PrivKitException]s carry the error code reported by the native runtime.
class PrivKit {
  PrivKit({PrivKitPlatform? platform})
    : _platform = platform ?? PrivKitPlatform.instance;

  final PrivKitPlatform _platform;

  int _operationCounter = 0;
  int _commandCounter = 0;
  int _walkCounter = 0;

  /// Process-wide connection state of the Privileged Server.
  ///
  /// A non-null value means a server is connected, `null` means disconnected.
  /// Every new listener immediately receives the current value.
  Stream<PrivServerInfo?> get serverState => _platform.serverState;

  /// Diagnostic lines emitted while a start operation is running.
  Stream<PrivStartupLogLine> get startupLog => _platform.startupLog;

  /// Starts the Privileged Server through `su`.
  ///
  /// Cancelling is possible through [cancelOperation] when [operationId] is
  /// known; a generated id is used when it is omitted.
  Future<PrivServerInfo> startRoot({int? timeoutMillis, String? operationId}) {
    final id = operationId ?? _nextOperationId('root');
    return _guard(
      () => _platform.startRoot(timeoutMillis: timeoutMillis, operationId: id),
    );
  }

  /// Starts the Privileged Server through ADB.
  ///
  /// [options] controls Wireless Debugging management and, through
  /// [PrivAdbConnectionOptions.port], whether the static TCP/IP port is used
  /// instead of discovering the Wireless Debugging connect port.
  Future<PrivServerInfo> startAdb({
    PrivAdbConnectionOptions? options,
    int? timeoutMillis,
    String? adbDeviceName,
    String? operationId,
  }) {
    final id = operationId ?? _nextOperationId('adb');
    return _guard(
      () => _platform.startAdb(
        options: options,
        timeoutMillis: timeoutMillis,
        adbDeviceName: adbDeviceName,
        operationId: id,
      ),
    );
  }

  /// Cancels a running start operation.
  ///
  /// The id is the one returned by [nextStartOperationId] or passed explicitly
  /// to [startRoot] / [startAdb].
  Future<void> cancelOperation(String operationId) =>
      _guard(() => _platform.cancelOperation(operationId));

  /// Generates an operation id so the matching start call can be cancelled.
  String nextStartOperationId(String prefix) => _nextOperationId(prefix);

  String _nextOperationId(String prefix) =>
      '${prefix}_${DateTime.now().microsecondsSinceEpoch}_${++_operationCounter}';

  /// Connects a server that has already announced itself, if any.
  Future<PrivServerInfo?> connectReadyServer() =>
      _guard(_platform.connectReadyServer);

  /// The currently connected server, or `null`.
  Future<PrivServerInfo?> getServerState() => _guard(_platform.getServerState);

  /// The connected server; throws when no server is connected.
  Future<PrivServerInfo> getServerInfo() => _guard(_platform.getServerInfo);

  /// Pings the server Binder, clearing the connection when it is dead.
  Future<bool> pingServer() => _guard(_platform.pingServer);

  /// Shuts the connected server down and clears the local connection.
  Future<void> shutdownServer() => _guard(_platform.shutdownServer);

  /// Tells the connected server that this owner process is about to restart.
  ///
  /// Call this only after the app's own restart trigger has been scheduled and
  /// immediately before terminating the owner process.
  Future<void> prepareOwnerRestart({
    required int passiveReconnectTimeoutMillis,
  }) => _guard(
    () => _platform.prepareOwnerRestart(
      passiveReconnectTimeoutMillis: passiveReconnectTimeoutMillis,
    ),
  );

  /// Permissions declared for the server's packages but denied to its process.
  ///
  /// The result is sorted and de-duplicated. It does not cover AppOps, SELinux
  /// policy or service internal authorization, so an empty list does not
  /// guarantee that every privileged operation succeeds.
  ///
  /// Root servers ([PrivServerInfo.isRoot]) always return an empty list.
  Future<List<String>> getDeniedServerPermissions() =>
      _guard(_platform.getDeniedServerPermissions);

  /// Checks one permission against the connected server.
  ///
  /// Returns [privilegePermissionGranted] (0) or
  /// [privilegePermissionDenied] (-1).
  ///
  /// Root servers ([PrivServerInfo.isRoot]) are not queried through the system:
  /// they return [privilegePermissionGranted] directly. The connection is still
  /// validated, so the call fails when the server is gone.
  Future<int> checkServerPermission(String permission) =>
      _guard(() => _platform.checkServerPermission(permission));

  /// Whether the connected server cannot grant runtime permissions.
  ///
  /// Root servers ([PrivServerInfo.isRoot]) are never restricted.
  Future<bool> isPermissionRestricted() =>
      _guard(_platform.isPermissionRestricted);

  /// Checks [permission] against [packageName].
  ///
  /// Unlike [checkServerPermission], which inspects the connected server
  /// itself, this can inspect any package on the device.
  ///
  /// Returns [privilegePermissionGranted] (0) or
  /// [privilegePermissionDenied] (-1). Omit [userId] to use the current
  /// Android user.
  Future<int> checkPermission({
    required String permission,
    required String packageName,
    int? userId,
  }) => _guard(
    () => _platform.checkPermission(
      permission: permission,
      packageName: packageName,
      userId: userId,
    ),
  );

  /// Whether [packageName] currently holds [permission].
  ///
  /// Convenience wrapper over [checkPermission].
  Future<bool> isPermissionGranted({
    required String permission,
    required String packageName,
    int? userId,
  }) async =>
      await checkPermission(
        permission: permission,
        packageName: packageName,
        userId: userId,
      ) ==
      privilegePermissionGranted;

  /// Grants [permission] to [packageName].
  ///
  /// Requires the connected server to hold
  /// `android.permission.GRANT_RUNTIME_PERMISSIONS`; use
  /// [isPermissionRestricted] to check first. Omit [userId] to use the current
  /// Android user.
  Future<void> grantRuntimePermission({
    required String packageName,
    required String permission,
    int? userId,
  }) => _guard(
    () => _platform.grantRuntimePermission(
      packageName: packageName,
      permission: permission,
      userId: userId,
    ),
  );

  /// Revokes [permission] from [packageName].
  ///
  /// Requires the connected server to hold
  /// `android.permission.GRANT_RUNTIME_PERMISSIONS`. Omit [userId] to use the
  /// current Android user.
  Future<void> revokeRuntimePermission({
    required String packageName,
    required String permission,
    int? userId,
  }) => _guard(
    () => _platform.revokeRuntimePermission(
      packageName: packageName,
      permission: permission,
      userId: userId,
    ),
  );

  /// Starts an app-defined UserService.
  ///
  /// The service is a Kotlin class you write, implementing an AIDL interface,
  /// and it runs with the server's privileges. See [bindUserService] for how to
  /// reach it.
  Future<void> startUserService(PrivUserServiceSpec spec) =>
      _guard(() => _platform.startUserService(spec));

  /// Binds an app-defined UserService and returns a connection handle.
  ///
  /// **The Binder cannot cross the platform channel**, so Dart cannot call the
  /// service's own AIDL methods. This call exists so Dart can manage the
  /// connection lifetime: keep the handle and pass it to [unbindUserService].
  ///
  /// To invoke your service's methods, bind it from Kotlin, convert the Binder
  /// with `YourService.Stub.asInterface(connection.binder)` and expose the
  /// result to Dart through your own method channel.
  Future<int> bindUserService(PrivUserServiceSpec spec) =>
      _guard(() => _platform.bindUserService(spec));

  /// Releases a connection handle returned by [bindUserService].
  Future<void> unbindUserService(int connectionHandle) =>
      _guard(() => _platform.unbindUserService(connectionHandle));

  /// Stops an app-defined UserService.
  Future<void> stopUserService(PrivUserServiceSpec spec) =>
      _guard(() => _platform.stopUserService(spec));

  /// Whether [serviceName] can be resolved from [source].
  ///
  /// Cheaper than [binderFromSystemService] when you only need to know whether
  /// the service exists — for example to decide which source to use.
  Future<bool> binderHasSystemService(
    String serviceName, {
    PrivBinderServiceSource source = PrivBinderServiceSource.currentProcess,
  }) => _guard(
    () => _platform.binderHasSystemService(serviceName, source: source),
  );

  /// Resolves [serviceName] into a handle Dart can inspect, or `null` when the
  /// service is not available from [source].
  ///
  /// **A Binder cannot cross the platform channel.** Dart gets an integer
  /// handle, and can only ask the Binder about itself — [binderPing],
  /// [binderIsAlive], [binderGetInterfaceDescriptor]. Issuing the service's own
  /// transactions is Kotlin work, exactly like calling a UserService: resolve
  /// the Binder there with
  /// `PrivilegeBinderWrapper.fromSystemService(name)`, convert it with your
  /// AIDL's `Stub.asInterface(...)` and report the result over your own
  /// channel.
  ///
  /// Release the handle with [binderClose] when you are done with it.
  Future<int?> binderFromSystemService(
    String serviceName, {
    PrivBinderServiceSource source = PrivBinderServiceSource.currentProcess,
  }) => _guard(
    () => _platform.binderFromSystemService(serviceName, source: source),
  );

  /// Handle for the connected server's lifecycle Binder, or `null` when no
  /// server is connected.
  ///
  /// Some privileged Binder APIs take an owner or death token so the remote
  /// process can release resources when the owner goes away. This Binder binds
  /// those resources to the current server process instead.
  ///
  /// It exposes no privileged operations and no custom transactions — only
  /// [binderPing], [binderIsAlive] and [binderClose] work on it. Its identity
  /// is stable for as long as this server process lives, so take a fresh handle
  /// after every [serverState] change rather than caching one across
  /// reconnections.
  Future<int?> binderServerLifecycle() =>
      _guard(_platform.binderServerLifecycle);

  /// The interface descriptor [handle] reports, when it has one.
  Future<String?> binderGetInterfaceDescriptor(int handle) =>
      _guard(() => _platform.binderGetInterfaceDescriptor(handle));

  /// Whether [handle] answers a ping.
  ///
  /// For a service resolved with [PrivBinderServiceSource.serverProcess] this
  /// checks the server side rather than the endpoint itself.
  Future<bool> binderPing(int handle) =>
      _guard(() => _platform.binderPing(handle));

  /// Whether the process hosting [handle] is still alive.
  Future<bool> binderIsAlive(int handle) =>
      _guard(() => _platform.binderIsAlive(handle));

  /// Releases a handle from [binderFromSystemService] or
  /// [binderServerLifecycle].
  Future<void> binderClose(int handle) =>
      _guard(() => _platform.binderClose(handle));

  /// Reads one metadata snapshot of [path].
  ///
  /// Symbolic links are not followed by default.
  Future<PrivFileMetadata> fileMetadata(
    String path, {
    bool followSymbolicLinks = false,
  }) => _guard(
    () =>
        _platform.fileMetadata(path, followSymbolicLinks: followSymbolicLinks),
  );

  /// Whether [path] exists.
  Future<bool> fileExists(String path) =>
      _guard(() => _platform.fileExists(path));

  /// Whether [path] is a regular file.
  Future<bool> fileIsFile(String path) =>
      _guard(() => _platform.fileIsFile(path));

  /// Whether [path] is a directory.
  Future<bool> fileIsDirectory(String path) =>
      _guard(() => _platform.fileIsDirectory(path));

  /// Whether [path] is a symbolic link.
  Future<bool> fileIsSymbolicLink(String path) =>
      _guard(() => _platform.fileIsSymbolicLink(path));

  /// Whether [path] can be read.
  Future<bool> fileCanRead(String path) =>
      _guard(() => _platform.fileCanRead(path));

  /// Whether [path] can be written.
  Future<bool> fileCanWrite(String path) =>
      _guard(() => _platform.fileCanWrite(path));

  /// Whether [path] can be executed.
  Future<bool> fileCanExecute(String path) =>
      _guard(() => _platform.fileCanExecute(path));

  /// Size of [path] in bytes.
  Future<int> fileLength(String path) =>
      _guard(() => _platform.fileLength(path));

  /// Last modification time of [path], in milliseconds since the epoch.
  Future<int> fileLastModified(String path) =>
      _guard(() => _platform.fileLastModified(path));

  /// Creates [path] as a new empty file.
  Future<bool> fileCreateNewFile(String path) =>
      _guard(() => _platform.fileCreateNewFile(path));

  /// Creates [path] as a directory, requiring its parent to exist.
  Future<bool> fileMkdir(String path) =>
      _guard(() => _platform.fileMkdir(path));

  /// Creates [path] as a directory, creating missing parents.
  Future<bool> fileMkdirs(String path) =>
      _guard(() => _platform.fileMkdirs(path));

  /// Deletes [path]. A directory must be empty; use
  /// [fileDeleteRecursively] for a non-empty one.
  Future<bool> fileDelete(String path) =>
      _guard(() => _platform.fileDelete(path));

  /// Renames [from] to [to].
  Future<bool> fileRenameTo(String from, String to) =>
      _guard(() => _platform.fileRenameTo(from, to));

  /// Atomically renames [from] over [to] using Linux `rename(2)`.
  ///
  /// Both paths must be on the same mounted filesystem; there is no copy or
  /// delete fallback. Fails with [PrivKitErrorCode.file] when they are not.
  Future<void> fileReplaceAtomically(String from, String to) =>
      _guard(() => _platform.fileReplaceAtomically(from, to));

  /// Deletes [path] and, when it is a directory, all of its descendants.
  ///
  /// The traversal does not follow symbolic links. A missing target counts as
  /// deleted. A `false` result means at least one entry could not be deleted;
  /// others may already have been removed.
  Future<bool> fileDeleteRecursively(String path) =>
      _guard(() => _platform.fileDeleteRecursively(path));

  /// Opens [path] for reading and returns a stream handle.
  ///
  /// Pass the handle to [fileRead] and release it with [fileClose].
  Future<int> fileOpenRead(String path) =>
      _guard(() => _platform.fileOpenRead(path));

  /// Reads the whole of [path] as bytes.
  ///
  /// Convenience wrapper that opens, drains and closes the stream.
  Future<Uint8List> fileReadAllBytes(String path) async {
    final handle = await fileOpenRead(path);
    try {
      final chunks = <int>[];
      while (true) {
        final chunk = await fileRead(handle);
        if (chunk.isEmpty) break;
        chunks.addAll(chunk);
      }
      return Uint8List.fromList(chunks);
    } finally {
      await fileClose(handle);
    }
  }

  /// Opens [path] for writing and returns a stream handle.
  ///
  /// When [syncOnClose] is true the server calls `fsync(2)` before reporting
  /// completion. Closing waits for the server to consume every byte.
  Future<int> fileOpenWrite(
    String path, {
    bool append = false,
    bool syncOnClose = false,
  }) => _guard(
    () =>
        _platform.fileOpenWrite(path, append: append, syncOnClose: syncOnClose),
  );

  /// Writes [bytes] and closes the stream, waiting for the server to finish.
  ///
  /// Convenience wrapper that opens, writes and closes.
  Future<void> fileWriteAllBytes(
    String path,
    Uint8List bytes, {
    bool append = false,
    bool syncOnClose = false,
  }) async {
    final handle = await fileOpenWrite(
      path,
      append: append,
      syncOnClose: syncOnClose,
    );
    try {
      await fileWrite(handle, bytes);
    } finally {
      await fileClose(handle);
    }
  }

  /// Reads up to [maxBytes] from [handle]. An empty list means end of file.
  Future<Uint8List> fileRead(
    int handle, {
    int maxBytes = privilegeFileDefaultReadChunkBytes,
  }) => _guard(() => _platform.fileRead(handle, maxBytes: maxBytes));

  /// Writes [bytes] to [handle].
  Future<void> fileWrite(int handle, Uint8List bytes) =>
      _guard(() => _platform.fileWrite(handle, bytes));

  /// Closes a stream handle opened by [fileOpenRead] or [fileOpenWrite].
  Future<void> fileClose(int handle) =>
      _guard(() => _platform.fileClose(handle));

  /// Streams the descendants of the directory at [path].
  ///
  /// The directory itself is not emitted; direct children have depth 1, so
  /// `maxDepth: 1` is a non-recursive listing. Cancelling the subscription
  /// stops the walk. The traversal does not follow symbolic links.
  Stream<PrivFileEntry> fileWalk(
    String path, {
    int? maxDepth,
    List<String>? skipDirectoryGlobs,
    int? flushBatchSize,
  }) {
    final id = nextWalkOperationId();
    return Stream<void>.fromFuture(
      _guard(
        () => _platform.fileWalkStart(
          id,
          path,
          maxDepth: maxDepth,
          skipDirectoryGlobs: skipDirectoryGlobs,
          flushBatchSize: flushBatchSize,
        ),
      ),
    ).asyncExpand((_) => _platform.fileWalkEntries(id));
  }

  /// Generates a walk operation id, so several walks can run at once.
  String nextWalkOperationId() =>
      'walk_${DateTime.now().microsecondsSinceEpoch}_${++_walkCounter}';

  /// The current owner-death reconnect policy.
  Future<PrivRuntimeConfig> getRuntimeConfig() =>
      _guard(_platform.getRuntimeConfig);

  /// Replaces the owner-death reconnect policy.
  ///
  /// Omitted fields keep their current value. The change is pushed to the
  /// connected server and applies to the **next** owner death: a reconnect flow
  /// that already started keeps the values it captured when the owner died.
  ///
  /// [crashLogDirectory] must be absolute and cover only this app and Android
  /// user, for example the value of `getExternalFilesDir("privilege-crashes")`.
  /// Set it as early as possible: it reaches the server through the native
  /// startup command, so a process started afterwards still writes to the
  /// previous location. `null` keeps the directory unchanged.
  Future<void> configureRuntime({
    int? followDeathDelayMillis,
    bool? activeReconnectOnOwnerDeath,
    String? crashLogDirectory,
  }) => _guard(
    () => _platform.configureRuntime(
      followDeathDelayMillis: followDeathDelayMillis,
      activeReconnectOnOwnerDeath: activeReconnectOnOwnerDeath,
      crashLogDirectory: crashLogDirectory,
    ),
  );

  /// Reads the crash reports written by privileged processes.
  ///
  /// Scans [directory], defaulting to the [PrivRuntimeConfig.crashLogDirectory]
  /// reported by [getRuntimeConfig], and — unless [includeFallbackDirectory] is
  /// false — also [privilegeCrashLogFallbackDirectory], where reports land when
  /// no directory is configured. Reports are sorted newest first.
  ///
  /// Every scan runs through the file proxy, so a Privileged Server has to be
  /// connected; an ordinary app cannot list the shared fallback directory. The
  /// fallback is shared between apps and users, so filter by
  /// [PrivCrashLog.applicationId] and [PrivCrashLog.userId] when it matters.
  ///
  /// Only `priv-crash_*.json` files below [privilegeCrashLogMaxBytes] are
  /// decoded. Cleanup belongs to the caller: priv-core never deletes a report.
  /// Fails with [PrivKitErrorCode.file] when a directory cannot be listed.
  Future<List<PrivCrashLog>> readCrashLogs({
    String? directory,
    bool includeFallbackDirectory = true,
  }) async {
    final configured =
        directory ?? (await getRuntimeConfig()).crashLogDirectory;
    final directories = <String>{
      if (configured != null && configured.isNotEmpty) configured,
      if (includeFallbackDirectory) privilegeCrashLogFallbackDirectory,
    };
    final reports = <PrivCrashLog>[];
    await _guard(() async {
      for (final current in directories) {
        await for (final entry in fileWalk(current, maxDepth: 1)) {
          if (!entry.name.startsWith(privilegeCrashLogFilePrefix) ||
              !entry.name.endsWith(privilegeCrashLogFileSuffix)) {
            continue;
          }
          if ((entry.metadata?.sizeBytes ?? 0) > privilegeCrashLogMaxBytes) {
            continue;
          }
          final json = jsonDecode(
            utf8.decode(await fileReadAllBytes(entry.absolutePath)),
          );
          if (json is! Map) continue;
          reports.add(PrivCrashLog.fromJson(json));
        }
      }
    });
    reports.sort(
      (a, b) => b.crashedAtEpochMillis.compareTo(a.crashedAtEpochMillis),
    );
    return reports;
  }

  /// The device-side shell command that starts the native starter.
  ///
  /// Prefix it with `adb shell ` when showing it to a development machine.
  /// The starter only runs as root (0), system (1000) or shell (2000).
  Future<String> getNativeStarterCommand() =>
      _guard(_platform.getNativeStarterCommand);

  /// ADB identity of this app, including its public key fingerprint.
  Future<PrivAdbIdentityInfo> adbGetIdentityInfo({String? adbDeviceName}) =>
      _guard(() => _platform.adbGetIdentityInfo(adbDeviceName: adbDeviceName));

  /// The static ADB port adbd is currently listening on, if any.
  Future<int?> adbGetActiveTcpPort({String? adbDeviceName}) =>
      _guard(() => _platform.adbGetActiveTcpPort(adbDeviceName: adbDeviceName));

  /// The static ADB port previously configured by this app, if any.
  Future<int?> adbGetConfiguredTcpPort({String? adbDeviceName}) => _guard(
    () => _platform.adbGetConfiguredTcpPort(adbDeviceName: adbDeviceName),
  );

  /// Whether Priv Kit can manage Wireless Debugging on this device.
  Future<PrivAdbWirelessDebuggingControlStatus>
  adbGetWirelessDebuggingControlStatus({String? adbDeviceName}) => _guard(
    () => _platform.adbGetWirelessDebuggingControlStatus(
      adbDeviceName: adbDeviceName,
    ),
  );

  /// Discovers the Wireless Debugging pairing port. Requires Android 11.
  Future<int> adbDiscoverPairingPort({
    String? adbDeviceName,
    int? timeoutMillis,
  }) => _guard(
    () => _platform.adbDiscoverPairingPort(
      adbDeviceName: adbDeviceName,
      timeoutMillis: timeoutMillis,
    ),
  );

  /// Discovers the Wireless Debugging connect port. Requires Android 11.
  Future<int> adbDiscoverConnectPort({
    String? adbDeviceName,
    int? timeoutMillis,
  }) => _guard(
    () => _platform.adbDiscoverConnectPort(
      adbDeviceName: adbDeviceName,
      timeoutMillis: timeoutMillis,
    ),
  );

  /// Pairs this app's ADB key with a six digit Wireless Debugging code.
  ///
  /// Requires Android 11. Pairing and starting are independent: a successful
  /// call never starts the server by itself.
  Future<PrivAdbPairingResult> adbPair({
    required String pairingCode,
    String? adbDeviceName,
    int? port,
    int? portDiscoveryTimeoutMillis,
  }) => _guard(
    () => _platform.adbPair(
      pairingCode: pairingCode,
      adbDeviceName: adbDeviceName,
      port: port,
      portDiscoveryTimeoutMillis: portDiscoveryTimeoutMillis,
    ),
  );

  /// One-shot check of whether this app's ADB key is already authorized.
  Future<PrivAdbPairingCheckResult> adbCheckPairing({
    String? adbDeviceName,
    int? port,
    int? portDiscoveryTimeoutMillis,
  }) => _guard(
    () => _platform.adbCheckPairing(
      adbDeviceName: adbDeviceName,
      port: port,
      portDiscoveryTimeoutMillis: portDiscoveryTimeoutMillis,
    ),
  );

  /// Opens a persistent pairing check session and returns its handle.
  ///
  /// Prefer this over repeated [adbCheckPairing] calls when polling, and close
  /// the session with [closeSession] when polling stops.
  Future<int> adbOpenPairingCheckSession({
    String? adbDeviceName,
    int? port,
    int? portDiscoveryTimeoutMillis,
  }) => _guard(
    () => _platform.adbOpenPairingCheckSession(
      adbDeviceName: adbDeviceName,
      port: port,
      portDiscoveryTimeoutMillis: portDiscoveryTimeoutMillis,
    ),
  );

  /// Runs one check on a session opened by [adbOpenPairingCheckSession].
  Future<PrivAdbPairingCheckResult> adbCheckPairingSession(int sessionId) =>
      _guard(() => _platform.adbCheckPairingSession(sessionId));

  /// Checks and, when possible, restores the static TCP port before a start.
  Future<PrivAdbAuthorizationCheckResult> adbPrepareTcpForStart({
    String? adbDeviceName,
    int? tcpPort,
  }) => _guard(
    () => _platform.adbPrepareTcpForStart(
      adbDeviceName: adbDeviceName,
      tcpPort: tcpPort,
    ),
  );

  /// One-shot authorization check against the static TCP port.
  Future<PrivAdbAuthorizationCheckResult> adbCheckTcpAuthorization({
    String? adbDeviceName,
    int? tcpPort,
  }) => _guard(
    () => _platform.adbCheckTcpAuthorization(
      adbDeviceName: adbDeviceName,
      tcpPort: tcpPort,
    ),
  );

  /// Requests authorization on the static TCP port and waits for the user to
  /// confirm the system dialog.
  Future<PrivAdbAuthorizationRequestResult> adbRequestTcpAuthorization({
    String? adbDeviceName,
    int? tcpPort,
    int? timeoutMillis,
  }) => _guard(
    () => _platform.adbRequestTcpAuthorization(
      adbDeviceName: adbDeviceName,
      tcpPort: tcpPort,
      timeoutMillis: timeoutMillis,
    ),
  );

  /// Opens a persistent TCP authorization check session, returns its handle.
  Future<int> adbOpenTcpAuthorizationCheckSession({
    String? adbDeviceName,
    int? tcpPort,
  }) => _guard(
    () => _platform.adbOpenTcpAuthorizationCheckSession(
      adbDeviceName: adbDeviceName,
      tcpPort: tcpPort,
    ),
  );

  /// Runs one check on a session opened by
  /// [adbOpenTcpAuthorizationCheckSession].
  Future<PrivAdbAuthorizationCheckResult> adbCheckTcpAuthorizationSession(
    int sessionId,
  ) => _guard(() => _platform.adbCheckTcpAuthorizationSession(sessionId));

  /// Switches adbd to TCP/IP mode on [tcpPort] (`adb tcpip`).
  ///
  /// Needs an already authorized ADB connection and affects every process that
  /// depends on ADB, so confirm with the user first.
  Future<PrivAdbTcpResult> adbSwitchToTcp({
    String? adbDeviceName,
    int? tcpPort,
    PrivAdbConnectionOptions? options,
  }) => _guard(
    () => _platform.adbSwitchToTcp(
      adbDeviceName: adbDeviceName,
      tcpPort: tcpPort,
      options: options,
    ),
  );

  /// Stops the static ADB port.
  Future<PrivAdbTcpResult> adbStopTcp({
    String? adbDeviceName,
    int? tcpPort,
    PrivAdbConnectionOptions? options,
  }) => _guard(
    () => _platform.adbStopTcp(
      adbDeviceName: adbDeviceName,
      tcpPort: tcpPort,
      options: options,
    ),
  );

  /// Restarts the static ADB port.
  Future<PrivAdbTcpResult> adbRestartTcp({
    String? adbDeviceName,
    int? tcpPort,
    PrivAdbConnectionOptions? options,
  }) => _guard(
    () => _platform.adbRestartTcp(
      adbDeviceName: adbDeviceName,
      tcpPort: tcpPort,
      options: options,
    ),
  );

  /// Closes a session opened by [adbOpenPairingCheckSession] or
  /// [adbOpenTcpAuthorizationCheckSession].
  Future<void> closeSession(int sessionId) =>
      _guard(() => _platform.closeSession(sessionId));

  /// Runs [command] to completion and returns its captured output.
  ///
  /// Both streams are drained concurrently and each is bounded by
  /// [maxBytesPerStream]; excess bytes are still drained so the process can
  /// exit, and the matching truncation flag is set.
  ///
  /// Leaves [timeoutMillis] unset to use the 30 second default, or pass
  /// [noCommandTimeout] to disable the deadline. At most four commands run at
  /// once; the fifth fails immediately instead of queueing.
  Future<PrivCommandResult> runCommand(
    PrivCommand command, {
    int? timeoutMillis,
    int? maxBytesPerStream,
  }) => _guard(
    () => _platform.runCommand(
      command,
      timeoutMillis: timeoutMillis,
      maxBytesPerStream: maxBytesPerStream,
    ),
  );

  /// Starts [command] and streams its output as it is produced.
  ///
  /// Cancelling the returned subscription cancels the remote process. Each
  /// stream may only be consumed once, and [PrivCommandExit] is always the
  /// final event. At most four commands run at once.
  Stream<PrivCommandEvent> startCommand(
    PrivCommand command, {
    int? timeoutMillis,
    String? commandId,
  }) {
    final id = commandId ?? nextCommandId();
    return Stream<void>.fromFuture(
      _guard(
        () => _platform.startCommand(id, command, timeoutMillis: timeoutMillis),
      ),
    ).asyncExpand((_) => _platform.commandEvents(id));
  }

  /// Generates a command id so the matching [startCommand] can be cancelled.
  String nextCommandId() =>
      'cmd_${DateTime.now().microsecondsSinceEpoch}_${++_commandCounter}';

  /// Cancels a command started with [startCommand] and releases its resources.
  Future<void> cancelCommand(String commandId) =>
      _guard(() => _platform.cancelCommand(commandId));

  /// Runs [commandLine] through `/system/bin/sh` in this app's own process.
  ///
  /// Only useful when this process already runs as root, system or shell.
  Future<String> externalStartupRunInCurrentProcess({
    required String commandLine,
    PrivExternalStartupOptions? options,
  }) => _guard(
    () => _platform.externalStartupRunInCurrentProcess(
      commandLine: commandLine,
      options: options,
    ),
  );

  /// Runs [commandLine] through an app-registered external startup bridge.
  ///
  /// Bridges are registered natively through
  /// `PrivKitExternalStartupBridges.register`, which lets an external
  /// authorizer such as Shizuku execute the native starter command.
  Future<String> externalStartupRunThroughBridge({
    required String commandLine,
    required String bridgeId,
    PrivExternalStartupBridgeOptions? options,
  }) => _guard(
    () => _platform.externalStartupRunThroughBridge(
      commandLine: commandLine,
      bridgeId: bridgeId,
      options: options,
    ),
  );

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on PlatformException catch (e) {
      throw PrivKitException.fromPlatformException(e);
    }
  }
}
