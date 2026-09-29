/// Where a system service is looked up from.
///
/// Mirrors `priv.kit.core.binder.PrivilegeSystemServiceSource`.
///
/// The same service name can resolve differently depending on the source,
/// because some services are only published to `shell` or to the Privileged
/// Server process itself.
///
/// A Binder cannot cross the platform channel, so Dart only ever receives an
/// integer handle. Everything that touches the Binder's own transactions has
/// to happen in Kotlin.
enum PrivBinderServiceSource {
  /// Looked up through `ServiceManager` in this app's own process.
  currentProcess('CURRENT_PROCESS'),

  /// Looked up inside the connected Privileged Server process.
  ///
  /// Use this for services that are only reachable as `shell` or root, such as
  /// vendor services like `miui.mqsas.IMQSNative`.
  serverProcess('SERVER_PROCESS');

  const PrivBinderServiceSource(this.wireName);

  /// Value sent across the platform channel.
  final String wireName;
}
