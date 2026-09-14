import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'priv_kit_platform_interface.dart';
import 'src/models/adb.dart';
import 'src/models/command.dart';
import 'src/models/external_startup.dart';
import 'src/models/server_info.dart';
import 'src/models/startup_log.dart';

/// An implementation of [PrivKitPlatform] that uses method channels.
class MethodChannelPrivKit extends PrivKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('priv_kit');

  /// Event channel carrying `Privilege.serverState`.
  @visibleForTesting
  final serverStateChannel = const EventChannel('priv_kit/server_state');

  /// Event channel carrying startup diagnostics.
  @visibleForTesting
  final startupLogChannel = const EventChannel('priv_kit/startup_log');

  /// Prefix of the per-command event channels.
  ///
  /// Each running command gets its own channel, because a Flutter
  /// [EventChannel] name can only back one active broadcast at a time.
  static const String commandChannelPrefix = 'priv_kit/command/';

  Stream<PrivServerInfo?>? _serverStateStream;
  Stream<PrivStartupLogLine>? _startupLogStream;

  @override
  Stream<PrivServerInfo?> get serverState => _serverStateStream ??=
      serverStateChannel.receiveBroadcastStream().map((dynamic event) {
        if (event == null) return null;
        return PrivServerInfo.fromMap(event as Map<dynamic, dynamic>);
      });

  @override
  Stream<PrivStartupLogLine> get startupLog =>
      _startupLogStream ??= startupLogChannel.receiveBroadcastStream().map(
        (dynamic event) =>
            PrivStartupLogLine.fromMap(event as Map<dynamic, dynamic>),
      );

  @override
  Future<PrivServerInfo> startRoot({
    int? timeoutMillis,
    String? operationId,
  }) async => PrivServerInfo.fromMap(
    await _requireMap('startRoot', <String, Object?>{
      'timeoutMillis': timeoutMillis,
      'operationId': operationId,
    }),
  );

  @override
  Future<PrivServerInfo> startAdb({
    PrivAdbConnectionOptions? options,
    int? timeoutMillis,
    String? adbDeviceName,
    String? operationId,
  }) async => PrivServerInfo.fromMap(
    await _requireMap('startAdb', <String, Object?>{
      'options': options?.toMap(),
      'timeoutMillis': timeoutMillis,
      'adbDeviceName': adbDeviceName,
      'operationId': operationId,
    }),
  );

  @override
  Future<PrivServerInfo?> connectReadyServer() async {
    final map = await _mapOrNull('connectReadyServer');
    return map == null ? null : PrivServerInfo.fromMap(map);
  }

  @override
  Future<PrivServerInfo?> getServerState() async {
    final map = await _mapOrNull('getServerState');
    return map == null ? null : PrivServerInfo.fromMap(map);
  }

  @override
  Future<PrivServerInfo> getServerInfo() async =>
      PrivServerInfo.fromMap(await _requireMap('getServerInfo'));

  @override
  Future<bool> pingServer() async =>
      await methodChannel.invokeMethod<bool>('pingServer') ?? false;

  @override
  Future<void> shutdownServer() =>
      methodChannel.invokeMethod<void>('shutdownServer');

  @override
  Future<void> prepareOwnerRestart({
    required int passiveReconnectTimeoutMillis,
  }) =>
      methodChannel.invokeMethod<void>('prepareOwnerRestart', <String, Object?>{
        'passiveReconnectTimeoutMillis': passiveReconnectTimeoutMillis,
      });

  @override
  Future<List<String>> getDeniedServerPermissions() async {
    final list = await methodChannel.invokeMethod<List<dynamic>>(
      'getDeniedServerPermissions',
    );
    return list?.cast<String>() ?? const <String>[];
  }

  @override
  Future<int> checkServerPermission(String permission) async =>
      await methodChannel.invokeMethod<int>(
        'checkServerPermission',
        <String, Object?>{'permission': permission},
      ) ??
      -1;

  @override
  Future<bool> isPermissionRestricted() async =>
      await methodChannel.invokeMethod<bool>('isPermissionRestricted') ?? true;

  @override
  Future<String> getNativeStarterCommand() async =>
      await methodChannel.invokeMethod<String>('getNativeStarterCommand') ?? '';

  @override
  Future<void> cancelOperation(String operationId) =>
      methodChannel.invokeMethod<void>('cancelOperation', <String, Object?>{
        'operationId': operationId,
      });

  @override
  Future<PrivAdbIdentityInfo> adbGetIdentityInfo({
    String? adbDeviceName,
  }) async => PrivAdbIdentityInfo.fromMap(
    await _requireMap('adbGetIdentityInfo', <String, Object?>{
      'adbDeviceName': adbDeviceName,
    }),
  );

  @override
  Future<int?> adbGetActiveTcpPort({String? adbDeviceName}) =>
      methodChannel.invokeMethod<int>('adbGetActiveTcpPort', <String, Object?>{
        'adbDeviceName': adbDeviceName,
      });

  @override
  Future<int?> adbGetConfiguredTcpPort({String? adbDeviceName}) =>
      methodChannel.invokeMethod<int>(
        'adbGetConfiguredTcpPort',
        <String, Object?>{'adbDeviceName': adbDeviceName},
      );

  @override
  Future<PrivAdbWirelessDebuggingControlStatus>
  adbGetWirelessDebuggingControlStatus({String? adbDeviceName}) async =>
      PrivAdbWirelessDebuggingControlStatus.fromMap(
        await _requireMap(
          'adbGetWirelessDebuggingControlStatus',
          <String, Object?>{'adbDeviceName': adbDeviceName},
        ),
      );

  @override
  Future<int> adbDiscoverPairingPort({
    String? adbDeviceName,
    int? timeoutMillis,
  }) async =>
      await methodChannel.invokeMethod<int>(
        'adbDiscoverPairingPort',
        <String, Object?>{
          'adbDeviceName': adbDeviceName,
          'timeoutMillis': timeoutMillis,
        },
      ) ??
      0;

  @override
  Future<int> adbDiscoverConnectPort({
    String? adbDeviceName,
    int? timeoutMillis,
  }) async =>
      await methodChannel.invokeMethod<int>(
        'adbDiscoverConnectPort',
        <String, Object?>{
          'adbDeviceName': adbDeviceName,
          'timeoutMillis': timeoutMillis,
        },
      ) ??
      0;

  @override
  Future<PrivAdbPairingResult> adbPair({
    required String pairingCode,
    String? adbDeviceName,
    int? port,
    int? portDiscoveryTimeoutMillis,
  }) async => PrivAdbPairingResult.fromMap(
    await _requireMap('adbPair', <String, Object?>{
      'adbDeviceName': adbDeviceName,
      'pairingCode': pairingCode,
      'port': port,
      'portDiscoveryTimeoutMillis': portDiscoveryTimeoutMillis,
    }),
  );

  @override
  Future<PrivAdbPairingCheckResult> adbCheckPairing({
    String? adbDeviceName,
    int? port,
    int? portDiscoveryTimeoutMillis,
  }) async => PrivAdbPairingCheckResult.fromMap(
    await _requireMap('adbCheckPairing', <String, Object?>{
      'adbDeviceName': adbDeviceName,
      'port': port,
      'portDiscoveryTimeoutMillis': portDiscoveryTimeoutMillis,
    }),
  );

  @override
  Future<int> adbOpenPairingCheckSession({
    String? adbDeviceName,
    int? port,
    int? portDiscoveryTimeoutMillis,
  }) async =>
      await methodChannel
          .invokeMethod<int>('adbOpenPairingCheckSession', <String, Object?>{
            'adbDeviceName': adbDeviceName,
            'port': port,
            'portDiscoveryTimeoutMillis': portDiscoveryTimeoutMillis,
          }) ??
      -1;

  @override
  Future<PrivAdbPairingCheckResult> adbCheckPairingSession(
    int sessionId,
  ) async => PrivAdbPairingCheckResult.fromMap(
    await _requireMap('adbCheckPairingSession', <String, Object?>{
      'sessionId': sessionId,
    }),
  );

  @override
  Future<PrivAdbAuthorizationCheckResult> adbPrepareTcpForStart({
    String? adbDeviceName,
    int? tcpPort,
  }) async => PrivAdbAuthorizationCheckResult.fromMap(
    await _requireMap('adbPrepareTcpForStart', <String, Object?>{
      'adbDeviceName': adbDeviceName,
      'tcpPort': tcpPort,
    }),
  );

  @override
  Future<PrivAdbAuthorizationCheckResult> adbCheckTcpAuthorization({
    String? adbDeviceName,
    int? tcpPort,
  }) async => PrivAdbAuthorizationCheckResult.fromMap(
    await _requireMap('adbCheckTcpAuthorization', <String, Object?>{
      'adbDeviceName': adbDeviceName,
      'tcpPort': tcpPort,
    }),
  );

  @override
  Future<PrivAdbAuthorizationRequestResult> adbRequestTcpAuthorization({
    String? adbDeviceName,
    int? tcpPort,
    int? timeoutMillis,
  }) async => PrivAdbAuthorizationRequestResult.fromMap(
    await _requireMap('adbRequestTcpAuthorization', <String, Object?>{
      'adbDeviceName': adbDeviceName,
      'tcpPort': tcpPort,
      'timeoutMillis': timeoutMillis,
    }),
  );

  @override
  Future<int> adbOpenTcpAuthorizationCheckSession({
    String? adbDeviceName,
    int? tcpPort,
  }) async =>
      await methodChannel.invokeMethod<int>(
        'adbOpenTcpAuthorizationCheckSession',
        <String, Object?>{'adbDeviceName': adbDeviceName, 'tcpPort': tcpPort},
      ) ??
      -1;

  @override
  Future<PrivAdbAuthorizationCheckResult> adbCheckTcpAuthorizationSession(
    int sessionId,
  ) async => PrivAdbAuthorizationCheckResult.fromMap(
    await _requireMap('adbCheckTcpAuthorizationSession', <String, Object?>{
      'sessionId': sessionId,
    }),
  );

  @override
  Future<PrivAdbTcpResult> adbSwitchToTcp({
    String? adbDeviceName,
    int? tcpPort,
    PrivAdbConnectionOptions? options,
  }) async => PrivAdbTcpResult.fromMap(
    await _requireMap('adbSwitchToTcp', <String, Object?>{
      'adbDeviceName': adbDeviceName,
      'tcpPort': tcpPort,
      'options': options?.toMap(),
    }),
  );

  @override
  Future<PrivAdbTcpResult> adbStopTcp({
    String? adbDeviceName,
    int? tcpPort,
    PrivAdbConnectionOptions? options,
  }) async => PrivAdbTcpResult.fromMap(
    await _requireMap('adbStopTcp', <String, Object?>{
      'adbDeviceName': adbDeviceName,
      'tcpPort': tcpPort,
      'options': options?.toMap(),
    }),
  );

  @override
  Future<PrivAdbTcpResult> adbRestartTcp({
    String? adbDeviceName,
    int? tcpPort,
    PrivAdbConnectionOptions? options,
  }) async => PrivAdbTcpResult.fromMap(
    await _requireMap('adbRestartTcp', <String, Object?>{
      'adbDeviceName': adbDeviceName,
      'tcpPort': tcpPort,
      'options': options?.toMap(),
    }),
  );

  @override
  Future<void> closeSession(int sessionId) => methodChannel.invokeMethod<void>(
    'closeSession',
    <String, Object?>{'sessionId': sessionId},
  );

  @override
  Future<PrivCommandResult> runCommand(
    PrivCommand command, {
    int? timeoutMillis,
    int? maxBytesPerStream,
  }) async => PrivCommandResult.fromMap(
    await _requireMap('runCommand', <String, Object?>{
      ...command.toMap(),
      'timeoutMillis': timeoutMillis,
      'maxBytesPerStream': maxBytesPerStream,
    }),
  );

  @override
  Future<void> startCommand(
    String commandId,
    PrivCommand command, {
    int? timeoutMillis,
  }) =>
      methodChannel.invokeMethod<void>('startCommandStream', <String, Object?>{
        'commandId': commandId,
        ...command.toMap(),
        'timeoutMillis': timeoutMillis,
      });

  @override
  Stream<PrivCommandEvent> commandEvents(String commandId) =>
      EventChannel(
        '${MethodChannelPrivKit.commandChannelPrefix}$commandId',
      ).receiveBroadcastStream().map(
        (dynamic event) => parseCommandEvent(event as Map<dynamic, dynamic>),
      );

  @override
  Future<void> cancelCommand(String commandId) =>
      methodChannel.invokeMethod<void>('cancelCommand', <String, Object?>{
        'commandId': commandId,
      });

  @override
  Future<String> externalStartupRunInCurrentProcess({
    required String commandLine,
    PrivExternalStartupOptions? options,
  }) async =>
      await methodChannel.invokeMethod<String>(
        'externalStartupRunInCurrentProcess',
        <String, Object?>{
          'commandLine': commandLine,
          'options': options?.toMap(),
        },
      ) ??
      '';

  @override
  Future<String> externalStartupRunThroughBridge({
    required String commandLine,
    required String bridgeId,
    PrivExternalStartupBridgeOptions? options,
  }) async =>
      await methodChannel.invokeMethod<String>(
        'externalStartupRunThroughBridge',
        <String, Object?>{
          'commandLine': commandLine,
          'bridgeId': bridgeId,
          'options': options?.toMap(),
        },
      ) ??
      '';

  Future<Map<dynamic, dynamic>> _requireMap(
    String method, [
    Map<String, Object?>? arguments,
  ]) async {
    final result = await methodChannel.invokeMethod<dynamic>(method, arguments);
    if (result is Map) return result;
    throw PlatformException(
      code: 'NATIVE_ERROR',
      message: '$method returned ${result.runtimeType}, expected a Map.',
    );
  }

  Future<Map<dynamic, dynamic>?> _mapOrNull(
    String method, [
    Map<String, Object?>? arguments,
  ]) async {
    final result = await methodChannel.invokeMethod<dynamic>(method, arguments);
    if (result == null) return null;
    if (result is Map) return result;
    throw PlatformException(
      code: 'NATIVE_ERROR',
      message: '$method returned ${result.runtimeType}, expected a Map.',
    );
  }
}
