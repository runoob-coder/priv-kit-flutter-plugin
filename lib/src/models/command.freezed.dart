// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrivCommandResult {

/// Process exit code. Non-zero values are normal exits, not errors.
 int get exitCode;/// Captured standard output.
 Uint8List get stdout;/// Captured standard error.
 Uint8List get stderr;/// Whether [stdout] hit the capture limit.
 bool get stdoutTruncated;/// Whether [stderr] hit the capture limit.
 bool get stderrTruncated;
/// Create a copy of PrivCommandResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivCommandResultCopyWith<PrivCommandResult> get copyWith => _$PrivCommandResultCopyWithImpl<PrivCommandResult>(this as PrivCommandResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivCommandResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivCommandResult&&(identical(other.exitCode, _this.exitCode) || other.exitCode == _this.exitCode)&&const DeepCollectionEquality().equals(other.stdout, _this.stdout)&&const DeepCollectionEquality().equals(other.stderr, _this.stderr)&&(identical(other.stdoutTruncated, _this.stdoutTruncated) || other.stdoutTruncated == _this.stdoutTruncated)&&(identical(other.stderrTruncated, _this.stderrTruncated) || other.stderrTruncated == _this.stderrTruncated));
}


@override
int get hashCode {
  final _this = this as PrivCommandResult;
  return Object.hash(runtimeType,_this.exitCode,const DeepCollectionEquality().hash(_this.stdout),const DeepCollectionEquality().hash(_this.stderr),_this.stdoutTruncated,_this.stderrTruncated);
}

@override
String toString() {
  final _this = this as PrivCommandResult;
  return 'PrivCommandResult(exitCode: ${_this.exitCode}, stdout: ${_this.stdout}, stderr: ${_this.stderr}, stdoutTruncated: ${_this.stdoutTruncated}, stderrTruncated: ${_this.stderrTruncated})';
}


}

/// @nodoc
abstract mixin class $PrivCommandResultCopyWith<$Res>  {
  factory $PrivCommandResultCopyWith(PrivCommandResult value, $Res Function(PrivCommandResult) _then) = _$PrivCommandResultCopyWithImpl;
@useResult
$Res call({
 int exitCode, Uint8List stdout, Uint8List stderr, bool stdoutTruncated, bool stderrTruncated
});




}
/// @nodoc
class _$PrivCommandResultCopyWithImpl<$Res>
    implements $PrivCommandResultCopyWith<$Res> {
  _$PrivCommandResultCopyWithImpl(this._self, this._then);

  final PrivCommandResult _self;
  final $Res Function(PrivCommandResult) _then;

/// Create a copy of PrivCommandResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exitCode = null,Object? stdout = null,Object? stderr = null,Object? stdoutTruncated = null,Object? stderrTruncated = null,}) {
  return _then(PrivCommandResult(
exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,stdout: null == stdout ? _self.stdout : stdout // ignore: cast_nullable_to_non_nullable
as Uint8List,stderr: null == stderr ? _self.stderr : stderr // ignore: cast_nullable_to_non_nullable
as Uint8List,stdoutTruncated: null == stdoutTruncated ? _self.stdoutTruncated : stdoutTruncated // ignore: cast_nullable_to_non_nullable
as bool,stderrTruncated: null == stderrTruncated ? _self.stderrTruncated : stderrTruncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivCommandResult].
extension PrivCommandResultPatterns on PrivCommandResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivCommandResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivCommandResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivCommandResult value)  $default,){
final _that = this;
switch (_that) {
case _PrivCommandResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivCommandResult value)?  $default,){
final _that = this;
switch (_that) {
case _PrivCommandResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int exitCode,  Uint8List stdout,  Uint8List stderr,  bool stdoutTruncated,  bool stderrTruncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivCommandResult() when $default != null:
return $default(_that.exitCode,_that.stdout,_that.stderr,_that.stdoutTruncated,_that.stderrTruncated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int exitCode,  Uint8List stdout,  Uint8List stderr,  bool stdoutTruncated,  bool stderrTruncated)  $default,) {final _that = this;
switch (_that) {
case _PrivCommandResult():
return $default(_that.exitCode,_that.stdout,_that.stderr,_that.stdoutTruncated,_that.stderrTruncated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int exitCode,  Uint8List stdout,  Uint8List stderr,  bool stdoutTruncated,  bool stderrTruncated)?  $default,) {final _that = this;
switch (_that) {
case _PrivCommandResult() when $default != null:
return $default(_that.exitCode,_that.stdout,_that.stderr,_that.stdoutTruncated,_that.stderrTruncated);case _:
  return null;

}
}

}

/// @nodoc


class _PrivCommandResult extends PrivCommandResult {
  const _PrivCommandResult({required this.exitCode, required this.stdout, required this.stderr, this.stdoutTruncated = false, this.stderrTruncated = false}): super._();
  

/// Process exit code. Non-zero values are normal exits, not errors.
@override final  int exitCode;
/// Captured standard output.
@override final  Uint8List stdout;
/// Captured standard error.
@override final  Uint8List stderr;
/// Whether [stdout] hit the capture limit.
@override@JsonKey() final  bool stdoutTruncated;
/// Whether [stderr] hit the capture limit.
@override@JsonKey() final  bool stderrTruncated;

/// Create a copy of PrivCommandResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivCommandResultCopyWith<_PrivCommandResult> get copyWith => __$PrivCommandResultCopyWithImpl<_PrivCommandResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivCommandResult&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&const DeepCollectionEquality().equals(other.stdout, stdout)&&const DeepCollectionEquality().equals(other.stderr, stderr)&&(identical(other.stdoutTruncated, stdoutTruncated) || other.stdoutTruncated == stdoutTruncated)&&(identical(other.stderrTruncated, stderrTruncated) || other.stderrTruncated == stderrTruncated));
}


@override
int get hashCode {
    return Object.hash(runtimeType,exitCode,const DeepCollectionEquality().hash(stdout),const DeepCollectionEquality().hash(stderr),stdoutTruncated,stderrTruncated);
}

@override
String toString() {
    return 'PrivCommandResult(exitCode: $exitCode, stdout: $stdout, stderr: $stderr, stdoutTruncated: $stdoutTruncated, stderrTruncated: $stderrTruncated)';
}


}

