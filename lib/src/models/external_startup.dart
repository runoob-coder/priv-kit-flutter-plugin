import 'package:freezed_annotation/freezed_annotation.dart';

part 'external_startup.freezed.dart';

/// Options for running the native starter command in the current process.
///
/// Mirrors `priv.kit.core.PrivilegeExternalStartupOptions`.
@freezed
abstract class PrivExternalStartupOptions with _$PrivExternalStartupOptions {
  const factory PrivExternalStartupOptions({
    @Default('/system/bin/sh') String shellPath,
    @Default(2000) int timeoutMillis,
    @Default(80) int maxCapturedLines,
  }) = _PrivExternalStartupOptions;

  const PrivExternalStartupOptions._();

  /// Encodes the options for the Android side.
  Map<String, Object?> toMap() => <String, Object?>{
    'shellPath': shellPath,
    'timeoutMillis': timeoutMillis,
    'maxCapturedLines': maxCapturedLines,
  };
}

/// Options for running the native starter command through a Binder bridge.
///
/// Mirrors `priv.kit.core.PrivilegeExternalStartupBridgeOptions`.
@freezed
abstract class PrivExternalStartupBridgeOptions
    with _$PrivExternalStartupBridgeOptions {
  const factory PrivExternalStartupBridgeOptions({
    @Default(10000) int timeoutMillis,
    @Default(80) int maxCapturedLines,

    /// Prefix prepended to every log source reported by the remote bridge.
    String? sourcePrefix,
  }) = _PrivExternalStartupBridgeOptions;

  const PrivExternalStartupBridgeOptions._();

  /// Encodes the options for the Android side.
  Map<String, Object?> toMap() => <String, Object?>{
    'timeoutMillis': timeoutMillis,
    'maxCapturedLines': maxCapturedLines,
    'sourcePrefix': sourcePrefix,
  };
}
