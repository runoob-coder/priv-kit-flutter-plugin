import 'package:freezed_annotation/freezed_annotation.dart';

part 'adb.freezed.dart';

/// Default static ADB TCP port used by Priv Kit.
///
/// Mirrors `priv.kit.core.adb.PRIVILEGE_ADB_DEFAULT_TCP_PORT`.
const int privilegeAdbDefaultTcpPort = 5555;

/// How the runtime may manage the Wireless Debugging setting while starting.
///
/// Mirrors `priv.kit.core.adb.PrivilegeAdbWirelessDebuggingControl`.
enum PrivAdbWirelessDebuggingControl {
  /// Leave the Wireless Debugging setting untouched.
  never('NEVER'),

  /// Temporarily enable Wireless Debugging when the app can manage it.
  ifAvailable('IF_AVAILABLE'),

  /// Require that Wireless Debugging can be managed before starting.
  require('REQUIRE');

  const PrivAdbWirelessDebuggingControl(this.wireName);

  /// Name used on the platform channel.
  final String wireName;
}

/// Connection options for an ADB start.
///
/// Mirrors `priv.kit.core.adb.PrivilegeAdbConnectionOptions`.
@freezed
abstract class PrivAdbConnectionOptions with _$PrivAdbConnectionOptions {
  // Invariants of `PrivilegeAdbConnectionOptions` on the native side.
  @Assert('portDiscoveryTimeoutMillis > 0')
  @Assert('connectRetryCount > 0')
  @Assert('connectRetryDelayMillis >= 0')
  const factory PrivAdbConnectionOptions({
    /// ADB connect port. `null` discovers the Wireless Debugging connect port.
    int? port,
    @Default(PrivAdbWirelessDebuggingControl.ifAvailable)
    PrivAdbWirelessDebuggingControl wirelessDebuggingControl,
    @Default(true) bool disableWirelessDebuggingAfterUse,
    @Default(15000) int portDiscoveryTimeoutMillis,
    @Default(5) int connectRetryCount,
    @Default(1000) int connectRetryDelayMillis,
  }) = _PrivAdbConnectionOptions;

  const PrivAdbConnectionOptions._();

  /// Encodes the options for the Android side.
  Map<String, Object?> toMap() => <String, Object?>{
    'port': port,
    'wirelessDebuggingControl': wirelessDebuggingControl.wireName,
    'disableWirelessDebuggingAfterUse': disableWirelessDebuggingAfterUse,
    'portDiscoveryTimeoutMillis': portDiscoveryTimeoutMillis,
    'connectRetryCount': connectRetryCount,
    'connectRetryDelayMillis': connectRetryDelayMillis,
  };
}

/// ADB identity of this app, including the public key fingerprint.
@freezed
abstract class PrivAdbIdentityInfo with _$PrivAdbIdentityInfo {
  const factory PrivAdbIdentityInfo({
    required String deviceName,
    required String publicKeyFingerprint,
  }) = _PrivAdbIdentityInfo;

  const PrivAdbIdentityInfo._();

  factory PrivAdbIdentityInfo.fromMap(Map<dynamic, dynamic> map) =>
      PrivAdbIdentityInfo(
        deviceName: map['deviceName'] as String,
        publicKeyFingerprint: map['publicKeyFingerprint'] as String,
      );
}

/// Outcome of a Wireless Debugging pairing attempt.
@freezed
abstract class PrivAdbPairingResult with _$PrivAdbPairingResult {
  const factory PrivAdbPairingResult({
    required int port,
    required String deviceName,
    required String publicKeyFingerprint,
  }) = _PrivAdbPairingResult;

  const PrivAdbPairingResult._();

  factory PrivAdbPairingResult.fromMap(Map<dynamic, dynamic> map) =>
      PrivAdbPairingResult(
        port: (map['port'] as num).toInt(),
        deviceName: map['deviceName'] as String,
        publicKeyFingerprint: map['publicKeyFingerprint'] as String,
      );
}

/// Status of a pairing check.
enum PrivAdbPairingCheckStatus {
  paired('PAIRED'),
  unpaired('UNPAIRED'),
  unavailable('UNAVAILABLE'),
  error('ERROR');

  const PrivAdbPairingCheckStatus(this.wireName);

  /// Name used on the platform channel.
  final String wireName;

  /// Decodes the name sent by the Android side.
  ///
  /// Unknown or missing values fall back to [error], so a newer platform that
  /// adds a state does not break older clients.
  static PrivAdbPairingCheckStatus fromWireName(String? name) =>
      values.firstWhere((e) => e.wireName == name, orElse: () => error);
}

/// Outcome of a pairing-state check.
@freezed
abstract class PrivAdbPairingCheckResult with _$PrivAdbPairingCheckResult {
  const factory PrivAdbPairingCheckResult({
    int? port,

    /// Whether the app's saved ADB key has been authorized on the device.
    @Default(false) bool paired,
    @Default('') String outputText,
    @Default('') String deviceName,
    @Default('') String publicKeyFingerprint,
    required PrivAdbPairingCheckStatus status,
    String? failureMessage,
  }) = _PrivAdbPairingCheckResult;

  const PrivAdbPairingCheckResult._();

  factory PrivAdbPairingCheckResult.fromMap(Map<dynamic, dynamic> map) =>
      PrivAdbPairingCheckResult(
        port: map['port'] == null ? null : (map['port'] as num).toInt(),
        paired: map['paired'] as bool? ?? false,
        outputText: map['outputText'] as String? ?? '',
        deviceName: map['deviceName'] as String? ?? '',
        publicKeyFingerprint: map['publicKeyFingerprint'] as String? ?? '',
        status: PrivAdbPairingCheckStatus.fromWireName(
          map['status'] as String?,
        ),
        failureMessage: map['failureMessage'] as String?,
      );
}

