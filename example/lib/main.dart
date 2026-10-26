import 'dart:async';
import 'dart:convert';

import 'l10n/gen_l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:priv_kit/priv_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.locale});

  /// Optional pinned locale (used for testing); `null` follows the system.
  final Locale? locale;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _privKit = PrivKit();
  final _logs = <String>[];

  StreamSubscription<PrivServerInfo?>? _stateSub;
  StreamSubscription<PrivStartupLogLine>? _logSub;
  StreamSubscription<PrivCommandEvent>? _commandSub;

  PrivServerInfo? _server;
  String? _nativeStarterCommand;
  bool _busy = false;
  bool _streaming = false;

  /// `null` follows the system locale; otherwise it pins the app to EN/ZH.
  Locale? _locale;

  void _toggleLocale(String currentLang) {
    setState(() {
      _locale =
          currentLang == 'zh' ? const Locale('en') : const Locale('zh');
    });
  }

  void _clearLogs() {
    if (!mounted) return;
    setState(() => _logs.clear());
  }

  /// Opens a modal dialog that shows the accumulated logs and lets the user
  /// clear them. The dialog snapshots the current entries, so it reflects the
  /// cleared state immediately without needing the page to rebuild.
  void _showLogs(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => _LogsDialog(
        logs: _logs,
        onClear: _clearLogs,
        title: l10n.logsTitle,
        emptyText: l10n.logsEmpty,
        clearText: l10n.logsClear,
        closeText: l10n.logsClose,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _locale = widget.locale;
    _subscribe();
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _logSub?.cancel();
    _commandSub?.cancel();
    super.dispose();
  }

  void _subscribe() {
    // Every new listener immediately receives the current value.
    _stateSub = _privKit.serverState.listen(
      (server) => setState(() => _server = server),
      onError: (Object error) => _log('serverState error: $error'),
    );
    _logSub = _privKit.startupLog.listen(
      (line) => _log('${line.source}: ${line.message}'),
    );
  }

  void _log(String message) {
    debugPrint(message);
    if (!mounted) return;
    setState(() {
      _logs.insert(0, message);
      if (_logs.length > 200) _logs.removeLast();
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } on PrivKitException catch (e) {
      _log('${e.code}: ${e.message ?? ''}');
    } catch (e) {
      _log('error: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _startRoot() => _run(() async {
    final info = await _privKit.startRoot();
    _log('startRoot -> $info');
  });

  Future<void> _startAdb() => _run(() async {
    final info = await _privKit.startAdb();
    _log('startAdb -> $info');
  });

  Future<void> _startAdbTcp() => _run(() async {
    const port = privilegeAdbDefaultTcpPort;
    final prepared = await _privKit.adbPrepareTcpForStart(tcpPort: port);
    _log('prepareTcpForStart -> ${prepared.status.name}');
    if (!prepared.isAuthorized) {
      final request = await _privKit.adbRequestTcpAuthorization(tcpPort: port);
      _log('requestTcpAuthorization -> authorized=${request.authorized}');
      if (!request.authorized) return;
    }
    final info = await _privKit.startAdb(
      options: const PrivAdbConnectionOptions(port: port),
    );
    _log('startAdb(tcp) -> $info');
  });

  Future<void> _checkPairing() => _run(() async {
    final result = await _privKit.adbCheckPairing();
    _log(
      'checkPairing -> paired=${result.paired} '
      'status=${result.status.name}',
    );
  });

  Future<void> _loadNativeStarterCommand() => _run(() async {
    final command = await _privKit.getNativeStarterCommand();
    setState(() => _nativeStarterCommand = command);
    _log('adb shell $command');
  });

  Future<void> _loadDeniedPermissions() => _run(() async {
    final denied = await _privKit.getDeniedServerPermissions();
    _log('deniedServerPermissions -> $denied');
  });

  /// Reads the reports privileged processes wrote when they died.
  ///
  /// The directory itself is configured natively in `MainApp` before Flutter
  /// starts, because it has to be set before any startup. The scan also covers
  /// the shared `/data/local/tmp` fallback, which is why it needs a connected
  /// server.
  Future<void> _readCrashLogs() => _run(() async {
    final reports = await _privKit.readCrashLogs();
    if (reports.isEmpty) {
      _log('Crash logs: no reports');
      return;
    }
    _log('Crash logs: ${reports.length} entries (newest first)');
    for (final report in reports.take(5)) {
      final head = report.stackTrace.split('\n').take(3).join('\n      ');
      _log(
        '  ${report.crashedAt} ${report.processType} pid=${report.pid}\n'
        '    ${report.exceptionType}: ${report.exceptionMessage}\n'
        '      $head',
      );
    }
  });

  Future<void> _shutdown() => _run(() async {
    await _privKit.shutdownServer();
    _log('shutdownServer done');
  });

  /// Aggregate consumption: drain both streams and report the exit code.
  Future<void> _runId() => _run(() async {
    final result = await _privKit.runCommand(
      PrivCommand(
        arguments: const ['/system/bin/id'],
        environment: const {'LANG': 'C'},
        workingDirectory: '/data/local/tmp',
      ),
    );
    _log('id -> exit=${result.exitCode}\n${result.stdoutText.trim()}');
  });

  /// Streaming consumption: emit each chunk as it arrives.
  ///
  /// Cancelling the subscription cancels the remote process.
  Future<void> _streamCount() => _listenToCommand(
    PrivCommand(
      arguments: const [
        '/system/bin/sh',
        '-c',
        // The backslash keeps Dart from interpolating the shell's $i.
        r'for i in 1 2 3; do echo line $i; echo warn $i >&2; sleep 1; done',
      ],
    ),
  );

  Future<void> _listenToCommand(
    PrivCommand command, {
    int? timeoutMillis,
  }) async {
    await _commandSub?.cancel();
    setState(() => _streaming = true);
    _commandSub = _privKit
        .startCommand(command, timeoutMillis: timeoutMillis)
        .listen(
          // `when` is exhaustive, so adding an event type is a compile error
          // here rather than a silently dropped case.
          (event) => event.when(
            stdout: (bytes) => _log('out: ${_decode(bytes)}'),
            stderr: (bytes) => _log('err: ${_decode(bytes)}'),
            exit: (code) => _log('exit: $code'),
          ),
          onError: (Object error) {
            _log('command error: $error');
            if (mounted) setState(() => _streaming = false);
          },
          onDone: () {
            _log('command stream done');
            if (mounted) setState(() => _streaming = false);
          },
          cancelOnError: true,
        );
  }

  Future<void> _cancelCommand() async {
    await _commandSub?.cancel();
    _commandSub = null;
    setState(() => _streaming = false);
    _log('command cancelled');
  }

  Future<void> _runInput(_CommandRequest request) => _run(() async {
    final result = await _privKit.runCommand(
      request.command,
      timeoutMillis: request.timeoutMillis,
    );
    _log(
      '${request.label} -> exit=${result.exitCode}'
      '${result.stdoutText.isEmpty ? '' : '\n${result.stdoutText.trim()}'}'
      '${result.stderrText.isEmpty ? '' : '\n[stderr] ${result.stderrText.trim()}'}',
    );
  });

  Future<void> _streamInput(_CommandRequest request) => _run(
    () =>
        _listenToCommand(request.command, timeoutMillis: request.timeoutMillis),
  );

  /// Safe here only because this demo emits ASCII: chunk boundaries are not
  /// UTF-8 character boundaries, so production code must buffer a partial
  /// trailing sequence instead of decoding each chunk on its own.
  static String _decode(Uint8List bytes) =>
      utf8.decode(bytes, allowMalformed: true).trimRight();

  // --- File proxy samples -------------------------------------------------

  Future<void> _fileInspect(String path) => _run(() async {
    if (!await _privKit.fileExists(path)) {
      _log('$path does not exist');
      return;
    }
    final metadata = await _privKit.fileMetadata(path);
    _log(
      'metadata: ${metadata.name} type=${metadata.type.name} '
      'size=${metadata.sizeBytes} uid=${metadata.uid} gid=${metadata.gid} '
      'mode=${metadata.unixMode.toRadixString(8)}',
    );
    _log(
      'isDirectory=${await _privKit.fileIsDirectory(path)} '
      'canRead=${await _privKit.fileCanRead(path)} '
      'canWrite=${await _privKit.fileCanWrite(path)}',
    );
  });

  /// Writes through a handle. Closing waits for the server to consume every
  /// byte, so a failed write still has to close the stream.
  Future<void> _fileWriteSample(String path) => _run(() async {
    await _privKit.fileWriteAllBytes(
      path,
      Uint8List.fromList(
        'written by priv_kit at ${DateTime.now()}\n'.codeUnits,
      ),
      syncOnClose: true,
    );
    _log('Wrote $path (${await _privKit.fileLength(path)} bytes)');
  });

  /// Reads the whole file. [PrivKit.fileReadAllBytes] opens, drains and closes.
  Future<void> _fileReadSample(String path) => _run(() async {
    final bytes = await _privKit.fileReadAllBytes(path);
    _log('Read $path -> ${bytes.length} bytes\n${_decode(bytes)}');
  });

  /// Lists one level. `maxDepth: 1` is a non-recursive listing; drop it to
  /// walk the whole subtree, or pass `skipDirectoryGlobs` to prune branches.
  Future<void> _fileListSample(String path) => _run(() async {
    final entries = <PrivFileEntry>[];
    await for (final entry in _privKit.fileWalk(path, maxDepth: 1)) {
      entries.add(entry);
    }
    if (entries.isEmpty) {
      _log('No entries under $path');
      return;
    }
    _log('${entries.length} entries under $path:');
    for (final entry in entries.take(20)) {
      final size = entry.metadata?.sizeBytes;
      _log(
        '  ${'  ' * (entry.depth - 1)}${entry.name}'
        '${size == null ? ' (metadata unreadable)' : ' $size bytes'}',
      );
    }
  });

  Future<void> _fileDeleteSample(String path) => _run(() async {
    if (await _privKit.fileIsDirectory(path)) {
      final deleted = await _privKit.fileDeleteRecursively(path);
      _log('Recursive delete $path -> $deleted');
    } else {
      _log('Delete $path -> ${await _privKit.fileDelete(path)}');
    }
  });

  // --- UserService samples -------------------------------------------------

  /// This channel belongs to the example app, not the plugin. A UserService
  /// returns a Binder, and a Binder cannot cross the platform channel, so the
  /// example's own Kotlin code binds it and calls the AIDL methods.
  static const _userServiceChannel = MethodChannel(
    'priv_kit_example/user_service',
  );

  /// The Binder transactions themselves run here, in Kotlin: see
  /// `DemoBinderBridge`.
  static const _binderChannel = MethodChannel('priv_kit_example/binder');

  PrivUserServiceSpec _userServiceSpec(bool embedded) => PrivUserServiceSpec(
    serviceClassName: 'com.noob_coder.priv_kit_example.DemoPrivilegeService',
    tag: embedded ? 'demo-embedded' : 'demo-standalone',
    embedded: embedded,
  );

  Future<void> _startUserService(bool embedded) => _run(() async {
    final spec = _userServiceSpec(embedded);
    await _privKit.startUserService(spec);
    _log('startUserService -> ${spec.tag} (embedded=$embedded)');
  });

  /// Dart can hold the connection handle, but cannot call the service with it.
  Future<void> _bindUserService(bool embedded) => _run(() async {
    final handle = await _privKit.bindUserService(_userServiceSpec(embedded));
    _log(
      'bindUserService -> handle=$handle (Binder cannot cross to Dart; '
      'see the example below)',
    );
    await _privKit.unbindUserService(handle);
    _log('unbindUserService -> handle=$handle');
  });

  /// The real call path: the example's Kotlin side binds the service, converts
  /// the Binder with asInterface and invokes the AIDL method.
  Future<void> _callDemoUserService(bool embedded) => _run(() async {
    final uid = await _userServiceChannel.invokeMethod<String>(
      'call',
      <String, Object?>{'embedded': embedded, 'method': 'getUid'},
    );
    _log('IDemoPrivilegeService.getUid() -> $uid');

    final isEmbedded = await _userServiceChannel.invokeMethod<bool>(
      'call',
      <String, Object?>{'embedded': embedded, 'method': 'isEmbedded'},
    );
    _log('IDemoPrivilegeService.isEmbedded() -> $isEmbedded');

    final sum = await _userServiceChannel.invokeMethod<int>(
      'call',
      <String, Object?>{
        'embedded': embedded,
        'method': 'add',
        'args': <String, Object?>{'a': 20, 'b': 22},
      },
    );
    _log('IDemoPrivilegeService.add(20, 22) -> $sum');
  });

  Future<void> _stopUserService(bool embedded) => _run(() async {
    await _privKit.stopUserService(_userServiceSpec(embedded));
    _log('stopUserService -> ${_userServiceSpec(embedded).tag}');
  });

  /// Resolves a service and reports everything Dart is allowed to know about
  /// it: whether it exists, its descriptor, and whether it answers.
  Future<void> _probeBinder(
    String serviceName,
    PrivBinderServiceSource source,
  ) => _run(() async {
    final has = await _privKit.binderHasSystemService(
      serviceName,
      source: source,
    );
    _log('binderHasSystemService($serviceName, ${source.name}) -> $has');
    if (!has) return;

    final handle = await _privKit.binderFromSystemService(
      serviceName,
      source: source,
    );
    if (handle == null) {
      _log('binderFromSystemService -> null (service unavailable)');
      return;
    }
    try {
      final descriptor = await _privKit.binderGetInterfaceDescriptor(handle);
      final alive = await _privKit.binderIsAlive(handle);
      final ping = await _privKit.binderPing(handle);
      _log(
        'binderFromSystemService -> handle=$handle\n'
        '  descriptor=$descriptor\n'
        '  isAlive=$alive ping=$ping',
      );
    } finally {
      await _privKit.binderClose(handle);
    }
  });

  /// A real Binder transaction, which has to be issued in Kotlin.
  ///
  /// DUMP is the transaction behind `dumpsys`, so it needs no app-specific
  /// AIDL and still shows the call travelling through the server.
  Future<void> _dumpBinder(
    String serviceName,
    PrivBinderServiceSource source,
    String args,
  ) => _run(() async {
    final output = await _binderChannel.invokeMethod<String>(
      'dump',
      <String, Object?>{
        'serviceName': serviceName,
        'source': _sourceWireName(source),
        'args': args.trim().isEmpty
            ? const <String>[]
            : args.trim().split(RegExp(r'\s+')),
      },
    );
    _log('DUMP $serviceName ->\n$output');
  });

  /// The server's own lifecycle Binder: an ownership token for privileged APIs
  /// that release resources when their owner dies.
  Future<void> _binderLifecycle() => _run(() async {
    final handle = await _privKit.binderServerLifecycle();
    if (handle == null) {
      _log('binderServerLifecycle -> null (server not connected)');
      return;
    }
    try {
      final alive = await _privKit.binderIsAlive(handle);
      final ping = await _privKit.binderPing(handle);
      _log('binderServerLifecycle -> handle=$handle isAlive=$alive ping=$ping');
    } finally {
      await _privKit.binderClose(handle);
    }
  });

  static String _sourceWireName(PrivBinderServiceSource source) =>
      source == PrivBinderServiceSource.serverProcess
      ? 'SERVER_PROCESS'
      : 'CURRENT_PROCESS';

  @override
  Widget build(BuildContext context) {
    final server = _server;
    return MaterialApp(
      title: 'Priv Kit',
      locale: _locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // `AppLocalizations` is only resolvable inside MaterialApp's
      // Localizations scope, so read it from a Builder context.
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          final currentLang = Localizations.localeOf(context).languageCode;
          return Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          actions: [
            IconButton(
              onPressed: () => _showLogs(context),
              tooltip: l10n.logsTitle,
              icon: Badge(
                isLabelVisible: _logs.isNotEmpty,
                label: Text('${_logs.length}'),
                child: const Icon(Icons.list_alt),
              ),
            ),
            IconButton(
              onPressed: () => _toggleLocale(currentLang),
              tooltip: 'Switch language / 切换语言',
              icon: Text(
                currentLang == 'zh' ? 'EN' : '中',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ServerCard(server: server),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _button(
                    label: l10n.actionRoot,
                    style: .filled,
                    onPressed: _busy ? null : _startRoot,
                  ),
                  _button(
                    label: l10n.actionAdb,
                    style: .filled,
                    onPressed: _busy ? null : _startAdb,
                  ),
                  _button(
                    label: l10n.actionAdbTcp,
                    style: .filled,
                    onPressed: _busy ? null : _startAdbTcp,
                  ),
                  _button(
                    label: l10n.actionCheckPairing,
                    onPressed: _busy ? null : _checkPairing,
                  ),
                  _button(
                    label: l10n.actionNativeStarter,
                    onPressed: _busy ? null : _loadNativeStarterCommand,
                  ),
                  _button(
                    label: l10n.actionDeniedPerms,
                    onPressed: _busy ? null : _loadDeniedPermissions,
                  ),
                  _button(
                    label: l10n.actionCrashLogs,
                    onPressed: _busy || server == null ? null : _readCrashLogs,
                  ),
                  _button(
                    label: l10n.actionShutdown,
                    onPressed: _busy ? null : _shutdown,
                  ),
                  _button(
                    label: l10n.actionRunId,
                    style: .tinted,
                    onPressed: _busy || server == null ? null : _runId,
                  ),
                  _button(
                    label: l10n.actionStreamCount,
                    style: .tinted,
                    onPressed: _busy || server == null ? null : _streamCount,
                  ),
                  _button(
                    label: l10n.actionCancelCommand,
                    onPressed: _cancelCommand,
                  ),
                ],
              ),
              if (server == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.serverNotConnectedHint,
                    style: _captionStyle(context),
                  ),
                ),
              const SizedBox(height: 12),
              _CommandPanel(
                enabled: server != null && !_busy,
                streaming: _streaming,
                onRun: _runInput,
                onStream: _streamInput,
                onCancel: _cancelCommand,
              ),
              if (_nativeStarterCommand != null) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: SelectableText(
                    'adb shell $_nativeStarterCommand',
                    style: _captionStyle(context),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              _FilePanel(
                enabled: server != null && !_busy,
                onInspect: _fileInspect,
                onWrite: _fileWriteSample,
                onRead: _fileReadSample,
                onList: _fileListSample,
                onDelete: _fileDeleteSample,
              ),
              const SizedBox(height: 12),
              _UserServicePanel(
                enabled: server != null && !_busy,
                onStart: _startUserService,
                onBind: _bindUserService,
                onCall: _callDemoUserService,
                onStop: _stopUserService,
              ),
              const SizedBox(height: 12),
              _BinderPanel(
                enabled: server != null && !_busy,
                onProbe: _probeBinder,
                onDump: _dumpBinder,
                onLifecycle: _binderLifecycle,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
        },
      ),
    );
  }
}

/// A command parsed from the input panel, ready to hand to [PrivKit].
class _CommandRequest {
  const _CommandRequest({
    required this.command,
    required this.label,
    this.timeoutMillis,
  });

  final PrivCommand command;

  /// Short text used when logging, so the log shows what was typed.
  final String label;

  /// `null` means "use the 30s default"; [noCommandTimeout] disables it.
  final int? timeoutMillis;
}

/// Lets the user type an arbitrary command and pick how to consume it.
///
/// The command API does not add a shell implicitly, so the panel offers
/// `/system/bin/sh -c` wrapping as an explicit switch.
class _CommandPanel extends StatefulWidget {
  const _CommandPanel({
    required this.enabled,
    required this.streaming,
    required this.onRun,
    required this.onStream,
    required this.onCancel,
  });

  final bool enabled;
  final bool streaming;
  final Future<void> Function(_CommandRequest request) onRun;
  final Future<void> Function(_CommandRequest request) onStream;
  final VoidCallback onCancel;

  @override
  State<_CommandPanel> createState() => _CommandPanelState();
}

class _CommandPanelState extends State<_CommandPanel> {
  final _command = TextEditingController();
  final _workingDirectory = TextEditingController();
  final _environment = TextEditingController();
  final _timeout = TextEditingController();

  var _useShell = true;
  var _disableTimeout = false;
  String? _error;

  static const _shellPath = '/system/bin/sh';

  @override
  void dispose() {
    _command.dispose();
    _workingDirectory.dispose();
    _environment.dispose();
    _timeout.dispose();
    super.dispose();
  }

  void _submit({required bool stream}) {
    final request = _buildRequest();
    if (request == null) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (stream) {
      widget.onStream(request);
    } else {
      widget.onRun(request);
    }
  }

  _CommandRequest? _buildRequest() {
    final l10n = AppLocalizations.of(context)!;
    final input = _command.text.trim();
    if (input.isEmpty) {
      setState(() => _error = l10n.errEmptyCommand);
      return null;
    }

    List<String> arguments;
    if (_useShell) {
      arguments = <String>[_shellPath, '-c', input];
    } else {
      arguments = _splitArgs(input);
      if (arguments.isEmpty) {
        setState(() => _error = l10n.errEmptyExecutable);
        return null;
      }
    }

    Map<String, String> environment;
    try {
      environment = _parseEnvironment(_environment.text, l10n);
    } on ArgumentError catch (e) {
      setState(() => _error = e.message as String?);
      return null;
    }

    int? timeoutMillis;
    if (_disableTimeout) {
      timeoutMillis = noCommandTimeout;
    } else {
      final text = _timeout.text.trim();
      if (text.isNotEmpty) {
        final value = int.tryParse(text);
        if (value == null || value <= 0) {
          setState(() => _error = l10n.errTimeoutPositive);
          return null;
        }
        timeoutMillis = value;
      }
    }

    final directory = _workingDirectory.text.trim();
    try {
      final command = PrivCommand(
        arguments: arguments,
        environment: environment,
        workingDirectory: directory.isEmpty ? null : directory,
      );
      setState(() => _error = null);
      return _CommandRequest(
        command: command,
        label: input,
        timeoutMillis: timeoutMillis,
      );
    } catch (e) {
      setState(() => _error = '$e');
      return null;
    }
  }

  /// Minimal shell-like splitting: honours quotes and backslash escapes.
  ///
  /// Only used when "Execute via shell" is off, because the command API passes
  /// arguments straight to the executable without a shell.
  static List<String> _splitArgs(String input) {
    final result = <String>[];
    final buffer = StringBuffer();
    var quote = '';
    var started = false;

    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      if (char == r'\' && i + 1 < input.length) {
        buffer.write(input[++i]);
        started = true;
        continue;
      }
      if (quote.isNotEmpty) {
        if (char == quote) {
          quote = '';
        } else {
          buffer.write(char);
        }
        continue;
      }
      if (char == '"' || char == "'") {
        quote = char;
        started = true;
        continue;
      }
      if (char == ' ' || char == '\t') {
        if (started) {
          result.add(buffer.toString());
          buffer.clear();
          started = false;
        }
        continue;
      }
      buffer.write(char);
      started = true;
    }
    if (started) result.add(buffer.toString());
    return result;
  }

  /// Parses one `KEY=VALUE` entry per line.
  static Map<String, String> _parseEnvironment(
    String text,
    AppLocalizations l10n,
  ) {
    final map = <String, String>{};
    for (final raw in text.split('\n')) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      final index = line.indexOf('=');
      if (index <= 0) {
        throw ArgumentError(l10n.envFormat(line));
      }
      map[line.substring(0, index)] = line.substring(index + 1);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = widget.enabled;
    return _PanelCard(
      title: l10n.cmdPanelTitle,
      footer: l10n.cmdPanelFooter,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _field(
            context,
            label: l10n.fieldCommand,
            controller: _command,
            placeholder: l10n.placeholderCommand,
            enabled: enabled,
            maxLines: 3,
            minLines: 2,
          ),
          const SizedBox(height: 12),
          _switch(
            context,
            title: l10n.switchUseShell,
            subtitle: l10n.switchUseShellSub,
            value: _useShell,
            onChanged: enabled
                ? (value) => setState(() => _useShell = value)
                : null,
          ),
          const SizedBox(height: 12),
          _field(
            context,
            label: l10n.fieldWorkDir,
            controller: _workingDirectory,
            placeholder: l10n.placeholderWorkDir,
            enabled: enabled,
          ),
          const SizedBox(height: 12),
          _field(
            context,
            label: l10n.fieldEnv,
            controller: _environment,
            placeholder: l10n.placeholderEnv,
            enabled: enabled,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: .center,
            children: [
              Expanded(
                child: _field(
                  context,
                  label: l10n.fieldTimeout,
                  controller: _timeout,
                  placeholder: l10n.placeholderTimeout,
                  enabled: enabled && !_disableTimeout,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _check(
                  context,
                  title: l10n.checkDisableTimeout,
                  value: _disableTimeout,
                  onChanged: enabled
                      ? (value) =>
                            setState(() => _disableTimeout = value ?? false)
                      : null,
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: _errorStyle(context)),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _button(
                label: l10n.btnRunAggregate,
                style: .tinted,
                onPressed: enabled ? () => _submit(stream: false) : null,
              ),
              _button(
                label: l10n.btnStream,
                style: .tinted,
                onPressed: enabled ? () => _submit(stream: true) : null,
              ),
              _button(
                // Only meaningful while a stream is running; cancelling the
                // subscription is what terminates the remote process.
                label: l10n.btnStopStream,
                onPressed: widget.streaming ? widget.onCancel : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Drives the demo UserService through both the plugin and the app's own
/// channel, which is how a real app has to reach its AIDL methods.
class _UserServicePanel extends StatefulWidget {
  const _UserServicePanel({
    required this.enabled,
    required this.onStart,
    required this.onBind,
    required this.onCall,
    required this.onStop,
  });

  final bool enabled;
  final Future<void> Function(bool embedded) onStart;
  final Future<void> Function(bool embedded) onBind;
  final Future<void> Function(bool embedded) onCall;
  final Future<void> Function(bool embedded) onStop;

  @override
  State<_UserServicePanel> createState() => _UserServicePanelState();
}

class _UserServicePanelState extends State<_UserServicePanel> {
  /// Embedded services run inside the server process, the default standalone
  /// mode uses a dedicated child process.
  var _embedded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = widget.enabled;
    return _PanelCard(
      title: l10n.userServiceTitle,
      description: l10n.userServiceDesc,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _switch(
            context,
            title: l10n.switchEmbedded,
            subtitle: l10n.switchEmbeddedSub,
            value: _embedded,
            onChanged: enabled
                ? (value) => setState(() => _embedded = value)
                : null,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _button(
                label: l10n.btnStart,
                style: .tinted,
                onPressed: enabled ? () => widget.onStart(_embedded) : null,
              ),
              _button(
                label: l10n.btnBind,
                onPressed: enabled ? () => widget.onBind(_embedded) : null,
              ),
              _button(
                label: l10n.btnCallAidl,
                style: .tinted,
                onPressed: enabled ? () => widget.onCall(_embedded) : null,
              ),
              _button(
                label: l10n.btnStop,
                onPressed: enabled ? () => widget.onStop(_embedded) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Exercises Binder access: resolve a system service from Dart, then issue a
/// real transaction from Kotlin.
class _BinderPanel extends StatefulWidget {
  const _BinderPanel({
    required this.enabled,
    required this.onProbe,
    required this.onDump,
    required this.onLifecycle,
  });

  final bool enabled;
  final void Function(String serviceName, PrivBinderServiceSource source)
  onProbe;
  final void Function(
    String serviceName,
    PrivBinderServiceSource source,
    String args,
  )
  onDump;
  final void Function() onLifecycle;

  @override
  State<_BinderPanel> createState() => _BinderPanelState();
}

class _BinderPanelState extends State<_BinderPanel> {
  final _serviceName = TextEditingController(text: 'activity');
  final _dumpArgs = TextEditingController();
  var _serverProcess = false;

  @override
  void dispose() {
    _serviceName.dispose();
    _dumpArgs.dispose();
    super.dispose();
  }

  PrivBinderServiceSource get _source => _serverProcess
      ? PrivBinderServiceSource.serverProcess
      : PrivBinderServiceSource.currentProcess;

  void _submit({required bool dump}) {
    final name = _serviceName.text.trim();
    if (name.isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (dump) {
      widget.onDump(name, _source, _dumpArgs.text);
    } else {
      widget.onProbe(name, _source);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = widget.enabled;
    return _PanelCard(
      title: l10n.binderTitle,
      description: l10n.binderDesc,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _field(
            context,
            label: l10n.fieldServiceName,
            controller: _serviceName,
            placeholder: l10n.placeholderServiceName,
            enabled: enabled,
          ),
          const SizedBox(height: 12),
          _switch(
            context,
            title: l10n.switchServerProcess,
            subtitle: l10n.switchServerProcessSub,
            value: _serverProcess,
            onChanged: enabled
                ? (value) => setState(() => _serverProcess = value)
                : null,
          ),
          const SizedBox(height: 12),
          _field(
            context,
            label: l10n.fieldDumpArgs,
            controller: _dumpArgs,
            enabled: enabled,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _button(
                label: l10n.btnProbe,
                style: .tinted,
                onPressed: enabled ? () => _submit(dump: false) : null,
              ),
              _button(
                label: l10n.btnDump,
                style: .tinted,
                onPressed: enabled ? () => _submit(dump: true) : null,
              ),
              _button(
                label: l10n.btnLifecycle,
                onPressed: enabled ? widget.onLifecycle : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Exercises the file proxy: query, write, read, list and delete.
class _FilePanel extends StatefulWidget {
  const _FilePanel({
    required this.enabled,
    required this.onInspect,
    required this.onWrite,
    required this.onRead,
    required this.onList,
    required this.onDelete,
  });

  final bool enabled;
  final Future<void> Function(String path) onInspect;
  final Future<void> Function(String path) onWrite;
  final Future<void> Function(String path) onRead;
  final Future<void> Function(String path) onList;
  final Future<void> Function(String path) onDelete;

  @override
  State<_FilePanel> createState() => _FilePanelState();
}

class _FilePanelState extends State<_FilePanel> {
  final _path = TextEditingController(text: '/data/local/tmp/priv_kit_demo');
  String? _error;

  @override
  void dispose() {
    _path.dispose();
    super.dispose();
  }

  void _submit(Future<void> Function(String path) action) {
    final l10n = AppLocalizations.of(context)!;
    final path = _path.text.trim();
    if (!path.startsWith('/')) {
      setState(() => _error = l10n.errPathAbsolute);
      return;
    }
    setState(() => _error = null);
    FocusManager.instance.primaryFocus?.unfocus();
    action(path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = widget.enabled;
    return _PanelCard(
      title: l10n.filePanelTitle,
      footer: l10n.filePanelFooter,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _field(context, label: l10n.fieldPath, controller: _path, enabled: enabled),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: _errorStyle(context)),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _button(
                label: l10n.btnInspect,
                style: .tinted,
                onPressed: enabled ? () => _submit(widget.onInspect) : null,
              ),
              _button(
                label: l10n.btnWrite,
                style: .tinted,
                onPressed: enabled ? () => _submit(widget.onWrite) : null,
              ),
              _button(
                label: l10n.btnRead,
                onPressed: enabled ? () => _submit(widget.onRead) : null,
              ),
              _button(
                label: l10n.btnList,
                onPressed: enabled ? () => _submit(widget.onList) : null,
              ),
              _button(
                label: l10n.btnDelete,
                onPressed: enabled ? () => _submit(widget.onDelete) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServerCard extends StatelessWidget {
  const _ServerCard({required this.server});

  final PrivServerInfo? server;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final info = server;
    return _PanelCard(
      title: l10n.serverCardTitle,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(
                info == null ? Icons.cancel : Icons.link,
                color: info == null ? Colors.grey : Colors.green,
              ),
              const SizedBox(width: 8),
              Text(
                info == null
                    ? l10n.serverDisconnected
                    : l10n.serverConnected(info.isRoot.toString()),
              ),
            ],
          ),
          if (info != null) ...[
            const SizedBox(height: 8),
            Text(
              l10n.serverUidLine(info.uid, info.pid, info.protocolVersion),
              style: _captionStyle(context),
            ),
            if (info.selinuxContext != null)
              Text(
                l10n.serverSelinux(info.selinuxContext!),
                style: _captionStyle(context),
              ),
          ],
        ],
      ),
    );
  }
}

// --- Material building blocks ---------------------------------------------

/// A modal viewer for the demo logs.
///
/// It snapshots the entries when opened (the dialog is modal, so nothing is
/// appended while it is shown) and clears its own copy on "Clear", while also
/// clearing the source list through [onClear].
class _LogsDialog extends StatefulWidget {
  const _LogsDialog({
    required this.logs,
    required this.onClear,
    required this.title,
    required this.emptyText,
    required this.clearText,
    required this.closeText,
  });

  final List<String> logs;
  final VoidCallback onClear;
  final String title;
  final String emptyText;
  final String clearText;
  final String closeText;

  @override
  State<_LogsDialog> createState() => _LogsDialogState();
}

class _LogsDialogState extends State<_LogsDialog> {
  late final List<String> _items = List<String>.from(widget.logs);
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Logs are stored newest-first, so the list is shown oldest-first and the
    // newest ends up at the bottom. Jump to it as soon as the dialog opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _clear() {
    widget.onClear();
    setState(_items.clear);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      // Tighter spacing around the action buttons.
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      actionsPadding: EdgeInsets.zero,
      buttonPadding: const EdgeInsets.symmetric(horizontal: 4),
      content: SizedBox(
        width: double.maxFinite,
        height: 320,
        child: _items.isEmpty
            ? Center(
                child: Text(widget.emptyText, style: _captionStyle(context)),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: _items.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: SelectableText(
                    // Reverse so the newest log is shown last (at the bottom).
                    _items[_items.length - 1 - index],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
      ),
      actions: [
        TextButton(onPressed: _clear, child: Text(widget.clearText)),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.closeText),
        ),
      ],
    );
  }
}

enum _ButtonStyle { plain, tinted, filled }

TextStyle _titleStyle(BuildContext context) =>
    Theme.of(context).textTheme.titleMedium!;

TextStyle _captionStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodySmall!;

TextStyle _errorStyle(BuildContext context) =>
    _captionStyle(context).copyWith(
      color: Theme.of(context).colorScheme.error,
    );

class _PanelCard extends StatelessWidget {
  const _PanelCard({
    required this.title,
    required this.child,
    this.description,
    this.footer,
  });

  final String title;

  /// Explanatory text rendered right below the [title].
  final String? description;

  /// Explanatory text rendered below the [child].
  final String? footer;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(title, style: _titleStyle(context)),
            if (description != null) ...[
              const SizedBox(height: 4),
              Text(description!, style: _captionStyle(context)),
            ],
            const SizedBox(height: 12),
            child,
            if (footer != null) ...[
              const SizedBox(height: 12),
              Text(footer!, style: _captionStyle(context)),
            ],
          ],
        ),
      ),
    );
  }
}

Widget _button({
  required String label,
  required VoidCallback? onPressed,
  _ButtonStyle style = _ButtonStyle.plain,
}) {
  final child = Text(label);
  return switch (style) {
    .filled => FilledButton(onPressed: onPressed, child: child),
    .tinted => FilledButton.tonal(onPressed: onPressed, child: child),
    .plain => TextButton(onPressed: onPressed, child: child),
  };
}

/// A labelled [TextField]: the label sits above the field, the placeholder
/// becomes the Material `hintText`.
Widget _field(
  BuildContext context, {
  required String label,
  required TextEditingController controller,
  String? placeholder,
  bool enabled = true,
  int maxLines = 1,
  int? minLines,
  TextInputType? keyboardType,
}) {
  return Column(
    crossAxisAlignment: .start,
    children: [
      Text(label, style: _captionStyle(context)),
      const SizedBox(height: 4),
      TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: placeholder,
          border: const OutlineInputBorder(),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        maxLines: maxLines,
        minLines: minLines,
        keyboardType: keyboardType,
      ),
    ],
  );
}

/// A [SwitchListTile] with the title/subtitle on the leading side.
Widget _switch(
  BuildContext context, {
  required String title,
  String? subtitle,
  required bool value,
  required ValueChanged<bool>? onChanged,
}) {
  return SwitchListTile(
    title: Text(title),
    subtitle: subtitle != null ? Text(subtitle) : null,
    value: value,
    onChanged: onChanged,
    contentPadding: EdgeInsets.zero,
  );
}

/// A [CheckboxListTile] with the checkbox on the leading side.
Widget _check(
  BuildContext context, {
  required String title,
  required bool value,
  required ValueChanged<bool?>? onChanged,
}) {
  return CheckboxListTile(
    title: Text(title),
    value: value,
    onChanged: onChanged,
    controlAffinity: ListTileControlAffinity.leading,
    contentPadding: EdgeInsets.zero,
  );
}
