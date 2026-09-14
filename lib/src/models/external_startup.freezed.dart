// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'external_startup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrivExternalStartupOptions {

 String get shellPath; int get timeoutMillis; int get maxCapturedLines;
/// Create a copy of PrivExternalStartupOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivExternalStartupOptionsCopyWith<PrivExternalStartupOptions> get copyWith => _$PrivExternalStartupOptionsCopyWithImpl<PrivExternalStartupOptions>(this as PrivExternalStartupOptions, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivExternalStartupOptions;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivExternalStartupOptions&&(identical(other.shellPath, _this.shellPath) || other.shellPath == _this.shellPath)&&(identical(other.timeoutMillis, _this.timeoutMillis) || other.timeoutMillis == _this.timeoutMillis)&&(identical(other.maxCapturedLines, _this.maxCapturedLines) || other.maxCapturedLines == _this.maxCapturedLines));
}


@override
int get hashCode {
  final _this = this as PrivExternalStartupOptions;
  return Object.hash(runtimeType,_this.shellPath,_this.timeoutMillis,_this.maxCapturedLines);
}

@override
String toString() {
  final _this = this as PrivExternalStartupOptions;
  return 'PrivExternalStartupOptions(shellPath: ${_this.shellPath}, timeoutMillis: ${_this.timeoutMillis}, maxCapturedLines: ${_this.maxCapturedLines})';
}


}

