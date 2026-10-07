// Behaviour tests for the crash log bridge added by priv-core 0.17.3.
//
// Privileged processes write their own crash reports as UTF-8 JSON; nothing in
// priv-core scans them, so [PrivKit.readCrashLogs] builds that on top of the
// file proxy and this file pins down what it skips and how it orders results.
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:priv_kit/priv_kit.dart';
import 'package:priv_kit/priv_kit_method_channel.dart';
import 'package:priv_kit/priv_kit_platform_interface.dart';

/// Serves a fixed set of files for every path [PrivKit.readCrashLogs] walks.
class _FakePlatform extends PrivKitPlatform with MockPlatformInterfaceMixin {
  _FakePlatform(this.files, {this.crashLogDirectory});

  final Map<String, Uint8List> files;
  final String? crashLogDirectory;

  /// Every directory handed to [fileWalkStart], in call order.
  final List<String> walked = <String>[];

  /// The `maxDepth` of each [fileWalkStart] call.
  final List<int?> depths = <int?>[];

  String? _walkedPath;
  String? _openedPath;
  int _offset = 0;

  @override
  Future<PrivRuntimeConfig> getRuntimeConfig() => Future.value(
    PrivRuntimeConfig(
      followDeathDelayMillis: privilegeDefaultFollowDeathDelayMillis,
      activeReconnectOnOwnerDeath: privilegeDefaultActiveReconnectOnOwnerDeath,
      crashLogDirectory: crashLogDirectory,
    ),
  );

  @override
  Future<void> fileWalkStart(
    String operationId,
    String path, {
    int? maxDepth,
    List<String>? skipDirectoryGlobs,
    int? flushBatchSize,
  }) async {
    walked.add(path);
    depths.add(maxDepth);
    _walkedPath = path;
  }

  @override
  Stream<PrivFileEntry> fileWalkEntries(String operationId) {
    final prefix = '${_walkedPath ?? ''}/';
    return Stream.fromIterable(
      files.entries
          .where((entry) => entry.key.startsWith(prefix))
          .map(
            (entry) => PrivFileEntry(
              absolutePath: entry.key,
              depth: 1,
              metadata: PrivFileMetadata(
                absolutePath: entry.key,
                sizeBytes: entry.value.lengthInBytes,
                lastModifiedMillis: 0,
                unixMode: 0,
                uid: 0,
                gid: 0,
                type: PrivFileType.regularFile,
              ),
            ),
          ),
    );
  }

  @override
  Future<int> fileOpenRead(String path) async {
    _openedPath = path;
    _offset = 0;
    return 1;
  }

  @override
  Future<Uint8List> fileRead(
    int handle, {
    int maxBytes = privilegeFileDefaultReadChunkBytes,
  }) async {
    final bytes = files[_openedPath] ?? Uint8List(0);
    if (_offset >= bytes.length) return Uint8List(0);
    final end = _offset + maxBytes > bytes.length
        ? bytes.length
        : _offset + maxBytes;
    final chunk = Uint8List.sublistView(bytes, _offset, end);
    _offset = end;
    return chunk;
  }

  @override
  Future<void> fileClose(int handle) async {
    _openedPath = null;
  }
}

/// Encodes one report the way priv-core writes it.
Uint8List _report({
  required String applicationId,
  required int crashedAtEpochMillis,
  String processType = privilegeCrashProcessTypeServer,
  String? serviceClassName,
}) {
  final json = <String, Object?>{
    'schemaVersion': privilegeCrashLogSchemaVersion,
    'applicationId': applicationId,
    'userId': 0,
    'uid': 2000,
    'pid': 4242,
    'processType': processType,
    'serviceClassName': serviceClassName,
    'startedAtEpochMillis': crashedAtEpochMillis - 1000,
    'crashedAtEpochMillis': crashedAtEpochMillis,
    'threadName': 'main',
    'exceptionType': 'java.lang.IllegalStateException',
    'exceptionMessage': 'boom',
    'stackTrace': 'java.lang.IllegalStateException: boom\n\tat main',
    // Unknown fields must not break decoding.
    'futureField': 'ignored',
  };
  return Uint8List.fromList(utf8.encode(jsonEncode(json)));
}

