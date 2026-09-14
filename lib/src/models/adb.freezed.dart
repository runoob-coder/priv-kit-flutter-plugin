// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adb.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrivAdbConnectionOptions {

/// ADB connect port. `null` discovers the Wireless Debugging connect port.
 int? get port; PrivAdbWirelessDebuggingControl get wirelessDebuggingControl; bool get disableWirelessDebuggingAfterUse; int get portDiscoveryTimeoutMillis; int get connectRetryCount; int get connectRetryDelayMillis;
/// Create a copy of PrivAdbConnectionOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivAdbConnectionOptionsCopyWith<PrivAdbConnectionOptions> get copyWith => _$PrivAdbConnectionOptionsCopyWithImpl<PrivAdbConnectionOptions>(this as PrivAdbConnectionOptions, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivAdbConnectionOptions;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivAdbConnectionOptions&&(identical(other.port, _this.port) || other.port == _this.port)&&(identical(other.wirelessDebuggingControl, _this.wirelessDebuggingControl) || other.wirelessDebuggingControl == _this.wirelessDebuggingControl)&&(identical(other.disableWirelessDebuggingAfterUse, _this.disableWirelessDebuggingAfterUse) || other.disableWirelessDebuggingAfterUse == _this.disableWirelessDebuggingAfterUse)&&(identical(other.portDiscoveryTimeoutMillis, _this.portDiscoveryTimeoutMillis) || other.portDiscoveryTimeoutMillis == _this.portDiscoveryTimeoutMillis)&&(identical(other.connectRetryCount, _this.connectRetryCount) || other.connectRetryCount == _this.connectRetryCount)&&(identical(other.connectRetryDelayMillis, _this.connectRetryDelayMillis) || other.connectRetryDelayMillis == _this.connectRetryDelayMillis));
}


@override
int get hashCode {
  final _this = this as PrivAdbConnectionOptions;
  return Object.hash(runtimeType,_this.port,_this.wirelessDebuggingControl,_this.disableWirelessDebuggingAfterUse,_this.portDiscoveryTimeoutMillis,_this.connectRetryCount,_this.connectRetryDelayMillis);
}

@override
String toString() {
  final _this = this as PrivAdbConnectionOptions;
  return 'PrivAdbConnectionOptions(port: ${_this.port}, wirelessDebuggingControl: ${_this.wirelessDebuggingControl}, disableWirelessDebuggingAfterUse: ${_this.disableWirelessDebuggingAfterUse}, portDiscoveryTimeoutMillis: ${_this.portDiscoveryTimeoutMillis}, connectRetryCount: ${_this.connectRetryCount}, connectRetryDelayMillis: ${_this.connectRetryDelayMillis})';
}


}

/// @nodoc
abstract mixin class $PrivAdbConnectionOptionsCopyWith<$Res>  {
  factory $PrivAdbConnectionOptionsCopyWith(PrivAdbConnectionOptions value, $Res Function(PrivAdbConnectionOptions) _then) = _$PrivAdbConnectionOptionsCopyWithImpl;
@useResult
$Res call({
 int? port, PrivAdbWirelessDebuggingControl wirelessDebuggingControl, bool disableWirelessDebuggingAfterUse, int portDiscoveryTimeoutMillis, int connectRetryCount, int connectRetryDelayMillis
});




}
/// @nodoc
class _$PrivAdbConnectionOptionsCopyWithImpl<$Res>
    implements $PrivAdbConnectionOptionsCopyWith<$Res> {
  _$PrivAdbConnectionOptionsCopyWithImpl(this._self, this._then);

  final PrivAdbConnectionOptions _self;
  final $Res Function(PrivAdbConnectionOptions) _then;

/// Create a copy of PrivAdbConnectionOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? port = freezed,Object? wirelessDebuggingControl = null,Object? disableWirelessDebuggingAfterUse = null,Object? portDiscoveryTimeoutMillis = null,Object? connectRetryCount = null,Object? connectRetryDelayMillis = null,}) {
  return _then(PrivAdbConnectionOptions(
port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,wirelessDebuggingControl: null == wirelessDebuggingControl ? _self.wirelessDebuggingControl : wirelessDebuggingControl // ignore: cast_nullable_to_non_nullable
as PrivAdbWirelessDebuggingControl,disableWirelessDebuggingAfterUse: null == disableWirelessDebuggingAfterUse ? _self.disableWirelessDebuggingAfterUse : disableWirelessDebuggingAfterUse // ignore: cast_nullable_to_non_nullable
as bool,portDiscoveryTimeoutMillis: null == portDiscoveryTimeoutMillis ? _self.portDiscoveryTimeoutMillis : portDiscoveryTimeoutMillis // ignore: cast_nullable_to_non_nullable
as int,connectRetryCount: null == connectRetryCount ? _self.connectRetryCount : connectRetryCount // ignore: cast_nullable_to_non_nullable
as int,connectRetryDelayMillis: null == connectRetryDelayMillis ? _self.connectRetryDelayMillis : connectRetryDelayMillis // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivAdbConnectionOptions].
extension PrivAdbConnectionOptionsPatterns on PrivAdbConnectionOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivAdbConnectionOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivAdbConnectionOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivAdbConnectionOptions value)  $default,){
final _that = this;
switch (_that) {
case _PrivAdbConnectionOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivAdbConnectionOptions value)?  $default,){
final _that = this;
switch (_that) {
case _PrivAdbConnectionOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? port,  PrivAdbWirelessDebuggingControl wirelessDebuggingControl,  bool disableWirelessDebuggingAfterUse,  int portDiscoveryTimeoutMillis,  int connectRetryCount,  int connectRetryDelayMillis)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivAdbConnectionOptions() when $default != null:
return $default(_that.port,_that.wirelessDebuggingControl,_that.disableWirelessDebuggingAfterUse,_that.portDiscoveryTimeoutMillis,_that.connectRetryCount,_that.connectRetryDelayMillis);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? port,  PrivAdbWirelessDebuggingControl wirelessDebuggingControl,  bool disableWirelessDebuggingAfterUse,  int portDiscoveryTimeoutMillis,  int connectRetryCount,  int connectRetryDelayMillis)  $default,) {final _that = this;
switch (_that) {
case _PrivAdbConnectionOptions():
return $default(_that.port,_that.wirelessDebuggingControl,_that.disableWirelessDebuggingAfterUse,_that.portDiscoveryTimeoutMillis,_that.connectRetryCount,_that.connectRetryDelayMillis);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? port,  PrivAdbWirelessDebuggingControl wirelessDebuggingControl,  bool disableWirelessDebuggingAfterUse,  int portDiscoveryTimeoutMillis,  int connectRetryCount,  int connectRetryDelayMillis)?  $default,) {final _that = this;
switch (_that) {
case _PrivAdbConnectionOptions() when $default != null:
return $default(_that.port,_that.wirelessDebuggingControl,_that.disableWirelessDebuggingAfterUse,_that.portDiscoveryTimeoutMillis,_that.connectRetryCount,_that.connectRetryDelayMillis);case _:
  return null;

}
}

}

/// @nodoc


