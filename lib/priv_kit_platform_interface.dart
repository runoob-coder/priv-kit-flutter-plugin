import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'priv_kit_method_channel.dart';
import 'src/models/adb.dart';
import 'src/models/command.dart';
import 'src/models/external_startup.dart';
import 'src/models/server_info.dart';
import 'src/models/startup_log.dart';

/// The interface that implementations of `priv_kit` must implement.
///
/// Platform implementations should extend this class rather than implement it,
/// so new methods added here do not break existing implementations.
abstract class PrivKitPlatform extends PlatformInterface {
  /// Constructs a PrivKitPlatform.
  PrivKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static PrivKitPlatform _instance = MethodChannelPrivKit();

  /// The default instance of [PrivKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelPrivKit].
  static PrivKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PrivKitPlatform] when
  /// they register themselves.
  static set instance(PrivKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Process-wide connection state of the Privileged Server.
  ///
  /// A non-null value means a server is connected, `null` means disconnected.
  /// Every new listener immediately receives the current value.
  Stream<PrivServerInfo?> get serverState =>
      throw UnimplementedError('serverState has not been implemented.');

  /// Diagnostic lines emitted while a start operation is running.
  Stream<PrivStartupLogLine> get startupLog =>
      throw UnimplementedError('startupLog has not been implemented.');

  /// Starts the Privileged Server through `su`.
  Future<PrivServerInfo> startRoot({int? timeoutMillis, String? operationId}) {
    throw UnimplementedError('startRoot() has not been implemented.');
  }

  /// Starts the Privileged Server through ADB.
  ///
  /// When [options] carries a non-null port, the static TCP/IP port is used and
  /// the Wireless Debugging connect port is not discovered.
  Future<PrivServerInfo> startAdb({
    PrivAdbConnectionOptions? options,
    int? timeoutMillis,
    String? adbDeviceName,
    String? operationId,
  }) {
    throw UnimplementedError('startAdb() has not been implemented.');
  }

  /// Connects a server that has already announced itself, if any.
  Future<PrivServerInfo?> connectReadyServer() {
    throw UnimplementedError('connectReadyServer() has not been implemented.');
  }

  /// The currently connected server, or `null`.
  Future<PrivServerInfo?> getServerState() {
    throw UnimplementedError('getServerState() has not been implemented.');
  }

  /// The connected server. Throws when no server is connected.
  Future<PrivServerInfo> getServerInfo() {
    throw UnimplementedError('getServerInfo() has not been implemented.');
  }

  /// Pings the server Binder, clearing the connection when it is dead.
  Future<bool> pingServer() {
    throw UnimplementedError('pingServer() has not been implemented.');
  }

  /// Shuts the connected server down and clears the local connection.
  Future<void> shutdownServer() {
    throw UnimplementedError('shutdownServer() has not been implemented.');
  }

  /// Tells the connected server that this owner process is about to restart.
  Future<void> prepareOwnerRestart({
    required int passiveReconnectTimeoutMillis,
  }) {
    throw UnimplementedError('prepareOwnerRestart() has not been implemented.');
  }

  /// Permissions declared for the server's packages but denied to its process.
  Future<List<String>> getDeniedServerPermissions() {
    throw UnimplementedError(
      'getDeniedServerPermissions() has not been implemented.',
    );
  }

  /// Checks one permission against the connected server.
  ///
  /// Returns `PackageManager.PERMISSION_GRANTED` (0) or
  /// `PERMISSION_DENIED` (-1).
  Future<int> checkServerPermission(String permission) {
    throw UnimplementedError(
      'checkServerPermission() has not been implemented.',
    );
  }

  /// Whether the connected server cannot grant runtime permissions.
  Future<bool> isPermissionRestricted() {
    throw UnimplementedError(
      'isPermissionRestricted() has not been implemented.',
    );
  }

  /// The device-side shell command that starts the native starter.
  Future<String> getNativeStarterCommand() {
    throw UnimplementedError(
      'getNativeStarterCommand() has not been implemented.',
    );
  }

  /// Cancels a start operation previously launched with [operationId].
  Future<void> cancelOperation(String operationId) {
    throw UnimplementedError('cancelOperation() has not been implemented.');
  }

  /// ADB identity of this app, including its public key fingerprint.
  Future<PrivAdbIdentityInfo> adbGetIdentityInfo({String? adbDeviceName}) {
    throw UnimplementedError('adbGetIdentityInfo() has not been implemented.');
  }

  /// The static ADB port adbd is currently listening on, if any.
  Future<int?> adbGetActiveTcpPort({String? adbDeviceName}) {
    throw UnimplementedError('adbGetActiveTcpPort() has not been implemented.');
  }

  /// The static ADB port previously configured by this app, if any.
  Future<int?> adbGetConfiguredTcpPort({String? adbDeviceName}) {
    throw UnimplementedError(
      'adbGetConfiguredTcpPort() has not been implemented.',
    );
  }

  /// Whether Priv Kit can manage Wireless Debugging on this device.
  Future<PrivAdbWirelessDebuggingControlStatus>
  adbGetWirelessDebuggingControlStatus({String? adbDeviceName}) {
    throw UnimplementedError(
      'adbGetWirelessDebuggingControlStatus() has not been implemented.',
    );
  }

  /// Discovers the Wireless Debugging pairing port.
  Future<int> adbDiscoverPairingPort({
    String? adbDeviceName,
    int? timeoutMillis,
  }) {
    throw UnimplementedError(
      'adbDiscoverPairingPort() has not been implemented.',
    );
  }

  /// Discovers the Wireless Debugging connect port.
  Future<int> adbDiscoverConnectPort({
    String? adbDeviceName,
    int? timeoutMillis,
  }) {
    throw UnimplementedError(
      'adbDiscoverConnectPort() has not been implemented.',
    );
  }

  /// Pairs this app's ADB key with a six digit Wireless Debugging code.
  ///
  /// Pairing and starting are independent: a successful [adbPair] never starts
  /// the server by itself.
  Future<PrivAdbPairingResult> adbPair({
    required String pairingCode,
    String? adbDeviceName,
    int? port,
    int? portDiscoveryTimeoutMillis,
  }) {
    throw UnimplementedError('adbPair() has not been implemented.');
  }

  /// One-shot check of whether this app's ADB key is already authorized.
  Future<PrivAdbPairingCheckResult> adbCheckPairing({
    String? adbDeviceName,
    int? port,
    int? portDiscoveryTimeoutMillis,
  }) {
    throw UnimplementedError('adbCheckPairing() has not been implemented.');
  }

  /// Opens a persistent pairing check session and returns its handle.
  ///
  /// Close it with [closeSession] when polling stops.
  Future<int> adbOpenPairingCheckSession({
    String? adbDeviceName,
    int? port,
    int? portDiscoveryTimeoutMillis,
  }) {
    throw UnimplementedError(
      'adbOpenPairingCheckSession() has not been implemented.',
    );
  }

  /// Runs one check on a session opened by [adbOpenPairingCheckSession].
  Future<PrivAdbPairingCheckResult> adbCheckPairingSession(int sessionId) {
    throw UnimplementedError(
      'adbCheckPairingSession() has not been implemented.',
    );
  }

  /// Checks and, when possible, restores the static TCP port before a start.
  Future<PrivAdbAuthorizationCheckResult> adbPrepareTcpForStart({
    String? adbDeviceName,
    int? tcpPort,
  }) {
    throw UnimplementedError(
      'adbPrepareTcpForStart() has not been implemented.',
    );
  }

  /// One-shot authorization check against the static TCP port.
  Future<PrivAdbAuthorizationCheckResult> adbCheckTcpAuthorization({
    String? adbDeviceName,
    int? tcpPort,
  }) {
    throw UnimplementedError(
      'adbCheckTcpAuthorization() has not been implemented.',
    );
  }

  /// Requests authorization on the static TCP port and waits for the user.
  Future<PrivAdbAuthorizationRequestResult> adbRequestTcpAuthorization({
    String? adbDeviceName,
    int? tcpPort,
    int? timeoutMillis,
  }) {
    throw UnimplementedError(
      'adbRequestTcpAuthorization() has not been implemented.',
    );
  }

  /// Opens a persistent TCP authorization check session, returns its handle.
  Future<int> adbOpenTcpAuthorizationCheckSession({
    String? adbDeviceName,
    int? tcpPort,
  }) {
    throw UnimplementedError(
      'adbOpenTcpAuthorizationCheckSession() has not been implemented.',
    );
  }

  /// Runs one check on a session opened by
  /// [adbOpenTcpAuthorizationCheckSession].
  Future<PrivAdbAuthorizationCheckResult> adbCheckTcpAuthorizationSession(
    int sessionId,
  ) {
    throw UnimplementedError(
      'adbCheckTcpAuthorizationSession() has not been implemented.',
    );
  }

  /// Switches adbd to TCP/IP mode on [tcpPort] (`adb tcpip`).
  Future<PrivAdbTcpResult> adbSwitchToTcp({
    String? adbDeviceName,
    int? tcpPort,
    PrivAdbConnectionOptions? options,
  }) {
    throw UnimplementedError('adbSwitchToTcp() has not been implemented.');
  }

  /// Stops the static ADB port.
  Future<PrivAdbTcpResult> adbStopTcp({
    String? adbDeviceName,
    int? tcpPort,
    PrivAdbConnectionOptions? options,
  }) {
    throw UnimplementedError('adbStopTcp() has not been implemented.');
  }

  /// Restarts the static ADB port.
  Future<PrivAdbTcpResult> adbRestartTcp({
    String? adbDeviceName,
    int? tcpPort,
    PrivAdbConnectionOptions? options,
  }) {
    throw UnimplementedError('adbRestartTcp() has not been implemented.');
  }

  /// Closes a session opened by [adbOpenPairingCheckSession] or
  /// [adbOpenTcpAuthorizationCheckSession].
  Future<void> closeSession(int sessionId) {
    throw UnimplementedError('closeSession() has not been implemented.');
  }

  /// Starts [command] and drains both streams to completion.
  ///
  /// Leaves [timeoutMillis] unset to use the 30 second default, or pass
  /// [noCommandTimeout] to disable the deadline.
  Future<PrivCommandResult> runCommand(
    PrivCommand command, {
    int? timeoutMillis,
    int? maxBytesPerStream,
  }) {
    throw UnimplementedError('runCommand() has not been implemented.');
  }

  /// Starts [command] for streaming consumption and keeps it under
  /// [commandId].
  ///
  /// The process is cancelled when the stream subscription is cancelled or when
  /// [cancelCommand] is called.
  Future<void> startCommand(
    String commandId,
    PrivCommand command, {
    int? timeoutMillis,
  }) {
    throw UnimplementedError('startCommand() has not been implemented.');
  }

  /// Events of the command previously started with [startCommand].
  Stream<PrivCommandEvent> commandEvents(String commandId) =>
      throw UnimplementedError('commandEvents() has not been implemented.');

  /// Cancels a running command and releases its resources.
  Future<void> cancelCommand(String commandId) {
    throw UnimplementedError('cancelCommand() has not been implemented.');
  }

  /// Runs [commandLine] through `/system/bin/sh` in this app's own process.
  Future<String> externalStartupRunInCurrentProcess({
    required String commandLine,
    PrivExternalStartupOptions? options,
  }) {
    throw UnimplementedError(
      'externalStartupRunInCurrentProcess() has not been implemented.',
    );
  }

  /// Runs [commandLine] through an app-registered external startup bridge.
  ///
  /// Bridges are registered natively through
  /// `PrivKitExternalStartupBridges.register`.
  Future<String> externalStartupRunThroughBridge({
    required String commandLine,
    required String bridgeId,
    PrivExternalStartupBridgeOptions? options,
  }) {
    throw UnimplementedError(
      'externalStartupRunThroughBridge() has not been implemented.',
    );
  }
}
