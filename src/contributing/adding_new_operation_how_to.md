# Adding operations to Parsec

This mini how-to will cover how to add operations to the Parsec service and Rust client. The steps
for adding a new provider operation will differ between providers, this guide will cover Mbed
Crypto. The steps for adding operations to [Parsec](#parsec), [Rust
interface](#parsec-interface-rs), and [Rust client](#parsec-client-rust) should be the same for all
backend providers.

## Operation specification

### parsec-book

Create the specification page for the Parsec Book, under
[Operations](https://parallaxsecond.github.io/parsec-book/parsec_client/operations/index.html) (can
also be found in the menu on the left of all pages). Include operation details such as parameters,
results, errors specific to the operation, a description, and a link to the
[protobuf](#parsec-operations) contract (which will be created further on). Also update all API
tables on the [Parsec Operations Coverage](../parsec_client/operations/service_api_coverage.md) page
to reflect the new addition (create any API tables if they are missing).

The opcode used should be the next available one. To find this, go to
[`parsec-interface-rs/src/requests/mod.rs`](https://github.com/parallaxsecond/parsec-interface-rs/blob/master/src/operations/mod.rs)
and find the largest in-use opcode.

### parsec-operations

Create the `protobuf` contracts in
[`parsec-operations`](https://github.com/parallaxsecond/parsec-operations/tree/master/protobuf).
These are the contracts that client libraries use to communicate with the Parsec service.

## Rust Interface

### parsec-interface-rs

Create the Rust interfaces for the operation. These interfaces go between
[`protobuf`](#parsec-operations) and the [Parsec service](#parsec) on the service side, and the Rust
client library and protobuf on the client side. Take care when deciding on datatypes. Sensitive data
should be wrapped in either
[`Zeroizing`](https://docs.rs/zeroize/latest/zeroize/struct.Zeroizing.html) or
[`Secret`](https://docs.rs/secrecy/latest/secrecy/struct.Secret.html) (choose depending on the
sensitivity of the data. Favour
[`Zeroizing`](https://docs.rs/zeroize/latest/zeroize/struct.Zeroizing.html) unless there is a clear
requirement for [`Secret`](https://docs.rs/secrecy/latest/secrecy/struct.Secret.html)) to ensure
they are wiped from memory when dropped and should not have any output for debugging. The operation
definitions are stored in
[`src/operations/`](https://github.com/parallaxsecond/parsec-interface-rs/tree/master/src/operations).

A `validate` method can be added to allow easy validation of the properties of the operations, to
check if there are any conflicting options, or combinations of options that are invalid. Tests must
be added for each operation with a validate method, to check it catches all erroneous combinations
of operation, and passes valid combinations.

A converter then needs to be added to
[`src/operations_protobuf`](https://github.com/parallaxsecond/parsec-interface-rs/tree/master/src/operations_protobuf).
This will convert to and from the protobuf contract and the Rust interface. There should be four
methods per operation; two for going to and from the operation struct, and two for going to and from
the result struct. Again, tests need to be added to ensure all conversions happen correctly.

Add your protobuf contracts to the
[`include_protobuf_as_module`](https://github.com/parallaxsecond/parsec-interface-rs/blob/f924c0f45695ebd88e34537934c579be8909cced/src/operations_protobuf/generated_ops.rs#L18)
block in
[`src/operations_protobuf/generated_ops.rs`](https://github.com/parallaxsecond/parsec-interface-rs/blob/master/src/operations_protobuf/generated_ops.rs).
If your Rust operation and/or result interfaces do not contain any sensitive information, add them
to the
[`empty_clear_message!`](https://github.com/parallaxsecond/parsec-interface-rs/blob/f924c0f45695ebd88e34537934c579be8909cced/src/operations_protobuf/generated_ops.rs#L129)
block. Otherwise, implement
[`ClearProtoMessage`](https://github.com/parallaxsecond/parsec-interface-rs/blob/f924c0f45695ebd88e34537934c579be8909cced/src/operations_protobuf/generated_ops.rs#L116)
for the interface/s that contain sensitive information and
[`zeroize`](https://github.com/parallaxsecond/parsec-interface-rs/blob/f924c0f45695ebd88e34537934c579be8909cced/src/operations_protobuf/generated_ops.rs#L146)
any of the sensitive fields.

In
[`src/requests/mod.rs`](https://github.com/parallaxsecond/parsec-interface-rs/blob/master/src/requests/mod.rs),
add the opcode that was specified in the [`parsec-book`](#parsec-book) for the operation. Finally,
add the relevant
[`NativeOperation`](https://github.com/parallaxsecond/parsec-interface-rs/blob/f924c0f45695ebd88e34537934c579be8909cced/src/operations/mod.rs#L32)
and
[`NativeResult`](https://github.com/parallaxsecond/parsec-interface-rs/blob/f924c0f45695ebd88e34537934c579be8909cced/src/operations/mod.rs#L79)
entries, along with the mappings to the opcode from the
[`NativeOperation`](https://github.com/parallaxsecond/parsec-interface-rs/blob/f924c0f45695ebd88e34537934c579be8909cced/src/operations/mod.rs#L59)
and
[`NativeResult`](https://github.com/parallaxsecond/parsec-interface-rs/blob/f924c0f45695ebd88e34537934c579be8909cced/src/operations/mod.rs#L106)
to the Opcode. Then, add `From` implementations to `NativeOperation` and `NativeResult`.

Finally, add the `mod` declaration in
[`src/operations_protobuf/mod.rs`](https://github.com/parallaxsecond/parsec-interface-rs/blob/master/src/operations_protobuf/mod.rs),
along with the entries in `body_to_operation`, `operation_to_body`, `body_to_result` and
`result_to_body`.

## Parsec Rust client

### parsec-client-rust

Add the user facing methods to
[`src/core/basic_client.rs`](https://github.com/parallaxsecond/parsec-client-rust/blob/master/src/core/basic_client.rs).
These are what users interacting with Parsec using Rust will use as the entrypoint. They are also
what [Parsec’s e2e test
suit](https://github.com/parallaxsecond/parsec/blob/master/e2e_tests/src/lib.rs) uses to test
Parsec, which is why this step comes before extending Parsec. Add the relevant tests to
[`src/core/testing/core_tests.rs`](https://github.com/parallaxsecond/parsec-client-rust/blob/master/src/core/testing/core_tests.rs).

### Other clients (e.g. Go)

The procedure for adding operations to another client library should be similar. We encourage that
all clients should be updated to allow the new operation is as many languages as possible.

## Parsec

### psa-crypto-sys

Locate the parts of the [PSA API](https://armmbed.github.io/mbed-crypto/html/index.html) in Mbed
Crypto that will need to be used during the operation you are adding. This includes all constants,
datatypes, macros and functions. Note: Mbed Crypto does not yet fully conform to the PSA API 1.0
specification, so there may be inconsistencies between the PSA documentation and the macros and
functions that Mbed Crypto exposes.

Starting in
[`psa-crypto-sys`](https://github.com/parallaxsecond/rust-psa-crypto/tree/master/psa-crypto-sys),
constants are added to
[`constants.rs`](https://github.com/parallaxsecond/rust-psa-crypto/blob/master/psa-crypto-sys/src/constants.rs).
Inline functions and macros require a shim. Add the inline function and macro definitions into
[`shim.h`](https://github.com/parallaxsecond/rust-psa-crypto/blob/master/psa-crypto-sys/src/c/shim.h),
[`shim.c`](https://github.com/parallaxsecond/rust-psa-crypto/blob/master/psa-crypto-sys/src/c/shim.c)
and
[`shim.rs`](https://github.com/parallaxsecond/rust-psa-crypto/blob/master/psa-crypto-sys/src/shim.rs).
When adding entries to
[`shim.rs`](https://github.com/parallaxsecond/rust-psa-crypto/blob/master/psa-crypto-sys/src/shim.rs),
take note of where you place
[`unsafe`](https://doc.rust-lang.org/book/ch19-01-unsafe-rust.html#using-extern-functions-to-call-external-code).
If the [PSA API](https://armmbed.github.io/mbed-crypto/html/index.html) specification states that
under any circumstance, an unspecified result can be returned, then mark the entire `fn` definition
as `unsafe`. Otherwise, if the return values are always specified, wrap the call to the shim method
as `unsafe`. Regular functions are added to [`pub use psa_crypto_binding::{ …
}`](https://github.com/parallaxsecond/rust-psa-crypto/blob/master/psa-crypto-sys/src/lib.rs).

### psa-crypto

Define a Rust native interface for the operation you are adding in
[`src/operations`](https://github.com/parallaxsecond/rust-psa-crypto/tree/master/psa-crypto/src/operations),
along with any Rust native types you need in
[`src/types`](https://github.com/parallaxsecond/rust-psa-crypto/tree/master/psa-crypto/src/types).
Generally, any helper macro functions are placed in the `impl` block of the Rust native type they
are for.

The interface will work between the Rust native datatypes given to it and the C bindings in
[`psa-crypto-sys`](#psa-crypto-sys). It is important to ensure that the Rust interface handles all
possible situations (e.g. closing a key-handle on an error) to ensure it is a safe Rust native
interface to the operation.

At this point, you will now have a safe Rust interface for the PSA operation you added.

### parsec

Add the new operation to the correct
[provider](https://github.com/parallaxsecond/parsec/tree/master/src/providers) (in this case, [Mbed
Crypto](https://github.com/parallaxsecond/parsec/tree/master/src/providers/mbed_crypto)) as a
`psa_xxx_internal` method. The operation method should take the user inputs, arrange them in a way
that [`psa-crypto`](#psa-crypto) accepts, and provide any extra logic or storage if required (e.g.
an output buffer). The external implementation is to be added to the provider’s
[`mod.rs`](https://github.com/parallaxsecond/parsec/blob/master/src/providers/mbed_crypto/mod.rs)
file, which outputs a trace entry and passes the call back to the internal implementation.

A default implementation is added to
[`src/providers/mod.rs`](https://github.com/parallaxsecond/parsec/blob/master/src/providers/mod.rs)
that is used when a provider does not support a particular operation. It outputs a trace entry and
returns an error, stating that the operation is not supported. The external implementation in the
provider’s `mod.rs` overrides this.

Add the `NativeOperation` mapping in
[`src/back/backend_handler.rs`](https://github.com/parallaxsecond/parsec/blob/master/src/back/backend_handler.rs)
`execute_request` function so Parsec can call the correct operation method when it receives a
request.

Finally, add [end to end (e2e)
testing](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/per_provider) for the
new operation. Operations are added to
[`e2e_tests/src/lib.rs`](https://github.com/parallaxsecond/parsec/blob/master/e2e_tests/src/lib.rs)
to save from code duplication in the tests. This also makes it quick and easy to write tests, and to
see exactly what operations a test is performing. Test should be very thorough, taking the operation
through valid and invalid inputs, checking that the proper output is returned. If possible, external
data and crates should be used during testing. E.g. if testing the cryptographic operation, generate
keys and an encrypted message externally and test that Parsec can correctly decrypt the message.
(Note: if crates are added solely for testing purposes, add them to `[dev-dependencies]` in
[`Cargo.toml`](https://github.com/parallaxsecond/parsec/blob/master/e2e_tests/Cargo.toml))
