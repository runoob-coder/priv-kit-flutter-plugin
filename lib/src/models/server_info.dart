import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_info.freezed.dart';

/// Identifies one connected Privileged Server process.
///
/// Mirrors `priv.kit.core.PrivilegeServerInfo` on the Android side. The native
/// `lifecycleBinder` is not transferred across the platform channel because it
/// is only meaningful inside the Android process.
@freezed
abstract class PrivServerInfo with _$PrivServerInfo {
  const factory PrivServerInfo({
    /// UID of the Privileged Server process.
    required int uid,

    /// PID of the Privileged Server process.
    required int pid,

    /// Wire protocol version reported by the connected server.
    required int protocolVersion,

    /// Opaque SELinux context of the server process, when provided.
    ///
    /// This is a diagnostic value only, never an authorization decision.
    String? selinuxContext,
  }) = _PrivServerInfo;

  const PrivServerInfo._();

  /// Decodes the map sent by the Android side.
  ///
  /// Numbers are read through [num] so a platform that hands back a different
  /// numeric subtype still decodes.
  factory PrivServerInfo.fromMap(Map<dynamic, dynamic> map) {
    int intOf(String key) => (map[key] as num).toInt();
    return PrivServerInfo(
      uid: intOf('uid'),
      pid: intOf('pid'),
      protocolVersion: intOf('protocolVersion'),
      selinuxContext: map['selinuxContext'] as String?,
    );
  }

  /// Whether the server runs as root (UID 0).
  bool get isRoot => uid == 0;
}