/// @nodoc
abstract mixin class _$PrivCommandResultCopyWith<$Res> implements $PrivCommandResultCopyWith<$Res> {
  factory _$PrivCommandResultCopyWith(_PrivCommandResult value, $Res Function(_PrivCommandResult) _then) = __$PrivCommandResultCopyWithImpl;
@override @useResult
$Res call({
 int exitCode, Uint8List stdout, Uint8List stderr, bool stdoutTruncated, bool stderrTruncated
});




}
/// @nodoc
class __$PrivCommandResultCopyWithImpl<$Res>
    implements _$PrivCommandResultCopyWith<$Res> {
  __$PrivCommandResultCopyWithImpl(this._self, this._then);

  final _PrivCommandResult _self;
  final $Res Function(_PrivCommandResult) _then;

/// Create a copy of PrivCommandResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exitCode = null,Object? stdout = null,Object? stderr = null,Object? stdoutTruncated = null,Object? stderrTruncated = null,}) {
  return _then(_PrivCommandResult(
exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,stdout: null == stdout ? _self.stdout : stdout // ignore: cast_nullable_to_non_nullable
as Uint8List,stderr: null == stderr ? _self.stderr : stderr // ignore: cast_nullable_to_non_nullable
as Uint8List,stdoutTruncated: null == stdoutTruncated ? _self.stdoutTruncated : stdoutTruncated // ignore: cast_nullable_to_non_nullable
as bool,stderrTruncated: null == stderrTruncated ? _self.stderrTruncated : stderrTruncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$PrivCommandEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivCommandEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PrivCommandEvent()';
}


}

/// @nodoc
class $PrivCommandEventCopyWith<$Res>  {
$PrivCommandEventCopyWith(PrivCommandEvent _, $Res Function(PrivCommandEvent) __);
}


/// Adds pattern-matching-related methods to [PrivCommandEvent].
extension PrivCommandEventPatterns on PrivCommandEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PrivCommandStdout value)?  stdout,TResult Function( PrivCommandStderr value)?  stderr,TResult Function( PrivCommandExit value)?  exit,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PrivCommandStdout() when stdout != null:
return stdout(_that);case PrivCommandStderr() when stderr != null:
return stderr(_that);case PrivCommandExit() when exit != null:
return exit(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PrivCommandStdout value)  stdout,required TResult Function( PrivCommandStderr value)  stderr,required TResult Function( PrivCommandExit value)  exit,}){
final _that = this;
switch (_that) {
case PrivCommandStdout():
return stdout(_that);case PrivCommandStderr():
return stderr(_that);case PrivCommandExit():
return exit(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PrivCommandStdout value)?  stdout,TResult? Function( PrivCommandStderr value)?  stderr,TResult? Function( PrivCommandExit value)?  exit,}){
final _that = this;
switch (_that) {
case PrivCommandStdout() when stdout != null:
return stdout(_that);case PrivCommandStderr() when stderr != null:
return stderr(_that);case PrivCommandExit() when exit != null:
return exit(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Uint8List bytes)?  stdout,TResult Function( Uint8List bytes)?  stderr,TResult Function( int exitCode)?  exit,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PrivCommandStdout() when stdout != null:
return stdout(_that.bytes);case PrivCommandStderr() when stderr != null:
return stderr(_that.bytes);case PrivCommandExit() when exit != null:
return exit(_that.exitCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Uint8List bytes)  stdout,required TResult Function( Uint8List bytes)  stderr,required TResult Function( int exitCode)  exit,}) {final _that = this;
switch (_that) {
case PrivCommandStdout():
return stdout(_that.bytes);case PrivCommandStderr():
return stderr(_that.bytes);case PrivCommandExit():
return exit(_that.exitCode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Uint8List bytes)?  stdout,TResult? Function( Uint8List bytes)?  stderr,TResult? Function( int exitCode)?  exit,}) {final _that = this;
switch (_that) {
case PrivCommandStdout() when stdout != null:
return stdout(_that.bytes);case PrivCommandStderr() when stderr != null:
return stderr(_that.bytes);case PrivCommandExit() when exit != null:
return exit(_that.exitCode);case _:
  return null;

}
}

}

