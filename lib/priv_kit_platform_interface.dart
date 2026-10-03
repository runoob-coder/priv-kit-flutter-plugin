import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'priv_kit_method_channel.dart';
import 'src/models/adb.dart';
import 'src/models/binder.dart';
import 'src/models/command.dart';
import 'src/models/config.dart';
import 'src/models/external_startup.dart';
import 'src/models/file.dart';
import 'src/models/server_info.dart';
import 'src/models/startup_log.dart';
import 'src/models/user_service.dart';

import 'dart:typed_data';

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
  ///
  /// Root servers always return an empty list.
  Future<List<String>> getDeniedServerPermissions() {
    throw UnimplementedError(
      'getDeniedServerPermissions() has not been implemented.',
    );
  }

  /// Checks one permission against the connected server.
  ///
  /// Returns `PackageManager.PERMISSION_GRANTED` (0) or
  /// `PERMISSION_DENIED` (-1).
  ///
  /// Root servers are not queried through the system and return
  /// `PERMISSION_GRANTED` directly; the connection is still validated.
  Future<int> checkServerPermission(String permission) {
    throw UnimplementedError(
      'checkServerPermission() has not been implemented.',
    );
  }

  /// Whether the connected server cannot grant runtime permissions.
  ///
  /// Root servers are never restricted.
  Future<bool> isPermissionRestricted() {
    throw UnimplementedError(
      'isPermissionRestricted() has not been implemented.',
    );
  }

  /// Checks [permission] against [packageName].
  ///
  /// Unlike [checkServerPermission], which inspects the connected server
  /// itself, this can inspect any package on the device.
  ///
  /// Returns [privilegePermissionGranted] (0) or
  /// [privilegePermissionDenied] (-1).
  Future<int> checkPermission({
    required String permission,
    required String packageName,
    int? userId,
  }) {
    throw UnimplementedError('checkPermission() has not been implemented.');
  }

  /// Grants [permission] to [packageName].
  ///
  /// Requires the connected server to hold
  /// `android.permission.GRANT_RUNTIME_PERMISSIONS`.
  Future<void> grantRuntimePermission({
    required String packageName,
    required String permission,
    int? userId,
  }) {
    throw UnimplementedError(
      'grantRuntimePermission() has not been implemented.',
    );
  }

  /// Revokes [permission] from [packageName].
  ///
  /// Requires the connected server to hold
  /// `android.permission.GRANT_RUNTIME_PERMISSIONS`.
  Future<void> revokeRuntimePermission({
    required String packageName,
    required String permission,
    int? userId,
  }) {
    throw UnimplementedError(
      'revokeRuntimePermission() has not been implemented.',
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

  /// Starts an app-defined UserService.
  Future<void> startUserService(PrivUserServiceSpec spec) {
    throw UnimplementedError('startUserService() has not been implemented.');
  }

  /// Binds an app-defined UserService and returns a connection handle.
  ///
  /// The underlying Binder cannot cross the platform channel, so Dart cannot
  /// call the service's own AIDL methods. The handle exists so Dart can manage
  /// the connection lifetime through [unbindUserService].
  Future<int> bindUserService(PrivUserServiceSpec spec) {
    throw UnimplementedError('bindUserService() has not been implemented.');
  }

  /// Releases a connection handle returned by [bindUserService].
  Future<void> unbindUserService(int connectionHandle) {
    throw UnimplementedError('unbindUserService() has not been implemented.');
  }

  /// Stops an app-defined UserService.
  Future<void> stopUserService(PrivUserServiceSpec spec) {
    throw UnimplementedError('stopUserService() has not been implemented.');
  }

  /// Whether [serviceName] can be resolved from [source].
  Future<bool> binderHasSystemService(
    String serviceName, {
    PrivBinderServiceSource source = PrivBinderServiceSource.currentProcess,
  }) {
    throw UnimplementedError(
      'binderHasSystemService() has not been implemented.',
    );
  }

  /// Resolves [serviceName] into a handle Dart can inspect.
  ///
  /// Returns `null` when the service is not available from [source].
  ///
  /// A Binder cannot cross the platform channel, so Dart only gets an integer
  /// handle. Issuing the service's own transactions has to happen in Kotlin,
  /// the same way a UserService is called.
  Future<int?> binderFromSystemService(
    String serviceName, {
    PrivBinderServiceSource source = PrivBinderServiceSource.currentProcess,
  }) {
    throw UnimplementedError(
      'binderFromSystemService() has not been implemented.',
    );
  }

  /// Handle for the connected server's lifecycle Binder.
  ///
  /// Some privileged Binder APIs accept an owner or death token so the remote
  /// process can release resources when the owner goes away. Pass this Binder
  /// to bind those resources to the current server process.
  ///
  /// It exposes no operations of its own: only [binderPing], [binderIsAlive]
  /// and [binderClose] work on it, and its identity is stable only for as long
  /// as this server process lives. Take a fresh handle after every
  /// [PrivKitPlatform.serverState] change.
  ///
  /// Returns `null` when no server is connected.
  Future<int?> binderServerLifecycle() {
    throw UnimplementedError(
      'binderServerLifecycle() has not been implemented.',
    );
  }

  /// The interface descriptor reported by [handle], when it has one.
  Future<String?> binderGetInterfaceDescriptor(int handle) {
    throw UnimplementedError(
      'binderGetInterfaceDescriptor() has not been implemented.',
    );
  }

  /// Whether [handle] answers a ping.
  Future<bool> binderPing(int handle) {
    throw UnimplementedError('binderPing() has not been implemented.');
  }

  /// Whether the process hosting [handle] is still alive.
  Future<bool> binderIsAlive(int handle) {
    throw UnimplementedError('binderIsAlive() has not been implemented.');
  }

  /// Releases a handle returned by the `binder*` calls.
  Future<void> binderClose(int handle) {
    throw UnimplementedError('binderClose() has not been implemented.');
  }

  /// Reads one metadata snapshot of [path].
  Future<PrivFileMetadata> fileMetadata(
    String path, {
    bool followSymbolicLinks = false,
  }) {
    throw UnimplementedError('fileMetadata() has not been implemented.');
  }

  /// Whether [path] exists.
  Future<bool> fileExists(String path) {
    throw UnimplementedError('fileExists() has not been implemented.');
  }

  /// Whether [path] is a regular file.
  Future<bool> fileIsFile(String path) {
    throw UnimplementedError('fileIsFile() has not been implemented.');
  }

  /// Whether [path] is a directory.
  Future<bool> fileIsDirectory(String path) {
    throw UnimplementedError('fileIsDirectory() has not been implemented.');
  }

  /// Whether [path] is a symbolic link.
  Future<bool> fileIsSymbolicLink(String path) {
    throw UnimplementedError('fileIsSymbolicLink() has not been implemented.');
  }

  /// Whether [path] can be read.
  Future<bool> fileCanRead(String path) {
    throw UnimplementedError('fileCanRead() has not been implemented.');
  }

  /// Whether [path] can be written.
  Future<bool> fileCanWrite(String path) {
    throw UnimplementedError('fileCanWrite() has not been implemented.');
  }

  /// Whether [path] can be executed.
  Future<bool> fileCanExecute(String path) {
    throw UnimplementedError('fileCanExecute() has not been implemented.');
  }

  /// Size of [path] in bytes.
  Future<int> fileLength(String path) {
    throw UnimplementedError('fileLength() has not been implemented.');
  }

  /// Last modification time of [path], in milliseconds since the epoch.
  Future<int> fileLastModified(String path) {
    throw UnimplementedError('fileLastModified() has not been implemented.');
  }

  /// Creates [path] as a new empty file.
  Future<bool> fileCreateNewFile(String path) {
    throw UnimplementedError('fileCreateNewFile() has not been implemented.');
  }

  /// Creates [path] as a directory, requiring its parent to exist.
  Future<bool> fileMkdir(String path) {
    throw UnimplementedError('fileMkdir() has not been implemented.');
  }

  /// Creates [path] as a directory, creating missing parents.
  Future<bool> fileMkdirs(String path) {
    throw UnimplementedError('fileMkdirs() has not been implemented.');
  }

  /// Deletes [path]. A directory must be empty.
  Future<bool> fileDelete(String path) {
    throw UnimplementedError('fileDelete() has not been implemented.');
  }

  /// Renames [from] to [to].
  Future<bool> fileRenameTo(String from, String to) {
    throw UnimplementedError('fileRenameTo() has not been implemented.');
  }

  /// Atomically renames [from] over [to].
  ///
  /// Both paths must be on the same mounted filesystem.
  Future<void> fileReplaceAtomically(String from, String to) {
    throw UnimplementedError(
      'fileReplaceAtomically() has not been implemented.',
    );
  }

  /// Deletes [path] and, when it is a directory, all of its descendants.
  Future<bool> fileDeleteRecursively(String path) {
    throw UnimplementedError(
      'fileDeleteRecursively() has not been implemented.',
    );
  }

  /// Opens [path] for reading and returns the stream handle.
  Future<int> fileOpenRead(String path) {
    throw UnimplementedError('fileOpenRead() has not been implemented.');
  }

  /// Opens [path] for writing and returns the stream handle.
  Future<int> fileOpenWrite(
    String path, {
    bool append = false,
    bool syncOnClose = false,
  }) {
    throw UnimplementedError('fileOpenWrite() has not been implemented.');
  }

  /// Reads up to [maxBytes] from [handle]. An empty list means end of file.
  Future<Uint8List> fileRead(
    int handle, {
    int maxBytes = privilegeFileDefaultReadChunkBytes,
  }) {
    throw UnimplementedError('fileRead() has not been implemented.');
  }

  /// Writes [bytes] to [handle].
  Future<void> fileWrite(int handle, Uint8List bytes) {
    throw UnimplementedError('fileWrite() has not been implemented.');
  }

  /// Closes a stream handle opened by [fileOpenRead] or [fileOpenWrite].
  Future<void> fileClose(int handle) {
    throw UnimplementedError('fileClose() has not been implemented.');
  }

  /// Starts a directory walk and keeps it under [operationId].
  Future<void> fileWalkStart(
    String operationId,
    String path, {
    int? maxDepth,
    List<String>? skipDirectoryGlobs,
    int? flushBatchSize,
  }) {
    throw UnimplementedError('fileWalkStart() has not been implemented.');
  }

  /// Entries of the walk previously started with [fileWalkStart].
  Stream<PrivFileEntry> fileWalkEntries(String operationId) {
    throw UnimplementedError('fileWalkEntries() has not been implemented.');
  }

  /// The current owner-death reconnect policy.
  Future<PrivRuntimeConfig> getRuntimeConfig() {
    throw UnimplementedError('getRuntimeConfig() has not been implemented.');
  }

  /// Replaces the owner-death reconnect policy.
  ///
  /// Omitted fields keep their current value. The change is pushed to the
  /// connected server and applies to the next owner death.
  Future<void> configureRuntime({
    int? followDeathDelayMillis,
    bool? activeReconnectOnOwnerDeath,
  }) {
    throw UnimplementedError('configureRuntime() has not been implemented.');
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
