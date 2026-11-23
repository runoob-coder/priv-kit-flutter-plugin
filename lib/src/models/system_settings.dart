/// Combined state of Android Developer options and Wireless debugging.
///
/// Wireless debugging is only visible after Developer options are enabled, so
/// the states are ordered: [disabled] hides the switch, [wirelessOff] shows it
/// but it is off, [ready] allows a pairing/start flow.
enum PrivDeveloperModeStatus {
  disabled,
  wirelessOff,
  ready,
}

/// Derives [PrivDeveloperModeStatus] from two independent channel reads.
PrivDeveloperModeStatus privDeveloperModeStatus({
  required bool developerOptionsEnabled,
  required bool wirelessDebuggingEnabled,
}) {
  if (!developerOptionsEnabled) return PrivDeveloperModeStatus.disabled;
  if (!wirelessDebuggingEnabled) return PrivDeveloperModeStatus.wirelessOff;
  return PrivDeveloperModeStatus.ready;
}

/// Combined state of Android Developer options and USB debugging.
///
/// USB debugging is also hidden until Developer options are enabled.
enum PrivUsbDebugStatus {
  disabled,
  usbOff,
  ready,
}

/// Derives [PrivUsbDebugStatus] from two independent channel reads.
PrivUsbDebugStatus privUsbDebugStatus({
  required bool developerOptionsEnabled,
  required bool usbDebuggingEnabled,
}) {
  if (!developerOptionsEnabled) return PrivUsbDebugStatus.disabled;
  if (!usbDebuggingEnabled) return PrivUsbDebugStatus.usbOff;
  return PrivUsbDebugStatus.ready;
}
