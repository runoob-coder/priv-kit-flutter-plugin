// Behaviour tests for [PrivKit.readCrashLogs]: ordered directories, fallback
// reports while disconnected, and report filtering.
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:priv_kit/priv_kit.dart';
import 'package:priv_kit/priv_kit_method_channel.dart';
import 'package:priv_kit/priv_kit_platform_interface.dart';

/// Serves a fixed set of files for every path [PrivKit.readCrashLogs] walks.
class _FakePlatform extends PrivKitPlatform with MockPlatformInterfaceMixin {
  _FakePlatform(
    this.files, {
    this.crashLogDirectories = const <String>[],
    this.fallbackFiles = const <String, Uint8List>{},
    this.serverConnected = true,
    this.walkError,
  });

  final Map<String, Uint8List> files;
  final List<String> crashLogDirectories;
  final Map<String, Uint8List> fallbackFiles;
  final bool serverConnected;
  final PlatformException? walkError;

  /// Every directory handed to [fileWalkStart], in call order.
  final List<String> walked = <String>[];

  /// The `maxDepth` of each [fileWalkStart] call.
  final List<int?> depths = <int?>[];

  int fallbackReads = 0;

  String? _walkedPath;
  String? _openedPath;
  int _offset = 0;

  @override
  Future<PrivServerInfo?> getServerState() => Future.value(
    serverConnected
        ? const PrivServerInfo(uid: 0, pid: 1, protocolVersion: 1)
        : null,
  );

  @override
  Future<PrivRuntimeConfig> getRuntimeConfig() => Future.value(
    PrivRuntimeConfig(
      followDeathDelayMillis: privilegeDefaultFollowDeathDelayMillis,
      activeReconnectOnOwnerDeath: privilegeDefaultActiveReconnectOnOwnerDeath,
      crashLogDirectories: crashLogDirectories,
    ),
  );

  @override
  Future<List<PrivFallbackCrashLogFile>> readFallbackCrashLogs() {
    fallbackReads++;
    return Future.value(
      fallbackFiles.entries
          .map(
            (entry) =>
                PrivFallbackCrashLogFile(path: entry.key, content: entry.value),
          )
          .toList(),
    );
  }

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
    if (walkError != null) return Stream<PrivFileEntry>.error(walkError!);
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
  const appDir = '/data/user/0/com.example/files/privilege-crashes';
  const externalDir =
      '/sdcard/Android/data/com.example/files/privilege-crashes';
  const fallbackDir = '$privilegeCrashLogFallbackRoot/com.example/0/crashes';

  const reportName = 'priv-crash_uid2000_20261008120000.json';

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

  test('the 0.19.0 report name pattern accepts only published names', () {
    expect(privilegeCrashLogFileNamePattern.hasMatch(reportName), isTrue);
    expect(
      privilegeCrashLogFileNamePattern.hasMatch('$reportName.tmp'),
      isFalse,
    );
    expect(
      privilegeCrashLogFileNamePattern.hasMatch(
        'priv-crash_com.example_u0_uid2000_20261008120000.json',
      ),
      isFalse,
    );
  });

  test('readCrashLogs scans every configured directory in order', () async {
    final platform = _FakePlatform(
      <String, Uint8List>{
        '$appDir/$reportName': _report(
          applicationId: 'com.example',
          crashedAtEpochMillis: 1000,
        ),
        '$externalDir/priv-crash_uid2000_20261008120100.json': _report(
          applicationId: 'com.example',
          crashedAtEpochMillis: 3000,
        ),
      },
      crashLogDirectories: [appDir, externalDir, appDir],
    );
    final kit = kitWith(platform);

    final reports = await kit.readCrashLogs(includeFallbackCrashLogs: false);

    expect(reports.map((report) => report.crashedAtEpochMillis), [3000, 1000]);
    // Duplicates are scanned once, in write order.
    expect(platform.walked, [appDir, externalDir]);
    // A non-recursive walk is enough: reports are flat files.
    expect(platform.depths, [1, 1]);
    expect(platform.fallbackReads, 0);
  });

  test('readCrashLogs reads fallback reports while disconnected', () async {
    final platform = _FakePlatform(
      <String, Uint8List>{
        '$appDir/$reportName': _report(
          applicationId: 'com.example',
          crashedAtEpochMillis: 1000,
        ),
      },
      crashLogDirectories: [appDir],
      fallbackFiles: <String, Uint8List>{
        '$fallbackDir/priv-crash_uid2000_20261008120300.json': _report(
          applicationId: 'com.example',
          crashedAtEpochMillis: 2000,
        ),
      },
      serverConnected: false,
    );
    final kit = kitWith(platform);

    final reports = await kit.readCrashLogs();

    expect(reports.single.crashedAtEpochMillis, 2000);
    expect(platform.walked, isEmpty);
    expect(platform.fallbackReads, 1);
  });

  test('readCrashLogs merges configured and fallback reports', () async {
    final platform = _FakePlatform(
      <String, Uint8List>{
        '$appDir/$reportName': _report(
          applicationId: 'com.example',
          crashedAtEpochMillis: 1000,
        ),
      },
      crashLogDirectories: [appDir],
      fallbackFiles: <String, Uint8List>{
        '$fallbackDir/priv-crash_uid2000_20261008120300.json': _report(
          applicationId: 'com.example',
          crashedAtEpochMillis: 2000,
        ),
      },
    );

    final reports = await kitWith(platform).readCrashLogs();

    expect(reports.map((report) => report.crashedAtEpochMillis), [2000, 1000]);
    expect(platform.walked, [appDir]);
  });

