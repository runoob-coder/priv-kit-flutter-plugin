import 'package:freezed_annotation/freezed_annotation.dart';

part 'file.freezed.dart';

/// Default number of bytes requested per [PrivKit.fileRead] call: 64 KiB.
const int privilegeFileDefaultReadChunkBytes = 64 * 1024;

/// Default maximum number of entries between pipe flushes during a walk.
const int privilegeFileDefaultWalkFlushBatchSize = 32;

/// Filesystem object type, mirroring `priv.kit.core.file.PrivilegeFileType`.
enum PrivFileType {
  regularFile('REGULAR_FILE'),
  directory('DIRECTORY'),
  symbolicLink('SYMBOLIC_LINK'),
  blockDevice('BLOCK_DEVICE'),
  characterDevice('CHARACTER_DEVICE'),
  fifo('FIFO'),
  socket('SOCKET'),
  other('OTHER');

  const PrivFileType(this.wireName);

  /// Name used on the platform channel.
  final String wireName;

  /// Decodes the name sent by the Android side.
  static PrivFileType fromWireName(String? name) {
    for (final value in values) {
      if (value.wireName == name) return value;
    }
    return other;
  }
}

/// A single, uncached metadata snapshot read by the Privileged Server.
///
/// Mirrors `priv.kit.core.file.PrivilegeFileMetadata`.
@freezed
abstract class PrivFileMetadata with _$PrivFileMetadata {
  const factory PrivFileMetadata({
    required String absolutePath,
    required int sizeBytes,
    required int lastModifiedMillis,
    required int unixMode,
    required int uid,
    required int gid,
    required PrivFileType type,
  }) = _PrivFileMetadata;

  const PrivFileMetadata._();

  factory PrivFileMetadata.fromMap(Map<dynamic, dynamic> map) =>
      PrivFileMetadata(
        absolutePath: map['absolutePath'] as String,
        sizeBytes: (map['sizeBytes'] as num).toInt(),
        lastModifiedMillis: (map['lastModifiedMillis'] as num).toInt(),
        unixMode: (map['unixMode'] as num).toInt(),
        uid: (map['uid'] as num).toInt(),
        gid: (map['gid'] as num).toInt(),
        type: PrivFileType.fromWireName(map['type'] as String?),
      );

  /// Last modification time as a [DateTime].
  DateTime get lastModified =>
      DateTime.fromMillisecondsSinceEpoch(lastModifiedMillis);

  /// The final path segment.
  String get name => absolutePath.split('/').last;
}

/// One descendant emitted while walking a directory.
///
/// Mirrors `priv.kit.core.file.PrivilegeFileEntry`.
///
/// [metadata] is null when the server can enumerate the name but cannot read
/// that entry's attributes. Such entries are emitted but never entered.
@freezed
abstract class PrivFileEntry with _$PrivFileEntry {
  const factory PrivFileEntry({
    required String absolutePath,
    required int depth,
    PrivFileMetadata? metadata,
  }) = _PrivFileEntry;

  const PrivFileEntry._();

  factory PrivFileEntry.fromMap(Map<dynamic, dynamic> map) => PrivFileEntry(
    absolutePath: map['absolutePath'] as String,
    depth: (map['depth'] as num).toInt(),
    metadata: map['metadata'] == null
        ? null
        : PrivFileMetadata.fromMap(map['metadata']! as Map<dynamic, dynamic>),
  );

  /// The final path segment.
  String get name => absolutePath.split('/').last;
}
