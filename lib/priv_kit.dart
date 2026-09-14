/// Flutter bindings for the Priv Kit Android runtime (`priv-core`).
///
/// Start with [PrivKit.startRoot] or [PrivKit.startAdb], then follow
/// [PrivKit.serverState] to observe the connection.
library;

export 'src/exceptions.dart';
export 'src/models/adb.dart';
export 'src/models/command.dart';
export 'src/models/external_startup.dart';
export 'src/models/server_info.dart';
export 'src/models/startup_log.dart';
export 'src/priv_kit.dart';
