// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crash_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrivCrashLog {

/// Format of this report. Currently [privilegeCrashLogSchemaVersion].
 int get schemaVersion;/// Application the crashing process belonged to.
 String get applicationId;/// Android user the crashing process ran as.
 int get userId;/// UID of the crashing process.
 int get uid;/// PID of the crashing process.
 int get pid;/// [privilegeCrashProcessTypeServer] or
/// [privilegeCrashProcessTypeUserService].
 String get processType;/// Class of the UserService that crashed, only for a UserService process.
 String? get serviceClassName;/// When the recorder was initialized, in milliseconds since the epoch.
 int get startedAtEpochMillis;/// When the process crashed, in milliseconds since the epoch.
 int get crashedAtEpochMillis;/// Thread that raised the exception.
 String get threadName;/// Fully qualified name of the exception class.
 String get exceptionType;/// Message of the exception, when it had one.
 String? get exceptionMessage;/// Full stack trace, including causes and suppressed exceptions.
 String get stackTrace;
/// Create a copy of PrivCrashLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivCrashLogCopyWith<PrivCrashLog> get copyWith => _$PrivCrashLogCopyWithImpl<PrivCrashLog>(this as PrivCrashLog, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivCrashLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivCrashLog&&(identical(other.schemaVersion, _this.schemaVersion) || other.schemaVersion == _this.schemaVersion)&&(identical(other.applicationId, _this.applicationId) || other.applicationId == _this.applicationId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.uid, _this.uid) || other.uid == _this.uid)&&(identical(other.pid, _this.pid) || other.pid == _this.pid)&&(identical(other.processType, _this.processType) || other.processType == _this.processType)&&(identical(other.serviceClassName, _this.serviceClassName) || other.serviceClassName == _this.serviceClassName)&&(identical(other.startedAtEpochMillis, _this.startedAtEpochMillis) || other.startedAtEpochMillis == _this.startedAtEpochMillis)&&(identical(other.crashedAtEpochMillis, _this.crashedAtEpochMillis) || other.crashedAtEpochMillis == _this.crashedAtEpochMillis)&&(identical(other.threadName, _this.threadName) || other.threadName == _this.threadName)&&(identical(other.exceptionType, _this.exceptionType) || other.exceptionType == _this.exceptionType)&&(identical(other.exceptionMessage, _this.exceptionMessage) || other.exceptionMessage == _this.exceptionMessage)&&(identical(other.stackTrace, _this.stackTrace) || other.stackTrace == _this.stackTrace));
}


@override
int get hashCode {
  final _this = this as PrivCrashLog;
  return Object.hash(runtimeType,_this.schemaVersion,_this.applicationId,_this.userId,_this.uid,_this.pid,_this.processType,_this.serviceClassName,_this.startedAtEpochMillis,_this.crashedAtEpochMillis,_this.threadName,_this.exceptionType,_this.exceptionMessage,_this.stackTrace);
}

@override
String toString() {
  final _this = this as PrivCrashLog;
  return 'PrivCrashLog(schemaVersion: ${_this.schemaVersion}, applicationId: ${_this.applicationId}, userId: ${_this.userId}, uid: ${_this.uid}, pid: ${_this.pid}, processType: ${_this.processType}, serviceClassName: ${_this.serviceClassName}, startedAtEpochMillis: ${_this.startedAtEpochMillis}, crashedAtEpochMillis: ${_this.crashedAtEpochMillis}, threadName: ${_this.threadName}, exceptionType: ${_this.exceptionType}, exceptionMessage: ${_this.exceptionMessage}, stackTrace: ${_this.stackTrace})';
}


}

