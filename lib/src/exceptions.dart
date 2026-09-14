import 'package:flutter/services.dart';

/// Error codes reported by the Android implementation.
abstract final class PrivKitErrorCode {
  /// `priv.kit.core.PrivilegeStartupException`: the server could not be started.
  static const String startup = 'STARTUP_ERROR';

  /// The Privileged Server Binder is missing or has died.
  static const String serverUnavailable = 'SERVER_UNAVAILABLE';

  /// A privileged command could not be started or completed.
  static const String command = 'COMMAND_ERROR';

  /// The command exceeded its execution timeout.
  static const String commandTimeout = 'COMMAND_TIMEOUT';

  /// An argument failed validation inside priv-core.
  static const String invalidArgument = 'INVALID_ARGUMENT';

  /// priv-core rejected the call for the current state.
  static const String illegalState = 'ILLEGAL_STATE';

  /// A required Android permission is missing.
  static const String security = 'SECURITY_ERROR';

  /// The start operation was cancelled through [PrivKitErrorCode.cancelled].
  static const String cancelled = 'CANCELLED';

  /// The call requires a newer Android version.
  static const String unsupportedApi = 'UNSUPPORTED_API';

  /// An ADB session or external-startup bridge handle is unknown.
  static const String notFound = 'NOT_FOUND';

  /// Any other native failure.
  static const String native = 'NATIVE_ERROR';
}

/// A typed error raised by the `priv_kit` plugin.
class PrivKitException implements Exception {
  const PrivKitException({required this.code, this.message, this.details});

  /// One of the [PrivKitErrorCode] values.
  final String code;

  /// Message reported by priv-core, when available.
  final String? message;

  /// Extra diagnostics, usually the underlying throwable description.
  final Object? details;

  /// Wraps a [PlatformException] coming from the method channel.
  factory PrivKitException.fromPlatformException(PlatformException e) =>
      PrivKitException(code: e.code, message: e.message, details: e.details);

  @override
  String toString() => 'PrivKitException($code): ${message ?? '<no message>'}';
}
