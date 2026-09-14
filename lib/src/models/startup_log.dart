import 'package:freezed_annotation/freezed_annotation.dart';

part 'startup_log.freezed.dart';

/// One line emitted by the Privileged Server startup pipeline.
///
/// Mirrors `priv.kit.core.PrivilegeStartupLogLine`.
@freezed
abstract class PrivStartupLogLine with _$PrivStartupLogLine {
  const factory PrivStartupLogLine({
    /// Component that produced the line, for example `runtime` or `adb`.
    required String source,

    /// Human readable diagnostic text.
    required String message,

    /// Wall-clock time of the line, in milliseconds since the Unix epoch.
    ///
    /// The platform channel carries this under the key `ctime`.
    required int timestampMillis,

    /// Identifier of the start operation that produced the line, when known.
    String? operationId,
  }) = _PrivStartupLogLine;

  const PrivStartupLogLine._();

  /// Decodes the map sent by the Android side.
  factory PrivStartupLogLine.fromMap(Map<dynamic, dynamic> map) =>
      PrivStartupLogLine(
        source: map['source'] as String,
        message: map['message'] as String,
        timestampMillis: (map['ctime'] as num).toInt(),
        operationId: map['operationId'] as String?,
      );

  /// The line's timestamp as a [DateTime].
  DateTime get timestamp =>
      DateTime.fromMillisecondsSinceEpoch(timestampMillis);
}