/// @nodoc
abstract mixin class $PrivExternalStartupOptionsCopyWith<$Res>  {
  factory $PrivExternalStartupOptionsCopyWith(PrivExternalStartupOptions value, $Res Function(PrivExternalStartupOptions) _then) = _$PrivExternalStartupOptionsCopyWithImpl;
@useResult
$Res call({
 String shellPath, int timeoutMillis, int maxCapturedLines
});




}
/// @nodoc
class _$PrivExternalStartupOptionsCopyWithImpl<$Res>
    implements $PrivExternalStartupOptionsCopyWith<$Res> {
  _$PrivExternalStartupOptionsCopyWithImpl(this._self, this._then);

  final PrivExternalStartupOptions _self;
  final $Res Function(PrivExternalStartupOptions) _then;

/// Create a copy of PrivExternalStartupOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shellPath = null,Object? timeoutMillis = null,Object? maxCapturedLines = null,}) {
  return _then(PrivExternalStartupOptions(
shellPath: null == shellPath ? _self.shellPath : shellPath // ignore: cast_nullable_to_non_nullable
as String,timeoutMillis: null == timeoutMillis ? _self.timeoutMillis : timeoutMillis // ignore: cast_nullable_to_non_nullable
as int,maxCapturedLines: null == maxCapturedLines ? _self.maxCapturedLines : maxCapturedLines // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivExternalStartupOptions].
extension PrivExternalStartupOptionsPatterns on PrivExternalStartupOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivExternalStartupOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivExternalStartupOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivExternalStartupOptions value)  $default,){
final _that = this;
switch (_that) {
case _PrivExternalStartupOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivExternalStartupOptions value)?  $default,){
final _that = this;
switch (_that) {
case _PrivExternalStartupOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String shellPath,  int timeoutMillis,  int maxCapturedLines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivExternalStartupOptions() when $default != null:
return $default(_that.shellPath,_that.timeoutMillis,_that.maxCapturedLines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String shellPath,  int timeoutMillis,  int maxCapturedLines)  $default,) {final _that = this;
switch (_that) {
case _PrivExternalStartupOptions():
return $default(_that.shellPath,_that.timeoutMillis,_that.maxCapturedLines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String shellPath,  int timeoutMillis,  int maxCapturedLines)?  $default,) {final _that = this;
switch (_that) {
case _PrivExternalStartupOptions() when $default != null:
return $default(_that.shellPath,_that.timeoutMillis,_that.maxCapturedLines);case _:
  return null;

}
}

}

/// @nodoc


class _PrivExternalStartupOptions extends PrivExternalStartupOptions {
  const _PrivExternalStartupOptions({this.shellPath = '/system/bin/sh', this.timeoutMillis = 2000, this.maxCapturedLines = 80}): super._();
  

@override@JsonKey() final  String shellPath;
@override@JsonKey() final  int timeoutMillis;
@override@JsonKey() final  int maxCapturedLines;

/// Create a copy of PrivExternalStartupOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivExternalStartupOptionsCopyWith<_PrivExternalStartupOptions> get copyWith => __$PrivExternalStartupOptionsCopyWithImpl<_PrivExternalStartupOptions>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivExternalStartupOptions&&(identical(other.shellPath, shellPath) || other.shellPath == shellPath)&&(identical(other.timeoutMillis, timeoutMillis) || other.timeoutMillis == timeoutMillis)&&(identical(other.maxCapturedLines, maxCapturedLines) || other.maxCapturedLines == maxCapturedLines));
}


@override
int get hashCode {
    return Object.hash(runtimeType,shellPath,timeoutMillis,maxCapturedLines);
}

@override
String toString() {
    return 'PrivExternalStartupOptions(shellPath: $shellPath, timeoutMillis: $timeoutMillis, maxCapturedLines: $maxCapturedLines)';
}


}

/// @nodoc
abstract mixin class _$PrivExternalStartupOptionsCopyWith<$Res> implements $PrivExternalStartupOptionsCopyWith<$Res> {
  factory _$PrivExternalStartupOptionsCopyWith(_PrivExternalStartupOptions value, $Res Function(_PrivExternalStartupOptions) _then) = __$PrivExternalStartupOptionsCopyWithImpl;
@override @useResult
$Res call({
 String shellPath, int timeoutMillis, int maxCapturedLines
});




}
/// @nodoc
class __$PrivExternalStartupOptionsCopyWithImpl<$Res>
    implements _$PrivExternalStartupOptionsCopyWith<$Res> {
  __$PrivExternalStartupOptionsCopyWithImpl(this._self, this._then);

  final _PrivExternalStartupOptions _self;
  final $Res Function(_PrivExternalStartupOptions) _then;

/// Create a copy of PrivExternalStartupOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shellPath = null,Object? timeoutMillis = null,Object? maxCapturedLines = null,}) {
  return _then(_PrivExternalStartupOptions(
shellPath: null == shellPath ? _self.shellPath : shellPath // ignore: cast_nullable_to_non_nullable
as String,timeoutMillis: null == timeoutMillis ? _self.timeoutMillis : timeoutMillis // ignore: cast_nullable_to_non_nullable
as int,maxCapturedLines: null == maxCapturedLines ? _self.maxCapturedLines : maxCapturedLines // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PrivExternalStartupBridgeOptions {

 int get timeoutMillis; int get maxCapturedLines;/// Prefix prepended to every log source reported by the remote bridge.
 String? get sourcePrefix;
/// Create a copy of PrivExternalStartupBridgeOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivExternalStartupBridgeOptionsCopyWith<PrivExternalStartupBridgeOptions> get copyWith => _$PrivExternalStartupBridgeOptionsCopyWithImpl<PrivExternalStartupBridgeOptions>(this as PrivExternalStartupBridgeOptions, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivExternalStartupBridgeOptions;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivExternalStartupBridgeOptions&&(identical(other.timeoutMillis, _this.timeoutMillis) || other.timeoutMillis == _this.timeoutMillis)&&(identical(other.maxCapturedLines, _this.maxCapturedLines) || other.maxCapturedLines == _this.maxCapturedLines)&&(identical(other.sourcePrefix, _this.sourcePrefix) || other.sourcePrefix == _this.sourcePrefix));
}


@override
int get hashCode {
  final _this = this as PrivExternalStartupBridgeOptions;
  return Object.hash(runtimeType,_this.timeoutMillis,_this.maxCapturedLines,_this.sourcePrefix);
}

@override
String toString() {
  final _this = this as PrivExternalStartupBridgeOptions;
  return 'PrivExternalStartupBridgeOptions(timeoutMillis: ${_this.timeoutMillis}, maxCapturedLines: ${_this.maxCapturedLines}, sourcePrefix: ${_this.sourcePrefix})';
}


}

/// @nodoc
abstract mixin class $PrivExternalStartupBridgeOptionsCopyWith<$Res>  {
  factory $PrivExternalStartupBridgeOptionsCopyWith(PrivExternalStartupBridgeOptions value, $Res Function(PrivExternalStartupBridgeOptions) _then) = _$PrivExternalStartupBridgeOptionsCopyWithImpl;
@useResult
$Res call({
 int timeoutMillis, int maxCapturedLines, String? sourcePrefix
});




}
/// @nodoc
class _$PrivExternalStartupBridgeOptionsCopyWithImpl<$Res>
    implements $PrivExternalStartupBridgeOptionsCopyWith<$Res> {
  _$PrivExternalStartupBridgeOptionsCopyWithImpl(this._self, this._then);

  final PrivExternalStartupBridgeOptions _self;
  final $Res Function(PrivExternalStartupBridgeOptions) _then;

/// Create a copy of PrivExternalStartupBridgeOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timeoutMillis = null,Object? maxCapturedLines = null,Object? sourcePrefix = freezed,}) {
  return _then(PrivExternalStartupBridgeOptions(
timeoutMillis: null == timeoutMillis ? _self.timeoutMillis : timeoutMillis // ignore: cast_nullable_to_non_nullable
as int,maxCapturedLines: null == maxCapturedLines ? _self.maxCapturedLines : maxCapturedLines // ignore: cast_nullable_to_non_nullable
as int,sourcePrefix: freezed == sourcePrefix ? _self.sourcePrefix : sourcePrefix // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivExternalStartupBridgeOptions].
extension PrivExternalStartupBridgeOptionsPatterns on PrivExternalStartupBridgeOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivExternalStartupBridgeOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivExternalStartupBridgeOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivExternalStartupBridgeOptions value)  $default,){
final _that = this;
switch (_that) {
case _PrivExternalStartupBridgeOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivExternalStartupBridgeOptions value)?  $default,){
final _that = this;
switch (_that) {
case _PrivExternalStartupBridgeOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int timeoutMillis,  int maxCapturedLines,  String? sourcePrefix)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivExternalStartupBridgeOptions() when $default != null:
return $default(_that.timeoutMillis,_that.maxCapturedLines,_that.sourcePrefix);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int timeoutMillis,  int maxCapturedLines,  String? sourcePrefix)  $default,) {final _that = this;
switch (_that) {
case _PrivExternalStartupBridgeOptions():
return $default(_that.timeoutMillis,_that.maxCapturedLines,_that.sourcePrefix);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int timeoutMillis,  int maxCapturedLines,  String? sourcePrefix)?  $default,) {final _that = this;
switch (_that) {
case _PrivExternalStartupBridgeOptions() when $default != null:
return $default(_that.timeoutMillis,_that.maxCapturedLines,_that.sourcePrefix);case _:
  return null;

}
}

}

/// @nodoc


class _PrivExternalStartupBridgeOptions extends PrivExternalStartupBridgeOptions {
  const _PrivExternalStartupBridgeOptions({this.timeoutMillis = 10000, this.maxCapturedLines = 80, this.sourcePrefix}): super._();
  

@override@JsonKey() final  int timeoutMillis;
@override@JsonKey() final  int maxCapturedLines;
/// Prefix prepended to every log source reported by the remote bridge.
@override final  String? sourcePrefix;

/// Create a copy of PrivExternalStartupBridgeOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivExternalStartupBridgeOptionsCopyWith<_PrivExternalStartupBridgeOptions> get copyWith => __$PrivExternalStartupBridgeOptionsCopyWithImpl<_PrivExternalStartupBridgeOptions>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivExternalStartupBridgeOptions&&(identical(other.timeoutMillis, timeoutMillis) || other.timeoutMillis == timeoutMillis)&&(identical(other.maxCapturedLines, maxCapturedLines) || other.maxCapturedLines == maxCapturedLines)&&(identical(other.sourcePrefix, sourcePrefix) || other.sourcePrefix == sourcePrefix));
}


@override
int get hashCode {
    return Object.hash(runtimeType,timeoutMillis,maxCapturedLines,sourcePrefix);
}

@override
String toString() {
    return 'PrivExternalStartupBridgeOptions(timeoutMillis: $timeoutMillis, maxCapturedLines: $maxCapturedLines, sourcePrefix: $sourcePrefix)';
}


}

