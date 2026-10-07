import 'package:freezed_annotation/freezed_annotation.dart';

part 'crash_log.freezed.dart';

/// Directory priv-core falls back to when
/// [PrivRuntimeConfig.crashLogDirectory] is not set.
///
/// Reading it generally needs a connected Privileged Server, and its files may
/// belong to another app or Android user.
const String privilegeCrashLogFallbackDirectory = '/data/local/tmp';

/// Prefix of the report filenames written by priv-core.
const String privilegeCrashLogFilePrefix = 'priv-crash_';

/// Extension of the report filenames written by priv-core.
///
/// A report is written next to its destination as `.json.tmp` and renamed once
/// it has been synced, so an interrupted write can leave a temporary file
/// behind. Both here and upstream, only `.json` files are read.
const String privilegeCrashLogFileSuffix = '.json';

/// Largest report the plugin reads, in bytes: 1 MiB.
const int privilegeCrashLogMaxBytes = 1024 * 1024;

/// The schema version this model decodes, matching priv-core 0.17.3+.
const int privilegeCrashLogSchemaVersion = 1;

/// Value of [PrivCrashLog.processType] for the Privileged Server itself.
const String privilegeCrashProcessTypeServer = 'server';

/// Value of [PrivCrashLog.processType] for a dedicated UserService process.
const String privilegeCrashProcessTypeUserService = 'userService';

/// One fatal Java/Kotlin exception recorded by a privileged process.
///
/// Mirrors `priv.kit.core.PrivilegeCrashLog`. The server and every dedicated
/// UserService install an uncaught exception handler once their launch
/// configuration has been parsed: the report is written as UTF-8 JSON next to
/// the configured crash log directory, or into
/// [privilegeCrashLogFallbackDirectory] when the write fails. Nothing deletes
/// these files, so the host owns cleanup.
///
/// Native crashes, `SIGKILL` and anything thrown before configuration parsing
/// never produce a report: Logcat stays the fallback for those.
@freezed
abstract class PrivCrashLog with _$PrivCrashLog {
  const factory PrivCrashLog({
    /// Format of this report. Currently [privilegeCrashLogSchemaVersion].
    required int schemaVersion,

    /// Application the crashing process belonged to.
    required String applicationId,

    /// Android user the crashing process ran as.
    required int userId,

    /// UID of the crashing process.
    required int uid,

    /// PID of the crashing process.
    required int pid,

    /// [privilegeCrashProcessTypeServer] or
    /// [privilegeCrashProcessTypeUserService].
    required String processType,

    /// Class of the UserService that crashed, only for a UserService process.
    String? serviceClassName,

    /// When the recorder was initialized, in milliseconds since the epoch.
    required int startedAtEpochMillis,

    /// When the process crashed, in milliseconds since the epoch.
    required int crashedAtEpochMillis,

    /// Thread that raised the exception.
    required String threadName,

    /// Fully qualified name of the exception class.
    required String exceptionType,

    /// Message of the exception, when it had one.
    String? exceptionMessage,

    /// Full stack trace, including causes and suppressed exceptions.
    required String stackTrace,
  }) = _PrivCrashLog;

  const PrivCrashLog._();

  /// Decodes the JSON of one report.
  ///
  /// Unknown fields are ignored and numbers are read through [num], so a
  /// report written by another JVM-style producer still decodes.
  factory PrivCrashLog.fromJson(Map<dynamic, dynamic> json) {
    int intOf(String key) => (json[key] as num?)?.toInt() ?? 0;
    String stringOf(String key) => json[key] as String? ?? '';
    return PrivCrashLog(
      schemaVersion: intOf('schemaVersion'),
      applicationId: stringOf('applicationId'),
      userId: intOf('userId'),
      uid: intOf('uid'),
      pid: intOf('pid'),
      processType: stringOf('processType'),
      serviceClassName: json['serviceClassName'] as String?,
      startedAtEpochMillis: intOf('startedAtEpochMillis'),
      crashedAtEpochMillis: intOf('crashedAtEpochMillis'),
      threadName: stringOf('threadName'),
      exceptionType: stringOf('exceptionType'),
      exceptionMessage: json['exceptionMessage'] as String?,
      stackTrace: stringOf('stackTrace'),
    );
  }

  /// When the recorder was initialized.
  DateTime get startedAt =>
      DateTime.fromMillisecondsSinceEpoch(startedAtEpochMillis);

  /// When the process crashed.
  DateTime get crashedAt =>
      DateTime.fromMillisecondsSinceEpoch(crashedAtEpochMillis);

  /// Whether the crash happened in the Privileged Server itself.
  bool get isServer => processType == privilegeCrashProcessTypeServer;

  /// Whether the crash happened in a dedicated UserService process.
  bool get isUserService => processType == privilegeCrashProcessTypeUserService;

  /// Whether this version of the plugin understands the report.
  ///
  /// Reports from a future priv-core are still decoded: extra fields are
  /// dropped while every known one stays readable.
  bool get isSupportedSchemaVersion =>
      schemaVersion == privilegeCrashLogSchemaVersion;
}
