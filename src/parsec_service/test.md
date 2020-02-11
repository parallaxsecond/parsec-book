# How to test Parsec

Parsec relies on a mix of unit, integration, stress and fuzz tests. Unit tests are usually found in
the same module as the code they verify. Integration tests can be found in the `tests` directory
(along with the code framework required for running them), and come in two flavours: single-provider
and all-providers.

Single-provider tests do a thorough verification of each individual provider, while all-providers
tests check that the common functionality is capable of supporting multiple providers at the same
time. Another subcategory of integration tests are persistance tests which check that key material
is persisted through service restarts.

The stress test simply constructs and sends random requests as fast as possible using a
multithreaded client. Valid requests are sent intermittently so as to check that the service is
still up and working correctly.

The `tests/ci.sh` script executes all tests and is used on the CI.
[`rustfmt`](https://github.com/rust-lang/rustfmt) and
[`clippy`](https://github.com/rust-lang/rust-clippy) are needed for code formatting and static
checks.

The [test client](https://github.com/parallaxsecond/parsec-client-test) is used for integration
testing. Check that repository for more details.

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

### Integration tests

#### Normal integration tests

```
cargo test normal_tests
```

#### Persistence integration tests

Those check if the Key ID mapping persist after a shutdown (check the `tests/ci.sh` script for
details of commands to execute).

#### Stress tests

```
cargo test stress_test
```

#### All providers integration tests.

This expect the Parsec service to include all providers.

```
cargo test all_providers
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

*Copyright (c) 2019, Arm Limited. All rights reserved.*
