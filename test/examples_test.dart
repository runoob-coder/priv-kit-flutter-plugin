// Verifies that the snippets in README.md / README_CN.md actually compile.
//
// Not a behaviour test: it exists so a doc example cannot silently rot when
// the API changes. Every snippet below is copied from the two READMEs.
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:priv_kit/priv_kit.dart';
import 'package:priv_kit/priv_kit_platform_interface.dart';

/// Mirrors every public member of [PrivKitPlatform] so the snippets type-check.
class _FakePlatform extends PrivKitPlatform {
  @override
  Stream<PrivServerInfo?> get serverState => const Stream.empty();

  @override
  Stream<PrivStartupLogLine> get startupLog => const Stream.empty();

  @override
  Future<PrivServerInfo> startRoot({int? timeoutMillis, String? operationId}) =>
      Future.value(const PrivServerInfo(uid: 0, pid: 1, protocolVersion: 1));

  @override
  Future<PrivServerInfo> startAdb({
    PrivAdbConnectionOptions? options,
    int? timeoutMillis,
    String? adbDeviceName,
    String? operationId,
  }) => Future.value(const PrivServerInfo(uid: 0, pid: 1, protocolVersion: 1));

  @override
  Future<void> cancelOperation(String operationId) async {}

  @override
  Future<PrivServerInfo?> connectReadyServer() => Future.value(null);

  @override
  Future<PrivServerInfo?> getServerState() => Future.value(null);

  @override
  Future<PrivServerInfo> getServerInfo() =>
      Future.value(const PrivServerInfo(uid: 0, pid: 1, protocolVersion: 1));

  @override
  Future<bool> pingServer() => Future.value(true);

  @override
  Future<void> shutdownServer() async {}

  @override
  Future<void> prepareOwnerRestart({
    required int passiveReconnectTimeoutMillis,
  }) async {}

  @override
  Future<List<String>> getDeniedServerPermissions() => Future.value(const []);

  @override
  Future<int> checkServerPermission(String permission) => Future.value(0);

  @override
  Future<bool> isPermissionRestricted() => Future.value(false);

  @override
  Future<int> checkPermission({
    required String permission,
    required String packageName,
    int? userId,
  }) => Future.value(privilegePermissionGranted);

  @override
  Future<void> grantRuntimePermission({
    required String packageName,
    required String permission,
    int? userId,
  }) async {}

  @override
  Future<void> revokeRuntimePermission({
    required String packageName,
    required String permission,
    int? userId,
  }) async {}

  @override
  Future<String> getNativeStarterCommand() => Future.value('starter');

  @override
  Future<PrivFileMetadata> fileMetadata(
    String path, {
    bool followSymbolicLinks = false,
  }) => Future.value(
    const PrivFileMetadata(
      absolutePath: '/data/local/tmp/a.txt',
      sizeBytes: 3,
      lastModifiedMillis: 0,
      unixMode: 33188,
      uid: 0,
      gid: 0,
      type: PrivFileType.regularFile,
    ),
  );

  @override
  Future<bool> fileExists(String path) => Future.value(true);

  @override
  Future<bool> fileIsFile(String path) => Future.value(true);

  @override
  Future<bool> fileIsDirectory(String path) => Future.value(false);

  @override
  Future<bool> fileIsSymbolicLink(String path) => Future.value(false);

  @override
  Future<bool> fileCanRead(String path) => Future.value(true);

  @override
  Future<bool> fileCanWrite(String path) => Future.value(true);

  @override
  Future<bool> fileCanExecute(String path) => Future.value(false);

  @override
  Future<int> fileLength(String path) => Future.value(3);

  @override
  Future<int> fileLastModified(String path) => Future.value(0);

  @override
  Future<bool> fileCreateNewFile(String path) => Future.value(true);

  @override
  Future<bool> fileMkdir(String path) => Future.value(true);

  @override
  Future<bool> fileMkdirs(String path) => Future.value(true);

  @override
  Future<bool> fileDelete(String path) => Future.value(true);

  @override
  Future<bool> fileRenameTo(String from, String to) => Future.value(true);

  @override
  Future<void> fileReplaceAtomically(String from, String to) async {}

  @override
  Future<bool> fileDeleteRecursively(String path) => Future.value(true);

  @override
  Future<int> fileOpenRead(String path) => Future.value(1);

  @override
  Future<int> fileOpenWrite(
    String path, {
    bool append = false,
    bool syncOnClose = false,
  }) => Future.value(2);

