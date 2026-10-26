// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Priv Kit example';

  @override
  String get serverNotConnectedHint =>
      'Commands require a connected Privileged Server';

  @override
  String get logsTitle => 'Logs';

  @override
  String get logsEmpty => 'No logs yet';

  @override
  String get logsClear => 'Clear';

  @override
  String get logsClose => 'Close';

  @override
  String get serverCardTitle => 'Privileged Server';

  @override
  String get serverDisconnected => 'Disconnected';

  @override
  String serverConnected(String root) {
    return 'Connected (root=$root)';
  }

  @override
  String serverUidLine(int uid, int pid, int protocol) {
    return 'uid=$uid pid=$pid protocol=$protocol';
  }

  @override
  String serverSelinux(String context) {
    return 'selinux=$context';
  }

  @override
  String get actionRoot => 'Start as Root';

  @override
  String get actionAdb => 'Start Wireless Debugging';

  @override
  String get actionAdbTcp => 'Start over TCP/IP';

  @override
  String get actionCheckPairing => 'Check Pairing';

  @override
  String get actionNativeStarter => 'Manual Start Command';

  @override
  String get actionDeniedPerms => 'Denied Permissions';

  @override
  String get actionCrashLogs => 'Crash Logs';

  @override
  String get actionShutdown => 'Shutdown Server';

  @override
  String get actionRunId => 'Run id (aggregated)';

  @override
  String get actionStreamCount => 'Run Command (streaming)';

  @override
  String get actionCancelCommand => 'Cancel Command';

  @override
  String get cmdPanelTitle => 'Run Command Manually';

  @override
  String get cmdPanelFooter =>
      'No stdin or PTY: interactive programs, terminal signals and ANSI rendering are unsupported.';

  @override
  String get fieldCommand => 'Command';

  @override
  String get placeholderCommand => 'id -u';

  @override
  String get switchUseShell => 'Execute via shell';

  @override
  String get switchUseShellSub =>
      'The command API does not add a shell implicitly';

  @override
  String get fieldWorkDir => 'Working directory (optional, absolute path)';

  @override
  String get placeholderWorkDir => '/data/local/tmp';

  @override
  String get fieldEnv => 'Environment (optional, one KEY=VALUE per line)';

  @override
  String get placeholderEnv => 'LANG=C';

  @override
  String get fieldTimeout => 'Timeout (ms)';

  @override
  String get placeholderTimeout => 'Leave blank for 30000';

  @override
  String get checkDisableTimeout => 'Disable timeout';

  @override
  String get errEmptyCommand => 'Please enter a command';

  @override
  String get errEmptyExecutable => 'Please enter an executable';

  @override
  String get errTimeoutPositive =>
      'Timeout must be a positive integer in milliseconds';

  @override
  String envFormat(String line) {
    return 'Environment must be KEY=VALUE: $line';
  }

  @override
  String get btnRunAggregate => 'Run and aggregate output';

  @override
  String get btnStream => 'Stream output';

  @override
  String get btnStopStream => 'Stop streaming command';

  @override
  String get userServiceTitle => 'UserService';

  @override
  String get userServiceDesc =>
      'DemoPrivilegeService is an AIDL service written by the app, running in the privileged process. The plugin controls start/stop from Dart; calling custom methods must go through the app\'s own Kotlin channel (see DemoUserServiceBridge).';

  @override
  String get switchEmbedded => 'Embedded';

  @override
  String get switchEmbeddedSub =>
      'When on, the service runs inside the Privileged Server process';

  @override
  String get btnStart => 'Start';

  @override
  String get btnBind => 'Bind (get handle)';

  @override
  String get btnCallAidl => 'Call AIDL methods';

  @override
  String get btnStop => 'Stop';

  @override
  String get binderTitle => 'Binder';

  @override
  String get binderDesc =>
      'Binder cannot cross the platform channel: Dart can only obtain an integer handle and query liveness and the descriptor. The real transaction must be issued on the Kotlin side (see DemoBinderBridge).';

  @override
  String get fieldServiceName => 'System service name';

  @override
  String get placeholderServiceName => 'activity';

  @override
  String get switchServerProcess => 'Look up from server process';

  @override
  String get switchServerProcessSub =>
      'Some services are only visible to shell / root';

  @override
  String get fieldDumpArgs => 'DUMP args (optional, space separated)';

  @override
  String get btnProbe => 'Probe service (handle)';

  @override
  String get btnDump => 'DUMP (Kotlin side)';

  @override
  String get btnLifecycle => 'Server lifecycle Binder';

  @override
  String get filePanelTitle => 'File Proxy';

  @override
  String get filePanelFooter =>
      'File operations run inside the server process, so they can read and write paths the app itself cannot access. Deleting a directory recurses automatically.';

  @override
  String get fieldPath => 'Absolute path';

  @override
  String get errPathAbsolute => 'Path must be absolute';

  @override
  String get btnInspect => 'Inspect';

  @override
  String get btnWrite => 'Write';

  @override
  String get btnRead => 'Read';

  @override
  String get btnList => 'List one level';

  @override
  String get btnDelete => 'Delete';
}
