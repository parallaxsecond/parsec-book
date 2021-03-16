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
folder contain the `Dockerfile` and Parsec configuration needed to run Parsec for the corresponding
tests.

| Name                                                                                                                                       | Description                                                                                                                                                                             |
|--------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [All providers normal e2e tests](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/all_providers/normal.rs)             | End-to-end tests on a service with all providers. Mostly to test core operations.                                                                                                       |
| [All providers cross-providers e2e tests](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/all_providers/cross.rs)     | Test that the output of various operations from different providers is accepted by the other providers.                                                                                 |
| [All providers configuration e2e tests](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/all_providers/config)         | These check if the behaviour of the service is correct before and after reloading with a different configuration.                                                                       |
| [All providers multitenancy e2e tests](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/all_providers/multitenancy.rs) | Test that multiple tenants of Parsec using different authentication methods can not access each other's keys.                                                                           |
| [Per provider normal tests](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/per_provider/normal_tests)                | E2E tests checking most cryptographic operations on a single provider. Parsec results are also verified with third party software crypto implementations (ring, the rsa crate, etc...). |
| [Per provider persistence tests](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/per_provider/persistent_before.rs)   | E2E tests checking correct behaviour of the service around persistence of keys in the Key Info Manager.                                                                                 |
| [Per provider stress tests](https://github.com/parallaxsecond/parsec/tree/master/e2e_tests/tests/per_provider/stress_test.rs)              | Stress tests executing a large number of canonical operations at high frequency on a single provider.                                                                                   |

## Fuzz testing

| Name                                                                      | Description                                                                   |
|---------------------------------------------------------------------------|-------------------------------------------------------------------------------|
| [Fuzz testing](https://github.com/parallaxsecond/parsec/tree/master/fuzz) | Tests sending random requests to the service and waiting it to crash/timeout. |

## Unit testing

| Name                                                                                                                                | Description                                                                                                                              |
|-------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|
| [Direct authenticator tests](https://github.com/parallaxsecond/parsec/blob/master/src/authenticators/direct_authenticator/mod.rs)   | Testing the `Authenticate` trait with this authenticator.                                                                                |
| [On-disk key info manager tests](https://github.com/parallaxsecond/parsec/blob/master/src/key_info_managers/on_disk_manager/mod.rs) | Testing the `ManageKeyInfo` trait with various strings for application and key names. The persistence is tested in the end-to-end tests. |

## In dependencies

The dependencies that we maintain in the `parallaxsecond` organisation also contain their own set of
integration and unit tests: `parsec-interface-rs`, `rust-psa-crypto` and `rust-tss-esapi`.

*Copyright 2020 Contributors to the Parsec project.*