class _PrivAdbConnectionOptions extends PrivAdbConnectionOptions {
  const _PrivAdbConnectionOptions({this.port, this.wirelessDebuggingControl = PrivAdbWirelessDebuggingControl.ifAvailable, this.disableWirelessDebuggingAfterUse = true, this.portDiscoveryTimeoutMillis = 15000, this.connectRetryCount = 5, this.connectRetryDelayMillis = 1000}): assert(portDiscoveryTimeoutMillis > 0),assert(connectRetryCount > 0),assert(connectRetryDelayMillis >= 0),super._();
  

/// ADB connect port. `null` discovers the Wireless Debugging connect port.
@override final  int? port;
@override@JsonKey() final  PrivAdbWirelessDebuggingControl wirelessDebuggingControl;
@override@JsonKey() final  bool disableWirelessDebuggingAfterUse;
@override@JsonKey() final  int portDiscoveryTimeoutMillis;
@override@JsonKey() final  int connectRetryCount;
@override@JsonKey() final  int connectRetryDelayMillis;

/// Create a copy of PrivAdbConnectionOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivAdbConnectionOptionsCopyWith<_PrivAdbConnectionOptions> get copyWith => __$PrivAdbConnectionOptionsCopyWithImpl<_PrivAdbConnectionOptions>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivAdbConnectionOptions&&(identical(other.port, port) || other.port == port)&&(identical(other.wirelessDebuggingControl, wirelessDebuggingControl) || other.wirelessDebuggingControl == wirelessDebuggingControl)&&(identical(other.disableWirelessDebuggingAfterUse, disableWirelessDebuggingAfterUse) || other.disableWirelessDebuggingAfterUse == disableWirelessDebuggingAfterUse)&&(identical(other.portDiscoveryTimeoutMillis, portDiscoveryTimeoutMillis) || other.portDiscoveryTimeoutMillis == portDiscoveryTimeoutMillis)&&(identical(other.connectRetryCount, connectRetryCount) || other.connectRetryCount == connectRetryCount)&&(identical(other.connectRetryDelayMillis, connectRetryDelayMillis) || other.connectRetryDelayMillis == connectRetryDelayMillis));
}


@override
int get hashCode {
    return Object.hash(runtimeType,port,wirelessDebuggingControl,disableWirelessDebuggingAfterUse,portDiscoveryTimeoutMillis,connectRetryCount,connectRetryDelayMillis);
}

@override
String toString() {
    return 'PrivAdbConnectionOptions(port: $port, wirelessDebuggingControl: $wirelessDebuggingControl, disableWirelessDebuggingAfterUse: $disableWirelessDebuggingAfterUse, portDiscoveryTimeoutMillis: $portDiscoveryTimeoutMillis, connectRetryCount: $connectRetryCount, connectRetryDelayMillis: $connectRetryDelayMillis)';
}


}

