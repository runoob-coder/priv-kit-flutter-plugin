// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrivServerInfo {

/// UID of the Privileged Server process.
 int get uid;/// PID of the Privileged Server process.
 int get pid;/// Wire protocol version reported by the connected server.
 int get protocolVersion;/// Opaque SELinux context of the server process, when provided.
///
/// This is a diagnostic value only, never an authorization decision.
 String? get selinuxContext;
/// Create a copy of PrivServerInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivServerInfoCopyWith<PrivServerInfo> get copyWith => _$PrivServerInfoCopyWithImpl<PrivServerInfo>(this as PrivServerInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivServerInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivServerInfo&&(identical(other.uid, _this.uid) || other.uid == _this.uid)&&(identical(other.pid, _this.pid) || other.pid == _this.pid)&&(identical(other.protocolVersion, _this.protocolVersion) || other.protocolVersion == _this.protocolVersion)&&(identical(other.selinuxContext, _this.selinuxContext) || other.selinuxContext == _this.selinuxContext));
}


@override
int get hashCode {
  final _this = this as PrivServerInfo;
  return Object.hash(runtimeType,_this.uid,_this.pid,_this.protocolVersion,_this.selinuxContext);
}

@override
String toString() {
  final _this = this as PrivServerInfo;
  return 'PrivServerInfo(uid: ${_this.uid}, pid: ${_this.pid}, protocolVersion: ${_this.protocolVersion}, selinuxContext: ${_this.selinuxContext})';
}


}

/// @nodoc
abstract mixin class $PrivServerInfoCopyWith<$Res>  {
  factory $PrivServerInfoCopyWith(PrivServerInfo value, $Res Function(PrivServerInfo) _then) = _$PrivServerInfoCopyWithImpl;
@useResult
$Res call({
 int uid, int pid, int protocolVersion, String? selinuxContext
});




}
/// @nodoc
class _$PrivServerInfoCopyWithImpl<$Res>
    implements $PrivServerInfoCopyWith<$Res> {
  _$PrivServerInfoCopyWithImpl(this._self, this._then);

  final PrivServerInfo _self;
  final $Res Function(PrivServerInfo) _then;

/// Create a copy of PrivServerInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? pid = null,Object? protocolVersion = null,Object? selinuxContext = freezed,}) {
  return _then(PrivServerInfo(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as int,pid: null == pid ? _self.pid : pid // ignore: cast_nullable_to_non_nullable
as int,protocolVersion: null == protocolVersion ? _self.protocolVersion : protocolVersion // ignore: cast_nullable_to_non_nullable
as int,selinuxContext: freezed == selinuxContext ? _self.selinuxContext : selinuxContext // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivServerInfo].
extension PrivServerInfoPatterns on PrivServerInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivServerInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivServerInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivServerInfo value)  $default,){
final _that = this;
switch (_that) {
case _PrivServerInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivServerInfo value)?  $default,){
final _that = this;
switch (_that) {
case _PrivServerInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int uid,  int pid,  int protocolVersion,  String? selinuxContext)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivServerInfo() when $default != null:
return $default(_that.uid,_that.pid,_that.protocolVersion,_that.selinuxContext);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int uid,  int pid,  int protocolVersion,  String? selinuxContext)  $default,) {final _that = this;
switch (_that) {
case _PrivServerInfo():
return $default(_that.uid,_that.pid,_that.protocolVersion,_that.selinuxContext);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int uid,  int pid,  int protocolVersion,  String? selinuxContext)?  $default,) {final _that = this;
switch (_that) {
case _PrivServerInfo() when $default != null:
return $default(_that.uid,_that.pid,_that.protocolVersion,_that.selinuxContext);case _:
  return null;

}
}

}

/// @nodoc


class _PrivServerInfo extends PrivServerInfo {
  const _PrivServerInfo({required this.uid, required this.pid, required this.protocolVersion, this.selinuxContext}): super._();
  

/// UID of the Privileged Server process.
@override final  int uid;
/// PID of the Privileged Server process.
@override final  int pid;
/// Wire protocol version reported by the connected server.
@override final  int protocolVersion;
/// Opaque SELinux context of the server process, when provided.
///
/// This is a diagnostic value only, never an authorization decision.
@override final  String? selinuxContext;

/// Create a copy of PrivServerInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivServerInfoCopyWith<_PrivServerInfo> get copyWith => __$PrivServerInfoCopyWithImpl<_PrivServerInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivServerInfo&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.pid, pid) || other.pid == pid)&&(identical(other.protocolVersion, protocolVersion) || other.protocolVersion == protocolVersion)&&(identical(other.selinuxContext, selinuxContext) || other.selinuxContext == selinuxContext));
}


@override
int get hashCode {
    return Object.hash(runtimeType,uid,pid,protocolVersion,selinuxContext);
}

@override
String toString() {
    return 'PrivServerInfo(uid: $uid, pid: $pid, protocolVersion: $protocolVersion, selinuxContext: $selinuxContext)';
}


}

/// @nodoc
abstract mixin class _$PrivServerInfoCopyWith<$Res> implements $PrivServerInfoCopyWith<$Res> {
  factory _$PrivServerInfoCopyWith(_PrivServerInfo value, $Res Function(_PrivServerInfo) _then) = __$PrivServerInfoCopyWithImpl;
@override @useResult
$Res call({
 int uid, int pid, int protocolVersion, String? selinuxContext
});




}
/// @nodoc
class __$PrivServerInfoCopyWithImpl<$Res>
    implements _$PrivServerInfoCopyWith<$Res> {
  __$PrivServerInfoCopyWithImpl(this._self, this._then);

  final _PrivServerInfo _self;
  final $Res Function(_PrivServerInfo) _then;

/// Create a copy of PrivServerInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? pid = null,Object? protocolVersion = null,Object? selinuxContext = freezed,}) {
  return _then(_PrivServerInfo(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as int,pid: null == pid ? _self.pid : pid // ignore: cast_nullable_to_non_nullable
as int,protocolVersion: null == protocolVersion ? _self.protocolVersion : protocolVersion // ignore: cast_nullable_to_non_nullable
as int,selinuxContext: freezed == selinuxContext ? _self.selinuxContext : selinuxContext // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