  var _readCount = 0;

  @override
  Future<Uint8List> fileRead(
    int handle, {
    int maxBytes = privilegeFileDefaultReadChunkBytes,
  }) {
    // First read yields content, the next reports EOF. Without that EOF step
    // fileReadAllBytes would loop forever.
    _readCount++;
    return Future.value(
      _readCount == 1 ? Uint8List.fromList('hi'.codeUnits) : Uint8List(0),
    );
  }

  @override
  Future<void> fileWrite(int handle, Uint8List bytes) async {}

  @override
  Future<void> fileClose(int handle) async {}

  @override
  Future<void> fileWalkStart(
    String operationId,
    String path, {
    int? maxDepth,
    List<String>? skipDirectoryGlobs,
    int? flushBatchSize,
  }) async {}

  @override
  Stream<PrivFileEntry> fileWalkEntries(String operationId) =>
      const Stream.empty();

  @override
  Future<PrivRuntimeConfig> getRuntimeConfig() => Future.value(
    const PrivRuntimeConfig(
      followDeathDelayMillis: privilegeDefaultFollowDeathDelayMillis,
      activeReconnectOnOwnerDeath: privilegeDefaultActiveReconnectOnOwnerDeath,
    ),
  );

  @override
  Future<void> configureRuntime({
    int? followDeathDelayMillis,
    bool? activeReconnectOnOwnerDeath,
  }) async {}

  @override
  Future<PrivAdbIdentityInfo> adbGetIdentityInfo({String? adbDeviceName}) =>
      Future.value(
        const PrivAdbIdentityInfo(deviceName: 'd', publicKeyFingerprint: 'f'),
      );

  @override
  Future<int?> adbGetActiveTcpPort({String? adbDeviceName}) =>
      Future.value(5555);

  @override
  Future<int?> adbGetConfiguredTcpPort({String? adbDeviceName}) =>
      Future.value(5555);

  @override
  Future<PrivAdbWirelessDebuggingControlStatus>
  adbGetWirelessDebuggingControlStatus({String? adbDeviceName}) =>
      Future.value(const PrivAdbWirelessDebuggingControlStatus());

  @override
  Future<int> adbDiscoverPairingPort({
    String? adbDeviceName,
    int? timeoutMillis,
  }) => Future.value(1);

  @override
  Future<int> adbDiscoverConnectPort({
    String? adbDeviceName,
    int? timeoutMillis,
  }) => Future.value(1);

  @override
  Future<PrivAdbPairingResult> adbPair({
    required String pairingCode,
    String? adbDeviceName,
    int? port,
    int? portDiscoveryTimeoutMillis,
  }) => Future.value(
    const PrivAdbPairingResult(
      port: 1,
      deviceName: 'd',
      publicKeyFingerprint: 'f',
    ),
  );

  @override
  Future<PrivAdbPairingCheckResult> adbCheckPairing({
    String? adbDeviceName,
    int? port,
    int? portDiscoveryTimeoutMillis,
  }) => Future.value(
    const PrivAdbPairingCheckResult(status: PrivAdbPairingCheckStatus.paired),
  );

  @override
  Future<int> adbOpenPairingCheckSession({
    String? adbDeviceName,
    int? port,
    int? portDiscoveryTimeoutMillis,
  }) => Future.value(1);

  @override
  Future<PrivAdbPairingCheckResult> adbCheckPairingSession(int sessionId) =>
      Future.value(
        const PrivAdbPairingCheckResult(
          status: PrivAdbPairingCheckStatus.paired,
        ),
      );

  @override
  Future<PrivAdbAuthorizationCheckResult> adbPrepareTcpForStart({
    String? adbDeviceName,
    int? tcpPort,
  }) => Future.value(
    const PrivAdbAuthorizationCheckResult(
      status: PrivAdbAuthorizationStatus.authorized,
    ),
  );

  @override
  Future<PrivAdbAuthorizationCheckResult> adbCheckTcpAuthorization({
    String? adbDeviceName,
    int? tcpPort,
  }) => Future.value(
    const PrivAdbAuthorizationCheckResult(
      status: PrivAdbAuthorizationStatus.authorized,
    ),
  );

  @override
  Future<PrivAdbAuthorizationRequestResult> adbRequestTcpAuthorization({
    String? adbDeviceName,
    int? tcpPort,
    int? timeoutMillis,
  }) => Future.value(const PrivAdbAuthorizationRequestResult());

