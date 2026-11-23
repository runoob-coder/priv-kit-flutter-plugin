import 'package:flutter_test/flutter_test.dart';
import 'package:priv_kit/priv_kit.dart';
import 'package:priv_kit/priv_kit_platform_interface.dart';

class _FakePlatform extends PrivKitPlatform {
  final calls = <String>[];
  final results = <String, bool>{
    'isWifiEnabled': false,
    'isWifiConnected': false,
    'isWifiReady': false,
    'isDeveloperModeEnabled': false,
    'isUsbDebuggingEnabled': false,
    'isWirelessDebuggingEnabled': false,
    'openWifiSettings': true,
    'openDeveloperSettings': true,
    'openUsbDebuggingSettings': true,
    'openWirelessDebuggingSettings': true,
  };

  bool _read(String name) {
    calls.add(name);
    return results[name] ?? false;
  }

  @override
  Future<bool> isWifiEnabled() async => _read('isWifiEnabled');

  @override
  Future<bool> isWifiConnected() async => _read('isWifiConnected');

  @override
  Future<bool> isWifiReady() async => _read('isWifiReady');

  @override
  Future<bool> isDeveloperModeEnabled() async =>
      _read('isDeveloperModeEnabled');

  @override
  Future<bool> isUsbDebuggingEnabled() async => _read('isUsbDebuggingEnabled');

  @override
  Future<bool> isWirelessDebuggingEnabled() async =>
      _read('isWirelessDebuggingEnabled');

  @override
  Future<bool> openWifiSettings() async => _read('openWifiSettings');

  @override
  Future<bool> openDeveloperSettings() async => _read('openDeveloperSettings');

  @override
  Future<bool> openUsbDebuggingSettings() async =>
      _read('openUsbDebuggingSettings');

  @override
  Future<bool> openWirelessDebuggingSettings() async =>
      _read('openWirelessDebuggingSettings');
}

void main() {
  test('pure status helpers encode the prerequisite order', () {
    expect(
      privDeveloperModeStatus(
        developerOptionsEnabled: false,
        wirelessDebuggingEnabled: true,
      ),
      PrivDeveloperModeStatus.disabled,
    );
    expect(
      privDeveloperModeStatus(
        developerOptionsEnabled: true,
        wirelessDebuggingEnabled: false,
      ),
      PrivDeveloperModeStatus.wirelessOff,
    );
    expect(
      privDeveloperModeStatus(
        developerOptionsEnabled: true,
        wirelessDebuggingEnabled: true,
      ),
      PrivDeveloperModeStatus.ready,
    );

    expect(
      privUsbDebugStatus(
        developerOptionsEnabled: false,
        usbDebuggingEnabled: true,
      ),
      PrivUsbDebugStatus.disabled,
    );
    expect(
      privUsbDebugStatus(
        developerOptionsEnabled: true,
        usbDebuggingEnabled: false,
      ),
      PrivUsbDebugStatus.usbOff,
    );
    expect(
      privUsbDebugStatus(
        developerOptionsEnabled: true,
        usbDebuggingEnabled: true,
      ),
      PrivUsbDebugStatus.ready,
    );
  });

  test('checkDeveloperModeStatus reads both switches live', () async {
    final platform = _FakePlatform();
    final privKit = PrivKit(platform: platform);

    expect(await privKit.checkDeveloperModeStatus(), PrivDeveloperModeStatus.disabled);
    expect(platform.calls, [
      'isDeveloperModeEnabled',
      'isWirelessDebuggingEnabled',
    ]);

    platform.calls.clear();
    platform.results['isDeveloperModeEnabled'] = true;
    expect(
      await privKit.checkDeveloperModeStatus(),
      PrivDeveloperModeStatus.wirelessOff,
    );

    platform.results['isWirelessDebuggingEnabled'] = true;
    expect(await privKit.checkDeveloperModeStatus(), PrivDeveloperModeStatus.ready);
  });

  test('checkUsbDebugStatus reads both switches live', () async {
    final platform = _FakePlatform();
    final privKit = PrivKit(platform: platform);

    expect(await privKit.checkUsbDebugStatus(), PrivUsbDebugStatus.disabled);
    expect(platform.calls, ['isDeveloperModeEnabled', 'isUsbDebuggingEnabled']);

    platform.calls.clear();
    platform.results['isDeveloperModeEnabled'] = true;
    expect(await privKit.checkUsbDebugStatus(), PrivUsbDebugStatus.usbOff);

    platform.results['isUsbDebuggingEnabled'] = true;
    expect(await privKit.checkUsbDebugStatus(), PrivUsbDebugStatus.ready);
  });

  test('navigation methods forward their boolean result', () async {
    final platform = _FakePlatform();
    final privKit = PrivKit(platform: platform);

    expect(await privKit.openWifiSettings(), isTrue);
    expect(await privKit.openDeveloperSettings(), isTrue);
    expect(await privKit.openUsbDebuggingSettings(), isTrue);
    expect(await privKit.openWirelessDebuggingSettings(), isTrue);
    expect(platform.calls, [
      'openWifiSettings',
      'openDeveloperSettings',
      'openUsbDebuggingSettings',
      'openWirelessDebuggingSettings',
    ]);

    platform.results['openWifiSettings'] = false;
    expect(await privKit.openWifiSettings(), isFalse);
  });
}
