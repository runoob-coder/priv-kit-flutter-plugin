// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrivFileMetadata {

 String get absolutePath; int get sizeBytes; int get lastModifiedMillis; int get unixMode; int get uid; int get gid; PrivFileType get type;
/// Create a copy of PrivFileMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivFileMetadataCopyWith<PrivFileMetadata> get copyWith => _$PrivFileMetadataCopyWithImpl<PrivFileMetadata>(this as PrivFileMetadata, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivFileMetadata;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivFileMetadata&&(identical(other.absolutePath, _this.absolutePath) || other.absolutePath == _this.absolutePath)&&(identical(other.sizeBytes, _this.sizeBytes) || other.sizeBytes == _this.sizeBytes)&&(identical(other.lastModifiedMillis, _this.lastModifiedMillis) || other.lastModifiedMillis == _this.lastModifiedMillis)&&(identical(other.unixMode, _this.unixMode) || other.unixMode == _this.unixMode)&&(identical(other.uid, _this.uid) || other.uid == _this.uid)&&(identical(other.gid, _this.gid) || other.gid == _this.gid)&&(identical(other.type, _this.type) || other.type == _this.type));
}


@override
int get hashCode {
  final _this = this as PrivFileMetadata;
  return Object.hash(runtimeType,_this.absolutePath,_this.sizeBytes,_this.lastModifiedMillis,_this.unixMode,_this.uid,_this.gid,_this.type);
}

@override
String toString() {
  final _this = this as PrivFileMetadata;
  return 'PrivFileMetadata(absolutePath: ${_this.absolutePath}, sizeBytes: ${_this.sizeBytes}, lastModifiedMillis: ${_this.lastModifiedMillis}, unixMode: ${_this.unixMode}, uid: ${_this.uid}, gid: ${_this.gid}, type: ${_this.type})';
}


}

