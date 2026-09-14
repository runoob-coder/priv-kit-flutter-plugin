import 'dart:convert';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'command.freezed.dart';

/// Default execution timeout, in milliseconds, counted from the moment the
/// remote process starts. New output does not reset the countdown.
const int privilegeCommandDefaultTimeoutMillis = 30000;

/// Pass as `timeoutMillis` to disable the execution deadline entirely.
const int noCommandTimeout = -1;

/// Default per-stream capture limit of [PrivCommandResult], 1 MiB.
const int privilegeCommandDefaultMaxBytesPerStream = 1024 * 1024;

/// Describes a non-interactive process to start in the connected server.
///
/// The command executes [arguments] directly. No shell is added implicitly, so
/// pass `['/system/bin/sh', '-c', script]` when shell parsing is needed.
///
/// This class is written by hand rather than generated, because it validates
/// its input at construction time and exposes unmodifiable collections. Both
/// behaviours are part of its contract: the checks reject values that the
/// native runtime would otherwise reject later with a less useful error.
class PrivCommand {
  PrivCommand({
    required List<String> arguments,
    Map<String, String> environment = const <String, String>{},
    this.workingDirectory,
  }) : arguments = List<String>.unmodifiable(arguments),
       environment = Map<String, String>.unmodifiable(environment) {
    if (arguments.isEmpty) {
      throw ArgumentError.value(arguments, 'arguments', 'must not be empty');
    }
    if (arguments.first.trim().isEmpty) {
      throw ArgumentError.value(
        arguments.first,
        'executable',
        'must not be blank',
      );
    }
    if (arguments.any((a) => a.contains('\u0000'))) {
      throw ArgumentError.value(
        arguments,
        'arguments',
        'must not contain NUL characters',
      );
    }
    for (final key in environment.keys) {
      if (key.isEmpty || key.contains('=') || key.contains('\u0000')) {
        throw ArgumentError.value(
          key,
          'environment key',
          'must be non-empty and must not contain "=" or NUL',
        );
      }
    }
    if (environment.values.any((v) => v.contains('\u0000'))) {
      throw ArgumentError.value(
        environment,
        'environment',
        'values must not contain NUL characters',
      );
    }
    final directory = workingDirectory;
    if (directory != null && !directory.startsWith('/')) {
      throw ArgumentError.value(
        directory,
        'workingDirectory',
        'must be absolute',
      );
    }
  }

  /// Executable plus its arguments. The first entry is the executable.
  final List<String> arguments;

  /// Extra environment variables merged into the server process environment.
  final Map<String, String> environment;

  /// Absolute working directory, or `null` to inherit the server's.
  final String? workingDirectory;

  /// Encodes the command for the Android side.
  Map<String, Object?> toMap() => <String, Object?>{
    'arguments': arguments,
    'environment': environment,
    'workingDirectory': workingDirectory,
  };

  @override
  String toString() =>
      'PrivCommand(arguments: $arguments, '
      'environmentKeys: ${environment.keys}, '
      'workingDirectory: $workingDirectory)';
}

/// Captured output and exit status of a finished command.
///
/// Returned by [PrivKit.runCommand], which drains stdout and stderr
/// concurrently and bounds each capture at `maxBytesPerStream`. Excess bytes
/// are still drained so the process can exit, and the matching `truncated`
/// flag becomes `true`.
@freezed
abstract class PrivCommandResult with _$PrivCommandResult {
  const factory PrivCommandResult({
    /// Process exit code. Non-zero values are normal exits, not errors.
    required int exitCode,

    /// Captured standard output.
    required Uint8List stdout,

    /// Captured standard error.
    required Uint8List stderr,

    /// Whether [stdout] hit the capture limit.
    @Default(false) bool stdoutTruncated,

    /// Whether [stderr] hit the capture limit.
    @Default(false) bool stderrTruncated,
  }) = _PrivCommandResult;

  const PrivCommandResult._();

  /// Decodes the map sent by the Android side.
  factory PrivCommandResult.fromMap(Map<dynamic, dynamic> map) =>
      PrivCommandResult(
        exitCode: (map['exitCode'] as num).toInt(),
        stdout: map['stdout'] as Uint8List? ?? Uint8List(0),
        stderr: map['stderr'] as Uint8List? ?? Uint8List(0),
        stdoutTruncated: map['stdoutTruncated'] as bool? ?? false,
        stderrTruncated: map['stderrTruncated'] as bool? ?? false,
      );

  /// [stdout] decoded as UTF-8, replacing malformed sequences.
  String get stdoutText => _decode(stdout);

  /// [stderr] decoded as UTF-8, replacing malformed sequences.
  String get stderrText => _decode(stderr);

  static String _decode(Uint8List bytes) =>
      utf8.decode(bytes, allowMalformed: true);
}

/// A single event emitted while consuming a command as a stream.
///
/// [PrivCommandExit] is always the last event of a stream, emitted after both
/// output streams have reached EOF.
@freezed
sealed class PrivCommandEvent with _$PrivCommandEvent {
  /// A chunk read from standard output.
  ///
  /// Chunk boundaries are not text boundaries and do not respect UTF-8
  /// character boundaries, so use an incremental decoder when displaying text.
  const factory PrivCommandEvent.stdout({required Uint8List bytes}) =
      PrivCommandStdout;

  /// A chunk read from standard error.
  const factory PrivCommandEvent.stderr({required Uint8List bytes}) =
      PrivCommandStderr;

  /// The final event, emitted after both output streams reach EOF.
  const factory PrivCommandEvent.exit({required int exitCode}) =
      PrivCommandExit;
}

/// Decodes one event received over the command channel.
PrivCommandEvent parseCommandEvent(Map<dynamic, dynamic> map) {
  final data = map['data'] as Uint8List?;
  switch (map['type'] as String?) {
    case 'stdout':
      return PrivCommandEvent.stdout(bytes: data ?? Uint8List(0));
    case 'stderr':
      return PrivCommandEvent.stderr(bytes: data ?? Uint8List(0));
    case 'exit':
      return PrivCommandEvent.exit(
        exitCode: (map['exitCode'] as num?)?.toInt() ?? -1,
      );
    default:
      throw FormatException('Unknown command event: $map');
  }
}
