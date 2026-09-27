// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrivUserServiceSpec {

/// Fully qualified name of the Kotlin class implementing the AIDL service.
 String get serviceClassName;/// Distinguishes several instances of the same class.
 String get tag;/// Compatibility marker; change it to replace a running instance.
 int get version;/// When true the service runs inside the Privileged Server process instead
/// of a dedicated child process.
 bool get embedded;/// When true the service survives the owner process death until it is
/// stopped explicitly or the server exits.
 bool get daemon;
/// Create a copy of PrivUserServiceSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivUserServiceSpecCopyWith<PrivUserServiceSpec> get copyWith => _$PrivUserServiceSpecCopyWithImpl<PrivUserServiceSpec>(this as PrivUserServiceSpec, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivUserServiceSpec;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivUserServiceSpec&&(identical(other.serviceClassName, _this.serviceClassName) || other.serviceClassName == _this.serviceClassName)&&(identical(other.tag, _this.tag) || other.tag == _this.tag)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.embedded, _this.embedded) || other.embedded == _this.embedded)&&(identical(other.daemon, _this.daemon) || other.daemon == _this.daemon));
}


@override
int get hashCode {
  final _this = this as PrivUserServiceSpec;
  return Object.hash(runtimeType,_this.serviceClassName,_this.tag,_this.version,_this.embedded,_this.daemon);
}

@override
String toString() {
  final _this = this as PrivUserServiceSpec;
  return 'PrivUserServiceSpec(serviceClassName: ${_this.serviceClassName}, tag: ${_this.tag}, version: ${_this.version}, embedded: ${_this.embedded}, daemon: ${_this.daemon})';
}


}

/// @nodoc
abstract mixin class $PrivUserServiceSpecCopyWith<$Res>  {
  factory $PrivUserServiceSpecCopyWith(PrivUserServiceSpec value, $Res Function(PrivUserServiceSpec) _then) = _$PrivUserServiceSpecCopyWithImpl;
@useResult
$Res call({
 String serviceClassName, String tag, int version, bool embedded, bool daemon
});




}
/// @nodoc
class _$PrivUserServiceSpecCopyWithImpl<$Res>
    implements $PrivUserServiceSpecCopyWith<$Res> {
  _$PrivUserServiceSpecCopyWithImpl(this._self, this._then);

  final PrivUserServiceSpec _self;
  final $Res Function(PrivUserServiceSpec) _then;

/// Create a copy of PrivUserServiceSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serviceClassName = null,Object? tag = null,Object? version = null,Object? embedded = null,Object? daemon = null,}) {
  return _then(PrivUserServiceSpec(
serviceClassName: null == serviceClassName ? _self.serviceClassName : serviceClassName // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,embedded: null == embedded ? _self.embedded : embedded // ignore: cast_nullable_to_non_nullable
as bool,daemon: null == daemon ? _self.daemon : daemon // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivUserServiceSpec].
extension PrivUserServiceSpecPatterns on PrivUserServiceSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivUserServiceSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivUserServiceSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivUserServiceSpec value)  $default,){
final _that = this;
switch (_that) {
case _PrivUserServiceSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivUserServiceSpec value)?  $default,){
final _that = this;
switch (_that) {
case _PrivUserServiceSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serviceClassName,  String tag,  int version,  bool embedded,  bool daemon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivUserServiceSpec() when $default != null:
return $default(_that.serviceClassName,_that.tag,_that.version,_that.embedded,_that.daemon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serviceClassName,  String tag,  int version,  bool embedded,  bool daemon)  $default,) {final _that = this;
switch (_that) {
case _PrivUserServiceSpec():
return $default(_that.serviceClassName,_that.tag,_that.version,_that.embedded,_that.daemon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serviceClassName,  String tag,  int version,  bool embedded,  bool daemon)?  $default,) {final _that = this;
switch (_that) {
case _PrivUserServiceSpec() when $default != null:
return $default(_that.serviceClassName,_that.tag,_that.version,_that.embedded,_that.daemon);case _:
  return null;

}
}

}

/// @nodoc


class _PrivUserServiceSpec extends PrivUserServiceSpec {
  const _PrivUserServiceSpec({required this.serviceClassName, this.tag = privilegeUserServiceDefaultTag, this.version = 1, this.embedded = false, this.daemon = false}): super._();
  

/// Fully qualified name of the Kotlin class implementing the AIDL service.
@override final  String serviceClassName;
/// Distinguishes several instances of the same class.
@override@JsonKey() final  String tag;
/// Compatibility marker; change it to replace a running instance.
@override@JsonKey() final  int version;
/// When true the service runs inside the Privileged Server process instead
/// of a dedicated child process.
@override@JsonKey() final  bool embedded;
/// When true the service survives the owner process death until it is
/// stopped explicitly or the server exits.
@override@JsonKey() final  bool daemon;

/// Create a copy of PrivUserServiceSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivUserServiceSpecCopyWith<_PrivUserServiceSpec> get copyWith => __$PrivUserServiceSpecCopyWithImpl<_PrivUserServiceSpec>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivUserServiceSpec&&(identical(other.serviceClassName, serviceClassName) || other.serviceClassName == serviceClassName)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.version, version) || other.version == version)&&(identical(other.embedded, embedded) || other.embedded == embedded)&&(identical(other.daemon, daemon) || other.daemon == daemon));
}


@override
int get hashCode {
    return Object.hash(runtimeType,serviceClassName,tag,version,embedded,daemon);
}

@override
String toString() {
    return 'PrivUserServiceSpec(serviceClassName: $serviceClassName, tag: $tag, version: $version, embedded: $embedded, daemon: $daemon)';
}


}

/// @nodoc
abstract mixin class _$PrivUserServiceSpecCopyWith<$Res> implements $PrivUserServiceSpecCopyWith<$Res> {
  factory _$PrivUserServiceSpecCopyWith(_PrivUserServiceSpec value, $Res Function(_PrivUserServiceSpec) _then) = __$PrivUserServiceSpecCopyWithImpl;
@override @useResult
$Res call({
 String serviceClassName, String tag, int version, bool embedded, bool daemon
});




}
/// @nodoc
class __$PrivUserServiceSpecCopyWithImpl<$Res>
    implements _$PrivUserServiceSpecCopyWith<$Res> {
  __$PrivUserServiceSpecCopyWithImpl(this._self, this._then);

  final _PrivUserServiceSpec _self;
  final $Res Function(_PrivUserServiceSpec) _then;

/// Create a copy of PrivUserServiceSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serviceClassName = null,Object? tag = null,Object? version = null,Object? embedded = null,Object? daemon = null,}) {
  return _then(_PrivUserServiceSpec(
serviceClassName: null == serviceClassName ? _self.serviceClassName : serviceClassName // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,embedded: null == embedded ? _self.embedded : embedded // ignore: cast_nullable_to_non_nullable
as bool,daemon: null == daemon ? _self.daemon : daemon // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