  test('readCrashLogs de-duplicates paths shared by both sources', () async {
    final path = '$fallbackDir/$reportName';
    final bytes = _report(
      applicationId: 'com.example',
      crashedAtEpochMillis: 1000,
    );
    final platform = _FakePlatform(
      <String, Uint8List>{path: bytes},
      crashLogDirectories: [fallbackDir],
      fallbackFiles: <String, Uint8List>{path: bytes},
    );

    final reports = await kitWith(platform).readCrashLogs();

    expect(reports, hasLength(1));
    expect(reports.single.crashedAtEpochMillis, 1000);
  });

  test('readCrashLogs honours explicit directories', () async {
    final platform = _FakePlatform(
      <String, Uint8List>{
        '/custom/$reportName': _report(
          applicationId: 'com.example',
          crashedAtEpochMillis: 1000,
        ),
      },
      crashLogDirectories: [appDir],
    );
    final kit = kitWith(platform);

    final reports = await kit.readCrashLogs(
      directories: const <String>['/custom'],
      includeFallbackCrashLogs: false,
    );

    expect(reports, hasLength(1));
    expect(platform.walked, ['/custom']);
  });

  test('readCrashLogs skips temporary, unrelated and legacy names', () async {
    final bytes = _report(
      applicationId: 'com.example',
      crashedAtEpochMillis: 1000,
    );
    final platform = _FakePlatform(
      <String, Uint8List>{
        '$appDir/$reportName': bytes,
        '$appDir/$reportName.tmp': bytes,
        '$appDir/unrelated.json': bytes,
        '$appDir/priv-crash_com.example_u0_uid2000_20261008120000.json': bytes,
      },
      crashLogDirectories: [appDir],
      fallbackFiles: <String, Uint8List>{
        '$fallbackDir/$reportName.tmp': bytes,
        '$fallbackDir/legacy.json': bytes,
        '$fallbackDir/priv-crash_uid2000_20261008120400.json': _report(
          applicationId: 'com.example',
          crashedAtEpochMillis: 4000,
        ),
      },
    );

    final reports = await kitWith(platform).readCrashLogs();

    expect(reports.map((report) => report.crashedAtEpochMillis), [4000, 1000]);
  });

  test('readCrashLogs skips reports above the size limit', () async {
    final small = _report(
      applicationId: 'com.example',
      crashedAtEpochMillis: 1000,
    );
    final padded = Uint8List(privilegeCrashLogMaxBytes + 1)
      ..setRange(0, small.length, small);
    final platform = _FakePlatform(
      <String, Uint8List>{
        '$appDir/$reportName': small,
        '$appDir/priv-crash_uid2000_20261008120100.json': padded,
      },
      crashLogDirectories: [appDir],
      fallbackFiles: <String, Uint8List>{
        '$fallbackDir/priv-crash_uid2000_20261008120200.json': padded,
      },
    );

    final reports = await kitWith(platform).readCrashLogs();

    expect(reports.map((report) => report.crashedAtEpochMillis), [1000]);
  });

  test(
    'readCrashLogs skips malformed reports without hiding the others',
    () async {
      final platform = _FakePlatform(
        <String, Uint8List>{
          '$appDir/$reportName': Uint8List.fromList(utf8.encode('{not json')),
        },
        crashLogDirectories: [appDir],
        fallbackFiles: <String, Uint8List>{
          '$fallbackDir/priv-crash_uid2000_20261008120500.json': _report(
            applicationId: 'com.example',
            crashedAtEpochMillis: 5000,
          ),
        },
      );

      final reports = await kitWith(platform).readCrashLogs();

      expect(reports.map((report) => report.crashedAtEpochMillis), [5000]);
    },
  );

  test('readCrashLogs returns nothing when all scans are disabled', () async {
    final platform = _FakePlatform(<String, Uint8List>{});
    final kit = kitWith(platform);

    final reports = await kit.readCrashLogs(
      directories: const <String>[],
      includeFallbackCrashLogs: false,
    );

    expect(reports, isEmpty);
    expect(platform.walked, isEmpty);
    expect(platform.fallbackReads, 0);
  });

  test('readCrashLogs propagates a real directory listing failure', () async {
    final platform = _FakePlatform(
      <String, Uint8List>{},
      crashLogDirectories: [appDir],
      walkError: PlatformException(code: PrivKitErrorCode.file),
    );

    await expectLater(
      kitWith(platform).readCrashLogs(includeFallbackCrashLogs: false),
      throwsA(
        isA<PrivKitException>().having(
          (error) => error.code,
          'code',
          PrivKitErrorCode.file,
        ),
      ),
    );
  });

  test(
    'readCrashLogs keeps fallback reports when the server dies mid-walk',
    () async {
      final platform = _FakePlatform(
        <String, Uint8List>{},
        crashLogDirectories: [appDir],
        fallbackFiles: <String, Uint8List>{
          '$fallbackDir/priv-crash_uid2000_20261008120600.json': _report(
            applicationId: 'com.example',
            crashedAtEpochMillis: 6000,
          ),
        },
        walkError: PlatformException(code: PrivKitErrorCode.serverUnavailable),
      );

      final reports = await kitWith(platform).readCrashLogs();

      expect(reports.single.crashedAtEpochMillis, 6000);
    },
  );

  test('configureRuntime rejects relative crash log directories', () {
    final kit = kitWith(_FakePlatform(<String, Uint8List>{}));

    expect(
      () => kit.configureRuntime(
        crashLogDirectories: const <String>['relative/crashes'],
      ),
      throwsArgumentError,
    );
  });
}
