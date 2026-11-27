import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_service.freezed.dart';

/// Where a UserService runs, mirroring `PrivilegeUserServiceProcess`.
class PrivUserServiceProcess {
  const PrivUserServiceProcess._(this.wireName, this.uid);

  /// Dedicated process inheriting the server UID.
  static const inherit = PrivUserServiceProcess._('INHERIT', -2);

  /// Privileged Server process (default).
  static const embedded = PrivUserServiceProcess._('EMBEDDED', -1);

  /// Dedicated root process.
  static const root = PrivUserServiceProcess._('ROOT', 0);

  /// Dedicated system process (UID 1000).
  static const system = PrivUserServiceProcess._('SYSTEM', 1000);

  /// Dedicated shell process (UID 2000).
  static const shell = PrivUserServiceProcess._('SHELL', 2000);

  static const List<PrivUserServiceProcess> values = <PrivUserServiceProcess>[
    inherit,
    embedded,
    root,
    system,
    shell,
  ];

  /// Name sent to priv-core.
  final String wireName;

  /// Requested UID; changing it keeps the server's SELinux domain.
  final int uid;

  bool get isEmbedded => this == embedded;

  @override
  String toString() => 'PrivUserServiceProcess.$wireName';
}

/// Identifies one UserService instance, mirroring `PrivilegeUserServiceSpec`.
@freezed
abstract class PrivUserServiceSpec with _$PrivUserServiceSpec {
  const factory PrivUserServiceSpec({
    /// Omit for priv-core's built-in Binder forwarding service.
    String? serviceClassName,

    /// Separates instances of the same class.
    String? tag,

    /// Where the service runs.
    @Default(PrivUserServiceProcess.embedded) PrivUserServiceProcess process,
  }) = _PrivUserServiceSpec;

  const PrivUserServiceSpec._();

  /// Encodes the spec for the Android side.
  Map<String, Object?> toMap() => <String, Object?>{
    'serviceClassName': serviceClassName,
    'tag': tag,
    'process': process.wireName,
  };
}
