// This is a basic Flutter widget test for the Material + i18n example.
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:priv_kit_example/main.dart';

void main() {
  testWidgets('renders the Material demo shell with English strings', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp(locale: Locale('en')));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    // Localized via the English .arb template.
    expect(find.text('Priv Kit example'), findsOneWidget);
    expect(find.text('Start as Root'), findsOneWidget);
    expect(find.byType(FilledButton), findsWidgets);
  });

  testWidgets('localizes to Chinese when the locale is pinned to zh', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp(locale: Locale('zh')));
    await tester.pumpAndSettle();

    expect(find.text('Root 启动'), findsOneWidget);
    // The English copy must no longer be shown.
    expect(find.text('Start as Root'), findsNothing);
  });

  testWidgets('tapping the language button switches EN <-> ZH', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp(locale: Locale('en')));
    await tester.pumpAndSettle();
    expect(find.text('Start as Root'), findsOneWidget);

    // The toggle button shows the language to switch *to* ('中' from English).
    await tester.tap(find.text('中'));
    await tester.pumpAndSettle();

    expect(find.text('Root 启动'), findsOneWidget);
    expect(find.text('Start as Root'), findsNothing);
  });

  testWidgets('shows the Shizuku provider actions in both locales', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp(locale: Locale('en')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Shizuku external start'),
      500,
      scrollable: find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      ).first,
    );

    expect(find.text('Shizuku external start'), findsOneWidget);
    expect(
      find.textContaining('Status comes from the Shizuku provider session'),
      findsOneWidget,
    );
    expect(find.text('Check status'), findsOneWidget);
    expect(find.text('Request authorization'), findsOneWidget);
    expect(find.text('Start via Shizuku'), findsOneWidget);
    expect(find.textContaining('Status: Not checked'), findsOneWidget);

    await tester.tap(find.text('中'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Shizuku 外部启动'),
      500,
      scrollable: find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      ).first,
    );

    expect(find.text('Shizuku 外部启动'), findsOneWidget);
    expect(
      find.textContaining('状态来自 Shizuku provider 会话'),
      findsOneWidget,
    );
    expect(find.text('检查状态'), findsOneWidget);
    expect(find.text('通过 Shizuku 启动'), findsOneWidget);
    expect(find.textContaining('状态: 未检查'), findsOneWidget);
  });

  testWidgets('log button opens a dialog that can clear logs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp(locale: Locale('zh')));
    await tester.pumpAndSettle();

    // Open the log dialog via the top-right button (tooltip = l10n.logsTitle).
    await tester.tap(find.byTooltip('日志'));
    await tester.pumpAndSettle();

    expect(find.text('清空'), findsOneWidget);
    expect(find.text('关闭'), findsOneWidget);
    // No logs were produced, so the empty state is shown.
    expect(find.text('暂无日志'), findsOneWidget);

    // Clearing keeps the dialog open and still shows the empty state.
    await tester.tap(find.text('清空'));
    await tester.pumpAndSettle();
    expect(find.text('暂无日志'), findsOneWidget);

    await tester.tap(find.text('关闭'));
    await tester.pumpAndSettle();
    expect(find.text('关闭'), findsNothing);
  });
}
