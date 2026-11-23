import 'package:flutter/services.dart';

import '../priv_kit_platform_interface.dart';
import 'exceptions.dart';

/// Host-app runtime permission helpers exposed by `priv_kit`.
///
/// These differ from [PrivKit.checkPermission]/[PrivKit.grantRuntimePermission],
/// which inspect or change permissions of a package through the connected
/// Privileged Server. Here the plugin asks the Android Activity to grant a
/// permission to **this app**, and can open the matching system settings page.
class PrivKitPermissions {
  const PrivKitPermissions(this._platform);

  final PrivKitPlatform _platform;

  /// Whether this app may post notifications.
  ///
  /// Always `true` below Android 13 (API 33), where notification permission is
  /// implicit.
  Future<bool> hasNotificationPermission() =>
      _guard(_platform.hasNotificationPermission);

  /// Asks this app's current Activity for `POST_NOTIFICATIONS`.
  ///
  /// Returns the granted state. Below API 33 this returns `true` without
  /// showing a dialog.
  Future<bool> requestNotificationPermission() =>
      _guard(_platform.requestNotificationPermission);

  /// Opens this app's notification settings page.
  ///
  /// Falls back to the app details page on ROMs without that Activity.
  Future<bool> openNotificationPermissionSettings() =>
      _guard(_platform.openNotificationPermissionSettings);

  /// Whether this app may access the local network (API 37+).
  ///
  /// Always `true` on older Android versions, where NSD/mDNS only needs
  /// `INTERNET`.
  Future<bool> hasLocalNetworkPermission() =>
      _guard(_platform.hasLocalNetworkPermission);

  /// Asks this app's current Activity for `ACCESS_LOCAL_NETWORK`.
  ///
  /// Returns `true` immediately below API 37 or when already granted.
  Future<bool> requestLocalNetworkPermission() =>
      _guard(_platform.requestLocalNetworkPermission);

  /// Opens this app's details page.
  Future<bool> openAppDetailsSettings() => _guard(_platform.openAppDetailsSettings);

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on PlatformException catch (e) {
      throw PrivKitException.fromPlatformException(e);
    }
  }
}
