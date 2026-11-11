// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrivRuntimeConfig {

 int get followDeathDelayMillis; bool get activeReconnectOnOwnerDeath;/// Existing absolute crash-report directories, in write order. priv-core
/// stops at the first successful write; empty means fallback only.
 List<String> get crashLogDirectories;
/// Create a copy of PrivRuntimeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivRuntimeConfigCopyWith<PrivRuntimeConfig> get copyWith => _$PrivRuntimeConfigCopyWithImpl<PrivRuntimeConfig>(this as PrivRuntimeConfig, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivRuntimeConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivRuntimeConfig&&(identical(other.followDeathDelayMillis, _this.followDeathDelayMillis) || other.followDeathDelayMillis == _this.followDeathDelayMillis)&&(identical(other.activeReconnectOnOwnerDeath, _this.activeReconnectOnOwnerDeath) || other.activeReconnectOnOwnerDeath == _this.activeReconnectOnOwnerDeath)&&const DeepCollectionEquality().equals(other.crashLogDirectories, _this.crashLogDirectories));
}


@override
int get hashCode {
  final _this = this as PrivRuntimeConfig;
  return Object.hash(runtimeType,_this.followDeathDelayMillis,_this.activeReconnectOnOwnerDeath,const DeepCollectionEquality().hash(_this.crashLogDirectories));
}

@override
String toString() {
  final _this = this as PrivRuntimeConfig;
  return 'PrivRuntimeConfig(followDeathDelayMillis: ${_this.followDeathDelayMillis}, activeReconnectOnOwnerDeath: ${_this.activeReconnectOnOwnerDeath}, crashLogDirectories: ${_this.crashLogDirectories})';
}


}

/// @nodoc
abstract mixin class $PrivRuntimeConfigCopyWith<$Res>  {
  factory $PrivRuntimeConfigCopyWith(PrivRuntimeConfig value, $Res Function(PrivRuntimeConfig) _then) = _$PrivRuntimeConfigCopyWithImpl;
@useResult
$Res call({
 int followDeathDelayMillis, bool activeReconnectOnOwnerDeath, List<String> crashLogDirectories
});




}
/// @nodoc
class _$PrivRuntimeConfigCopyWithImpl<$Res>
    implements $PrivRuntimeConfigCopyWith<$Res> {
  _$PrivRuntimeConfigCopyWithImpl(this._self, this._then);

  final PrivRuntimeConfig _self;
  final $Res Function(PrivRuntimeConfig) _then;

/// Create a copy of PrivRuntimeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? followDeathDelayMillis = null,Object? activeReconnectOnOwnerDeath = null,Object? crashLogDirectories = null,}) {
  return _then(PrivRuntimeConfig(
followDeathDelayMillis: null == followDeathDelayMillis ? _self.followDeathDelayMillis : followDeathDelayMillis // ignore: cast_nullable_to_non_nullable
as int,activeReconnectOnOwnerDeath: null == activeReconnectOnOwnerDeath ? _self.activeReconnectOnOwnerDeath : activeReconnectOnOwnerDeath // ignore: cast_nullable_to_non_nullable
as bool,crashLogDirectories: null == crashLogDirectories ? _self.crashLogDirectories : crashLogDirectories // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivRuntimeConfig].
extension PrivRuntimeConfigPatterns on PrivRuntimeConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivRuntimeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivRuntimeConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivRuntimeConfig value)  $default,){
final _that = this;
switch (_that) {
case _PrivRuntimeConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivRuntimeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _PrivRuntimeConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int followDeathDelayMillis,  bool activeReconnectOnOwnerDeath,  List<String> crashLogDirectories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivRuntimeConfig() when $default != null:
return $default(_that.followDeathDelayMillis,_that.activeReconnectOnOwnerDeath,_that.crashLogDirectories);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int followDeathDelayMillis,  bool activeReconnectOnOwnerDeath,  List<String> crashLogDirectories)  $default,) {final _that = this;
switch (_that) {
case _PrivRuntimeConfig():
return $default(_that.followDeathDelayMillis,_that.activeReconnectOnOwnerDeath,_that.crashLogDirectories);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int followDeathDelayMillis,  bool activeReconnectOnOwnerDeath,  List<String> crashLogDirectories)?  $default,) {final _that = this;
switch (_that) {
case _PrivRuntimeConfig() when $default != null:
return $default(_that.followDeathDelayMillis,_that.activeReconnectOnOwnerDeath,_that.crashLogDirectories);case _:
  return null;

}
}

}