/// @nodoc
abstract mixin class $PrivFileMetadataCopyWith<$Res>  {
  factory $PrivFileMetadataCopyWith(PrivFileMetadata value, $Res Function(PrivFileMetadata) _then) = _$PrivFileMetadataCopyWithImpl;
@useResult
$Res call({
 String absolutePath, int sizeBytes, int lastModifiedMillis, int unixMode, int uid, int gid, PrivFileType type
});




}
/// @nodoc
class _$PrivFileMetadataCopyWithImpl<$Res>
    implements $PrivFileMetadataCopyWith<$Res> {
  _$PrivFileMetadataCopyWithImpl(this._self, this._then);

  final PrivFileMetadata _self;
  final $Res Function(PrivFileMetadata) _then;

/// Create a copy of PrivFileMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? absolutePath = null,Object? sizeBytes = null,Object? lastModifiedMillis = null,Object? unixMode = null,Object? uid = null,Object? gid = null,Object? type = null,}) {
  return _then(PrivFileMetadata(
absolutePath: null == absolutePath ? _self.absolutePath : absolutePath // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,lastModifiedMillis: null == lastModifiedMillis ? _self.lastModifiedMillis : lastModifiedMillis // ignore: cast_nullable_to_non_nullable
as int,unixMode: null == unixMode ? _self.unixMode : unixMode // ignore: cast_nullable_to_non_nullable
as int,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as int,gid: null == gid ? _self.gid : gid // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PrivFileType,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivFileMetadata].
extension PrivFileMetadataPatterns on PrivFileMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivFileMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivFileMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivFileMetadata value)  $default,){
final _that = this;
switch (_that) {
case _PrivFileMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivFileMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _PrivFileMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String absolutePath,  int sizeBytes,  int lastModifiedMillis,  int unixMode,  int uid,  int gid,  PrivFileType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivFileMetadata() when $default != null:
return $default(_that.absolutePath,_that.sizeBytes,_that.lastModifiedMillis,_that.unixMode,_that.uid,_that.gid,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String absolutePath,  int sizeBytes,  int lastModifiedMillis,  int unixMode,  int uid,  int gid,  PrivFileType type)  $default,) {final _that = this;
switch (_that) {
case _PrivFileMetadata():
return $default(_that.absolutePath,_that.sizeBytes,_that.lastModifiedMillis,_that.unixMode,_that.uid,_that.gid,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String absolutePath,  int sizeBytes,  int lastModifiedMillis,  int unixMode,  int uid,  int gid,  PrivFileType type)?  $default,) {final _that = this;
switch (_that) {
case _PrivFileMetadata() when $default != null:
return $default(_that.absolutePath,_that.sizeBytes,_that.lastModifiedMillis,_that.unixMode,_that.uid,_that.gid,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _PrivFileMetadata extends PrivFileMetadata {
  const _PrivFileMetadata({required this.absolutePath, required this.sizeBytes, required this.lastModifiedMillis, required this.unixMode, required this.uid, required this.gid, required this.type}): super._();
  

@override final  String absolutePath;
@override final  int sizeBytes;
@override final  int lastModifiedMillis;
@override final  int unixMode;
@override final  int uid;
@override final  int gid;
@override final  PrivFileType type;

/// Create a copy of PrivFileMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivFileMetadataCopyWith<_PrivFileMetadata> get copyWith => __$PrivFileMetadataCopyWithImpl<_PrivFileMetadata>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivFileMetadata&&(identical(other.absolutePath, absolutePath) || other.absolutePath == absolutePath)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.lastModifiedMillis, lastModifiedMillis) || other.lastModifiedMillis == lastModifiedMillis)&&(identical(other.unixMode, unixMode) || other.unixMode == unixMode)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.gid, gid) || other.gid == gid)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode {
    return Object.hash(runtimeType,absolutePath,sizeBytes,lastModifiedMillis,unixMode,uid,gid,type);
}

@override
String toString() {
    return 'PrivFileMetadata(absolutePath: $absolutePath, sizeBytes: $sizeBytes, lastModifiedMillis: $lastModifiedMillis, unixMode: $unixMode, uid: $uid, gid: $gid, type: $type)';
}


}

/// @nodoc
abstract mixin class _$PrivFileMetadataCopyWith<$Res> implements $PrivFileMetadataCopyWith<$Res> {
  factory _$PrivFileMetadataCopyWith(_PrivFileMetadata value, $Res Function(_PrivFileMetadata) _then) = __$PrivFileMetadataCopyWithImpl;
@override @useResult
$Res call({
 String absolutePath, int sizeBytes, int lastModifiedMillis, int unixMode, int uid, int gid, PrivFileType type
});




}
/// @nodoc
class __$PrivFileMetadataCopyWithImpl<$Res>
    implements _$PrivFileMetadataCopyWith<$Res> {
  __$PrivFileMetadataCopyWithImpl(this._self, this._then);

  final _PrivFileMetadata _self;
  final $Res Function(_PrivFileMetadata) _then;

/// Create a copy of PrivFileMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? absolutePath = null,Object? sizeBytes = null,Object? lastModifiedMillis = null,Object? unixMode = null,Object? uid = null,Object? gid = null,Object? type = null,}) {
  return _then(_PrivFileMetadata(
absolutePath: null == absolutePath ? _self.absolutePath : absolutePath // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,lastModifiedMillis: null == lastModifiedMillis ? _self.lastModifiedMillis : lastModifiedMillis // ignore: cast_nullable_to_non_nullable
as int,unixMode: null == unixMode ? _self.unixMode : unixMode // ignore: cast_nullable_to_non_nullable
as int,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as int,gid: null == gid ? _self.gid : gid // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PrivFileType,
  ));
}


}

/// @nodoc
mixin _$PrivFileEntry {

 String get absolutePath; int get depth; PrivFileMetadata? get metadata;
/// Create a copy of PrivFileEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivFileEntryCopyWith<PrivFileEntry> get copyWith => _$PrivFileEntryCopyWithImpl<PrivFileEntry>(this as PrivFileEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivFileEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivFileEntry&&(identical(other.absolutePath, _this.absolutePath) || other.absolutePath == _this.absolutePath)&&(identical(other.depth, _this.depth) || other.depth == _this.depth)&&(identical(other.metadata, _this.metadata) || other.metadata == _this.metadata));
}


@override
int get hashCode {
  final _this = this as PrivFileEntry;
  return Object.hash(runtimeType,_this.absolutePath,_this.depth,_this.metadata);
}

@override
String toString() {
  final _this = this as PrivFileEntry;
  return 'PrivFileEntry(absolutePath: ${_this.absolutePath}, depth: ${_this.depth}, metadata: ${_this.metadata})';
}


}

/// @nodoc
abstract mixin class $PrivFileEntryCopyWith<$Res>  {
  factory $PrivFileEntryCopyWith(PrivFileEntry value, $Res Function(PrivFileEntry) _then) = _$PrivFileEntryCopyWithImpl;
@useResult
$Res call({
 String absolutePath, int depth, PrivFileMetadata? metadata
});


$PrivFileMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$PrivFileEntryCopyWithImpl<$Res>
    implements $PrivFileEntryCopyWith<$Res> {
  _$PrivFileEntryCopyWithImpl(this._self, this._then);

  final PrivFileEntry _self;
  final $Res Function(PrivFileEntry) _then;

/// Create a copy of PrivFileEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? absolutePath = null,Object? depth = null,Object? metadata = freezed,}) {
  return _then(PrivFileEntry(
absolutePath: null == absolutePath ? _self.absolutePath : absolutePath // ignore: cast_nullable_to_non_nullable
as String,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as PrivFileMetadata?,
  ));
}
/// Create a copy of PrivFileEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrivFileMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $PrivFileMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [PrivFileEntry].
extension PrivFileEntryPatterns on PrivFileEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivFileEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivFileEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivFileEntry value)  $default,){
final _that = this;
switch (_that) {
case _PrivFileEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivFileEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PrivFileEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String absolutePath,  int depth,  PrivFileMetadata? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivFileEntry() when $default != null:
return $default(_that.absolutePath,_that.depth,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String absolutePath,  int depth,  PrivFileMetadata? metadata)  $default,) {final _that = this;
switch (_that) {
case _PrivFileEntry():
return $default(_that.absolutePath,_that.depth,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String absolutePath,  int depth,  PrivFileMetadata? metadata)?  $default,) {final _that = this;
switch (_that) {
case _PrivFileEntry() when $default != null:
return $default(_that.absolutePath,_that.depth,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc


class _PrivFileEntry extends PrivFileEntry {
  const _PrivFileEntry({required this.absolutePath, required this.depth, this.metadata}): super._();
  

@override final  String absolutePath;
@override final  int depth;
@override final  PrivFileMetadata? metadata;

/// Create a copy of PrivFileEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivFileEntryCopyWith<_PrivFileEntry> get copyWith => __$PrivFileEntryCopyWithImpl<_PrivFileEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivFileEntry&&(identical(other.absolutePath, absolutePath) || other.absolutePath == absolutePath)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}


@override
int get hashCode {
    return Object.hash(runtimeType,absolutePath,depth,metadata);
}

@override
String toString() {
    return 'PrivFileEntry(absolutePath: $absolutePath, depth: $depth, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$PrivFileEntryCopyWith<$Res> implements $PrivFileEntryCopyWith<$Res> {
  factory _$PrivFileEntryCopyWith(_PrivFileEntry value, $Res Function(_PrivFileEntry) _then) = __$PrivFileEntryCopyWithImpl;
@override @useResult
$Res call({
 String absolutePath, int depth, PrivFileMetadata? metadata
});


@override $PrivFileMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$PrivFileEntryCopyWithImpl<$Res>
    implements _$PrivFileEntryCopyWith<$Res> {
  __$PrivFileEntryCopyWithImpl(this._self, this._then);

  final _PrivFileEntry _self;
  final $Res Function(_PrivFileEntry) _then;

/// Create a copy of PrivFileEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? absolutePath = null,Object? depth = null,Object? metadata = freezed,}) {
  return _then(_PrivFileEntry(
absolutePath: null == absolutePath ? _self.absolutePath : absolutePath // ignore: cast_nullable_to_non_nullable
as String,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as PrivFileMetadata?,
  ));
}

/// Create a copy of PrivFileEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrivFileMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $PrivFileMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
