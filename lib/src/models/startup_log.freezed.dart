// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'startup_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrivStartupLogLine {

/// Component that produced the line, for example `runtime` or `adb`.
 String get source;/// Human readable diagnostic text.
 String get message;/// Wall-clock time of the line, in milliseconds since the Unix epoch.
///
/// The platform channel carries this under the key `ctime`.
 int get timestampMillis;/// Identifier of the start operation that produced the line, when known.
 String? get operationId;
/// Create a copy of PrivStartupLogLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivStartupLogLineCopyWith<PrivStartupLogLine> get copyWith => _$PrivStartupLogLineCopyWithImpl<PrivStartupLogLine>(this as PrivStartupLogLine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivStartupLogLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivStartupLogLine&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.timestampMillis, _this.timestampMillis) || other.timestampMillis == _this.timestampMillis)&&(identical(other.operationId, _this.operationId) || other.operationId == _this.operationId));
}


@override
int get hashCode {
  final _this = this as PrivStartupLogLine;
  return Object.hash(runtimeType,_this.source,_this.message,_this.timestampMillis,_this.operationId);
}

@override
String toString() {
  final _this = this as PrivStartupLogLine;
  return 'PrivStartupLogLine(source: ${_this.source}, message: ${_this.message}, timestampMillis: ${_this.timestampMillis}, operationId: ${_this.operationId})';
}


}

/// @nodoc
abstract mixin class $PrivStartupLogLineCopyWith<$Res>  {
  factory $PrivStartupLogLineCopyWith(PrivStartupLogLine value, $Res Function(PrivStartupLogLine) _then) = _$PrivStartupLogLineCopyWithImpl;
@useResult
$Res call({
 String source, String message, int timestampMillis, String? operationId
});




}
/// @nodoc
class _$PrivStartupLogLineCopyWithImpl<$Res>
    implements $PrivStartupLogLineCopyWith<$Res> {
  _$PrivStartupLogLineCopyWithImpl(this._self, this._then);

  final PrivStartupLogLine _self;
  final $Res Function(PrivStartupLogLine) _then;

/// Create a copy of PrivStartupLogLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? message = null,Object? timestampMillis = null,Object? operationId = freezed,}) {
  return _then(PrivStartupLogLine(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,timestampMillis: null == timestampMillis ? _self.timestampMillis : timestampMillis // ignore: cast_nullable_to_non_nullable
as int,operationId: freezed == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivStartupLogLine].
extension PrivStartupLogLinePatterns on PrivStartupLogLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivStartupLogLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivStartupLogLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivStartupLogLine value)  $default,){
final _that = this;
switch (_that) {
case _PrivStartupLogLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivStartupLogLine value)?  $default,){
final _that = this;
switch (_that) {
case _PrivStartupLogLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String source,  String message,  int timestampMillis,  String? operationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivStartupLogLine() when $default != null:
return $default(_that.source,_that.message,_that.timestampMillis,_that.operationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String source,  String message,  int timestampMillis,  String? operationId)  $default,) {final _that = this;
switch (_that) {
case _PrivStartupLogLine():
return $default(_that.source,_that.message,_that.timestampMillis,_that.operationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String source,  String message,  int timestampMillis,  String? operationId)?  $default,) {final _that = this;
switch (_that) {
case _PrivStartupLogLine() when $default != null:
return $default(_that.source,_that.message,_that.timestampMillis,_that.operationId);case _:
  return null;

}
}

}

/// @nodoc


class _PrivStartupLogLine extends PrivStartupLogLine {
  const _PrivStartupLogLine({required this.source, required this.message, required this.timestampMillis, this.operationId}): super._();
  

/// Component that produced the line, for example `runtime` or `adb`.
@override final  String source;
/// Human readable diagnostic text.
@override final  String message;
/// Wall-clock time of the line, in milliseconds since the Unix epoch.
///
/// The platform channel carries this under the key `ctime`.
@override final  int timestampMillis;
/// Identifier of the start operation that produced the line, when known.
@override final  String? operationId;

/// Create a copy of PrivStartupLogLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivStartupLogLineCopyWith<_PrivStartupLogLine> get copyWith => __$PrivStartupLogLineCopyWithImpl<_PrivStartupLogLine>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivStartupLogLine&&(identical(other.source, source) || other.source == source)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestampMillis, timestampMillis) || other.timestampMillis == timestampMillis)&&(identical(other.operationId, operationId) || other.operationId == operationId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,source,message,timestampMillis,operationId);
}

@override
String toString() {
    return 'PrivStartupLogLine(source: $source, message: $message, timestampMillis: $timestampMillis, operationId: $operationId)';
}


}

/// @nodoc
abstract mixin class _$PrivStartupLogLineCopyWith<$Res> implements $PrivStartupLogLineCopyWith<$Res> {
  factory _$PrivStartupLogLineCopyWith(_PrivStartupLogLine value, $Res Function(_PrivStartupLogLine) _then) = __$PrivStartupLogLineCopyWithImpl;
@override @useResult
$Res call({
 String source, String message, int timestampMillis, String? operationId
});




}
/// @nodoc
class __$PrivStartupLogLineCopyWithImpl<$Res>
    implements _$PrivStartupLogLineCopyWith<$Res> {
  __$PrivStartupLogLineCopyWithImpl(this._self, this._then);

  final _PrivStartupLogLine _self;
  final $Res Function(_PrivStartupLogLine) _then;

/// Create a copy of PrivStartupLogLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? message = null,Object? timestampMillis = null,Object? operationId = freezed,}) {
  return _then(_PrivStartupLogLine(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,timestampMillis: null == timestampMillis ? _self.timestampMillis : timestampMillis // ignore: cast_nullable_to_non_nullable
as int,operationId: freezed == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