/// Authorization state of an ADB connection.
enum PrivAdbAuthorizationStatus {
  authorized('AUTHORIZED'),
  unauthorized('UNAUTHORIZED'),
  unavailable('UNAVAILABLE'),
  error('ERROR');

  const PrivAdbAuthorizationStatus(this.wireName);

  /// Name used on the platform channel.
  final String wireName;

  /// Decodes the name sent by the Android side.
  static PrivAdbAuthorizationStatus fromWireName(String? name) =>
      values.firstWhere((e) => e.wireName == name, orElse: () => error);
}

/// Outcome of an ADB authorization check.
@freezed
abstract class PrivAdbAuthorizationCheckResult
    with _$PrivAdbAuthorizationCheckResult {
  const factory PrivAdbAuthorizationCheckResult({
    required PrivAdbAuthorizationStatus status,
    @Default('') String outputText,
    @Default('') String deviceName,
    @Default('') String publicKeyFingerprint,
    String? failureMessage,
  }) = _PrivAdbAuthorizationCheckResult;

  const PrivAdbAuthorizationCheckResult._();

  factory PrivAdbAuthorizationCheckResult.fromMap(Map<dynamic, dynamic> map) =>
      PrivAdbAuthorizationCheckResult(
        status: PrivAdbAuthorizationStatus.fromWireName(
          map['status'] as String?,
        ),
        outputText: map['outputText'] as String? ?? '',
        deviceName: map['deviceName'] as String? ?? '',
        publicKeyFingerprint: map['publicKeyFingerprint'] as String? ?? '',
        failureMessage: map['failureMessage'] as String?,
      );

  /// Whether the ADB key is authorized on this endpoint.
  bool get isAuthorized => status == PrivAdbAuthorizationStatus.authorized;
}

/// Why an authorization request ended.
enum PrivAdbAuthorizationEndReason {
  automaticTimeout('AUTOMATIC_TIMEOUT'),
  failed('FAILED');

  const PrivAdbAuthorizationEndReason(this.wireName);

  /// Name used on the platform channel.
  final String wireName;

  /// Decodes the name sent by the Android side.
  ///
  /// Returns `null` when the request is still pending or ended normally.
  static PrivAdbAuthorizationEndReason? fromWireName(String? name) {
    for (final value in values) {
      if (value.wireName == name) return value;
    }
    return null;
  }
}

/// Outcome of an interactive ADB authorization request.
@freezed
abstract class PrivAdbAuthorizationRequestResult
    with _$PrivAdbAuthorizationRequestResult {
  const factory PrivAdbAuthorizationRequestResult({
    @Default(false) bool authorized,
    @Default('') String outputText,
    PrivAdbAuthorizationEndReason? endReason,
    String? failureMessage,
  }) = _PrivAdbAuthorizationRequestResult;

  const PrivAdbAuthorizationRequestResult._();

  factory PrivAdbAuthorizationRequestResult.fromMap(
    Map<dynamic, dynamic> map,
  ) => PrivAdbAuthorizationRequestResult(
    authorized: map['authorized'] as bool? ?? false,
    outputText: map['outputText'] as String? ?? '',
    endReason: PrivAdbAuthorizationEndReason.fromWireName(
      map['endReason'] as String?,
    ),
    failureMessage: map['failureMessage'] as String?,
  );
}

/// Outcome of an ADB TCP control command (`adb tcpip`, stop, restart).
@freezed
abstract class PrivAdbTcpResult with _$PrivAdbTcpResult {
  const factory PrivAdbTcpResult({
    required int port,
    @Default('') String outputText,
    @Default('') String deviceName,
    @Default('') String publicKeyFingerprint,
  }) = _PrivAdbTcpResult;

  const PrivAdbTcpResult._();

  factory PrivAdbTcpResult.fromMap(Map<dynamic, dynamic> map) =>
      PrivAdbTcpResult(
        port: (map['port'] as num).toInt(),
        outputText: map['outputText'] as String? ?? '',
        deviceName: map['deviceName'] as String? ?? '',
        publicKeyFingerprint: map['publicKeyFingerprint'] as String? ?? '',
      );
}

/// Capability snapshot for managing Wireless Debugging.
@freezed
abstract class PrivAdbWirelessDebuggingControlStatus
    with _$PrivAdbWirelessDebuggingControlStatus {
  const factory PrivAdbWirelessDebuggingControlStatus({
    @Default(false) bool supported,

    /// Whether `WRITE_SECURE_SETTINGS` is declared in the manifest.
    @Default(false) bool permissionDeclared,

    /// Whether `WRITE_SECURE_SETTINGS` has actually been granted.
    @Default(false) bool permissionGranted,
    @Default(false) bool wirelessDebuggingEnabled,

    /// Whether the runtime can toggle Wireless Debugging on this device.
    @Default(false) bool canManage,
    String? failureMessage,
  }) = _PrivAdbWirelessDebuggingControlStatus;

  const PrivAdbWirelessDebuggingControlStatus._();

  factory PrivAdbWirelessDebuggingControlStatus.fromMap(
    Map<dynamic, dynamic> map,
  ) => PrivAdbWirelessDebuggingControlStatus(
    supported: map['supported'] as bool? ?? false,
    permissionDeclared: map['permissionDeclared'] as bool? ?? false,
    permissionGranted: map['permissionGranted'] as bool? ?? false,
    wirelessDebuggingEnabled: map['wirelessDebuggingEnabled'] as bool? ?? false,
    canManage: map['canManage'] as bool? ?? false,
    failureMessage: map['failureMessage'] as String?,
  );
}
