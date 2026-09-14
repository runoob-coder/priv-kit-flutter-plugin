import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
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
