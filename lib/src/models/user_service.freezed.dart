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

/// Omit for priv-core's built-in Binder forwarding service.
 String? get serviceClassName;/// Separates instances of the same class.
 String? get tag;/// Where the service runs.
 PrivUserServiceProcess get process;
/// Create a copy of PrivUserServiceSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivUserServiceSpecCopyWith<PrivUserServiceSpec> get copyWith => _$PrivUserServiceSpecCopyWithImpl<PrivUserServiceSpec>(this as PrivUserServiceSpec, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivUserServiceSpec;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivUserServiceSpec&&(identical(other.serviceClassName, _this.serviceClassName) || other.serviceClassName == _this.serviceClassName)&&(identical(other.tag, _this.tag) || other.tag == _this.tag)&&(identical(other.process, _this.process) || other.process == _this.process));
}


@override
int get hashCode {
  final _this = this as PrivUserServiceSpec;
  return Object.hash(runtimeType,_this.serviceClassName,_this.tag,_this.process);
}

@override
String toString() {
  final _this = this as PrivUserServiceSpec;
  return 'PrivUserServiceSpec(serviceClassName: ${_this.serviceClassName}, tag: ${_this.tag}, process: ${_this.process})';
}


}

/// @nodoc
abstract mixin class $PrivUserServiceSpecCopyWith<$Res>  {
  factory $PrivUserServiceSpecCopyWith(PrivUserServiceSpec value, $Res Function(PrivUserServiceSpec) _then) = _$PrivUserServiceSpecCopyWithImpl;
@useResult
$Res call({
 String? serviceClassName, String? tag, PrivUserServiceProcess process
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
@pragma('vm:prefer-inline') @override $Res call({Object? serviceClassName = freezed,Object? tag = freezed,Object? process = null,}) {
  return _then(PrivUserServiceSpec(
serviceClassName: freezed == serviceClassName ? _self.serviceClassName : serviceClassName // ignore: cast_nullable_to_non_nullable
as String?,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,process: null == process ? _self.process : process // ignore: cast_nullable_to_non_nullable
as PrivUserServiceProcess,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? serviceClassName,  String? tag,  PrivUserServiceProcess process)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivUserServiceSpec() when $default != null:
return $default(_that.serviceClassName,_that.tag,_that.process);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? serviceClassName,  String? tag,  PrivUserServiceProcess process)  $default,) {final _that = this;
switch (_that) {
case _PrivUserServiceSpec():
return $default(_that.serviceClassName,_that.tag,_that.process);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? serviceClassName,  String? tag,  PrivUserServiceProcess process)?  $default,) {final _that = this;
switch (_that) {
case _PrivUserServiceSpec() when $default != null:
return $default(_that.serviceClassName,_that.tag,_that.process);case _:
  return null;

}
}

}

/// @nodoc


class _PrivUserServiceSpec extends PrivUserServiceSpec {
  const _PrivUserServiceSpec({this.serviceClassName, this.tag, this.process = PrivUserServiceProcess.embedded}): super._();
  

/// Omit for priv-core's built-in Binder forwarding service.
@override final  String? serviceClassName;
/// Separates instances of the same class.
@override final  String? tag;
/// Where the service runs.
@override@JsonKey() final  PrivUserServiceProcess process;

/// Create a copy of PrivUserServiceSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivUserServiceSpecCopyWith<_PrivUserServiceSpec> get copyWith => __$PrivUserServiceSpecCopyWithImpl<_PrivUserServiceSpec>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivUserServiceSpec&&(identical(other.serviceClassName, serviceClassName) || other.serviceClassName == serviceClassName)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.process, process) || other.process == process));
}


@override
int get hashCode {
    return Object.hash(runtimeType,serviceClassName,tag,process);
}

@override
String toString() {
    return 'PrivUserServiceSpec(serviceClassName: $serviceClassName, tag: $tag, process: $process)';
}


}

/// @nodoc
abstract mixin class _$PrivUserServiceSpecCopyWith<$Res> implements $PrivUserServiceSpecCopyWith<$Res> {
  factory _$PrivUserServiceSpecCopyWith(_PrivUserServiceSpec value, $Res Function(_PrivUserServiceSpec) _then) = __$PrivUserServiceSpecCopyWithImpl;
@override @useResult
$Res call({
 String? serviceClassName, String? tag, PrivUserServiceProcess process
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
@override @pragma('vm:prefer-inline') $Res call({Object? serviceClassName = freezed,Object? tag = freezed,Object? process = null,}) {
  return _then(_PrivUserServiceSpec(
serviceClassName: freezed == serviceClassName ? _self.serviceClassName : serviceClassName // ignore: cast_nullable_to_non_nullable
as String?,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,process: null == process ? _self.process : process // ignore: cast_nullable_to_non_nullable
as PrivUserServiceProcess,
  ));
}


}

// dart format on
