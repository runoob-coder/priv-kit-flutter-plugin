import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:priv_kit/priv_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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

  @override
  void initState() {
    super.initState();
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
      _log('崩溃日志：没有报告');
      return;
    }
    _log('崩溃日志：${reports.length} 条（按时间倒序）');
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

  /// Runs the command typed into the panel and prints its captured output.
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

  /// Streams the command typed into the panel.
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
      _log('$path 不存在');
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
    _log('已写入 $path (${await _privKit.fileLength(path)} bytes)');
  });

  /// Reads the whole file. [PrivKit.fileReadAllBytes] opens, drains and closes.
  Future<void> _fileReadSample(String path) => _run(() async {
    final bytes = await _privKit.fileReadAllBytes(path);
    _log('读取 $path -> ${bytes.length} bytes\n${_decode(bytes)}');
  });

  /// Lists one level. `maxDepth: 1` is a non-recursive listing; drop it to
  /// walk the whole subtree, or pass `skipDirectoryGlobs` to prune branches.
  Future<void> _fileListSample(String path) => _run(() async {
    final entries = <PrivFileEntry>[];
    await for (final entry in _privKit.fileWalk(path, maxDepth: 1)) {
      entries.add(entry);
    }
    if (entries.isEmpty) {
      _log('$path 下没有条目');
      return;
    }
    _log('$path 下 ${entries.length} 个条目：');
    for (final entry in entries.take(20)) {
      final size = entry.metadata?.sizeBytes;
      _log(
        '  ${'  ' * (entry.depth - 1)}${entry.name}'
        '${size == null ? ' (metadata 不可读)' : ' $size bytes'}',
      );
    }
  });

  Future<void> _fileDeleteSample(String path) => _run(() async {
    if (await _privKit.fileIsDirectory(path)) {
      final deleted = await _privKit.fileDeleteRecursively(path);
      _log('递归删除 $path -> $deleted');
    } else {
      _log('删除 $path -> ${await _privKit.fileDelete(path)}');
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

  /// Lifecycle is driven through the plugin: start, then stop.
  Future<void> _startUserService(bool embedded) => _run(() async {
    final spec = _userServiceSpec(embedded);
    await _privKit.startUserService(spec);
    _log('startUserService -> ${spec.tag} (embedded=$embedded)');
  });

  /// Dart can hold the connection handle, but cannot call the service with it.
  Future<void> _bindUserService(bool embedded) => _run(() async {
    final handle = await _privKit.bindUserService(_userServiceSpec(embedded));
    _log(
      'bindUserService -> handle=$handle（Binder 无法传给 Dart，'
      '调用请见下面的示例）',
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
      _log('binderFromSystemService -> null（服务不可用）');
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
      _log('binderServerLifecycle -> null（未连接服务端）');
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
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: Scaffold(
        appBar: AppBar(title: const Text('Priv Kit example')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ServerCard(server: server),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: _busy ? null : _startRoot,
                  child: const Text('Root 启动'),
                ),
                FilledButton(
                  onPressed: _busy ? null : _startAdb,
                  child: const Text('无线调试启动'),
                ),
                FilledButton(
                  onPressed: _busy ? null : _startAdbTcp,
                  child: const Text('TCP/IP 启动'),
                ),
                OutlinedButton(
                  onPressed: _busy ? null : _checkPairing,
                  child: const Text('检查配对'),
                ),
                OutlinedButton(
                  onPressed: _busy ? null : _loadNativeStarterCommand,
                  child: const Text('手动启动命令'),
                ),
                OutlinedButton(
                  onPressed: _busy ? null : _loadDeniedPermissions,
                  child: const Text('被拒绝权限'),
                ),
                OutlinedButton(
                  onPressed: _busy || server == null ? null : _readCrashLogs,
                  child: const Text('崩溃日志'),
                ),
                OutlinedButton(
                  onPressed: _busy ? null : _shutdown,
                  child: const Text('关闭服务端'),
                ),
                FilledButton.tonal(
                  onPressed: _busy || server == null ? null : _runId,
                  child: const Text('执行 id（汇总）'),
                ),
                FilledButton.tonal(
                  onPressed: _busy || server == null ? null : _streamCount,
                  child: const Text('执行命令（流式）'),
                ),
                OutlinedButton(
                  onPressed: _cancelCommand,
                  child: const Text('取消命令'),
                ),
              ],
            ),
            if (server == null)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('命令执行需要先连接 Privileged Server'),
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
              SelectableText('adb shell ${_nativeStarterCommand!}'),
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
            Text('日志', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            for (final line in _logs.take(40))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(line, style: const TextStyle(fontSize: 12)),
              ),
          ],
        ),
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
    final input = _command.text.trim();
    if (input.isEmpty) {
      setState(() => _error = '请输入命令');
      return null;
    }

    List<String> arguments;
    if (_useShell) {
      arguments = <String>[_shellPath, '-c', input];
    } else {
      arguments = _splitArgs(input);
      if (arguments.isEmpty) {
        setState(() => _error = '请输入可执行文件');
        return null;
      }
    }

    Map<String, String> environment;
    try {
      environment = _parseEnvironment(_environment.text);
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
          setState(() => _error = '超时必须是正整数毫秒');
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
  /// Only used when "通过 shell 执行" is off, because the command API passes
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
  static Map<String, String> _parseEnvironment(String text) {
    final map = <String, String>{};
    for (final raw in text.split('\n')) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      final index = line.indexOf('=');
      if (index <= 0) {
        throw ArgumentError('环境变量需写成 KEY=VALUE：$line');
      }
      map[line.substring(0, index)] = line.substring(index + 1);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('手动执行命令', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _command,
              enabled: enabled,
              maxLines: 3,
              minLines: 2,
              decoration: const InputDecoration(
                labelText: '命令',
                hintText: 'id -u',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('通过 shell 执行'),
              subtitle: const Text('命令 API 不会隐式添加 shell'),
              value: _useShell,
              onChanged: enabled
                  ? (value) => setState(() => _useShell = value)
                  : null,
            ),
            TextField(
              controller: _workingDirectory,
              enabled: enabled,
              decoration: const InputDecoration(
                labelText: '工作目录（可选，需绝对路径）',
                hintText: '/data/local/tmp',
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _environment,
              enabled: enabled,
              maxLines: 2,
              minLines: 1,
              decoration: const InputDecoration(
                labelText: '环境变量（可选，每行一个 KEY=VALUE）',
                hintText: 'LANG=C',
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _timeout,
                    enabled: enabled && !_disableTimeout,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '超时（毫秒）',
                      hintText: '留空为 30000',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('禁用超时'),
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
              Text(
                _error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: enabled ? () => _submit(stream: false) : null,
                  child: const Text('执行并汇总输出'),
                ),
                FilledButton.tonal(
                  onPressed: enabled ? () => _submit(stream: true) : null,
                  child: const Text('流式执行'),
                ),
                OutlinedButton(
                  // Only meaningful while a stream is running; cancelling the
                  // subscription is what terminates the remote process.
                  onPressed: widget.streaming ? widget.onCancel : null,
                  child: const Text('停止流式命令'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '不提供 stdin 或 PTY：不支持交互式程序、终端信号与 ANSI 渲染。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
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
    final enabled = widget.enabled;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('UserService', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              'DemoPrivilegeService 是 App 自己写的 AIDL 服务，运行在特权进程。'
              '插件的 start/stop 由 Dart 控制；调用自定义方法必须走 App 自己的'
              ' Kotlin 通道（见 DemoUserServiceBridge）。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('嵌入式（embedded）'),
              subtitle: const Text('开启后服务跑在 Privileged Server 进程内'),
              value: _embedded,
              onChanged: enabled
                  ? (value) => setState(() => _embedded = value)
                  : null,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: enabled ? () => widget.onStart(_embedded) : null,
                  child: const Text('启动'),
                ),
                OutlinedButton(
                  onPressed: enabled ? () => widget.onBind(_embedded) : null,
                  child: const Text('绑定（拿句柄）'),
                ),
                FilledButton.tonal(
                  onPressed: enabled ? () => widget.onCall(_embedded) : null,
                  child: const Text('调用 AIDL 方法'),
                ),
                OutlinedButton(
                  onPressed: enabled ? () => widget.onStop(_embedded) : null,
                  child: const Text('停止'),
                ),
              ],
            ),
          ],
        ),
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
    final enabled = widget.enabled;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Binder', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              'Binder 无法通过平台通道传递：Dart 只能拿到整型句柄，做存活与描述符'
              '查询。真正的 transaction 必须在 Kotlin 侧发起，见 DemoBinderBridge。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _serviceName,
              enabled: enabled,
              decoration: const InputDecoration(
                labelText: '系统服务名',
                hintText: 'activity',
                isDense: true,
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('从服务端进程查找'),
              subtitle: const Text('部分服务只对 shell / root 可见'),
              value: _serverProcess,
              onChanged: enabled
                  ? (value) => setState(() => _serverProcess = value)
                  : null,
            ),
            TextField(
              controller: _dumpArgs,
              enabled: enabled,
              decoration: const InputDecoration(
                labelText: 'DUMP 参数（可选，空格分隔）',
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: enabled ? () => _submit(dump: false) : null,
                  child: const Text('检查服务（句柄）'),
                ),
                FilledButton.tonal(
                  onPressed: enabled ? () => _submit(dump: true) : null,
                  child: const Text('DUMP（Kotlin 侧）'),
                ),
                OutlinedButton(
                  onPressed: enabled ? widget.onLifecycle : null,
                  child: const Text('服务端生命周期 Binder'),
                ),
              ],
            ),
          ],
        ),
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
    final path = _path.text.trim();
    if (!path.startsWith('/')) {
      setState(() => _error = '路径必须是绝对路径');
      return;
    }
    setState(() => _error = null);
    FocusManager.instance.primaryFocus?.unfocus();
    action(path);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('文件代理', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _path,
              enabled: enabled,
              decoration: const InputDecoration(
                labelText: '绝对路径',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: enabled ? () => _submit(widget.onInspect) : null,
                  child: const Text('查询信息'),
                ),
                FilledButton.tonal(
                  onPressed: enabled ? () => _submit(widget.onWrite) : null,
                  child: const Text('写入'),
                ),
                OutlinedButton(
                  onPressed: enabled ? () => _submit(widget.onRead) : null,
                  child: const Text('读取'),
                ),
                OutlinedButton(
                  onPressed: enabled ? () => _submit(widget.onList) : null,
                  child: const Text('列出一层'),
                ),
                OutlinedButton(
                  onPressed: enabled ? () => _submit(widget.onDelete) : null,
                  child: const Text('删除'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '文件操作在服务端进程内执行，因此可以读写 App 自身无权访问的路径。'
              '删除目录会自动递归。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServerCard extends StatelessWidget {
  const _ServerCard({required this.server});

  final PrivServerInfo? server;

  @override
  Widget build(BuildContext context) {
    final info = server;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  info == null ? Icons.link_off : Icons.link,
                  color: info == null ? Colors.grey : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(info == null ? '未连接' : '已连接 (root=${info.isRoot})'),
              ],
            ),
            if (info != null) ...[
              const SizedBox(height: 8),
              Text(
                'uid=${info.uid} pid=${info.pid} '
                'protocol=${info.protocolVersion}',
              ),
              if (info.selinuxContext != null)
                Text('selinux=${info.selinuxContext}'),
            ],
          ],
        ),
      ),
    );
  }
}
