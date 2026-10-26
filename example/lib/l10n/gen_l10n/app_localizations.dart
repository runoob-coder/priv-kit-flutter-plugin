import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// Title shown in the app bar.
  ///
  /// In en, this message translates to:
  /// **'Priv Kit example'**
  String get appTitle;

  /// Hint shown when no server is connected.
  ///
  /// In en, this message translates to:
  /// **'Commands require a connected Privileged Server'**
  String get serverNotConnectedHint;

  /// Section title for the log output.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logsTitle;

  /// Shown in the log dialog when there are no entries.
  ///
  /// In en, this message translates to:
  /// **'No logs yet'**
  String get logsEmpty;

  /// Button in the log dialog to clear all logs.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get logsClear;

  /// Button to close the log dialog.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get logsClose;

  /// Title of the server status card.
  ///
  /// In en, this message translates to:
  /// **'Privileged Server'**
  String get serverCardTitle;

  /// Shown when the server is not connected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get serverDisconnected;

  /// Shown when the server is connected.
  ///
  /// In en, this message translates to:
  /// **'Connected (root={root})'**
  String serverConnected(String root);

  /// Server identity line.
  ///
  /// In en, this message translates to:
  /// **'uid={uid} pid={pid} protocol={protocol}'**
  String serverUidLine(int uid, int pid, int protocol);

  /// SELinux context line.
  ///
  /// In en, this message translates to:
  /// **'selinux={context}'**
  String serverSelinux(String context);

  /// Button: start the server as root.
  ///
  /// In en, this message translates to:
  /// **'Start as Root'**
  String get actionRoot;

  /// Button: start over wireless debugging.
  ///
  /// In en, this message translates to:
  /// **'Start Wireless Debugging'**
  String get actionAdb;

  /// Button: start over TCP/IP.
  ///
  /// In en, this message translates to:
  /// **'Start over TCP/IP'**
  String get actionAdbTcp;

  /// Button: check ADB pairing.
  ///
  /// In en, this message translates to:
  /// **'Check Pairing'**
  String get actionCheckPairing;

  /// Button: fetch the manual starter command.
  ///
  /// In en, this message translates to:
  /// **'Manual Start Command'**
  String get actionNativeStarter;

  /// Button: list denied permissions.
  ///
  /// In en, this message translates to:
  /// **'Denied Permissions'**
  String get actionDeniedPerms;

  /// Button: read crash logs.
  ///
  /// In en, this message translates to:
  /// **'Crash Logs'**
  String get actionCrashLogs;

  /// Button: shut down the server.
  ///
  /// In en, this message translates to:
  /// **'Shutdown Server'**
  String get actionShutdown;

  /// Button: run id and aggregate output.
  ///
  /// In en, this message translates to:
  /// **'Run id (aggregated)'**
  String get actionRunId;

  /// Button: run command and stream output.
  ///
  /// In en, this message translates to:
  /// **'Run Command (streaming)'**
  String get actionStreamCount;

  /// Button: cancel the running command.
  ///
  /// In en, this message translates to:
  /// **'Cancel Command'**
  String get actionCancelCommand;

  /// Title of the command panel.
  ///
  /// In en, this message translates to:
  /// **'Run Command Manually'**
  String get cmdPanelTitle;

  /// Footer note of the command panel.
  ///
  /// In en, this message translates to:
  /// **'No stdin or PTY: interactive programs, terminal signals and ANSI rendering are unsupported.'**
  String get cmdPanelFooter;

  /// Label for the command field.
  ///
  /// In en, this message translates to:
  /// **'Command'**
  String get fieldCommand;

  /// Placeholder for the command field.
  ///
  /// In en, this message translates to:
  /// **'id -u'**
  String get placeholderCommand;

  /// Title of the use-shell switch.
  ///
  /// In en, this message translates to:
  /// **'Execute via shell'**
  String get switchUseShell;

  /// Subtitle of the use-shell switch.
  ///
  /// In en, this message translates to:
  /// **'The command API does not add a shell implicitly'**
  String get switchUseShellSub;

  /// Label for the working directory field.
  ///
  /// In en, this message translates to:
  /// **'Working directory (optional, absolute path)'**
  String get fieldWorkDir;

  /// Placeholder for the working directory field.
  ///
  /// In en, this message translates to:
  /// **'/data/local/tmp'**
  String get placeholderWorkDir;

  /// Label for the environment field.
  ///
  /// In en, this message translates to:
  /// **'Environment (optional, one KEY=VALUE per line)'**
  String get fieldEnv;

  /// Placeholder for the environment field.
  ///
  /// In en, this message translates to:
  /// **'LANG=C'**
  String get placeholderEnv;

  /// Label for the timeout field.
  ///
  /// In en, this message translates to:
  /// **'Timeout (ms)'**
  String get fieldTimeout;

  /// Placeholder for the timeout field.
  ///
  /// In en, this message translates to:
  /// **'Leave blank for 30000'**
  String get placeholderTimeout;

  /// Title of the disable-timeout checkbox.
  ///
  /// In en, this message translates to:
  /// **'Disable timeout'**
  String get checkDisableTimeout;

  /// Error when the command field is empty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a command'**
  String get errEmptyCommand;

  /// Error when no executable is parsed.
  ///
  /// In en, this message translates to:
  /// **'Please enter an executable'**
  String get errEmptyExecutable;

  /// Error when the timeout is not a positive integer.
  ///
  /// In en, this message translates to:
  /// **'Timeout must be a positive integer in milliseconds'**
  String get errTimeoutPositive;

  /// Error when an environment line is malformed.
  ///
  /// In en, this message translates to:
  /// **'Environment must be KEY=VALUE: {line}'**
  String envFormat(String line);

  /// Button: run and aggregate output.
  ///
  /// In en, this message translates to:
  /// **'Run and aggregate output'**
  String get btnRunAggregate;

  /// Button: stream output.
  ///
  /// In en, this message translates to:
  /// **'Stream output'**
  String get btnStream;

  /// Button: stop the streaming command.
  ///
  /// In en, this message translates to:
  /// **'Stop streaming command'**
  String get btnStopStream;

  /// Title of the UserService panel.
  ///
  /// In en, this message translates to:
  /// **'UserService'**
  String get userServiceTitle;

  /// Description of the UserService panel.
  ///
  /// In en, this message translates to:
  /// **'DemoPrivilegeService is an AIDL service written by the app, running in the privileged process. The plugin controls start/stop from Dart; calling custom methods must go through the app\'s own Kotlin channel (see DemoUserServiceBridge).'**
  String get userServiceDesc;

  /// Title of the embedded switch.
  ///
  /// In en, this message translates to:
  /// **'Embedded'**
  String get switchEmbedded;

  /// Subtitle of the embedded switch.
  ///
  /// In en, this message translates to:
  /// **'When on, the service runs inside the Privileged Server process'**
  String get switchEmbeddedSub;

  /// Button: start the service.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get btnStart;

  /// Button: bind the service.
  ///
  /// In en, this message translates to:
  /// **'Bind (get handle)'**
  String get btnBind;

  /// Button: call AIDL methods.
  ///
  /// In en, this message translates to:
  /// **'Call AIDL methods'**
  String get btnCallAidl;

  /// Button: stop the service.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get btnStop;

  /// Title of the Binder panel.
  ///
  /// In en, this message translates to:
  /// **'Binder'**
  String get binderTitle;

  /// Description of the Binder panel.
  ///
  /// In en, this message translates to:
  /// **'Binder cannot cross the platform channel: Dart can only obtain an integer handle and query liveness and the descriptor. The real transaction must be issued on the Kotlin side (see DemoBinderBridge).'**
  String get binderDesc;

  /// Label for the system service name field.
  ///
  /// In en, this message translates to:
  /// **'System service name'**
  String get fieldServiceName;

  /// Placeholder for the system service name field.
  ///
  /// In en, this message translates to:
  /// **'activity'**
  String get placeholderServiceName;

  /// Title of the server-process switch.
  ///
  /// In en, this message translates to:
  /// **'Look up from server process'**
  String get switchServerProcess;

  /// Subtitle of the server-process switch.
  ///
  /// In en, this message translates to:
  /// **'Some services are only visible to shell / root'**
  String get switchServerProcessSub;

  /// Label for the DUMP args field.
  ///
  /// In en, this message translates to:
  /// **'DUMP args (optional, space separated)'**
  String get fieldDumpArgs;

  /// Button: probe service by handle.
  ///
  /// In en, this message translates to:
  /// **'Probe service (handle)'**
  String get btnProbe;

  /// Button: run DUMP on the Kotlin side.
  ///
  /// In en, this message translates to:
  /// **'DUMP (Kotlin side)'**
  String get btnDump;

  /// Button: server lifecycle Binder.
  ///
  /// In en, this message translates to:
  /// **'Server lifecycle Binder'**
  String get btnLifecycle;

  /// Title of the File panel.
  ///
  /// In en, this message translates to:
  /// **'File Proxy'**
  String get filePanelTitle;

  /// Footer of the File panel.
  ///
  /// In en, this message translates to:
  /// **'File operations run inside the server process, so they can read and write paths the app itself cannot access. Deleting a directory recurses automatically.'**
  String get filePanelFooter;

  /// Label for the absolute path field.
  ///
  /// In en, this message translates to:
  /// **'Absolute path'**
  String get fieldPath;

  /// Error when the path is not absolute.
  ///
  /// In en, this message translates to:
  /// **'Path must be absolute'**
  String get errPathAbsolute;

  /// Button: inspect a file.
  ///
  /// In en, this message translates to:
  /// **'Inspect'**
  String get btnInspect;

  /// Button: write a file.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get btnWrite;

  /// Button: read a file.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get btnRead;

  /// Button: list one directory level.
  ///
  /// In en, this message translates to:
  /// **'List one level'**
  String get btnList;

  /// Button: delete a file or directory.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get btnDelete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
