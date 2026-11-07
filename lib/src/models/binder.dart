/// Where a system service is looked up from.
///
/// Mirrors `priv.kit.core.binder.PrivilegeSystemServiceSource`.
///
/// The same service name can resolve differently depending on the source,
/// because some services are only published to `shell` or to the remote
/// privileged process itself.
///
/// A Binder cannot cross the platform channel, so Dart only ever receives an
/// integer handle. Everything that touches the Binder's own transactions has
/// to happen in Kotlin.
enum PrivBinderServiceSource {
  /// Looked up through `ServiceManager` in this app's own process.
  currentProcess('CURRENT_PROCESS'),

  /// Looked up inside the connected remote process.
  ///
  /// Without a `userServiceHandle` this is the Privileged Server; with one it
  /// is the selected UserService process. Use it for services that are only
  /// reachable as `shell` or root, such as vendor services like
  /// `miui.mqsas.IMQSNative`.
  remoteProcess('REMOTE_PROCESS');

  const PrivBinderServiceSource(this.wireName);

  /// Value sent across the platform channel.
  final String wireName;

  /// Old name for [remoteProcess].
  ///
  /// priv-core 0.18.0 renamed `SERVER_PROCESS` to `REMOTE_PROCESS`, because
  /// the lookup may now happen in a selected UserService process. This alias
  /// keeps source compatibility while sending the new wire value.
  @Deprecated(
    'Use remoteProcess instead; it also covers UserService processes.',
  )
  static const PrivBinderServiceSource serverProcess = remoteProcess;
}