void main() {
  const appDir = '/sdcard/Android/data/com.example/files/privilege-crashes';
  const fallback = privilegeCrashLogFallbackDirectory;

  PrivKit kitWith(_FakePlatform platform) {
    PrivKitPlatform.instance = platform;
    return PrivKit();
  }

  tearDown(() {
    PrivKitPlatform.instance = MethodChannelPrivKit();
  });

  test('PrivCrashLog decodes a report written by priv-core', () {
    final log = PrivCrashLog.fromJson(
      jsonDecode(
            utf8.decode(
              _report(applicationId: 'com.example', crashedAtEpochMillis: 2000),
            ),
          )
          as Map<dynamic, dynamic>,
    );

    expect(log.schemaVersion, privilegeCrashLogSchemaVersion);
    expect(log.isSupportedSchemaVersion, isTrue);
    expect(log.applicationId, 'com.example');
    expect(log.userId, 0);
    expect(log.uid, 2000);
    expect(log.pid, 4242);
    expect(log.processType, privilegeCrashProcessTypeServer);
    expect(log.isServer, isTrue);
    expect(log.isUserService, isFalse);
    expect(log.serviceClassName, isNull);
    expect(log.startedAtEpochMillis, 1000);
    expect(log.crashedAtEpochMillis, 2000);
    expect(log.crashedAt.difference(log.startedAt), const Duration(seconds: 1));
    expect(log.threadName, 'main');
    expect(log.exceptionType, 'java.lang.IllegalStateException');
    expect(log.exceptionMessage, 'boom');
    expect(log.stackTrace, contains('at main'));
  });

  test('PrivCrashLog supports value equality and copyWith', () {
    final log = PrivCrashLog.fromJson(
      jsonDecode(
            utf8.decode(
              _report(
                applicationId: 'com.example',
                crashedAtEpochMillis: 2000,
                processType: privilegeCrashProcessTypeUserService,
                serviceClassName: 'com.example.Demo',
              ),
            ),
          )
          as Map<dynamic, dynamic>,
    );

    expect(log.isUserService, isTrue);
    expect(log.serviceClassName, 'com.example.Demo');
    expect(log, log.copyWith());
    expect(log.copyWith(threadName: 'pool-1').threadName, 'pool-1');
  });

  test('readCrashLogs reads every report, newest first', () async {
    final platform = _FakePlatform(<String, Uint8List>{
      '$appDir/priv-crash_uid10234_20261008120000.json': _report(
        applicationId: 'com.example',
        crashedAtEpochMillis: 1000,
      ),
      '$appDir/priv-crash_uid10234_20261008120100.json': _report(
        applicationId: 'com.example',
        crashedAtEpochMillis: 3000,
      ),
      '$appDir/priv-crash_uid10234_20261008120200.json.tmp': _report(
        applicationId: 'com.example',
        crashedAtEpochMillis: 9000,
      ),
      '$appDir/unrelated.json': _report(
        applicationId: 'com.example',
        crashedAtEpochMillis: 8000,
      ),
    }, crashLogDirectory: appDir);
    final kit = kitWith(platform);

    final reports = await kit.readCrashLogs(includeFallbackDirectory: false);

    expect(reports.map((report) => report.crashedAtEpochMillis), [3000, 1000]);
    expect(platform.walked, [appDir]);
    // A non-recursive walk is enough: reports are flat files.
    expect(platform.depths, [1]);
  });

  test('readCrashLogs uses the configured directory as default', () async {
    final platform = _FakePlatform(<String, Uint8List>{
      '$appDir/priv-crash_uid10234_20261008120000.json': _report(
        applicationId: 'com.example',
        crashedAtEpochMillis: 1000,
      ),
      '$fallback/priv-crash_com.example_u0_uid2000_20261008120300.json':
          _report(applicationId: 'com.example', crashedAtEpochMillis: 2000),
    }, crashLogDirectory: appDir);
    final kit = kitWith(platform);

    final reports = await kit.readCrashLogs();

    expect(reports.map((report) => report.crashedAtEpochMillis), [2000, 1000]);
    expect(platform.walked, [appDir, fallback]);
  });

  test(
    'readCrashLogs scans the fallback directory only when unconfigured',
    () async {
      final platform = _FakePlatform(<String, Uint8List>{
        '$fallback/priv-crash_com.example_u0_uid2000_20261008120300.json':
            _report(applicationId: 'com.example', crashedAtEpochMillis: 2000),
      });
      final kit = kitWith(platform);

      final reports = await kit.readCrashLogs();

      expect(reports.single.applicationId, 'com.example');
      expect(platform.walked, [fallback]);
    },
  );

  test('readCrashLogs honours an explicit directory', () async {
    final platform = _FakePlatform(<String, Uint8List>{
      '/custom/priv-crash_uid10234_20261008120000.json': _report(
        applicationId: 'com.example',
        crashedAtEpochMillis: 1000,
      ),
    }, crashLogDirectory: appDir);
    final kit = kitWith(platform);

    final reports = await kit.readCrashLogs(
      directory: '/custom',
      includeFallbackDirectory: false,
    );

    expect(reports, hasLength(1));
    expect(platform.walked, ['/custom']);
  });

  test('readCrashLogs skips reports above the size limit', () async {
    final oversized = _report(
      applicationId: 'com.example',
      crashedAtEpochMillis: 5000,
    );
    final padded = Uint8List(privilegeCrashLogMaxBytes + 1)
      ..setRange(0, oversized.length, oversized);
    final platform = _FakePlatform(<String, Uint8List>{
      '$appDir/priv-crash_uid10234_20261008120000.json': _report(
        applicationId: 'com.example',
        crashedAtEpochMillis: 1000,
      ),
      '$appDir/priv-crash_uid10234_20261008120100.json': padded,
    }, crashLogDirectory: appDir);
    final kit = kitWith(platform);

    final reports = await kit.readCrashLogs(includeFallbackDirectory: false);

    expect(reports.map((report) => report.crashedAtEpochMillis), [1000]);
  });

  test('readCrashLogs returns nothing when all scans are disabled', () async {
    final platform = _FakePlatform(<String, Uint8List>{});
    final kit = kitWith(platform);

    final reports = await kit.readCrashLogs(
      directory: '',
      includeFallbackDirectory: false,
    );

    expect(reports, isEmpty);
    expect(platform.walked, isEmpty);
  });
}
