import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.freezed.dart';

/// Default time the server stays alive while waiting for the owner to
/// reconnect: 10 minutes.
const int privilegeDefaultFollowDeathDelayMillis = 10 * 60 * 1000;

/// Default for [PrivRuntimeConfig.activeReconnectOnOwnerDeath].
const bool privilegeDefaultActiveReconnectOnOwnerDeath = false;

/// Owner-death reconnect policy, mirroring `priv.kit.core.PrivilegeConfig`.
///
/// Changes are pushed to the connected server and apply to the **next** owner
/// death. A reconnect flow that has already started keeps the values it
/// captured when the owner died.
@freezed
abstract class PrivRuntimeConfig with _$PrivRuntimeConfig {
  const factory PrivRuntimeConfig({
    required int followDeathDelayMillis,
    required bool activeReconnectOnOwnerDeath,
  }) = _PrivRuntimeConfig;

  const PrivRuntimeConfig._();

  /// Decodes the map sent by the Android side.
  factory PrivRuntimeConfig.fromMap(Map<dynamic, dynamic> map) =>
      PrivRuntimeConfig(
        followDeathDelayMillis:
            (map['followDeathDelayMillis'] as num?)?.toInt() ??
            privilegeDefaultFollowDeathDelayMillis,
        activeReconnectOnOwnerDeath:
            map['activeReconnectOnOwnerDeath'] as bool? ??
            privilegeDefaultActiveReconnectOnOwnerDeath,
      );

  /// Encodes the configuration for the Android side.
  Map<String, Object?> toMap() => <String, Object?>{
    'followDeathDelayMillis': followDeathDelayMillis,
    'activeReconnectOnOwnerDeath': activeReconnectOnOwnerDeath,
  };

  /// How long the server waits for the owner process to reconnect.
  Duration get followDeathDelay =>
      Duration(milliseconds: followDeathDelayMillis);

  /// Whether the configuration still has its upstream defaults.
  bool get isDefault =>
      followDeathDelayMillis == privilegeDefaultFollowDeathDelayMillis &&
      activeReconnectOnOwnerDeath ==
          privilegeDefaultActiveReconnectOnOwnerDeath;
}
