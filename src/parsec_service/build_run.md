# How to build and run Parsec

This project is coded in the Rust Programming Language. To build it, you first need to [install
Rust](https://www.rust-lang.org/tools/install).

Because the providers supported by Parsec are dependent on libraries and/or hardware features
present on the platform, the build is fragmented through Rust features so that the resulting binary
only contains the desired providers. Currently the service provides the following features:
`mbed-crypto-provider`, `pkcs11-provider`, and `tpm-provider`. Please check the
[dependencies](#dependencies) for what is needed to build each provider.

In order for the service to be spun up, a number of parameters are required in a TOML file. The
repository contains an [example](https://github.com/parallaxsecond/parsec/blob/master/config.toml)
of such a configuration file which shows all the options and their default values. You can also take
example of the ones used for testing, for example [the TPM provider
one](https://github.com/parallaxsecond/parsec/blob/master/e2e_tests/provider_cfg/tpm/config.toml).

The `mbed-crypto-provider` feature is going to be used as an example in this guide. This can be
replaced by a subset of the features mentioned above, space or comma separated. If you would like to
test the TPM or PKCS check the [related
guides](test.md#testing-the-tpm-provider-using-the-software-tpm).

To build and run Parsec from source:

```````
RUST_LOG=info cargo run --features mbed-crypto-provider
```````

`parsec` will then construct the service based on the configuration file and wait for clients.
Setting `RUST_LOG=info` on the command line is not needed if the log level was modified via the
configuration file.

At the end of initialization, it should print `Parsec is ready` which means that it is ready to take
requests from clients.

If the configuration file is not in the directory from which Parsec is run, its path must be passed
via a command-line argument:

```````
cargo run --features mbed-crypto-provider -- --config e2e_tests/provider_cfg/mbed-crypto/config.toml
```````

From another terminal, it is now possible to execute the [end-to-end
tests](test.md#end-to-end-tests) on Parsec!

```````
cd e2e_tests
cargo test normal_tests
```````

## Killing Parsec

On Linux, sending `SIGTERM` will gracefully terminate Parsec, waiting all of its threads to finish.

```````
pkill parsec
```````

## Reloading Parsec

On Linux, sending `SIGHUP` will reload Parsec: it will wait for its threads to finish, drop all of
its components, read the configuration and instantiate all the components again. It is usefull to
change the Parsec configuration without having to kill the service.

```````
pkill -SIGHUP parsec
```````

## Dependencies

The Parsec Interface needs the `protoc` command to be available on the `PATH` in order to use the
Protobuf contracts. On Ubuntu-like distributions, it can be installed via the package manager under
the name `protobuf-compiler`:

```````
sudo apt install protobuf-compiler
```````

To use `bindgen` and generate the Rust to C wrappers, `libclang` (version at least 3.9) is needed:

```````
sudo apt install llvm-dev libclang-dev clang
```````

Each provider has external dependencies that are needed to compile.

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

## Cross-compiling for Arm64

To cross-compile the service for the Linux on Arm64 target, you will need to install the appropriate
toolchain for this target. By default the Arm GNU toolchain is used to compile Mbed Crypto and link
everything together. The `aarch64-linux-gnu-*` tools will be needed. Change `build-conf.toml` and
`.cargo/config` files to change the cross-compiling toolchain used. Just execute the following
command to cross-compile for the Linux on Arm64 target:

```````
cargo build --target aarch64-unknown-linux-gnu
```````

*Copyright 2019 Contributors to the Parsec project.*