  @override
  Future<int> adbOpenTcpAuthorizationCheckSession({
    String? adbDeviceName,
    int? tcpPort,
  }) => Future.value(1);

  @override
  Future<PrivAdbAuthorizationCheckResult> adbCheckTcpAuthorizationSession(
    int sessionId,
  ) => Future.value(
    const PrivAdbAuthorizationCheckResult(
      status: PrivAdbAuthorizationStatus.authorized,
    ),
  );

  @override
  Future<PrivAdbTcpResult> adbSwitchToTcp({
    String? adbDeviceName,
    int? tcpPort,
    PrivAdbConnectionOptions? options,
  }) => Future.value(const PrivAdbTcpResult(port: 5555));

  @override
  Future<PrivAdbTcpResult> adbStopTcp({
    String? adbDeviceName,
    int? tcpPort,
    PrivAdbConnectionOptions? options,
  }) => Future.value(const PrivAdbTcpResult(port: 5555));

  @override
  Future<PrivAdbTcpResult> adbRestartTcp({
    String? adbDeviceName,
    int? tcpPort,
    PrivAdbConnectionOptions? options,
  }) => Future.value(const PrivAdbTcpResult(port: 5555));

  @override
  Future<void> closeSession(int sessionId) async {}

  @override
  Future<PrivCommandResult> runCommand(
    PrivCommand command, {
    int? timeoutMillis,
    int? maxBytesPerStream,
  }) => Future.value(
    PrivCommandResult(exitCode: 0, stdout: Uint8List(0), stderr: Uint8List(0)),
  );

  @override
  Future<void> startCommand(
    String commandId,
    PrivCommand command, {
    int? timeoutMillis,
  }) async {}

  @override
  Stream<PrivCommandEvent> commandEvents(String commandId) =>
      const Stream.empty();

  @override
  Future<void> cancelCommand(String commandId) async {}

  @override
  Future<String> externalStartupRunInCurrentProcess({
    required String commandLine,
    PrivExternalStartupOptions? options,
  }) => Future.value('');

  @override
  Future<String> externalStartupRunThroughBridge({
    required String commandLine,
    required String bridgeId,
    PrivExternalStartupBridgeOptions? options,
  }) => Future.value('');
}

