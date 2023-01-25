# How to build and run Parsec

## Prerequisites

This project is coded in the Rust Programming Language. To build it, you first need to [install
Rust](https://www.rust-lang.org/tools/install).

Some Parsec backends require FFI binding code to be generated, to allow us to interface with the
libraries driving the hardware. For this we use `bindgen` and generate the Rust to C wrappers, for
which `libclang` (version at least 3.9) is needed:

```````
sudo apt install llvm-dev libclang-dev clang cmake
```````

## Building Parsec

Because the [providers](providers.md) and [authenticators](authenticators.md) supported by Parsec
are dependent on libraries and/or hardware features present on the platform, the build is fragmented
through Rust features so that the resulting binary only contains the desired providers. Currently
the service provides some of the following features: `mbed-crypto-provider`, `pkcs11-provider`,
`tpm-provider`, `cryptoauthlib-provider`, `trusted-service-provider`, as well as
`jwt-svid-authenticator`. Please check the [dependencies](#dependencies) for what is needed to build
each provider.

The `mbed-crypto-provider` feature is going to be used as an example in this guide. This can be
replaced by a subset of the features mentioned above, space or comma separated. If you would like to
test the TPM or PKCS check the [related
guides](tests#testing-the-tpm-provider-using-the-software-tpm).

On a real deployment (as explained in our [installation guide](install_parsec_linux.md)) specific
owners and permissions need to be set up on multiple folders. For testing only, it is fine to run
Parsec from the current directory, have the key information mappings in `./mappings` and the socket
at `/tmp/parsec.sock`. The test configuration will make those choices.

Clone the Parsec service repo,

```
git clone --branch 1.1.0 https://github.com/parallaxsecond/parsec.git
```

Having cloned the Parsec repository, to build and run from source using the Mbed Crypto provider and
the test configuration:

```````
cd parsec
cargo build --features "mbed-crypto-provider,direct-authenticator"
RUST_LOG=info ./target/debug/parsec -c e2e_tests/provider_cfg/mbed-crypto/config.toml
```````

`parsec` will then construct the service based on the [configuration](configuration.md) file and
wait for clients.

At the end of initialization, it should print `Parsec is ready` which means that it is ready to take
requests from clients.

## Running Parsec end-to-end-tests

From another terminal, it is now possible to execute the [end-to-end tests](tests#end-to-end-tests)
on Parsec!

```````
cd e2e_tests
export PARSEC_SERVICE_ENDPOINT="unix:/tmp/parsec.sock"
cargo test --features mbed-crypto-provider normal_tests
```````

## Killing Parsec

On Linux, sending `SIGTERM` will gracefully terminate Parsec, waiting all of its threads to finish.

```````
pkill parsec
```````

## Reloading Parsec

On Linux, sending `SIGHUP` will reload Parsec: it will wait for its threads to finish, drop all of
its components, read the configuration and instantiate all the components again. It is useful to
change the Parsec configuration without having to kill the service.

```````
pkill -SIGHUP parsec
```````

## Dependencies

Each provider has external dependencies that are needed to compile. Additionally, the JWT SVID
authenticator also relies on external dependencies being present.

### Mbed Crypto

The Mbed Crypto provider is built on top of the reference implementation of the PSA Cryptography
API. You can find a list of dependencies
[here](https://github.com/parallaxsecond/rust-psa-crypto/tree/master/psa-crypto-sys).

### PKCS 11 Crypto

The PKCS 11 provider will try to dynamically load the library indicated in the configuration file,
hence a library implementing the PKCS 11 API is needed.

### TPM Crypto

The TPM provider will try to build the `tss-esapi` crate which needs built TSS 2.0 esys and tctildr
libraries. It will use `pkg-config` to find them using the names `tss2-esys` and `tss2-tctildr`.
Make sure you also follow the requirements of the [tss-esapi crate](https://docs.rs/tss-esapi).

### CryptoAuth Library

TODO

### Trusted Service

The Trusted Service provider connects to its backend through the shared library produced by the
[`libts` deployment](https://trusted-services.readthedocs.io/en/integration/deployments/index.html).
You can find instructions for building the required components
[here](https://trusted-services.readthedocs.io/en/integration/developer/build-instructions.html).

The Trusted Service provider also relies on the `protoc` command to be available on the `PATH`. This
is needed as our method of IPC with the TS relies on protobuf. On Ubuntu-like distributions, it can
be installed via the package manager under the name `protobuf-compiler`:

```````
sudo apt install protobuf-compiler
```````

## Cross-compilation

The Parsec service can be cross-compiled to other target triplets. You might need to install a
cross-compilation C toolchain for the target you want to compile for. The default ones are indicated
in the `.cargo/config` file.

*Copyright 2022 Contributors to the Parsec project.*
