import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_service.freezed.dart';

/// Default instance tag used by `PrivilegeUserServiceSpec`.
const String privilegeUserServiceDefaultTag = 'default';

/// Identifies one instance of an app-defined UserService.
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
    required String serviceClassName,

    /// Distinguishes several instances of the same class.
    @Default(privilegeUserServiceDefaultTag) String tag,

    /// Compatibility marker; change it to replace a running instance.
    @Default(1) int version,

    /// When true the service runs inside the Privileged Server process instead
    /// of a dedicated child process.
    @Default(false) bool embedded,

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
    'embedded': embedded,
    'daemon': daemon,
  };
}