/// @nodoc


class _PrivRuntimeConfig extends PrivRuntimeConfig {
  const _PrivRuntimeConfig({required this.followDeathDelayMillis, required this.activeReconnectOnOwnerDeath,  List<String> crashLogDirectories = const <String>[]}): _crashLogDirectories = crashLogDirectories,super._();
  

@override final  int followDeathDelayMillis;
@override final  bool activeReconnectOnOwnerDeath;
/// Existing absolute crash-report directories, in write order. priv-core
/// stops at the first successful write; empty means fallback only.
 final  List<String> _crashLogDirectories;
/// Existing absolute crash-report directories, in write order. priv-core
/// stops at the first successful write; empty means fallback only.
@override@JsonKey() List<String> get crashLogDirectories {
  if (_crashLogDirectories is EqualUnmodifiableListView) return _crashLogDirectories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_crashLogDirectories);
}


/// Create a copy of PrivRuntimeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivRuntimeConfigCopyWith<_PrivRuntimeConfig> get copyWith => __$PrivRuntimeConfigCopyWithImpl<_PrivRuntimeConfig>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivRuntimeConfig&&(identical(other.followDeathDelayMillis, followDeathDelayMillis) || other.followDeathDelayMillis == followDeathDelayMillis)&&(identical(other.activeReconnectOnOwnerDeath, activeReconnectOnOwnerDeath) || other.activeReconnectOnOwnerDeath == activeReconnectOnOwnerDeath)&&const DeepCollectionEquality().equals(other.crashLogDirectories, _crashLogDirectories));
}


@override
int get hashCode {
    return Object.hash(runtimeType,followDeathDelayMillis,activeReconnectOnOwnerDeath,const DeepCollectionEquality().hash(_crashLogDirectories));
}

@override
String toString() {
    return 'PrivRuntimeConfig(followDeathDelayMillis: $followDeathDelayMillis, activeReconnectOnOwnerDeath: $activeReconnectOnOwnerDeath, crashLogDirectories: $crashLogDirectories)';
}


}

/// @nodoc
abstract mixin class _$PrivRuntimeConfigCopyWith<$Res> implements $PrivRuntimeConfigCopyWith<$Res> {
  factory _$PrivRuntimeConfigCopyWith(_PrivRuntimeConfig value, $Res Function(_PrivRuntimeConfig) _then) = __$PrivRuntimeConfigCopyWithImpl;
@override @useResult
$Res call({
 int followDeathDelayMillis, bool activeReconnectOnOwnerDeath, List<String> crashLogDirectories
});




}
/// @nodoc
class __$PrivRuntimeConfigCopyWithImpl<$Res>
    implements _$PrivRuntimeConfigCopyWith<$Res> {
  __$PrivRuntimeConfigCopyWithImpl(this._self, this._then);

  final _PrivRuntimeConfig _self;
  final $Res Function(_PrivRuntimeConfig) _then;

/// Create a copy of PrivRuntimeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? followDeathDelayMillis = null,Object? activeReconnectOnOwnerDeath = null,Object? crashLogDirectories = null,}) {
  return _then(_PrivRuntimeConfig(
followDeathDelayMillis: null == followDeathDelayMillis ? _self.followDeathDelayMillis : followDeathDelayMillis // ignore: cast_nullable_to_non_nullable
as int,activeReconnectOnOwnerDeath: null == activeReconnectOnOwnerDeath ? _self.activeReconnectOnOwnerDeath : activeReconnectOnOwnerDeath // ignore: cast_nullable_to_non_nullable
as bool,crashLogDirectories: null == crashLogDirectories ? _self._crashLogDirectories : crashLogDirectories // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
