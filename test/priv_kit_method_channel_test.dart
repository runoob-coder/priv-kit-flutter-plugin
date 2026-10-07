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

  test('checkPermission forwards permission, package and userId', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          if (methodCall.method == 'checkPermission') {
            return privilegePermissionGranted;
          }
          return null;
        });

    final result = await platform.checkPermission(
      permission: 'android.permission.CAMERA',
      packageName: 'com.example.app',
      userId: 0,
    );

    expect(result, privilegePermissionGranted);
    final call = log.singleWhere((c) => c.method == 'checkPermission');
    expect(call.arguments['permission'], 'android.permission.CAMERA');
    expect(call.arguments['packageName'], 'com.example.app');
    expect(call.arguments['userId'], 0);
  });

  test(
    'checkPermission falls back to denied when the call returns null',
    () async {
      final result = await platform.checkPermission(
        permission: 'android.permission.CAMERA',
        packageName: 'com.example.app',
      );
      expect(result, privilegePermissionDenied);
    },
  );

  test('grant and revoke runtime permission forward their arguments', () async {
    await platform.grantRuntimePermission(
      packageName: 'com.example.app',
      permission: 'android.permission.CAMERA',
    );
    await platform.revokeRuntimePermission(
      packageName: 'com.example.app',
      permission: 'android.permission.CAMERA',
      userId: 10,
    );

    final granted = log.singleWhere(
      (c) => c.method == 'grantRuntimePermission',
    );
    expect(granted.arguments['packageName'], 'com.example.app');
    expect(granted.arguments['permission'], 'android.permission.CAMERA');
    expect(granted.arguments['userId'], isNull);

    final revoked = log.singleWhere(
      (c) => c.method == 'revokeRuntimePermission',
    );
    expect(revoked.arguments['userId'], 10);
  });

  test('startUserService forwards the whole spec', () async {
    await platform.startUserService(
      const PrivUserServiceSpec(
        serviceClassName: 'com.example.MyService',
        tag: 'main',
        version: 3,
        embedded: true,
        daemon: true,
      ),
    );

    final call = log.singleWhere((c) => c.method == 'startUserService');
    expect(call.arguments['serviceClassName'], 'com.example.MyService');
    expect(call.arguments['tag'], 'main');
    expect(call.arguments['version'], 3);
    expect(call.arguments['embedded'], true);
    expect(call.arguments['daemon'], true);
  });

  test('bindUserService returns the connection handle', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          return 42;
        });

    final handle = await platform.bindUserService(
      const PrivUserServiceSpec(serviceClassName: 'com.example.MyService'),
    );

    expect(handle, 42);
    final call = log.singleWhere((c) => c.method == 'bindUserService');
    // Defaults are filled in on the Dart side.
    expect(call.arguments['tag'], privilegeUserServiceDefaultTag);
    expect(call.arguments['version'], 1);
    expect(call.arguments['embedded'], false);
    expect(call.arguments['daemon'], false);
  });

  test(
    'unbindUserService and stopUserService forward their arguments',
    () async {
      await platform.unbindUserService(7);
      await platform.stopUserService(
        const PrivUserServiceSpec(serviceClassName: 'com.example.MyService'),
      );

      expect(
        log
            .singleWhere((c) => c.method == 'unbindUserService')
            .arguments['connectionHandle'],
        7,
      );
      expect(
        log
            .singleWhere((c) => c.method == 'stopUserService')
            .arguments['serviceClassName'],
        'com.example.MyService',
      );
    },
  );

  test('fileMetadata decodes the metadata snapshot', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          return <String, Object?>{
            'absolutePath': '/data/local/tmp/a.txt',
            'sizeBytes': 12,
            'lastModifiedMillis': 1000,
            'unixMode': 33188,
            'uid': 0,
            'gid': 0,
            'type': 'REGULAR_FILE',
          };
        });

    final metadata = await platform.fileMetadata('/data/local/tmp/a.txt');
    expect(metadata.name, 'a.txt');
    expect(metadata.sizeBytes, 12);
    expect(metadata.type, PrivFileType.regularFile);
    expect(metadata.lastModified, DateTime.fromMillisecondsSinceEpoch(1000));

    final call = log.singleWhere((c) => c.method == 'fileMetadata');
    expect(call.arguments['path'], '/data/local/tmp/a.txt');
    expect(call.arguments['followSymbolicLinks'], false);
  });

  test('file queries forward the path and default to false', () async {
    final exists = await platform.fileExists('/data/local/tmp');
    expect(exists, isFalse);
    final call = log.singleWhere((c) => c.method == 'fileExists');
    expect(call.arguments['path'], '/data/local/tmp');
  });

  test('file read goes through handle -> bytes -> close', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          switch (methodCall.method) {
            case 'fileOpenRead':
              return 7;
            case 'fileRead':
              return Uint8List.fromList('hi'.codeUnits);
            default:
              return null;
          }
        });

    final handle = await platform.fileOpenRead('/data/local/tmp/a.txt');
    expect(handle, 7);

    final bytes = await platform.fileRead(handle, maxBytes: 16);
    expect(bytes, Uint8List.fromList('hi'.codeUnits));

    await platform.fileClose(handle);

    final read = log.singleWhere((c) => c.method == 'fileRead');
    expect(read.arguments['handle'], 7);
    expect(read.arguments['maxBytes'], 16);
    expect(
      log.singleWhere((c) => c.method == 'fileClose').arguments['handle'],
      7,
    );
  });

  test('fileWalkStart forwards the walk options', () async {
    await platform.fileWalkStart(
      'walk_1',
      '/data/local/tmp',
      maxDepth: 2,
      skipDirectoryGlobs: const ['cache'],
      flushBatchSize: 8,
    );

    final call = log.singleWhere((c) => c.method == 'fileWalkStart');
    expect(call.arguments['operationId'], 'walk_1');
    expect(call.arguments['path'], '/data/local/tmp');
    expect(call.arguments['maxDepth'], 2);
    expect(call.arguments['skipDirectoryGlobs'], <String>['cache']);
    expect(call.arguments['flushBatchSize'], 8);
  });

  test('fileWalkEntries decodes entries, including missing metadata', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
          const EventChannel('priv_kit/file_walk/walk_2'),
          MockStreamHandler.inline(
            onListen: (Object? arguments, MockStreamHandlerEventSink events) {
              events.success(<String, Object?>{
                'absolutePath': '/data/local/tmp/a.txt',
                'depth': 1,
                'metadata': <String, Object?>{
                  'absolutePath': '/data/local/tmp/a.txt',
                  'sizeBytes': 3,
                  'lastModifiedMillis': 0,
                  'unixMode': 33188,
                  'uid': 0,
                  'gid': 0,
                  'type': 'REGULAR_FILE',
                },
              });
              // Metadata is absent when the server cannot read the attributes.
              events.success(<String, Object?>{
                'absolutePath': '/data/local/tmp/locked',
                'depth': 2,
                'metadata': null,
              });
              events.endOfStream();
            },
          ),
        );

    final entries = await platform.fileWalkEntries('walk_2').toList();
    expect(entries, hasLength(2));
    expect(entries.first.name, 'a.txt');
    expect(entries.first.metadata?.sizeBytes, 3);
    expect(entries.last.metadata, isNull);
    expect(entries.last.depth, 2);
  });

  test('getRuntimeConfig decodes the reconnect policy', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          return <String, Object?>{
            'followDeathDelayMillis': 60000,
            'activeReconnectOnOwnerDeath': true,
          };
        });

    final config = await platform.getRuntimeConfig();
    expect(config.followDeathDelayMillis, 60000);
    expect(config.followDeathDelay, const Duration(minutes: 1));
    expect(config.activeReconnectOnOwnerDeath, isTrue);
    expect(config.isDefault, isFalse);
  });

  test('getRuntimeConfig decodes the crash log directory', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          return <String, Object?>{
            'followDeathDelayMillis': 60000,
            'activeReconnectOnOwnerDeath': true,
            'crashLogDirectory':
                '/sdcard/Android/data/com.example/files/crashes',
          };
        });

    final config = await platform.getRuntimeConfig();
    expect(
      config.crashLogDirectory,
      '/sdcard/Android/data/com.example/files/crashes',
    );
    expect(config.isDefault, isFalse);
  });

  test('getRuntimeConfig reports a missing crash log directory', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          return <String, Object?>{
            'followDeathDelayMillis': 60000,
            'activeReconnectOnOwnerDeath': true,
            'crashLogDirectory': null,
          };
        });

    expect((await platform.getRuntimeConfig()).crashLogDirectory, isNull);
  });

  test('configureRuntime forwards both fields', () async {
    await platform.configureRuntime(
      followDeathDelayMillis: 30000,
      activeReconnectOnOwnerDeath: false,
    );

    final call = log.singleWhere((c) => c.method == 'configureRuntime');
    expect(call.arguments['followDeathDelayMillis'], 30000);
    expect(call.arguments['activeReconnectOnOwnerDeath'], false);
  });

  test('configureRuntime omits fields that were not given', () async {
    await platform.configureRuntime(activeReconnectOnOwnerDeath: true);

    final call = log.singleWhere((c) => c.method == 'configureRuntime');
    expect(call.arguments['activeReconnectOnOwnerDeath'], true);
    expect(call.arguments['followDeathDelayMillis'], isNull);
  });

  test('configureRuntime forwards the crash log directory', () async {
    await platform.configureRuntime(
      crashLogDirectory: '/sdcard/Android/data/com.example/files/crashes',
    );

    final call = log.singleWhere((c) => c.method == 'configureRuntime');
    expect(
      call.arguments['crashLogDirectory'],
      '/sdcard/Android/data/com.example/files/crashes',
    );
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

  test('binderHasSystemService forwards the name and the source', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          if (methodCall.method == 'binderHasSystemService') return true;
          return null;
        });

    final has = await platform.binderHasSystemService(
      'activity',
      source: PrivBinderServiceSource.serverProcess,
    );
    expect(has, isTrue);

    final call = log.single;
    expect(call.arguments['serviceName'], 'activity');
    expect(call.arguments['source'], 'SERVER_PROCESS');
  });

  test('binderHasSystemService defaults to the current process', () async {
    await platform.binderHasSystemService('package');
    expect(log.single.arguments['source'], 'CURRENT_PROCESS');
  });

  test('binderFromSystemService returns null when unavailable', () async {
    final handle = await platform.binderFromSystemService('nope');
    expect(handle, isNull);
  });

  test('binder handles are passed through as integers', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          return switch (methodCall.method) {
            'binderFromSystemService' => 7,
            'binderGetInterfaceDescriptor' => 'android.app.IActivityManager',
            'binderPing' => true,
            'binderIsAlive' => true,
            _ => null,
          };
        });

    final handle = await platform.binderFromSystemService('activity');
    expect(handle, 7);
    expect(
      await platform.binderGetInterfaceDescriptor(7),
      'android.app.IActivityManager',
    );
    expect(await platform.binderPing(7), isTrue);
    expect(await platform.binderIsAlive(7), isTrue);

    await platform.binderClose(7);
    final close = log.lastWhere((c) => c.method == 'binderClose');
    expect(close.arguments['handle'], 7);
  });

  test(
    'binderServerLifecycle returns null when nothing is connected',
    () async {
      expect(await platform.binderServerLifecycle(), isNull);
    },
  );

  test('binderPing treats an unreachable endpoint as false', () async {
    final ping = await platform.binderPing(42);
    expect(ping, isFalse);
  });
}
