import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_service.freezed.dart';

/// Default instance tag used by `PrivilegeUserServiceSpec`.
const String privilegeUserServiceDefaultTag = 'default';

/// UID that runs a UserService inside the Privileged Server process.
const int privilegeUserServiceUidEmbedded = -1;

/// UID of a dedicated UserService process running as root.
const int privilegeUserServiceUidRoot = 0;

/// UID of a dedicated UserService process running as `android` (system).
const int privilegeUserServiceUidSystem = 1000;

/// UID of a dedicated UserService process running as `com.android.shell`.
const int privilegeUserServiceUidShell = 2000;

/// Selects where a UserService runs, and with which UID.
///
/// Mirrors `priv.kit.core.userservice.PrivilegeUserServiceProcess`.
///
/// A null [uid] (the default) starts a dedicated child process that inherits
/// the server's UID. [privilegeUserServiceUidEmbedded] embeds the service in
/// the Privileged Server process. The remaining supported UIDs are root,
/// system and shell.
///
/// Changing the UID does not change the inherited SELinux domain, nor does it
/// turn the process into an Android application process.
class PrivUserServiceProcess {
  const PrivUserServiceProcess._(this.uid);

  /// Creates a process selection, rejecting UIDs priv-core does not support.
  factory PrivUserServiceProcess({int? uid}) {
    if (uid != null &&
        uid != privilegeUserServiceUidEmbedded &&
        uid != privilegeUserServiceUidRoot &&
        uid != privilegeUserServiceUidSystem &&
        uid != privilegeUserServiceUidShell) {
      throw ArgumentError.value(
        uid,
        'uid',
        'must be null, -1 (embedded), 0 (root), 1000 (system) or 2000 (shell)',
      );
    }
    return PrivUserServiceProcess._(uid);
  }

  /// Dedicated child process inheriting the server UID.
  static const PrivUserServiceProcess dedicated = PrivUserServiceProcess._(
    null,
  );

  /// Runs inside the Privileged Server process.
  static const PrivUserServiceProcess embedded = PrivUserServiceProcess._(
    privilegeUserServiceUidEmbedded,
  );

  /// Dedicated process with UID 0 (root).
  static const PrivUserServiceProcess root = PrivUserServiceProcess._(
    privilegeUserServiceUidRoot,
  );

  /// Dedicated process with UID 1000 (`android`).
  static const PrivUserServiceProcess system = PrivUserServiceProcess._(
    privilegeUserServiceUidSystem,
  );

  /// Dedicated process with UID 2000 (`com.android.shell`).
  static const PrivUserServiceProcess shell = PrivUserServiceProcess._(
    privilegeUserServiceUidShell,
  );

  /// Requested UID; `null` means the server UID in a dedicated process.
  final int? uid;

  /// Whether the service shares the Privileged Server process.
  bool get isEmbedded => uid == privilegeUserServiceUidEmbedded;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrivUserServiceProcess && other.uid == uid);

  @override
  int get hashCode => uid.hashCode;

  @override
  String toString() => 'PrivUserServiceProcess(uid: $uid)';
}

/// Identifies one instance of a UserService.
///
/// Mirrors `priv.kit.core.userservice.PrivilegeUserServiceSpec`.
///
/// An instance is identified by [serviceClassName] plus [tag]. Bump [version]
/// when the implementation is no longer compatible, and the runtime replaces
/// the running instance.
@freezed
abstract class PrivUserServiceSpec with _$PrivUserServiceSpec {
  const factory PrivUserServiceSpec({
    /// Fully qualified name of the Kotlin class implementing the AIDL service.
    ///
    /// Omit it to use priv-core's built-in Binder forwarding service, which
    /// needs no app-defined class or business AIDL.
    String? serviceClassName,

    /// Distinguishes several instances of the same class.
    @Default(privilegeUserServiceDefaultTag) String tag,

    /// Compatibility marker; change it to replace a running instance.
    @Default(1) int version,

    /// Where the service runs, and with which UID.
    @Default(PrivUserServiceProcess.dedicated) PrivUserServiceProcess process,

    /// When true the service survives the owner process death until it is
    /// stopped explicitly or the server exits.
    @Default(false) bool daemon,
  }) = _PrivUserServiceSpec;

  const PrivUserServiceSpec._();

  /// Encodes the spec for the Android side.
  Map<String, Object?> toMap() => <String, Object?>{
    'serviceClassName': serviceClassName,
    'tag': tag,
    'version': version,
    'processUid': process.uid,
    'daemon': daemon,
  };
}

/// Identity of a bound UserService connection.
///
/// Mirrors `PrivilegeUserServiceConnection.uid` and
/// `PrivilegeUserServiceConnection.callingPackageName`. The Binder itself never
/// crosses the platform channel, so Dart only holds an integer handle.
@freezed
abstract class PrivUserServiceConnectionInfo
    with _$PrivUserServiceConnectionInfo {
  const factory PrivUserServiceConnectionInfo({
    /// Effective UID of the process hosting the connection.
    required int uid,

    /// Package identity to pass to system calls, when the UID has one.
    String? callingPackageName,
  }) = _PrivUserServiceConnectionInfo;

  const PrivUserServiceConnectionInfo._();

  /// Decodes the map sent by the Android side.
  factory PrivUserServiceConnectionInfo.fromMap(Map<dynamic, dynamic> map) =>
      PrivUserServiceConnectionInfo(
        uid: (map['uid'] as num).toInt(),
        callingPackageName: map['callingPackageName'] as String?,
      );
}