/// @nodoc
abstract mixin class $PrivCrashLogCopyWith<$Res>  {
  factory $PrivCrashLogCopyWith(PrivCrashLog value, $Res Function(PrivCrashLog) _then) = _$PrivCrashLogCopyWithImpl;
@useResult
$Res call({
 int schemaVersion, String applicationId, int userId, int uid, int pid, String processType, String? serviceClassName, int startedAtEpochMillis, int crashedAtEpochMillis, String threadName, String exceptionType, String? exceptionMessage, String stackTrace
});




}
/// @nodoc
class _$PrivCrashLogCopyWithImpl<$Res>
    implements $PrivCrashLogCopyWith<$Res> {
  _$PrivCrashLogCopyWithImpl(this._self, this._then);

  final PrivCrashLog _self;
  final $Res Function(PrivCrashLog) _then;

/// Create a copy of PrivCrashLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? applicationId = null,Object? userId = null,Object? uid = null,Object? pid = null,Object? processType = null,Object? serviceClassName = freezed,Object? startedAtEpochMillis = null,Object? crashedAtEpochMillis = null,Object? threadName = null,Object? exceptionType = null,Object? exceptionMessage = freezed,Object? stackTrace = null,}) {
  return _then(PrivCrashLog(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,applicationId: null == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as int,pid: null == pid ? _self.pid : pid // ignore: cast_nullable_to_non_nullable
as int,processType: null == processType ? _self.processType : processType // ignore: cast_nullable_to_non_nullable
as String,serviceClassName: freezed == serviceClassName ? _self.serviceClassName : serviceClassName // ignore: cast_nullable_to_non_nullable
as String?,startedAtEpochMillis: null == startedAtEpochMillis ? _self.startedAtEpochMillis : startedAtEpochMillis // ignore: cast_nullable_to_non_nullable
as int,crashedAtEpochMillis: null == crashedAtEpochMillis ? _self.crashedAtEpochMillis : crashedAtEpochMillis // ignore: cast_nullable_to_non_nullable
as int,threadName: null == threadName ? _self.threadName : threadName // ignore: cast_nullable_to_non_nullable
as String,exceptionType: null == exceptionType ? _self.exceptionType : exceptionType // ignore: cast_nullable_to_non_nullable
as String,exceptionMessage: freezed == exceptionMessage ? _self.exceptionMessage : exceptionMessage // ignore: cast_nullable_to_non_nullable
as String?,stackTrace: null == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivCrashLog].
extension PrivCrashLogPatterns on PrivCrashLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivCrashLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivCrashLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivCrashLog value)  $default,){
final _that = this;
switch (_that) {
case _PrivCrashLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivCrashLog value)?  $default,){
final _that = this;
switch (_that) {
case _PrivCrashLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int schemaVersion,  String applicationId,  int userId,  int uid,  int pid,  String processType,  String? serviceClassName,  int startedAtEpochMillis,  int crashedAtEpochMillis,  String threadName,  String exceptionType,  String? exceptionMessage,  String stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivCrashLog() when $default != null:
return $default(_that.schemaVersion,_that.applicationId,_that.userId,_that.uid,_that.pid,_that.processType,_that.serviceClassName,_that.startedAtEpochMillis,_that.crashedAtEpochMillis,_that.threadName,_that.exceptionType,_that.exceptionMessage,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int schemaVersion,  String applicationId,  int userId,  int uid,  int pid,  String processType,  String? serviceClassName,  int startedAtEpochMillis,  int crashedAtEpochMillis,  String threadName,  String exceptionType,  String? exceptionMessage,  String stackTrace)  $default,) {final _that = this;
switch (_that) {
case _PrivCrashLog():
return $default(_that.schemaVersion,_that.applicationId,_that.userId,_that.uid,_that.pid,_that.processType,_that.serviceClassName,_that.startedAtEpochMillis,_that.crashedAtEpochMillis,_that.threadName,_that.exceptionType,_that.exceptionMessage,_that.stackTrace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int schemaVersion,  String applicationId,  int userId,  int uid,  int pid,  String processType,  String? serviceClassName,  int startedAtEpochMillis,  int crashedAtEpochMillis,  String threadName,  String exceptionType,  String? exceptionMessage,  String stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _PrivCrashLog() when $default != null:
return $default(_that.schemaVersion,_that.applicationId,_that.userId,_that.uid,_that.pid,_that.processType,_that.serviceClassName,_that.startedAtEpochMillis,_that.crashedAtEpochMillis,_that.threadName,_that.exceptionType,_that.exceptionMessage,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _PrivCrashLog extends PrivCrashLog {
  const _PrivCrashLog({required this.schemaVersion, required this.applicationId, required this.userId, required this.uid, required this.pid, required this.processType, this.serviceClassName, required this.startedAtEpochMillis, required this.crashedAtEpochMillis, required this.threadName, required this.exceptionType, this.exceptionMessage, required this.stackTrace}): super._();
  

/// Format of this report. Currently [privilegeCrashLogSchemaVersion].
@override final  int schemaVersion;
/// Application the crashing process belonged to.
@override final  String applicationId;
/// Android user the crashing process ran as.
@override final  int userId;
/// UID of the crashing process.
@override final  int uid;
/// PID of the crashing process.
@override final  int pid;
/// [privilegeCrashProcessTypeServer] or
/// [privilegeCrashProcessTypeUserService].
@override final  String processType;
/// Class of the UserService that crashed, only for a UserService process.
@override final  String? serviceClassName;
/// When the recorder was initialized, in milliseconds since the epoch.
@override final  int startedAtEpochMillis;
/// When the process crashed, in milliseconds since the epoch.
@override final  int crashedAtEpochMillis;
/// Thread that raised the exception.
@override final  String threadName;
/// Fully qualified name of the exception class.
@override final  String exceptionType;
/// Message of the exception, when it had one.
@override final  String? exceptionMessage;
/// Full stack trace, including causes and suppressed exceptions.
@override final  String stackTrace;

/// Create a copy of PrivCrashLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivCrashLogCopyWith<_PrivCrashLog> get copyWith => __$PrivCrashLogCopyWithImpl<_PrivCrashLog>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivCrashLog&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.pid, pid) || other.pid == pid)&&(identical(other.processType, processType) || other.processType == processType)&&(identical(other.serviceClassName, serviceClassName) || other.serviceClassName == serviceClassName)&&(identical(other.startedAtEpochMillis, startedAtEpochMillis) || other.startedAtEpochMillis == startedAtEpochMillis)&&(identical(other.crashedAtEpochMillis, crashedAtEpochMillis) || other.crashedAtEpochMillis == crashedAtEpochMillis)&&(identical(other.threadName, threadName) || other.threadName == threadName)&&(identical(other.exceptionType, exceptionType) || other.exceptionType == exceptionType)&&(identical(other.exceptionMessage, exceptionMessage) || other.exceptionMessage == exceptionMessage)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode {
    return Object.hash(runtimeType,schemaVersion,applicationId,userId,uid,pid,processType,serviceClassName,startedAtEpochMillis,crashedAtEpochMillis,threadName,exceptionType,exceptionMessage,stackTrace);
}

@override
String toString() {
    return 'PrivCrashLog(schemaVersion: $schemaVersion, applicationId: $applicationId, userId: $userId, uid: $uid, pid: $pid, processType: $processType, serviceClassName: $serviceClassName, startedAtEpochMillis: $startedAtEpochMillis, crashedAtEpochMillis: $crashedAtEpochMillis, threadName: $threadName, exceptionType: $exceptionType, exceptionMessage: $exceptionMessage, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$PrivCrashLogCopyWith<$Res> implements $PrivCrashLogCopyWith<$Res> {
  factory _$PrivCrashLogCopyWith(_PrivCrashLog value, $Res Function(_PrivCrashLog) _then) = __$PrivCrashLogCopyWithImpl;
@override @useResult
$Res call({
 int schemaVersion, String applicationId, int userId, int uid, int pid, String processType, String? serviceClassName, int startedAtEpochMillis, int crashedAtEpochMillis, String threadName, String exceptionType, String? exceptionMessage, String stackTrace
});




}
/// @nodoc
class __$PrivCrashLogCopyWithImpl<$Res>
    implements _$PrivCrashLogCopyWith<$Res> {
  __$PrivCrashLogCopyWithImpl(this._self, this._then);

  final _PrivCrashLog _self;
  final $Res Function(_PrivCrashLog) _then;

/// Create a copy of PrivCrashLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? applicationId = null,Object? userId = null,Object? uid = null,Object? pid = null,Object? processType = null,Object? serviceClassName = freezed,Object? startedAtEpochMillis = null,Object? crashedAtEpochMillis = null,Object? threadName = null,Object? exceptionType = null,Object? exceptionMessage = freezed,Object? stackTrace = null,}) {
  return _then(_PrivCrashLog(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,applicationId: null == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as int,pid: null == pid ? _self.pid : pid // ignore: cast_nullable_to_non_nullable
as int,processType: null == processType ? _self.processType : processType // ignore: cast_nullable_to_non_nullable
as String,serviceClassName: freezed == serviceClassName ? _self.serviceClassName : serviceClassName // ignore: cast_nullable_to_non_nullable
as String?,startedAtEpochMillis: null == startedAtEpochMillis ? _self.startedAtEpochMillis : startedAtEpochMillis // ignore: cast_nullable_to_non_nullable
as int,crashedAtEpochMillis: null == crashedAtEpochMillis ? _self.crashedAtEpochMillis : crashedAtEpochMillis // ignore: cast_nullable_to_non_nullable
as int,threadName: null == threadName ? _self.threadName : threadName // ignore: cast_nullable_to_non_nullable
as String,exceptionType: null == exceptionType ? _self.exceptionType : exceptionType // ignore: cast_nullable_to_non_nullable
as String,exceptionMessage: freezed == exceptionMessage ? _self.exceptionMessage : exceptionMessage // ignore: cast_nullable_to_non_nullable
as String?,stackTrace: null == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