/// @nodoc
abstract mixin class _$PrivExternalStartupBridgeOptionsCopyWith<$Res> implements $PrivExternalStartupBridgeOptionsCopyWith<$Res> {
  factory _$PrivExternalStartupBridgeOptionsCopyWith(_PrivExternalStartupBridgeOptions value, $Res Function(_PrivExternalStartupBridgeOptions) _then) = __$PrivExternalStartupBridgeOptionsCopyWithImpl;
@override @useResult
$Res call({
 int timeoutMillis, int maxCapturedLines, String? sourcePrefix
});




}
/// @nodoc
class __$PrivExternalStartupBridgeOptionsCopyWithImpl<$Res>
    implements _$PrivExternalStartupBridgeOptionsCopyWith<$Res> {
  __$PrivExternalStartupBridgeOptionsCopyWithImpl(this._self, this._then);

  final _PrivExternalStartupBridgeOptions _self;
  final $Res Function(_PrivExternalStartupBridgeOptions) _then;

/// Create a copy of PrivExternalStartupBridgeOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timeoutMillis = null,Object? maxCapturedLines = null,Object? sourcePrefix = freezed,}) {
  return _then(_PrivExternalStartupBridgeOptions(
timeoutMillis: null == timeoutMillis ? _self.timeoutMillis : timeoutMillis // ignore: cast_nullable_to_non_nullable
as int,maxCapturedLines: null == maxCapturedLines ? _self.maxCapturedLines : maxCapturedLines // ignore: cast_nullable_to_non_nullable
as int,sourcePrefix: freezed == sourcePrefix ? _self.sourcePrefix : sourcePrefix // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
