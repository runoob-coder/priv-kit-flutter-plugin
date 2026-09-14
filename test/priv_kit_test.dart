import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:priv_kit/priv_kit.dart';
import 'package:priv_kit/priv_kit_platform_interface.dart';
import 'package:priv_kit/priv_kit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPrivKitPlatform extends PrivKitPlatform
    with MockPlatformInterfaceMixin {
  @override
  Future<PrivServerInfo?> getServerState() =>
      Future.value(const PrivServerInfo(uid: 0, pid: 1234, protocolVersion: 1));
}

void main() {
  final PrivKitPlatform initialPlatform = PrivKitPlatform.instance;

  test('$MethodChannelPrivKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPrivKit>());
  });

  test('getServerState', () async {
    PrivKitPlatform.instance = MockPrivKitPlatform();
    final privKitPlugin = PrivKit();

    final serverInfo = await privKitPlugin.getServerState();
    expect(serverInfo?.uid, 0);
    expect(serverInfo?.pid, 1234);
    expect(serverInfo?.isRoot, isTrue);
  });

  group('models', () {
    test('PrivServerInfo supports value equality and copyWith', () {
      const info = PrivServerInfo(uid: 0, pid: 1, protocolVersion: 2);
      final copy = info.copyWith(selinuxContext: 'u:r:su:s0');

      expect(info, PrivServerInfo(uid: 0, pid: 1, protocolVersion: 2));
      expect(copy, isNot(info));
      expect(copy.selinuxContext, 'u:r:su:s0');
      expect(copy.uid, 0);
    });

    test('PrivCommandEvent is an exhaustive union', () {
      final events = <PrivCommandEvent>[
        PrivCommandEvent.stdout(bytes: Uint8List(0)),
        PrivCommandEvent.stderr(bytes: Uint8List(0)),
        PrivCommandEvent.exit(exitCode: 0),
      ];

      final kinds = events.map(
        (event) => event.when(
          stdout: (_) => 'stdout',
          stderr: (_) => 'stderr',
          exit: (_) => 'exit',
        ),
      );

      expect(kinds, ['stdout', 'stderr', 'exit']);
    });
  });
}
