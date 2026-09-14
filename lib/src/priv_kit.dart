import 'dart:async';

import 'package:flutter/services.dart';

import '../priv_kit_platform_interface.dart';
import 'exceptions.dart';
import 'models/adb.dart';
import 'models/command.dart';
import 'models/external_startup.dart';
import 'models/server_info.dart';
import 'models/startup_log.dart';

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
  Future<List<String>> getDeniedServerPermissions() =>
      _guard(_platform.getDeniedServerPermissions);

  /// Checks one permission against the connected server.
  Future<int> checkServerPermission(String permission) =>
      _guard(() => _platform.checkServerPermission(permission));

  /// Whether the connected server cannot grant runtime permissions.
  Future<bool> isPermissionRestricted() =>
      _guard(_platform.isPermissionRestricted);

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
