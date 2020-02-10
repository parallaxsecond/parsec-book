# How to build and run Parsec

This project is coded in the Rust Programming Language. To build it, you first need to [install
Rust](https://www.rust-lang.org/tools/install).

Because the providers supported by Parsec are dependent on libraries and/or hardware features
present on the platform, the build is fragmented through Rust features so that the resulting binary
only contains the desired providers. Currently the service provides the following features:
`mbed-crypto-provider`, `pkcs11-provider`, and `tpm-provider`.

In order for the service to be spun up, a number of parameters are required in a TOML file. The
repository contains an [example](https://github.com/parallaxsecond/parsec/blob/master/config.toml)
of such a configuration file which shows all the options and their default values.

To build and run the service, set `DESIRED_FEATURES` to be a subset of the features mentioned above,
space or comma separated, and execute:

```````
cargo run --no-default-features --features $DESIRED_FEATURES
```````

`parsec` will then construct the service based on the configuration file and wait for clients. If
the configuration file is not in the directory from which Parsec is run, its path must be passed via
CLI:

```````
cargo run --no-default-features --features $DESIRED_FEATURES -- --config $PATH_TO_CONFIG
```````

From another terminal, it is now possible to execute [integration tests](test.md#integration-tests)
on Parsec!

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

## External dependencies

Each provider has external dependencies that are needed to compile.

### Mbed Crypto

If Mbed Crypto is not already available on the system, the build script will try to download and
compile it. The following commands need to be available:

- a C toolchain, by default `clang` and `ar` are used but this is
   [configurable](https://github.com/parallaxsecond/parsec/blob/master/build-conf.toml)
- `wget`
- `tar`
- `make`
- `python3`

### PKCS 11 Crypto

The PKCS 11 provider will try to dynamically load the library indicated in the configuration file,
hence a library implementing the PKCS 11 API is needed.

### TPM Crypto

The TPM provider will try to build the `tss-esapi` crate which needs built TSS 2.0 esys and tctildr
libraries. It will use `pkg-config` to find them using the names `tss2-esys` and `tss2-tctildr`.

## Cross-compiling for Arm64

To cross-compile the service for the Linux on Arm64 target, you will need to install the appropriate
toolchain for this target. By default the Arm GNU toolchain is used to compile Mbed Crypto and link
everything together. The `aarch64-linux-gnu-*` tools will be needed. Change `build-conf.toml` and
`.cargo/config` files to change the cross-compiling toolchain used. Just execute the following
command to cross-compile for the Linux on Arm64 target:

```````
cargo build --target aarch64-unknown-linux-gnu
```````

*Copyright (c) 2019, Arm Limited. All rights reserved.*