/// @nodoc


class PrivCommandStdout implements PrivCommandEvent {
  const PrivCommandStdout({required this.bytes});
  

 final  Uint8List bytes;

/// Create a copy of PrivCommandEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivCommandStdoutCopyWith<PrivCommandStdout> get copyWith => _$PrivCommandStdoutCopyWithImpl<PrivCommandStdout>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivCommandStdout&&const DeepCollectionEquality().equals(other.bytes, bytes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(bytes));
}

@override
String toString() {
    return 'PrivCommandEvent.stdout(bytes: $bytes)';
}


}

/// @nodoc
abstract mixin class $PrivCommandStdoutCopyWith<$Res> implements $PrivCommandEventCopyWith<$Res> {
  factory $PrivCommandStdoutCopyWith(PrivCommandStdout value, $Res Function(PrivCommandStdout) _then) = _$PrivCommandStdoutCopyWithImpl;
@useResult
$Res call({
 Uint8List bytes
});




}
/// @nodoc
class _$PrivCommandStdoutCopyWithImpl<$Res>
    implements $PrivCommandStdoutCopyWith<$Res> {
  _$PrivCommandStdoutCopyWithImpl(this._self, this._then);

  final PrivCommandStdout _self;
  final $Res Function(PrivCommandStdout) _then;

/// Create a copy of PrivCommandEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bytes = null,}) {
  return _then(PrivCommandStdout(
bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,
  ));
}


}

/// @nodoc


class PrivCommandStderr implements PrivCommandEvent {
  const PrivCommandStderr({required this.bytes});
  

 final  Uint8List bytes;

/// Create a copy of PrivCommandEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivCommandStderrCopyWith<PrivCommandStderr> get copyWith => _$PrivCommandStderrCopyWithImpl<PrivCommandStderr>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivCommandStderr&&const DeepCollectionEquality().equals(other.bytes, bytes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(bytes));
}

@override
String toString() {
    return 'PrivCommandEvent.stderr(bytes: $bytes)';
}


}

/// @nodoc
abstract mixin class $PrivCommandStderrCopyWith<$Res> implements $PrivCommandEventCopyWith<$Res> {
  factory $PrivCommandStderrCopyWith(PrivCommandStderr value, $Res Function(PrivCommandStderr) _then) = _$PrivCommandStderrCopyWithImpl;
@useResult
$Res call({
 Uint8List bytes
});




}
/// @nodoc
class _$PrivCommandStderrCopyWithImpl<$Res>
    implements $PrivCommandStderrCopyWith<$Res> {
  _$PrivCommandStderrCopyWithImpl(this._self, this._then);

  final PrivCommandStderr _self;
  final $Res Function(PrivCommandStderr) _then;

/// Create a copy of PrivCommandEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bytes = null,}) {
  return _then(PrivCommandStderr(
bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,
  ));
}


}

/// @nodoc


class PrivCommandExit implements PrivCommandEvent {
  const PrivCommandExit({required this.exitCode});
  

 final  int exitCode;

/// Create a copy of PrivCommandEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivCommandExitCopyWith<PrivCommandExit> get copyWith => _$PrivCommandExitCopyWithImpl<PrivCommandExit>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivCommandExit&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,exitCode);
}

@override
String toString() {
    return 'PrivCommandEvent.exit(exitCode: $exitCode)';
}


}

/// @nodoc
abstract mixin class $PrivCommandExitCopyWith<$Res> implements $PrivCommandEventCopyWith<$Res> {
  factory $PrivCommandExitCopyWith(PrivCommandExit value, $Res Function(PrivCommandExit) _then) = _$PrivCommandExitCopyWithImpl;
@useResult
$Res call({
 int exitCode
});




}
/// @nodoc
class _$PrivCommandExitCopyWithImpl<$Res>
    implements $PrivCommandExitCopyWith<$Res> {
  _$PrivCommandExitCopyWithImpl(this._self, this._then);

  final PrivCommandExit _self;
  final $Res Function(PrivCommandExit) _then;

/// Create a copy of PrivCommandEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? exitCode = null,}) {
  return _then(PrivCommandExit(
exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
