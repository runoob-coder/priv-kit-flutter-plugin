// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Priv Kit 示例';

  @override
  String get serverNotConnectedHint => '命令执行需要先连接 Privileged Server';

  @override
  String get logsTitle => '日志';

  @override
  String get logsEmpty => '暂无日志';

  @override
  String get logsClear => '清空';

  @override
  String get logsClose => '关闭';

  @override
  String get serverCardTitle => 'Privileged Server';

  @override
  String get serverDisconnected => '未连接';

  @override
  String serverConnected(String root) {
    return '已连接 (root=$root)';
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
  String get actionRoot => 'Root 启动';

  @override
  String get actionAdb => '无线调试启动';

  @override
  String get actionAdbTcp => 'TCP/IP 启动';

  @override
  String get actionCheckPairing => '检查配对';

  @override
  String get actionNativeStarter => '手动启动命令';

  @override
  String get actionDeniedPerms => '被拒绝权限';

  @override
  String get actionCrashLogs => '崩溃日志';

  @override
  String get actionShutdown => '关闭服务端';

  @override
  String get actionRunId => '执行 id（汇总）';

  @override
  String get actionStreamCount => '执行命令（流式）';

  @override
  String get actionCancelCommand => '取消命令';

  @override
  String get cmdPanelTitle => '手动执行命令';

  @override
  String get cmdPanelFooter => '不提供 stdin 或 PTY：不支持交互式程序、终端信号与 ANSI 渲染。';

  @override
  String get fieldCommand => '命令';

  @override
  String get placeholderCommand => 'id -u';

  @override
  String get switchUseShell => '通过 shell 执行';

  @override
  String get switchUseShellSub => '命令 API 不会隐式添加 shell';

  @override
  String get fieldWorkDir => '工作目录（可选，需绝对路径）';

  @override
  String get placeholderWorkDir => '/data/local/tmp';

  @override
  String get fieldEnv => '环境变量（可选，每行一个 KEY=VALUE）';

  @override
  String get placeholderEnv => 'LANG=C';

  @override
  String get fieldTimeout => '超时（毫秒）';

  @override
  String get placeholderTimeout => '留空为 30000';

  @override
  String get checkDisableTimeout => '禁用超时';

  @override
  String get errEmptyCommand => '请输入命令';

  @override
  String get errEmptyExecutable => '请输入可执行文件';

  @override
  String get errTimeoutPositive => '超时必须是正整数毫秒';

  @override
  String envFormat(String line) {
    return '环境变量需写成 KEY=VALUE：$line';
  }

  @override
  String get btnRunAggregate => '执行并汇总输出';

  @override
  String get btnStream => '流式执行';

  @override
  String get btnStopStream => '停止流式命令';

  @override
  String get userServiceTitle => 'UserService';

  @override
  String get userServiceDesc =>
      'DemoPrivilegeService 是 App 自己写的 AIDL 服务，运行在特权进程。插件的 start/stop 由 Dart 控制；调用自定义方法必须走 App 自己的 Kotlin 通道（见 DemoUserServiceBridge）。';

  @override
  String get switchEmbedded => '嵌入式（embedded）';

  @override
  String get switchEmbeddedSub => '开启后服务跑在 Privileged Server 进程内';

  @override
  String get btnStart => '启动';

  @override
  String get btnBind => '绑定（拿句柄）';

  @override
  String get btnCallAidl => '调用 AIDL 方法';

  @override
  String get btnStop => '停止';

  @override
  String get binderTitle => 'Binder';

  @override
  String get binderDesc =>
      'Binder 无法通过平台通道传递：Dart 只能拿到整型句柄，做存活与描述符查询。真正的 transaction 必须在 Kotlin 侧发起，见 DemoBinderBridge。';

  @override
  String get fieldServiceName => '系统服务名';

  @override
  String get placeholderServiceName => 'activity';

  @override
  String get switchServerProcess => '从服务端进程查找';

  @override
  String get switchServerProcessSub => '部分服务只对 shell / root 可见';

  @override
  String get fieldDumpArgs => 'DUMP 参数（可选，空格分隔）';

  @override
  String get btnProbe => '检查服务（句柄）';

  @override
  String get btnDump => 'DUMP（Kotlin 侧）';

  @override
  String get btnLifecycle => '服务端生命周期 Binder';

  @override
  String get filePanelTitle => '文件代理';

  @override
  String get filePanelFooter => '文件操作在服务端进程内执行，因此可以读写 App 自身无权访问的路径。删除目录会自动递归。';

  @override
  String get fieldPath => '绝对路径';

  @override
  String get errPathAbsolute => '路径必须是绝对路径';

  @override
  String get btnInspect => '查询信息';

  @override
  String get btnWrite => '写入';

  @override
  String get btnRead => '读取';

  @override
  String get btnList => '列出一层';

  @override
  String get btnDelete => '删除';
}