void main() {
  test('error-code switch compiles against the real constants', () {
    final e = const PrivKitException(code: PrivKitErrorCode.serverUnavailable);
    var seen = '';
    switch (e.code) {
      case PrivKitErrorCode.serverUnavailable:
        seen = 'unavailable';
      case PrivKitErrorCode.cancelled:
        seen = 'cancelled';
      default:
        seen = 'other';
    }
    expect(seen, 'unavailable');
  });

  test('command event union matches the documented when() shape', () async {
    final event = PrivCommandEvent.stdout(bytes: Uint8List(0));
    final out = event.when(
      stdout: (Uint8List bytes) => 'stdout:${bytes.length}',
      stderr: (Uint8List bytes) => 'stderr:${bytes.length}',
      exit: (int code) => 'exit:$code',
    );
    expect(out, 'stdout:0');
  });

  test('documented snippets type-check', () async {
    final privKit = PrivKit(platform: _FakePlatform());

    // Quick start: serverState listener.
    final sub = privKit.serverState.listen((server) {
      if (server == null) return;
      // ignore: avoid_print
      print('uid=${server.uid} pid=${server.pid}');
    });
    await sub.cancel();

    // Root start + error handling.
    try {
      final info = await privKit.startRoot();
      expect(info.uid, 0);
    } on PrivKitException catch (e) {
      // ignore: avoid_print
      print('${e.code}: ${e.message}');
    }

    // Command execution.
    final result = await privKit.runCommand(
      PrivCommand(arguments: const ['/system/bin/id']),
    );
    expect(result.exitCode, 0);

    // Commands with environment and working directory.
    await privKit.runCommand(
      PrivCommand(
        arguments: const ['/system/bin/id'],
        environment: const {'LANG': 'C'},
        workingDirectory: '/data/local/tmp',
      ),
    );

    // Shell parsing has to be requested explicitly.
    await privKit.runCommand(
      PrivCommand(
        arguments: const ['/system/bin/sh', '-c', 'ls /data/local/tmp'],
      ),
    );

    // Wireless debugging start.
    final pairing = await privKit.adbCheckPairing();
    if (!pairing.paired) {
      await privKit.adbPair(pairingCode: '123456');
    }
    await privKit.startAdb();

    // Static TCP port start.
    const port = privilegeAdbDefaultTcpPort;
    final prepared = await privKit.adbPrepareTcpForStart(tcpPort: port);
    if (!prepared.isAuthorized) {
      await privKit.adbRequestTcpAuthorization(tcpPort: port);
    }
    await privKit.startAdb(options: const PrivAdbConnectionOptions(port: port));

    // Cancellation.
    final id = privKit.nextStartOperationId('adb');
    unawaited(privKit.startAdb(operationId: id));
    await privKit.cancelOperation(id);

    // Session handles.
    final sessionId = await privKit.adbOpenPairingCheckSession();
    await privKit.adbCheckPairingSession(sessionId);
    await privKit.closeSession(sessionId);

    // Startup diagnostics.
    final logSub = privKit.startupLog.listen((line) {
      // ignore: avoid_print
      print('[${line.source}] ${line.message}');
    });
    await logSub.cancel();

    // Lifecycle.
    await privKit.connectReadyServer();
    await privKit.getServerState();
    await privKit.getServerInfo();
    await privKit.pingServer();
    await privKit.prepareOwnerRestart(passiveReconnectTimeoutMillis: 10_000);
    await privKit.shutdownServer();

    // File proxy: metadata, streams and walking.
    const path = '/data/local/tmp/priv_kit_demo';
    final metadata = await privKit.fileMetadata(path);
    expect(metadata.type, PrivFileType.regularFile);
    await privKit.fileExists(path);
    await privKit.fileIsDirectory(path);
    await privKit.fileLength(path);

    await privKit.fileWriteAllBytes(
      path,
      Uint8List.fromList('hello'.codeUnits),
      syncOnClose: true,
    );
    final bytes = await privKit.fileReadAllBytes(path);
    expect(bytes.isNotEmpty, isTrue);

    // Streaming a directory; maxDepth 1 is a non-recursive listing.
    await for (final entry in privKit.fileWalk(
      '/data/local/tmp',
      maxDepth: 1,
    )) {
      // ignore: avoid_print
      print('${entry.depth} ${entry.name}');
    }

    // Runtime configuration.
    final config = await privKit.getRuntimeConfig();
    expect(
      config.followDeathDelayMillis,
      privilegeDefaultFollowDeathDelayMillis,
    );
    await privKit.configureRuntime(
      followDeathDelayMillis: 60000,
      activeReconnectOnOwnerDeath: true,
    );

    // Permissions.
    await privKit.getDeniedServerPermissions();
    await privKit.checkServerPermission(
      'android.permission.GRANT_RUNTIME_PERMISSIONS',
    );
    await privKit.isPermissionRestricted();

    // Runtime permissions for any package.
    final granted = await privKit.checkPermission(
      permission: 'android.permission.CAMERA',
      packageName: 'com.example.app',
    );
    expect(granted, privilegePermissionGranted);

    await privKit.isPermissionGranted(
      permission: 'android.permission.CAMERA',
      packageName: 'com.example.app',
    );
    await privKit.grantRuntimePermission(
      packageName: 'com.example.app',
      permission: 'android.permission.CAMERA',
    );
    await privKit.revokeRuntimePermission(
      packageName: 'com.example.app',
      permission: 'android.permission.CAMERA',
    );

    // Aggregated output with an explicit capture limit.
    final capped = await privKit.runCommand(
      PrivCommand(arguments: const ['/system/bin/cat', '/proc/version']),
      maxBytesPerStream: 1 << 20,
    );
    expect(capped.stdoutTruncated, isFalse);

    // Timeouts.
    await privKit.runCommand(
      PrivCommand(arguments: const ['/system/bin/id']),
      timeoutMillis: 120000,
    );
    await privKit.runCommand(
      PrivCommand(arguments: const ['/system/bin/id']),
      timeoutMillis: noCommandTimeout,
    );

    // External startup.
    final command = await privKit.getNativeStarterCommand();
    await privKit.externalStartupRunThroughBridge(
      commandLine: command,
      bridgeId: 'shizuku',
    );

    // Streaming.
    final cmdSub = privKit
        .startCommand(
          PrivCommand(
            arguments: const ['/system/bin/sh', '-c', 'logcat -v brief'],
          ),
        )
        .listen((event) {
          event.when(
            stdout: stdout.add,
            stderr: stderr.add,
            exit: (code) => stdout.write('exit: $code'),
          );
        });
    await cmdSub.cancel();
  });
}
