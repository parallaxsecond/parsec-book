# How to test Parsec

Parsec relies on a mix of unit, end-to-end, integration, stress and fuzz tests. Unit tests are
usually found in the same module as the code they verify. End-to-end and stress tests can be found
in the `e2e_tests` directory (along with the code framework required for running them), and come in
two flavours: single-provider and all-providers. Integration tests are found in the `tests`
directory and test the public module that the `parsec-service` crate exports.

Single-provider tests do a thorough verification of each individual provider, while all-providers
tests check that the common functionality is capable of supporting multiple providers at the same
time. Another subcategory of integration tests are persistance tests which check that key material
is persisted through service restarts.

The stress test simply constructs and sends random requests as fast as possible using a
multithreaded client. Valid requests are sent intermittently so as to check that the service is
still up and working correctly.

The `ci.sh` script executes all tests and is used on the CI.
[`rustfmt`](https://github.com/rust-lang/rustfmt) and
[`clippy`](https://github.com/rust-lang/rust-clippy) are needed for code formatting and static
checks.

You can see a (partial) code coverage figure [here](https://app.codecov.io/gh/parallaxsecond/parsec)
- partial because only a subset of the tests can be run with the code coverage instrumentation
enabled.

## Executing tests manually

### Static tests

#### Checking code formatting

```
cargo fmt --all -- --check
```

#### Checking lints

```
cargo clippy --all-targets --all-features -- -D clippy::all -D clippy::cargo
```

### Unit tests

#### Doc tests

```
cargo test --doc --all-features
```

#### Unit tests

```
cargo test --lib --all-features
```

### End-to-end tests

They need to be executed from the `e2e_tests` folder with a specific set of features describing for
which providers the tests should be run against. You can choose from the following list:
`mbed-crypto-provider`, `pkcs11-provider`, `tpm-provider`, `cryptoauthlib-provider`, and
`trusted-service-provider`. `all-providers` selects them all. In the following sections, the
`mbed-crypto-provider` will be assumed.

#### Normal tests

```
cargo test --features mbed-crypto-provider normal_tests
```

#### Persistence integration tests

Those check if the Key Info mapping persist after a shutdown (check the `ci.sh` script for details
of commands to execute).

#### Stress tests

```
cargo test --features mbed-crypto-provider stress_test
```

#### All providers end-to-end tests.

This expects the Parsec service to include all providers.

```
cargo test --features all-providers all_providers
```

Configuration tests, using all providers (must be run single-threaded):

```
cargo test --features all-providers config -- --test-threads=1
```

## Fuzz testing

Fuzz testing works, at the moment, on a service level, generating random requests and sending them
to be processed. Running the fuzz tests can be done through the `fuzz.sh` script in the root of the
repository. `./fuzz.sh run` builds a Docker image where the fuzz tests will run. It then sets up the
environment and initiates the test in the container. The fuzzing engine
([libFuzzer](http://llvm.org/docs/LibFuzzer.html)) works by generating random inputs for a fuzzing
target and then observing the code segments reached using said input. To stop the fuzzer, simply run
`./fuzz.sh stop`. To view the logs of a currently executing fuzzer, run `./fuzz.sh follow`. Any
crashes or slow tests, as well as tests that lead to a timeout, are stored in
`./fuzz/artifacts/fuzz_service/`.

## Testing the TPM provider using the Software TPM

If you do not have a hardware TPM, or you do not want to use it for tests, you might want to use the
IBM Software TPM. You will need to follow these steps:

- install the TSS libraries ([installation
   guide](https://github.com/tpm2-software/tpm2-tss/blob/master/INSTALL.md)). Parsec has been tested
   with version 2.3.3.
- install the [TPM tools](https://github.com/tpm2-software/tpm2-tools). Parsec has been tested with
   version 4.1.
- install the [Software TPM](https://sourceforge.net/projects/ibmswtpm2/), run `make` in the `src`
   directory. It will build the `tpm_server` executable.
- install Parsec with the `tpm-provider` feature: `cargo build --features tpm-provider`.

Once the required software is installed you can:

Launch the TPM server in the background (in the `src` folder where the TPM is installed):

```
$ rm NVChip # this deletes the TPM cache
$ ./tpm_server &
```

Use the TPM tools to startup the TPM server and set its owner hierarchy password (the tools need to
be on the `PATH`):

```
$ tpm2_startup -c -T mssim
$ tpm2_changeauth -c owner tpm_pass -T mssim
```

Start Parsec with the TPM configuration:

```
$ RUST_LOG=info ./target/debug/parsec -c e2e_tests/provider_cfg/tpm/config.toml
```

Which should print a `[INFO parsec] Parsec is ready.` You can now execute the end-to-end tests using
that provider!

## Testing the PKCS11 provider using the Software HSM

If you do not have a hardware HSM, or you do not want to use it for tests, you might want to use the
Software HSM. You will need to follow these steps:

- install [SoftHSMv2](https://github.com/opendnssec/SoftHSMv2). We use version 2.5.0 for tests in
   Parsec.
- install Parsec with the `pkcs11-provider` feature: `cargo build --features pkcs11-provider`.

Create a new token in a new slot.

```
softhsm2-util --init-token --slot 0 --label "Parsec Tests" --pin 123456 --so-pin 123456
```

The slot number assigned will be random and can be found and appended at the end of the
configuration file with the following commands:

```
SLOT_NUMBER=`softhsm2-util --show-slots | head -n2 | tail -n1 | cut -d " " -f 2`
# Find all TOML files in the directory (except Cargo.toml) and replace the commented slot number with the valid one
find . -name "*toml" -not -name "Cargo.toml" -exec sed -i "s/^# slot_number.*$/slot_number = $SLOT_NUMBER/" {} \;
```

Start Parsec with the PKCS11 configuration:

```
$ RUST_LOG=info ./target/debug/parsec -c e2e_tests/provider_cfg/pkcs11/config.toml
```

Which should print a `[INFO parsec] Parsec is ready.` You can now execute the end-to-end tests using
that provider!

## Testing the Trusted Service provider using the in-process Trusted Services stack

It is possible to test the Crypto Trusted Service integration through the `libts` for `linux-pc`
[deployment](https://trusted-services.readthedocs.io/en/integration/deployments/index.html)
available in the project source code. You can find instructions for building and installing the
library
[here](https://trusted-services.readthedocs.io/en/integration/developer/build-instructions.html).
Once the library is installed, no other steps are needed - the whole stack will be housed within the
Parsec service process, similarly to the Mbed Crypto provider.

Start Parsec with the Trusted Service configuration:

```
$ RUST_LOG=info ./target/debug/parsec -c e2e_tests/provider_cfg/trusted-service/config.toml
```

Which should print a `[INFO parsec] Parsec is ready.` You can now execute the end-to-end tests using
that provider!

**NOTE:** The in-process stack uses Mbed Crypto for the crypto implementation, and therefore the
code will be shared with the backend of the Mbed Crypto provider if both are used. Because Mbed
Crypto stores keys on disk, by default in the working directory of the process, creating keys in
both providers in parallel will lead to errors, as one will confuse the keys of the other for its
own.

*Copyright 2019 Contributors to the Parsec project.*
