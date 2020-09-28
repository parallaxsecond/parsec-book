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
guides](tests#testing-the-tpm-provider-using-the-software-tpm).

On a real deployment (as explained in our [installation guide](install_parsec_linux.md)) specific
owners and permissions need to be set up on multiple folders. Those security settings will be
checked by the clients for them to make sure they are communicating with a trusted Parsec service.
For testing only, it is fine to run Parsec from the current directory, have the key information
mappings in `./mappings` and the socket at `/tmp/parsec.sock`. The test configuration will make
those choices.

Having cloned the Parsec repository, to build and run from source using the Mbed Crypto provider and
the test configuration:

```````
RUST_LOG=info cargo run --features mbed-crypto-provider -- -c e2e_tests/provider_cfg/mbed-crypto/config.toml
```````

`parsec` will then construct the service based on the configuration file and wait for clients.

At the end of initialization, it should print `Parsec is ready` which means that it is ready to take
requests from clients:

```
[INFO  parsec] Parsec started. Configuring the service...
[INFO  parsec_service::utils::service_builder] Creating a Mbed Crypto Provider.
[WARN  parsec_service::front::domain_socket] Incorrect user. Parsec should be run as user parsec. Follow recommendations to install Parsec securely or clients might not be able to connect.
[INFO  parsec] Parsec is ready.
```

The `WARN` log warns us that we are not following the secure installation practices which is fine as
this is for testing.

From another terminal, it is now possible to execute the [end-to-end tests](tests#end-to-end-tests)
on Parsec!

```````
cd e2e_tests
cargo test --features mbed-crypto-provider normal_tests
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

*Copyright 2019 Contributors to the Parsec project.*
