// App-defined AIDL interface implemented by DemoPrivilegeService.
//
// `destroy` MUST use 16777114. Priv Kit only holds an IBinder, so it asks a
// running service to release its resources with a raw Binder transaction
// (writeInterfaceToken + transact) instead of going through your AIDL
// interface. The number is therefore a hard convention.
//
// It cannot be replaced by a named constant:
//   * the AIDL grammar accepts only an integer literal here — writing an
//     identifier fails with "syntax error, expecting int literal";
//   * priv.kit.core.userservice.PrivilegeUserServiceTransactions is `internal`,
//     so a host app could not read it even if the grammar allowed it.
//
// Mind the off-by-one: AIDL adds IBinder.FIRST_CALL_TRANSACTION to this value,
// so 16777115 is what actually goes over the wire.
package com.noob_coder.priv_kit_example;

interface IDemoPrivilegeService {
    void destroy() = 16777114;

    // Reports the identity the service is actually running as, which is the
    // point of a UserService: this is *not* the app's own UID.
    String getUid() = 1;

    // Where the service is running: embedded in the Privileged Server, or in a
    // dedicated child process.
    boolean isEmbedded() = 2;

    int add(int a, int b) = 3;
}
