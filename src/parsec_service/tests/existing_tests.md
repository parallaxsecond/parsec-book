# List of existing tests

The code coverage information of some of Parsec repositories can be found
[here](https://codecov.io/gh/parallaxsecond).

## End-to-end testing

These tests are meant to be executed on a running Parsec service and using a Parsec client to
communicate to it. The
[`parsec/e2e_tests`](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests) crate contains
a test client based on the Rust client that is used inside the tests written in
[`parsec/e2e_tests/tests`](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests).

The end-to-end tests contain tests to be executed:

- with a Parsec service containing a single provider:
   [`per_provider`](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/per_provider)
   tests
- with a Parsec service containing all providers:
   [`all_providers`](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/all_providers)

The
[`parsec/e2e_tests/provider_cfg`](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/provider_cfg)
folder contain the configuration needed to run Parsec for the corresponding tests.

| Name                                                                                                                                       | Description                                                                                                                                                                               |
|--------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [All providers normal e2e tests](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/all_providers/normal.rs)             | End-to-end tests on a service with all providers. Mostly to test core operations.                                                                                                         |
| [All providers cross-providers e2e tests](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/all_providers/cross.rs)     | Test that the output of various operations from different providers is accepted by the other providers.                                                                                   |
| [All providers configuration e2e tests](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/all_providers/config)         | These check if the behavior of the service is correct before and after reloading with a different configuration.                                                                          |
| [All providers multitenancy e2e tests](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/all_providers/multitenancy.rs) | Test that multiple tenants of Parsec using different authentication methods can not access each other's keys.                                                                             |
| [Per provider normal tests](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/per_provider/normal_tests)                | E2E tests checking most cryptographic operations on a single provider. Parsec results are also verified with third party software crypto implementations (ring, the rsa crate, etc...).   |
| [Per provider key mappings tests](https://github.com/parallaxsecond/parsec/blob/main/e2e_tests/tests/per_provider/key_mappings.rs)         | E2E tests checking that key created by an older version of Parsec can still be retrieved and used correctly. It also checks that wrong mappings are deleted.                              |
| [Per provider stress tests](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/per_provider/stress_test.rs)              | Stress tests executing a large number of canonical operations at high frequency on a single provider.                                                                                     |
| [Old e2e tests](https://github.com/parallaxsecond/parsec/blob/main/e2e_tests/docker_image/import-old-e2e-tests.sh)                         | Tests executed from an old version of the Rust client to make sure the operation contracts are stable. The executed tests are the per provider normal tests.                              |
| [Per-provider key-mappings tests](https://github.com/parallaxsecond/parsec/blob/main/e2e_tests/tests/per_provider/key_mappings.rs)         | Tests that make use of previously-generated key mappings files along with the corresponding entries within the target providers, to ensure the stability of key mappings across versions. |
| [OnDisk KIM tests](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/all_providers/normal.rs)                           | Tests the OnDisk KIM with the `all-providers` end-to-end tests to ensure the correct functioning of the KIM. All other tests are run using the SQLite KIM.                                |
| [TPM reset tests](https://github.com/parallaxsecond/parsec/blob/main/e2e_tests/tests/per_provider/tpm_reset.rs)                            | Tests that verify that keys created with the TPM provider can be used following a TPM reset (i.e., simulating a reboot for certain platforms).                                            |

## Fuzz testing

| Name                                                                      | Description                                                                   |
|---------------------------------------------------------------------------|-------------------------------------------------------------------------------|
| [Fuzz testing](https://github.com/parallaxsecond/parsec/tree/master/fuzz) | Tests sending random requests to the service and waiting it to crash/timeout. |

## Unit testing

| Name                                                                                                                                | Description                                                                                                                              |
|-------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|
| [Direct authenticator tests](https://github.com/parallaxsecond/parsec/blob/master/src/authenticators/direct_authenticator/mod.rs)   | Testing the `Authenticate` trait with this authenticator.                                                                                |
| [On-disk key info manager tests](https://github.com/parallaxsecond/parsec/blob/master/src/key_info_managers/on_disk_manager/mod.rs) | Testing the `ManageKeyInfo` trait with various strings for application and key names. The persistence is tested in the end-to-end tests. |
| [SQLite key info manager tests](https://github.com/parallaxsecond/parsec/blob/main/src/key_info_managers/sqlite_manager/mod.rs)     | Testing the `ManageKeyInfo` trait with various strings for application and key names. The persistence is tested in the end-to-end tests. |

## Cross-compilation tests

Given that Parsec is expected to run natively on as many platforms as possible, we have incorporated
cross-compilation testing in our CI framework. These check that the service can be built for the
following platform triples:

- `arm-linux-gnueabihf`
- `aarch64-linux-gnu`
- `i686-linux-gnu`

Cross-compilation is tested for the PKCS11, Mbed Crypto, and TPM providers. The Trusted Service
provider is included for cross-compilation to aarch64. You can see details of this test
[here](https://github.com/parallaxsecond/parsec/blob/main/test/cross-compile.sh). All other CI jobs
run in `x86_64-linux-gnu`.

## In dependencies

The dependencies that we maintain in the `parallaxsecond` organization also contain their own set of
integration and unit tests: `parsec-interface-rs`, `rust-psa-crypto`, `rust-tss-esapi`, and
`rust-cryptoki`.

*Copyright 2020 Contributors to the Parsec project.*
