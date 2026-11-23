import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priv_kit/priv_kit.dart';
import 'package:priv_kit/priv_kit_platform_interface.dart';

class _FakePlatform extends PrivKitPlatform {
  final calls = <String>[];
  final results = <String, bool>{
    'isRootAvailable': true,
    'hasNotificationPermission': false,
    'requestNotificationPermission': true,
    'openNotificationPermissionSettings': true,
    'hasLocalNetworkPermission': false,
    'requestLocalNetworkPermission': true,
    'openLocalNetworkPermissionSettings': true,
  };

  bool _read(String name) {
    calls.add(name);
    return results[name] ?? false;
  }

  @override
  Future<bool> isRootAvailable() async => _read('isRootAvailable');

  @override
  Future<bool> hasNotificationPermission() async =>
      _read('hasNotificationPermission');

  @override
  Future<bool> requestNotificationPermission() async =>
      _read('requestNotificationPermission');

  @override
  Future<bool> openNotificationPermissionSettings() async =>
      _read('openNotificationPermissionSettings');

  @override
  Future<bool> hasLocalNetworkPermission() async =>
      _read('hasLocalNetworkPermission');

  @override
  Future<bool> requestLocalNetworkPermission() async =>
      _read('requestLocalNetworkPermission');

  @override
  Future<bool> openLocalNetworkPermissionSettings() async =>
      _read('openLocalNetworkPermissionSettings');
}

class _ThrowingPlatform extends _FakePlatform {
  @override
  Future<bool> hasNotificationPermission() async =>
      throw PlatformException(code: 'NATIVE_ERROR', message: 'boom');
}

void main() {
  test('isRootAvailable forwards the pre-flight root check', () async {
    final platform = _FakePlatform();
    final privKit = PrivKit(platform: platform);

    expect(await privKit.isRootAvailable(), isTrue);
    expect(platform.calls, ['isRootAvailable']);
  });

  test('permissions API forwards notification and local network calls', () async {
    final platform = _FakePlatform();
    final privKit = PrivKit(platform: platform);
    final permissions = privKit.permissions;

    expect(permissions, isA<PrivKitPermissions>());
    expect(await permissions.hasNotificationPermission(), isFalse);
    expect(await permissions.requestNotificationPermission(), isTrue);
    expect(await permissions.openNotificationPermissionSettings(), isTrue);
    expect(await permissions.hasLocalNetworkPermission(), isFalse);
    expect(await permissions.requestLocalNetworkPermission(), isTrue);
    expect(await permissions.openLocalNetworkPermissionSettings(), isTrue);
    expect(platform.calls, [
      'hasNotificationPermission',
      'requestNotificationPermission',
      'openNotificationPermissionSettings',
      'hasLocalNetworkPermission',
      'requestLocalNetworkPermission',
      'openLocalNetworkPermissionSettings',
    ]);
  });

  test('permissions API translates PlatformException', () async {
    final privKit = PrivKit(platform: _ThrowingPlatform());

    expect(
      privKit.permissions.hasNotificationPermission(),
      throwsA(
        isA<PrivKitException>().having(
          (e) => e.code,
          'code',
          PrivKitErrorCode.native,
        ),
      ),
    );
  });
}
