import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priv_kit/priv_kit.dart';
import 'package:priv_kit/priv_kit_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelPrivKit platform = MethodChannelPrivKit();
  const MethodChannel channel = MethodChannel('priv_kit');

  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          if (methodCall.method == 'getServerState') {
            return <String, Object?>{
              'uid': 0,
              'pid': 4242,
              'protocolVersion': 1,
              'selinuxContext': 'u:r:su:s0',
            };
          }
          if (methodCall.method == 'getDeniedServerPermissions') {
            return <String>['android.permission.FAKE'];
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getServerState', () async {
    final info = await platform.getServerState();
    expect(info, isNotNull);
    expect(info!.uid, 0);
    expect(info.pid, 4242);
    expect(info.selinuxContext, 'u:r:su:s0');
  });

  test('getDeniedServerPermissions', () async {
    expect(await platform.getDeniedServerPermissions(), <String>[
      'android.permission.FAKE',
    ]);
  });

  test('startAdb forwards options to the native side', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          return <String, Object?>{
            'uid': 2000,
            'pid': 77,
            'protocolVersion': 1,
            'selinuxContext': null,
          };
        });

    final info = await platform.startAdb(
      options: const PrivAdbConnectionOptions(port: 5555),
      adbDeviceName: 'demo',
      operationId: 'adb-1',
    );

    expect(info.uid, 2000);
    final call = log.singleWhere((c) => c.method == 'startAdb');
    expect(call.arguments['adbDeviceName'], 'demo');
    expect(call.arguments['operationId'], 'adb-1');
    expect(call.arguments['options']['port'], 5555);
    expect(
      call.arguments['options']['wirelessDebuggingControl'],
      'IF_AVAILABLE',
    );
  });

  test('adbCheckTcpAuthorization maps the authorization status', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          return <String, Object?>{
            'status': 'AUTHORIZED',
            'outputText': 'ok',
            'deviceName': 'demo',
            'publicKeyFingerprint': 'fp',
            'failureMessage': null,
          };
        });

    final result = await platform.adbCheckTcpAuthorization(tcpPort: 5555);
    expect(result.isAuthorized, isTrue);
    expect(result.deviceName, 'demo');
    final call = log.singleWhere((c) => c.method == 'adbCheckTcpAuthorization');
    expect(call.arguments['tcpPort'], 5555);
  });

  test('runCommand forwards the command and decodes the result', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          return <String, Object?>{
            'exitCode': 0,
            'stdout': Uint8List.fromList('uid=0(root)'.codeUnits),
            'stderr': Uint8List(0),
            'stdoutTruncated': false,
            'stderrTruncated': true,
          };
        });

    final result = await platform.runCommand(
      PrivCommand(
        arguments: const ['/system/bin/id'],
        environment: const {'LANG': 'C'},
        workingDirectory: '/data/local/tmp',
      ),
      timeoutMillis: noCommandTimeout,
    );

    expect(result.exitCode, 0);
    expect(result.stdoutText, 'uid=0(root)');
    expect(result.stderrTruncated, isTrue);

    final call = log.singleWhere((c) => c.method == 'runCommand');
    expect(call.arguments['arguments'], <String>['/system/bin/id']);
    expect(call.arguments['environment'], <String, String>{'LANG': 'C'});
    expect(call.arguments['workingDirectory'], '/data/local/tmp');
    expect(call.arguments['timeoutMillis'], noCommandTimeout);
  });

  test('startCommand uses a per-command event channel', () async {
    await platform.startCommand(
      'cmd_1',
      PrivCommand(arguments: const ['/system/bin/id']),
    );

    final call = log.singleWhere((c) => c.method == 'startCommandStream');
    expect(call.arguments['commandId'], 'cmd_1');
    expect(call.arguments['arguments'], <String>['/system/bin/id']);
    expect(call.arguments['timeoutMillis'], isNull);
  });

  test('commandEvents parses stdout, stderr and exit events', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
          const EventChannel('priv_kit/command/cmd_2'),
          MockStreamHandler.inline(
            onListen: (Object? arguments, MockStreamHandlerEventSink events) {
              events.success(<String, Object?>{
                'type': 'stdout',
                'data': Uint8List.fromList('out1'.codeUnits),
              });
              events.success(<String, Object?>{
                'type': 'stderr',
                'data': Uint8List.fromList('err'.codeUnits),
              });
              events.success(<String, Object?>{'type': 'exit', 'exitCode': 7});
              events.endOfStream();
            },
          ),
        );

    final events = await platform.commandEvents('cmd_2').toList();
    expect(events, [
      isA<PrivCommandStdout>().having((e) => e.bytes.length, 'bytes', 4),
      isA<PrivCommandStderr>().having((e) => e.bytes.length, 'bytes', 3),
      isA<PrivCommandExit>().having((e) => e.exitCode, 'exitCode', 7),
    ]);
  });
}