/// @nodoc
abstract mixin class _$PrivAdbConnectionOptionsCopyWith<$Res> implements $PrivAdbConnectionOptionsCopyWith<$Res> {
  factory _$PrivAdbConnectionOptionsCopyWith(_PrivAdbConnectionOptions value, $Res Function(_PrivAdbConnectionOptions) _then) = __$PrivAdbConnectionOptionsCopyWithImpl;
@override @useResult
$Res call({
 int? port, PrivAdbWirelessDebuggingControl wirelessDebuggingControl, bool disableWirelessDebuggingAfterUse, int portDiscoveryTimeoutMillis, int connectRetryCount, int connectRetryDelayMillis
});




}
/// @nodoc
class __$PrivAdbConnectionOptionsCopyWithImpl<$Res>
    implements _$PrivAdbConnectionOptionsCopyWith<$Res> {
  __$PrivAdbConnectionOptionsCopyWithImpl(this._self, this._then);

  final _PrivAdbConnectionOptions _self;
  final $Res Function(_PrivAdbConnectionOptions) _then;

/// Create a copy of PrivAdbConnectionOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? port = freezed,Object? wirelessDebuggingControl = null,Object? disableWirelessDebuggingAfterUse = null,Object? portDiscoveryTimeoutMillis = null,Object? connectRetryCount = null,Object? connectRetryDelayMillis = null,}) {
  return _then(_PrivAdbConnectionOptions(
port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,wirelessDebuggingControl: null == wirelessDebuggingControl ? _self.wirelessDebuggingControl : wirelessDebuggingControl // ignore: cast_nullable_to_non_nullable
as PrivAdbWirelessDebuggingControl,disableWirelessDebuggingAfterUse: null == disableWirelessDebuggingAfterUse ? _self.disableWirelessDebuggingAfterUse : disableWirelessDebuggingAfterUse // ignore: cast_nullable_to_non_nullable
as bool,portDiscoveryTimeoutMillis: null == portDiscoveryTimeoutMillis ? _self.portDiscoveryTimeoutMillis : portDiscoveryTimeoutMillis // ignore: cast_nullable_to_non_nullable
as int,connectRetryCount: null == connectRetryCount ? _self.connectRetryCount : connectRetryCount // ignore: cast_nullable_to_non_nullable
as int,connectRetryDelayMillis: null == connectRetryDelayMillis ? _self.connectRetryDelayMillis : connectRetryDelayMillis // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PrivAdbIdentityInfo {

 String get deviceName; String get publicKeyFingerprint;
/// Create a copy of PrivAdbIdentityInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivAdbIdentityInfoCopyWith<PrivAdbIdentityInfo> get copyWith => _$PrivAdbIdentityInfoCopyWithImpl<PrivAdbIdentityInfo>(this as PrivAdbIdentityInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivAdbIdentityInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivAdbIdentityInfo&&(identical(other.deviceName, _this.deviceName) || other.deviceName == _this.deviceName)&&(identical(other.publicKeyFingerprint, _this.publicKeyFingerprint) || other.publicKeyFingerprint == _this.publicKeyFingerprint));
}


@override
int get hashCode {
  final _this = this as PrivAdbIdentityInfo;
  return Object.hash(runtimeType,_this.deviceName,_this.publicKeyFingerprint);
}

@override
String toString() {
  final _this = this as PrivAdbIdentityInfo;
  return 'PrivAdbIdentityInfo(deviceName: ${_this.deviceName}, publicKeyFingerprint: ${_this.publicKeyFingerprint})';
}


}

/// @nodoc
abstract mixin class $PrivAdbIdentityInfoCopyWith<$Res>  {
  factory $PrivAdbIdentityInfoCopyWith(PrivAdbIdentityInfo value, $Res Function(PrivAdbIdentityInfo) _then) = _$PrivAdbIdentityInfoCopyWithImpl;
@useResult
$Res call({
 String deviceName, String publicKeyFingerprint
});




}
/// @nodoc
class _$PrivAdbIdentityInfoCopyWithImpl<$Res>
    implements $PrivAdbIdentityInfoCopyWith<$Res> {
  _$PrivAdbIdentityInfoCopyWithImpl(this._self, this._then);

  final PrivAdbIdentityInfo _self;
  final $Res Function(PrivAdbIdentityInfo) _then;

/// Create a copy of PrivAdbIdentityInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceName = null,Object? publicKeyFingerprint = null,}) {
  return _then(PrivAdbIdentityInfo(
deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,publicKeyFingerprint: null == publicKeyFingerprint ? _self.publicKeyFingerprint : publicKeyFingerprint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivAdbIdentityInfo].
extension PrivAdbIdentityInfoPatterns on PrivAdbIdentityInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivAdbIdentityInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivAdbIdentityInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivAdbIdentityInfo value)  $default,){
final _that = this;
switch (_that) {
case _PrivAdbIdentityInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivAdbIdentityInfo value)?  $default,){
final _that = this;
switch (_that) {
case _PrivAdbIdentityInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceName,  String publicKeyFingerprint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivAdbIdentityInfo() when $default != null:
return $default(_that.deviceName,_that.publicKeyFingerprint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceName,  String publicKeyFingerprint)  $default,) {final _that = this;
switch (_that) {
case _PrivAdbIdentityInfo():
return $default(_that.deviceName,_that.publicKeyFingerprint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceName,  String publicKeyFingerprint)?  $default,) {final _that = this;
switch (_that) {
case _PrivAdbIdentityInfo() when $default != null:
return $default(_that.deviceName,_that.publicKeyFingerprint);case _:
  return null;

}
}

}

/// @nodoc


class _PrivAdbIdentityInfo extends PrivAdbIdentityInfo {
  const _PrivAdbIdentityInfo({required this.deviceName, required this.publicKeyFingerprint}): super._();
  

@override final  String deviceName;
@override final  String publicKeyFingerprint;

/// Create a copy of PrivAdbIdentityInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivAdbIdentityInfoCopyWith<_PrivAdbIdentityInfo> get copyWith => __$PrivAdbIdentityInfoCopyWithImpl<_PrivAdbIdentityInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivAdbIdentityInfo&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.publicKeyFingerprint, publicKeyFingerprint) || other.publicKeyFingerprint == publicKeyFingerprint));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceName,publicKeyFingerprint);
}

@override
String toString() {
    return 'PrivAdbIdentityInfo(deviceName: $deviceName, publicKeyFingerprint: $publicKeyFingerprint)';
}


}

/// @nodoc
abstract mixin class _$PrivAdbIdentityInfoCopyWith<$Res> implements $PrivAdbIdentityInfoCopyWith<$Res> {
  factory _$PrivAdbIdentityInfoCopyWith(_PrivAdbIdentityInfo value, $Res Function(_PrivAdbIdentityInfo) _then) = __$PrivAdbIdentityInfoCopyWithImpl;
@override @useResult
$Res call({
 String deviceName, String publicKeyFingerprint
});




}
/// @nodoc
class __$PrivAdbIdentityInfoCopyWithImpl<$Res>
    implements _$PrivAdbIdentityInfoCopyWith<$Res> {
  __$PrivAdbIdentityInfoCopyWithImpl(this._self, this._then);

  final _PrivAdbIdentityInfo _self;
  final $Res Function(_PrivAdbIdentityInfo) _then;

/// Create a copy of PrivAdbIdentityInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceName = null,Object? publicKeyFingerprint = null,}) {
  return _then(_PrivAdbIdentityInfo(
deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,publicKeyFingerprint: null == publicKeyFingerprint ? _self.publicKeyFingerprint : publicKeyFingerprint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PrivAdbPairingResult {

 int get port; String get deviceName; String get publicKeyFingerprint;
/// Create a copy of PrivAdbPairingResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivAdbPairingResultCopyWith<PrivAdbPairingResult> get copyWith => _$PrivAdbPairingResultCopyWithImpl<PrivAdbPairingResult>(this as PrivAdbPairingResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivAdbPairingResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivAdbPairingResult&&(identical(other.port, _this.port) || other.port == _this.port)&&(identical(other.deviceName, _this.deviceName) || other.deviceName == _this.deviceName)&&(identical(other.publicKeyFingerprint, _this.publicKeyFingerprint) || other.publicKeyFingerprint == _this.publicKeyFingerprint));
}


@override
int get hashCode {
  final _this = this as PrivAdbPairingResult;
  return Object.hash(runtimeType,_this.port,_this.deviceName,_this.publicKeyFingerprint);
}

@override
String toString() {
  final _this = this as PrivAdbPairingResult;
  return 'PrivAdbPairingResult(port: ${_this.port}, deviceName: ${_this.deviceName}, publicKeyFingerprint: ${_this.publicKeyFingerprint})';
}


}

/// @nodoc
abstract mixin class $PrivAdbPairingResultCopyWith<$Res>  {
  factory $PrivAdbPairingResultCopyWith(PrivAdbPairingResult value, $Res Function(PrivAdbPairingResult) _then) = _$PrivAdbPairingResultCopyWithImpl;
@useResult
$Res call({
 int port, String deviceName, String publicKeyFingerprint
});




}
/// @nodoc
class _$PrivAdbPairingResultCopyWithImpl<$Res>
    implements $PrivAdbPairingResultCopyWith<$Res> {
  _$PrivAdbPairingResultCopyWithImpl(this._self, this._then);

  final PrivAdbPairingResult _self;
  final $Res Function(PrivAdbPairingResult) _then;

/// Create a copy of PrivAdbPairingResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? port = null,Object? deviceName = null,Object? publicKeyFingerprint = null,}) {
  return _then(PrivAdbPairingResult(
port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,publicKeyFingerprint: null == publicKeyFingerprint ? _self.publicKeyFingerprint : publicKeyFingerprint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivAdbPairingResult].
extension PrivAdbPairingResultPatterns on PrivAdbPairingResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivAdbPairingResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivAdbPairingResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivAdbPairingResult value)  $default,){
final _that = this;
switch (_that) {
case _PrivAdbPairingResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivAdbPairingResult value)?  $default,){
final _that = this;
switch (_that) {
case _PrivAdbPairingResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int port,  String deviceName,  String publicKeyFingerprint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivAdbPairingResult() when $default != null:
return $default(_that.port,_that.deviceName,_that.publicKeyFingerprint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int port,  String deviceName,  String publicKeyFingerprint)  $default,) {final _that = this;
switch (_that) {
case _PrivAdbPairingResult():
return $default(_that.port,_that.deviceName,_that.publicKeyFingerprint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int port,  String deviceName,  String publicKeyFingerprint)?  $default,) {final _that = this;
switch (_that) {
case _PrivAdbPairingResult() when $default != null:
return $default(_that.port,_that.deviceName,_that.publicKeyFingerprint);case _:
  return null;

}
}

}

/// @nodoc


class _PrivAdbPairingResult extends PrivAdbPairingResult {
  const _PrivAdbPairingResult({required this.port, required this.deviceName, required this.publicKeyFingerprint}): super._();
  

@override final  int port;
@override final  String deviceName;
@override final  String publicKeyFingerprint;

/// Create a copy of PrivAdbPairingResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivAdbPairingResultCopyWith<_PrivAdbPairingResult> get copyWith => __$PrivAdbPairingResultCopyWithImpl<_PrivAdbPairingResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivAdbPairingResult&&(identical(other.port, port) || other.port == port)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.publicKeyFingerprint, publicKeyFingerprint) || other.publicKeyFingerprint == publicKeyFingerprint));
}


@override
int get hashCode {
    return Object.hash(runtimeType,port,deviceName,publicKeyFingerprint);
}

@override
String toString() {
    return 'PrivAdbPairingResult(port: $port, deviceName: $deviceName, publicKeyFingerprint: $publicKeyFingerprint)';
}


}

/// @nodoc
abstract mixin class _$PrivAdbPairingResultCopyWith<$Res> implements $PrivAdbPairingResultCopyWith<$Res> {
  factory _$PrivAdbPairingResultCopyWith(_PrivAdbPairingResult value, $Res Function(_PrivAdbPairingResult) _then) = __$PrivAdbPairingResultCopyWithImpl;
@override @useResult
$Res call({
 int port, String deviceName, String publicKeyFingerprint
});




}
/// @nodoc
class __$PrivAdbPairingResultCopyWithImpl<$Res>
    implements _$PrivAdbPairingResultCopyWith<$Res> {
  __$PrivAdbPairingResultCopyWithImpl(this._self, this._then);

  final _PrivAdbPairingResult _self;
  final $Res Function(_PrivAdbPairingResult) _then;

/// Create a copy of PrivAdbPairingResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? port = null,Object? deviceName = null,Object? publicKeyFingerprint = null,}) {
  return _then(_PrivAdbPairingResult(
port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,publicKeyFingerprint: null == publicKeyFingerprint ? _self.publicKeyFingerprint : publicKeyFingerprint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PrivAdbPairingCheckResult {

 int? get port;/// Whether the app's saved ADB key has been authorized on the device.
 bool get paired; String get outputText; String get deviceName; String get publicKeyFingerprint; PrivAdbPairingCheckStatus get status; String? get failureMessage;
/// Create a copy of PrivAdbPairingCheckResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivAdbPairingCheckResultCopyWith<PrivAdbPairingCheckResult> get copyWith => _$PrivAdbPairingCheckResultCopyWithImpl<PrivAdbPairingCheckResult>(this as PrivAdbPairingCheckResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivAdbPairingCheckResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivAdbPairingCheckResult&&(identical(other.port, _this.port) || other.port == _this.port)&&(identical(other.paired, _this.paired) || other.paired == _this.paired)&&(identical(other.outputText, _this.outputText) || other.outputText == _this.outputText)&&(identical(other.deviceName, _this.deviceName) || other.deviceName == _this.deviceName)&&(identical(other.publicKeyFingerprint, _this.publicKeyFingerprint) || other.publicKeyFingerprint == _this.publicKeyFingerprint)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.failureMessage, _this.failureMessage) || other.failureMessage == _this.failureMessage));
}


@override
int get hashCode {
  final _this = this as PrivAdbPairingCheckResult;
  return Object.hash(runtimeType,_this.port,_this.paired,_this.outputText,_this.deviceName,_this.publicKeyFingerprint,_this.status,_this.failureMessage);
}

@override
String toString() {
  final _this = this as PrivAdbPairingCheckResult;
  return 'PrivAdbPairingCheckResult(port: ${_this.port}, paired: ${_this.paired}, outputText: ${_this.outputText}, deviceName: ${_this.deviceName}, publicKeyFingerprint: ${_this.publicKeyFingerprint}, status: ${_this.status}, failureMessage: ${_this.failureMessage})';
}


}

/// @nodoc
abstract mixin class $PrivAdbPairingCheckResultCopyWith<$Res>  {
  factory $PrivAdbPairingCheckResultCopyWith(PrivAdbPairingCheckResult value, $Res Function(PrivAdbPairingCheckResult) _then) = _$PrivAdbPairingCheckResultCopyWithImpl;
@useResult
$Res call({
 int? port, bool paired, String outputText, String deviceName, String publicKeyFingerprint, PrivAdbPairingCheckStatus status, String? failureMessage
});




}
/// @nodoc
class _$PrivAdbPairingCheckResultCopyWithImpl<$Res>
    implements $PrivAdbPairingCheckResultCopyWith<$Res> {
  _$PrivAdbPairingCheckResultCopyWithImpl(this._self, this._then);

  final PrivAdbPairingCheckResult _self;
  final $Res Function(PrivAdbPairingCheckResult) _then;

/// Create a copy of PrivAdbPairingCheckResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? port = freezed,Object? paired = null,Object? outputText = null,Object? deviceName = null,Object? publicKeyFingerprint = null,Object? status = null,Object? failureMessage = freezed,}) {
  return _then(PrivAdbPairingCheckResult(
port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,paired: null == paired ? _self.paired : paired // ignore: cast_nullable_to_non_nullable
as bool,outputText: null == outputText ? _self.outputText : outputText // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,publicKeyFingerprint: null == publicKeyFingerprint ? _self.publicKeyFingerprint : publicKeyFingerprint // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PrivAdbPairingCheckStatus,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivAdbPairingCheckResult].
extension PrivAdbPairingCheckResultPatterns on PrivAdbPairingCheckResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivAdbPairingCheckResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivAdbPairingCheckResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivAdbPairingCheckResult value)  $default,){
final _that = this;
switch (_that) {
case _PrivAdbPairingCheckResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivAdbPairingCheckResult value)?  $default,){
final _that = this;
switch (_that) {
case _PrivAdbPairingCheckResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? port,  bool paired,  String outputText,  String deviceName,  String publicKeyFingerprint,  PrivAdbPairingCheckStatus status,  String? failureMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivAdbPairingCheckResult() when $default != null:
return $default(_that.port,_that.paired,_that.outputText,_that.deviceName,_that.publicKeyFingerprint,_that.status,_that.failureMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? port,  bool paired,  String outputText,  String deviceName,  String publicKeyFingerprint,  PrivAdbPairingCheckStatus status,  String? failureMessage)  $default,) {final _that = this;
switch (_that) {
case _PrivAdbPairingCheckResult():
return $default(_that.port,_that.paired,_that.outputText,_that.deviceName,_that.publicKeyFingerprint,_that.status,_that.failureMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? port,  bool paired,  String outputText,  String deviceName,  String publicKeyFingerprint,  PrivAdbPairingCheckStatus status,  String? failureMessage)?  $default,) {final _that = this;
switch (_that) {
case _PrivAdbPairingCheckResult() when $default != null:
return $default(_that.port,_that.paired,_that.outputText,_that.deviceName,_that.publicKeyFingerprint,_that.status,_that.failureMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PrivAdbPairingCheckResult extends PrivAdbPairingCheckResult {
  const _PrivAdbPairingCheckResult({this.port, this.paired = false, this.outputText = '', this.deviceName = '', this.publicKeyFingerprint = '', required this.status, this.failureMessage}): super._();
  

@override final  int? port;
/// Whether the app's saved ADB key has been authorized on the device.
@override@JsonKey() final  bool paired;
@override@JsonKey() final  String outputText;
@override@JsonKey() final  String deviceName;
@override@JsonKey() final  String publicKeyFingerprint;
@override final  PrivAdbPairingCheckStatus status;
@override final  String? failureMessage;

/// Create a copy of PrivAdbPairingCheckResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivAdbPairingCheckResultCopyWith<_PrivAdbPairingCheckResult> get copyWith => __$PrivAdbPairingCheckResultCopyWithImpl<_PrivAdbPairingCheckResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivAdbPairingCheckResult&&(identical(other.port, port) || other.port == port)&&(identical(other.paired, paired) || other.paired == paired)&&(identical(other.outputText, outputText) || other.outputText == outputText)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.publicKeyFingerprint, publicKeyFingerprint) || other.publicKeyFingerprint == publicKeyFingerprint)&&(identical(other.status, status) || other.status == status)&&(identical(other.failureMessage, failureMessage) || other.failureMessage == failureMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,port,paired,outputText,deviceName,publicKeyFingerprint,status,failureMessage);
}

@override
String toString() {
    return 'PrivAdbPairingCheckResult(port: $port, paired: $paired, outputText: $outputText, deviceName: $deviceName, publicKeyFingerprint: $publicKeyFingerprint, status: $status, failureMessage: $failureMessage)';
}


}

/// @nodoc
abstract mixin class _$PrivAdbPairingCheckResultCopyWith<$Res> implements $PrivAdbPairingCheckResultCopyWith<$Res> {
  factory _$PrivAdbPairingCheckResultCopyWith(_PrivAdbPairingCheckResult value, $Res Function(_PrivAdbPairingCheckResult) _then) = __$PrivAdbPairingCheckResultCopyWithImpl;
@override @useResult
$Res call({
 int? port, bool paired, String outputText, String deviceName, String publicKeyFingerprint, PrivAdbPairingCheckStatus status, String? failureMessage
});




}
/// @nodoc
class __$PrivAdbPairingCheckResultCopyWithImpl<$Res>
    implements _$PrivAdbPairingCheckResultCopyWith<$Res> {
  __$PrivAdbPairingCheckResultCopyWithImpl(this._self, this._then);

  final _PrivAdbPairingCheckResult _self;
  final $Res Function(_PrivAdbPairingCheckResult) _then;

/// Create a copy of PrivAdbPairingCheckResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? port = freezed,Object? paired = null,Object? outputText = null,Object? deviceName = null,Object? publicKeyFingerprint = null,Object? status = null,Object? failureMessage = freezed,}) {
  return _then(_PrivAdbPairingCheckResult(
port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,paired: null == paired ? _self.paired : paired // ignore: cast_nullable_to_non_nullable
as bool,outputText: null == outputText ? _self.outputText : outputText // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,publicKeyFingerprint: null == publicKeyFingerprint ? _self.publicKeyFingerprint : publicKeyFingerprint // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PrivAdbPairingCheckStatus,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PrivAdbAuthorizationCheckResult {

 PrivAdbAuthorizationStatus get status; String get outputText; String get deviceName; String get publicKeyFingerprint; String? get failureMessage;
/// Create a copy of PrivAdbAuthorizationCheckResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivAdbAuthorizationCheckResultCopyWith<PrivAdbAuthorizationCheckResult> get copyWith => _$PrivAdbAuthorizationCheckResultCopyWithImpl<PrivAdbAuthorizationCheckResult>(this as PrivAdbAuthorizationCheckResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivAdbAuthorizationCheckResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivAdbAuthorizationCheckResult&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.outputText, _this.outputText) || other.outputText == _this.outputText)&&(identical(other.deviceName, _this.deviceName) || other.deviceName == _this.deviceName)&&(identical(other.publicKeyFingerprint, _this.publicKeyFingerprint) || other.publicKeyFingerprint == _this.publicKeyFingerprint)&&(identical(other.failureMessage, _this.failureMessage) || other.failureMessage == _this.failureMessage));
}


@override
int get hashCode {
  final _this = this as PrivAdbAuthorizationCheckResult;
  return Object.hash(runtimeType,_this.status,_this.outputText,_this.deviceName,_this.publicKeyFingerprint,_this.failureMessage);
}

@override
String toString() {
  final _this = this as PrivAdbAuthorizationCheckResult;
  return 'PrivAdbAuthorizationCheckResult(status: ${_this.status}, outputText: ${_this.outputText}, deviceName: ${_this.deviceName}, publicKeyFingerprint: ${_this.publicKeyFingerprint}, failureMessage: ${_this.failureMessage})';
}


}

/// @nodoc
abstract mixin class $PrivAdbAuthorizationCheckResultCopyWith<$Res>  {
  factory $PrivAdbAuthorizationCheckResultCopyWith(PrivAdbAuthorizationCheckResult value, $Res Function(PrivAdbAuthorizationCheckResult) _then) = _$PrivAdbAuthorizationCheckResultCopyWithImpl;
@useResult
$Res call({
 PrivAdbAuthorizationStatus status, String outputText, String deviceName, String publicKeyFingerprint, String? failureMessage
});




}
/// @nodoc
class _$PrivAdbAuthorizationCheckResultCopyWithImpl<$Res>
    implements $PrivAdbAuthorizationCheckResultCopyWith<$Res> {
  _$PrivAdbAuthorizationCheckResultCopyWithImpl(this._self, this._then);

  final PrivAdbAuthorizationCheckResult _self;
  final $Res Function(PrivAdbAuthorizationCheckResult) _then;

/// Create a copy of PrivAdbAuthorizationCheckResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? outputText = null,Object? deviceName = null,Object? publicKeyFingerprint = null,Object? failureMessage = freezed,}) {
  return _then(PrivAdbAuthorizationCheckResult(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PrivAdbAuthorizationStatus,outputText: null == outputText ? _self.outputText : outputText // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,publicKeyFingerprint: null == publicKeyFingerprint ? _self.publicKeyFingerprint : publicKeyFingerprint // ignore: cast_nullable_to_non_nullable
as String,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivAdbAuthorizationCheckResult].
extension PrivAdbAuthorizationCheckResultPatterns on PrivAdbAuthorizationCheckResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivAdbAuthorizationCheckResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivAdbAuthorizationCheckResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivAdbAuthorizationCheckResult value)  $default,){
final _that = this;
switch (_that) {
case _PrivAdbAuthorizationCheckResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivAdbAuthorizationCheckResult value)?  $default,){
final _that = this;
switch (_that) {
case _PrivAdbAuthorizationCheckResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PrivAdbAuthorizationStatus status,  String outputText,  String deviceName,  String publicKeyFingerprint,  String? failureMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivAdbAuthorizationCheckResult() when $default != null:
return $default(_that.status,_that.outputText,_that.deviceName,_that.publicKeyFingerprint,_that.failureMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PrivAdbAuthorizationStatus status,  String outputText,  String deviceName,  String publicKeyFingerprint,  String? failureMessage)  $default,) {final _that = this;
switch (_that) {
case _PrivAdbAuthorizationCheckResult():
return $default(_that.status,_that.outputText,_that.deviceName,_that.publicKeyFingerprint,_that.failureMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PrivAdbAuthorizationStatus status,  String outputText,  String deviceName,  String publicKeyFingerprint,  String? failureMessage)?  $default,) {final _that = this;
switch (_that) {
case _PrivAdbAuthorizationCheckResult() when $default != null:
return $default(_that.status,_that.outputText,_that.deviceName,_that.publicKeyFingerprint,_that.failureMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PrivAdbAuthorizationCheckResult extends PrivAdbAuthorizationCheckResult {
  const _PrivAdbAuthorizationCheckResult({required this.status, this.outputText = '', this.deviceName = '', this.publicKeyFingerprint = '', this.failureMessage}): super._();
  

@override final  PrivAdbAuthorizationStatus status;
@override@JsonKey() final  String outputText;
@override@JsonKey() final  String deviceName;
@override@JsonKey() final  String publicKeyFingerprint;
@override final  String? failureMessage;

/// Create a copy of PrivAdbAuthorizationCheckResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivAdbAuthorizationCheckResultCopyWith<_PrivAdbAuthorizationCheckResult> get copyWith => __$PrivAdbAuthorizationCheckResultCopyWithImpl<_PrivAdbAuthorizationCheckResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivAdbAuthorizationCheckResult&&(identical(other.status, status) || other.status == status)&&(identical(other.outputText, outputText) || other.outputText == outputText)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.publicKeyFingerprint, publicKeyFingerprint) || other.publicKeyFingerprint == publicKeyFingerprint)&&(identical(other.failureMessage, failureMessage) || other.failureMessage == failureMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,outputText,deviceName,publicKeyFingerprint,failureMessage);
}

@override
String toString() {
    return 'PrivAdbAuthorizationCheckResult(status: $status, outputText: $outputText, deviceName: $deviceName, publicKeyFingerprint: $publicKeyFingerprint, failureMessage: $failureMessage)';
}


}

/// @nodoc
abstract mixin class _$PrivAdbAuthorizationCheckResultCopyWith<$Res> implements $PrivAdbAuthorizationCheckResultCopyWith<$Res> {
  factory _$PrivAdbAuthorizationCheckResultCopyWith(_PrivAdbAuthorizationCheckResult value, $Res Function(_PrivAdbAuthorizationCheckResult) _then) = __$PrivAdbAuthorizationCheckResultCopyWithImpl;
@override @useResult
$Res call({
 PrivAdbAuthorizationStatus status, String outputText, String deviceName, String publicKeyFingerprint, String? failureMessage
});




}
/// @nodoc
class __$PrivAdbAuthorizationCheckResultCopyWithImpl<$Res>
    implements _$PrivAdbAuthorizationCheckResultCopyWith<$Res> {
  __$PrivAdbAuthorizationCheckResultCopyWithImpl(this._self, this._then);

  final _PrivAdbAuthorizationCheckResult _self;
  final $Res Function(_PrivAdbAuthorizationCheckResult) _then;

/// Create a copy of PrivAdbAuthorizationCheckResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? outputText = null,Object? deviceName = null,Object? publicKeyFingerprint = null,Object? failureMessage = freezed,}) {
  return _then(_PrivAdbAuthorizationCheckResult(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PrivAdbAuthorizationStatus,outputText: null == outputText ? _self.outputText : outputText // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,publicKeyFingerprint: null == publicKeyFingerprint ? _self.publicKeyFingerprint : publicKeyFingerprint // ignore: cast_nullable_to_non_nullable
as String,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PrivAdbAuthorizationRequestResult {

 bool get authorized; String get outputText; PrivAdbAuthorizationEndReason? get endReason; String? get failureMessage;
/// Create a copy of PrivAdbAuthorizationRequestResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivAdbAuthorizationRequestResultCopyWith<PrivAdbAuthorizationRequestResult> get copyWith => _$PrivAdbAuthorizationRequestResultCopyWithImpl<PrivAdbAuthorizationRequestResult>(this as PrivAdbAuthorizationRequestResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivAdbAuthorizationRequestResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivAdbAuthorizationRequestResult&&(identical(other.authorized, _this.authorized) || other.authorized == _this.authorized)&&(identical(other.outputText, _this.outputText) || other.outputText == _this.outputText)&&(identical(other.endReason, _this.endReason) || other.endReason == _this.endReason)&&(identical(other.failureMessage, _this.failureMessage) || other.failureMessage == _this.failureMessage));
}


@override
int get hashCode {
  final _this = this as PrivAdbAuthorizationRequestResult;
  return Object.hash(runtimeType,_this.authorized,_this.outputText,_this.endReason,_this.failureMessage);
}

@override
String toString() {
  final _this = this as PrivAdbAuthorizationRequestResult;
  return 'PrivAdbAuthorizationRequestResult(authorized: ${_this.authorized}, outputText: ${_this.outputText}, endReason: ${_this.endReason}, failureMessage: ${_this.failureMessage})';
}


}

/// @nodoc
abstract mixin class $PrivAdbAuthorizationRequestResultCopyWith<$Res>  {
  factory $PrivAdbAuthorizationRequestResultCopyWith(PrivAdbAuthorizationRequestResult value, $Res Function(PrivAdbAuthorizationRequestResult) _then) = _$PrivAdbAuthorizationRequestResultCopyWithImpl;
@useResult
$Res call({
 bool authorized, String outputText, PrivAdbAuthorizationEndReason? endReason, String? failureMessage
});




}
/// @nodoc
class _$PrivAdbAuthorizationRequestResultCopyWithImpl<$Res>
    implements $PrivAdbAuthorizationRequestResultCopyWith<$Res> {
  _$PrivAdbAuthorizationRequestResultCopyWithImpl(this._self, this._then);

  final PrivAdbAuthorizationRequestResult _self;
  final $Res Function(PrivAdbAuthorizationRequestResult) _then;

/// Create a copy of PrivAdbAuthorizationRequestResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authorized = null,Object? outputText = null,Object? endReason = freezed,Object? failureMessage = freezed,}) {
  return _then(PrivAdbAuthorizationRequestResult(
authorized: null == authorized ? _self.authorized : authorized // ignore: cast_nullable_to_non_nullable
as bool,outputText: null == outputText ? _self.outputText : outputText // ignore: cast_nullable_to_non_nullable
as String,endReason: freezed == endReason ? _self.endReason : endReason // ignore: cast_nullable_to_non_nullable
as PrivAdbAuthorizationEndReason?,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivAdbAuthorizationRequestResult].
extension PrivAdbAuthorizationRequestResultPatterns on PrivAdbAuthorizationRequestResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivAdbAuthorizationRequestResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivAdbAuthorizationRequestResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivAdbAuthorizationRequestResult value)  $default,){
final _that = this;
switch (_that) {
case _PrivAdbAuthorizationRequestResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivAdbAuthorizationRequestResult value)?  $default,){
final _that = this;
switch (_that) {
case _PrivAdbAuthorizationRequestResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool authorized,  String outputText,  PrivAdbAuthorizationEndReason? endReason,  String? failureMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivAdbAuthorizationRequestResult() when $default != null:
return $default(_that.authorized,_that.outputText,_that.endReason,_that.failureMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool authorized,  String outputText,  PrivAdbAuthorizationEndReason? endReason,  String? failureMessage)  $default,) {final _that = this;
switch (_that) {
case _PrivAdbAuthorizationRequestResult():
return $default(_that.authorized,_that.outputText,_that.endReason,_that.failureMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool authorized,  String outputText,  PrivAdbAuthorizationEndReason? endReason,  String? failureMessage)?  $default,) {final _that = this;
switch (_that) {
case _PrivAdbAuthorizationRequestResult() when $default != null:
return $default(_that.authorized,_that.outputText,_that.endReason,_that.failureMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PrivAdbAuthorizationRequestResult extends PrivAdbAuthorizationRequestResult {
  const _PrivAdbAuthorizationRequestResult({this.authorized = false, this.outputText = '', this.endReason, this.failureMessage}): super._();
  

@override@JsonKey() final  bool authorized;
@override@JsonKey() final  String outputText;
@override final  PrivAdbAuthorizationEndReason? endReason;
@override final  String? failureMessage;

/// Create a copy of PrivAdbAuthorizationRequestResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivAdbAuthorizationRequestResultCopyWith<_PrivAdbAuthorizationRequestResult> get copyWith => __$PrivAdbAuthorizationRequestResultCopyWithImpl<_PrivAdbAuthorizationRequestResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivAdbAuthorizationRequestResult&&(identical(other.authorized, authorized) || other.authorized == authorized)&&(identical(other.outputText, outputText) || other.outputText == outputText)&&(identical(other.endReason, endReason) || other.endReason == endReason)&&(identical(other.failureMessage, failureMessage) || other.failureMessage == failureMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,authorized,outputText,endReason,failureMessage);
}

@override
String toString() {
    return 'PrivAdbAuthorizationRequestResult(authorized: $authorized, outputText: $outputText, endReason: $endReason, failureMessage: $failureMessage)';
}


}

/// @nodoc
abstract mixin class _$PrivAdbAuthorizationRequestResultCopyWith<$Res> implements $PrivAdbAuthorizationRequestResultCopyWith<$Res> {
  factory _$PrivAdbAuthorizationRequestResultCopyWith(_PrivAdbAuthorizationRequestResult value, $Res Function(_PrivAdbAuthorizationRequestResult) _then) = __$PrivAdbAuthorizationRequestResultCopyWithImpl;
@override @useResult
$Res call({
 bool authorized, String outputText, PrivAdbAuthorizationEndReason? endReason, String? failureMessage
});




}
/// @nodoc
class __$PrivAdbAuthorizationRequestResultCopyWithImpl<$Res>
    implements _$PrivAdbAuthorizationRequestResultCopyWith<$Res> {
  __$PrivAdbAuthorizationRequestResultCopyWithImpl(this._self, this._then);

  final _PrivAdbAuthorizationRequestResult _self;
  final $Res Function(_PrivAdbAuthorizationRequestResult) _then;

/// Create a copy of PrivAdbAuthorizationRequestResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authorized = null,Object? outputText = null,Object? endReason = freezed,Object? failureMessage = freezed,}) {
  return _then(_PrivAdbAuthorizationRequestResult(
authorized: null == authorized ? _self.authorized : authorized // ignore: cast_nullable_to_non_nullable
as bool,outputText: null == outputText ? _self.outputText : outputText // ignore: cast_nullable_to_non_nullable
as String,endReason: freezed == endReason ? _self.endReason : endReason // ignore: cast_nullable_to_non_nullable
as PrivAdbAuthorizationEndReason?,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PrivAdbTcpResult {

 int get port; String get outputText; String get deviceName; String get publicKeyFingerprint;
/// Create a copy of PrivAdbTcpResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivAdbTcpResultCopyWith<PrivAdbTcpResult> get copyWith => _$PrivAdbTcpResultCopyWithImpl<PrivAdbTcpResult>(this as PrivAdbTcpResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivAdbTcpResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivAdbTcpResult&&(identical(other.port, _this.port) || other.port == _this.port)&&(identical(other.outputText, _this.outputText) || other.outputText == _this.outputText)&&(identical(other.deviceName, _this.deviceName) || other.deviceName == _this.deviceName)&&(identical(other.publicKeyFingerprint, _this.publicKeyFingerprint) || other.publicKeyFingerprint == _this.publicKeyFingerprint));
}


@override
int get hashCode {
  final _this = this as PrivAdbTcpResult;
  return Object.hash(runtimeType,_this.port,_this.outputText,_this.deviceName,_this.publicKeyFingerprint);
}

@override
String toString() {
  final _this = this as PrivAdbTcpResult;
  return 'PrivAdbTcpResult(port: ${_this.port}, outputText: ${_this.outputText}, deviceName: ${_this.deviceName}, publicKeyFingerprint: ${_this.publicKeyFingerprint})';
}


}

/// @nodoc
abstract mixin class $PrivAdbTcpResultCopyWith<$Res>  {
  factory $PrivAdbTcpResultCopyWith(PrivAdbTcpResult value, $Res Function(PrivAdbTcpResult) _then) = _$PrivAdbTcpResultCopyWithImpl;
@useResult
$Res call({
 int port, String outputText, String deviceName, String publicKeyFingerprint
});




}
/// @nodoc
class _$PrivAdbTcpResultCopyWithImpl<$Res>
    implements $PrivAdbTcpResultCopyWith<$Res> {
  _$PrivAdbTcpResultCopyWithImpl(this._self, this._then);

  final PrivAdbTcpResult _self;
  final $Res Function(PrivAdbTcpResult) _then;

/// Create a copy of PrivAdbTcpResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? port = null,Object? outputText = null,Object? deviceName = null,Object? publicKeyFingerprint = null,}) {
  return _then(PrivAdbTcpResult(
port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,outputText: null == outputText ? _self.outputText : outputText // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,publicKeyFingerprint: null == publicKeyFingerprint ? _self.publicKeyFingerprint : publicKeyFingerprint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivAdbTcpResult].
extension PrivAdbTcpResultPatterns on PrivAdbTcpResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivAdbTcpResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivAdbTcpResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivAdbTcpResult value)  $default,){
final _that = this;
switch (_that) {
case _PrivAdbTcpResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivAdbTcpResult value)?  $default,){
final _that = this;
switch (_that) {
case _PrivAdbTcpResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int port,  String outputText,  String deviceName,  String publicKeyFingerprint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivAdbTcpResult() when $default != null:
return $default(_that.port,_that.outputText,_that.deviceName,_that.publicKeyFingerprint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int port,  String outputText,  String deviceName,  String publicKeyFingerprint)  $default,) {final _that = this;
switch (_that) {
case _PrivAdbTcpResult():
return $default(_that.port,_that.outputText,_that.deviceName,_that.publicKeyFingerprint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int port,  String outputText,  String deviceName,  String publicKeyFingerprint)?  $default,) {final _that = this;
switch (_that) {
case _PrivAdbTcpResult() when $default != null:
return $default(_that.port,_that.outputText,_that.deviceName,_that.publicKeyFingerprint);case _:
  return null;

}
}

}

/// @nodoc


class _PrivAdbTcpResult extends PrivAdbTcpResult {
  const _PrivAdbTcpResult({required this.port, this.outputText = '', this.deviceName = '', this.publicKeyFingerprint = ''}): super._();
  

@override final  int port;
@override@JsonKey() final  String outputText;
@override@JsonKey() final  String deviceName;
@override@JsonKey() final  String publicKeyFingerprint;

/// Create a copy of PrivAdbTcpResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivAdbTcpResultCopyWith<_PrivAdbTcpResult> get copyWith => __$PrivAdbTcpResultCopyWithImpl<_PrivAdbTcpResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivAdbTcpResult&&(identical(other.port, port) || other.port == port)&&(identical(other.outputText, outputText) || other.outputText == outputText)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.publicKeyFingerprint, publicKeyFingerprint) || other.publicKeyFingerprint == publicKeyFingerprint));
}


@override
int get hashCode {
    return Object.hash(runtimeType,port,outputText,deviceName,publicKeyFingerprint);
}

@override
String toString() {
    return 'PrivAdbTcpResult(port: $port, outputText: $outputText, deviceName: $deviceName, publicKeyFingerprint: $publicKeyFingerprint)';
}


}

/// @nodoc
abstract mixin class _$PrivAdbTcpResultCopyWith<$Res> implements $PrivAdbTcpResultCopyWith<$Res> {
  factory _$PrivAdbTcpResultCopyWith(_PrivAdbTcpResult value, $Res Function(_PrivAdbTcpResult) _then) = __$PrivAdbTcpResultCopyWithImpl;
@override @useResult
$Res call({
 int port, String outputText, String deviceName, String publicKeyFingerprint
});




}
/// @nodoc
class __$PrivAdbTcpResultCopyWithImpl<$Res>
    implements _$PrivAdbTcpResultCopyWith<$Res> {
  __$PrivAdbTcpResultCopyWithImpl(this._self, this._then);

  final _PrivAdbTcpResult _self;
  final $Res Function(_PrivAdbTcpResult) _then;

/// Create a copy of PrivAdbTcpResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? port = null,Object? outputText = null,Object? deviceName = null,Object? publicKeyFingerprint = null,}) {
  return _then(_PrivAdbTcpResult(
port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,outputText: null == outputText ? _self.outputText : outputText // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,publicKeyFingerprint: null == publicKeyFingerprint ? _self.publicKeyFingerprint : publicKeyFingerprint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PrivAdbWirelessDebuggingControlStatus {

 bool get supported;/// Whether `WRITE_SECURE_SETTINGS` is declared in the manifest.
 bool get permissionDeclared;/// Whether `WRITE_SECURE_SETTINGS` has actually been granted.
 bool get permissionGranted; bool get wirelessDebuggingEnabled;/// Whether the runtime can toggle Wireless Debugging on this device.
 bool get canManage; String? get failureMessage;
/// Create a copy of PrivAdbWirelessDebuggingControlStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivAdbWirelessDebuggingControlStatusCopyWith<PrivAdbWirelessDebuggingControlStatus> get copyWith => _$PrivAdbWirelessDebuggingControlStatusCopyWithImpl<PrivAdbWirelessDebuggingControlStatus>(this as PrivAdbWirelessDebuggingControlStatus, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivAdbWirelessDebuggingControlStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivAdbWirelessDebuggingControlStatus&&(identical(other.supported, _this.supported) || other.supported == _this.supported)&&(identical(other.permissionDeclared, _this.permissionDeclared) || other.permissionDeclared == _this.permissionDeclared)&&(identical(other.permissionGranted, _this.permissionGranted) || other.permissionGranted == _this.permissionGranted)&&(identical(other.wirelessDebuggingEnabled, _this.wirelessDebuggingEnabled) || other.wirelessDebuggingEnabled == _this.wirelessDebuggingEnabled)&&(identical(other.canManage, _this.canManage) || other.canManage == _this.canManage)&&(identical(other.failureMessage, _this.failureMessage) || other.failureMessage == _this.failureMessage));
}


@override
int get hashCode {
  final _this = this as PrivAdbWirelessDebuggingControlStatus;
  return Object.hash(runtimeType,_this.supported,_this.permissionDeclared,_this.permissionGranted,_this.wirelessDebuggingEnabled,_this.canManage,_this.failureMessage);
}

@override
String toString() {
  final _this = this as PrivAdbWirelessDebuggingControlStatus;
  return 'PrivAdbWirelessDebuggingControlStatus(supported: ${_this.supported}, permissionDeclared: ${_this.permissionDeclared}, permissionGranted: ${_this.permissionGranted}, wirelessDebuggingEnabled: ${_this.wirelessDebuggingEnabled}, canManage: ${_this.canManage}, failureMessage: ${_this.failureMessage})';
}


}

/// @nodoc
abstract mixin class $PrivAdbWirelessDebuggingControlStatusCopyWith<$Res>  {
  factory $PrivAdbWirelessDebuggingControlStatusCopyWith(PrivAdbWirelessDebuggingControlStatus value, $Res Function(PrivAdbWirelessDebuggingControlStatus) _then) = _$PrivAdbWirelessDebuggingControlStatusCopyWithImpl;
@useResult
$Res call({
 bool supported, bool permissionDeclared, bool permissionGranted, bool wirelessDebuggingEnabled, bool canManage, String? failureMessage
});




}
/// @nodoc
class _$PrivAdbWirelessDebuggingControlStatusCopyWithImpl<$Res>
    implements $PrivAdbWirelessDebuggingControlStatusCopyWith<$Res> {
  _$PrivAdbWirelessDebuggingControlStatusCopyWithImpl(this._self, this._then);

  final PrivAdbWirelessDebuggingControlStatus _self;
  final $Res Function(PrivAdbWirelessDebuggingControlStatus) _then;

/// Create a copy of PrivAdbWirelessDebuggingControlStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? supported = null,Object? permissionDeclared = null,Object? permissionGranted = null,Object? wirelessDebuggingEnabled = null,Object? canManage = null,Object? failureMessage = freezed,}) {
  return _then(PrivAdbWirelessDebuggingControlStatus(
supported: null == supported ? _self.supported : supported // ignore: cast_nullable_to_non_nullable
as bool,permissionDeclared: null == permissionDeclared ? _self.permissionDeclared : permissionDeclared // ignore: cast_nullable_to_non_nullable
as bool,permissionGranted: null == permissionGranted ? _self.permissionGranted : permissionGranted // ignore: cast_nullable_to_non_nullable
as bool,wirelessDebuggingEnabled: null == wirelessDebuggingEnabled ? _self.wirelessDebuggingEnabled : wirelessDebuggingEnabled // ignore: cast_nullable_to_non_nullable
as bool,canManage: null == canManage ? _self.canManage : canManage // ignore: cast_nullable_to_non_nullable
as bool,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivAdbWirelessDebuggingControlStatus].
extension PrivAdbWirelessDebuggingControlStatusPatterns on PrivAdbWirelessDebuggingControlStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivAdbWirelessDebuggingControlStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivAdbWirelessDebuggingControlStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivAdbWirelessDebuggingControlStatus value)  $default,){
final _that = this;
switch (_that) {
case _PrivAdbWirelessDebuggingControlStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivAdbWirelessDebuggingControlStatus value)?  $default,){
final _that = this;
switch (_that) {
case _PrivAdbWirelessDebuggingControlStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool supported,  bool permissionDeclared,  bool permissionGranted,  bool wirelessDebuggingEnabled,  bool canManage,  String? failureMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivAdbWirelessDebuggingControlStatus() when $default != null:
return $default(_that.supported,_that.permissionDeclared,_that.permissionGranted,_that.wirelessDebuggingEnabled,_that.canManage,_that.failureMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool supported,  bool permissionDeclared,  bool permissionGranted,  bool wirelessDebuggingEnabled,  bool canManage,  String? failureMessage)  $default,) {final _that = this;
switch (_that) {
case _PrivAdbWirelessDebuggingControlStatus():
return $default(_that.supported,_that.permissionDeclared,_that.permissionGranted,_that.wirelessDebuggingEnabled,_that.canManage,_that.failureMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool supported,  bool permissionDeclared,  bool permissionGranted,  bool wirelessDebuggingEnabled,  bool canManage,  String? failureMessage)?  $default,) {final _that = this;
switch (_that) {
case _PrivAdbWirelessDebuggingControlStatus() when $default != null:
return $default(_that.supported,_that.permissionDeclared,_that.permissionGranted,_that.wirelessDebuggingEnabled,_that.canManage,_that.failureMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PrivAdbWirelessDebuggingControlStatus extends PrivAdbWirelessDebuggingControlStatus {
  const _PrivAdbWirelessDebuggingControlStatus({this.supported = false, this.permissionDeclared = false, this.permissionGranted = false, this.wirelessDebuggingEnabled = false, this.canManage = false, this.failureMessage}): super._();
  

@override@JsonKey() final  bool supported;
/// Whether `WRITE_SECURE_SETTINGS` is declared in the manifest.
@override@JsonKey() final  bool permissionDeclared;
/// Whether `WRITE_SECURE_SETTINGS` has actually been granted.
@override@JsonKey() final  bool permissionGranted;
@override@JsonKey() final  bool wirelessDebuggingEnabled;
/// Whether the runtime can toggle Wireless Debugging on this device.
@override@JsonKey() final  bool canManage;
@override final  String? failureMessage;

/// Create a copy of PrivAdbWirelessDebuggingControlStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivAdbWirelessDebuggingControlStatusCopyWith<_PrivAdbWirelessDebuggingControlStatus> get copyWith => __$PrivAdbWirelessDebuggingControlStatusCopyWithImpl<_PrivAdbWirelessDebuggingControlStatus>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivAdbWirelessDebuggingControlStatus&&(identical(other.supported, supported) || other.supported == supported)&&(identical(other.permissionDeclared, permissionDeclared) || other.permissionDeclared == permissionDeclared)&&(identical(other.permissionGranted, permissionGranted) || other.permissionGranted == permissionGranted)&&(identical(other.wirelessDebuggingEnabled, wirelessDebuggingEnabled) || other.wirelessDebuggingEnabled == wirelessDebuggingEnabled)&&(identical(other.canManage, canManage) || other.canManage == canManage)&&(identical(other.failureMessage, failureMessage) || other.failureMessage == failureMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,supported,permissionDeclared,permissionGranted,wirelessDebuggingEnabled,canManage,failureMessage);
}

@override
String toString() {
    return 'PrivAdbWirelessDebuggingControlStatus(supported: $supported, permissionDeclared: $permissionDeclared, permissionGranted: $permissionGranted, wirelessDebuggingEnabled: $wirelessDebuggingEnabled, canManage: $canManage, failureMessage: $failureMessage)';
}


}

/// @nodoc
abstract mixin class _$PrivAdbWirelessDebuggingControlStatusCopyWith<$Res> implements $PrivAdbWirelessDebuggingControlStatusCopyWith<$Res> {
  factory _$PrivAdbWirelessDebuggingControlStatusCopyWith(_PrivAdbWirelessDebuggingControlStatus value, $Res Function(_PrivAdbWirelessDebuggingControlStatus) _then) = __$PrivAdbWirelessDebuggingControlStatusCopyWithImpl;
@override @useResult
$Res call({
 bool supported, bool permissionDeclared, bool permissionGranted, bool wirelessDebuggingEnabled, bool canManage, String? failureMessage
});




}
/// @nodoc
class __$PrivAdbWirelessDebuggingControlStatusCopyWithImpl<$Res>
    implements _$PrivAdbWirelessDebuggingControlStatusCopyWith<$Res> {
  __$PrivAdbWirelessDebuggingControlStatusCopyWithImpl(this._self, this._then);

  final _PrivAdbWirelessDebuggingControlStatus _self;
  final $Res Function(_PrivAdbWirelessDebuggingControlStatus) _then;

/// Create a copy of PrivAdbWirelessDebuggingControlStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? supported = null,Object? permissionDeclared = null,Object? permissionGranted = null,Object? wirelessDebuggingEnabled = null,Object? canManage = null,Object? failureMessage = freezed,}) {
  return _then(_PrivAdbWirelessDebuggingControlStatus(
supported: null == supported ? _self.supported : supported // ignore: cast_nullable_to_non_nullable
as bool,permissionDeclared: null == permissionDeclared ? _self.permissionDeclared : permissionDeclared // ignore: cast_nullable_to_non_nullable
as bool,permissionGranted: null == permissionGranted ? _self.permissionGranted : permissionGranted // ignore: cast_nullable_to_non_nullable
as bool,wirelessDebuggingEnabled: null == wirelessDebuggingEnabled ? _self.wirelessDebuggingEnabled : wirelessDebuggingEnabled // ignore: cast_nullable_to_non_nullable
as bool,canManage: null == canManage ? _self.canManage : canManage // ignore: cast_nullable_to_non_nullable
as bool,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
