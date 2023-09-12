# Pull request reviewer checklist

The following checklist is intended for reviewers of pull requests to Parsec-related repositories.
It is only intended for guidance and not for strict enforcing.

## Code-wise

Follow [Rust API guidelines](https://rust-lang.github.io/api-guidelines/about.html)

Usage of `unsafe` blocks, `.unwrap()`, `.expect(...)`, `panic!(...)` etc. should be strictly limited
to well understood and controlled cases and documented properly.

Abstract types should be preferred to generic representations - e.g. instead of representing PSA
algorithms as a bitfield like in the spec, a rich Rust-native type was used.

Buffers should be zeroed out after usage if they contain any sensitive data.

Logs should not contain sensitive data, and should only present detailed data and error information
(such as stack traces) if configured so.

Parsec should follow the [Rust Style
Guide](https://doc.rust-lang.org/nightly/style-guide/#rust-style-guide) and [Rust official
lints](https://rust-lang.github.io/rust-clippy/master/index.html), both of which are enforced by the
tools mentioned in the [How to test
Parsec](https://parallaxsecond.github.io/parsec-book/parsec_service/tests/index.html) section, on
static checks.

New functionality is properly tested.

## Threat model

The [threat
model](https://parallaxsecond.github.io/parsec-book/parsec_security/parsec_threat_model/threat_model.html)
should be reviewed if:

- Avenues for communication between the service and the rest of the system are created or modified
- Components that deal with authenticating requests are created or modified
- Key namespacing is altered in any way

Special care should also be taken around the bits of code that enforce key policies.

## Documentation

If changes are made to the authentication process, [the API
overview](https://parallaxsecond.github.io/parsec-book/parsec_client/api_overview.html#authentication-and-sessions)
and
[authenticators](https://parallaxsecond.github.io/parsec-book/parsec_service/authenticators.html)
pages should be checked.

If new response codes are added, please review the [status codes
page](https://parallaxsecond.github.io/parsec-book/parsec_client/status_codes.html).

If improving support for one of the providers, please check the [service API coverage
page](https://parallaxsecond.github.io/parsec-book/parsec_client/operations/service_api_coverage.html).

If large changes are made (including additions or deletions) to the source code structure, please
check the [associated
page](https://parallaxsecond.github.io/parsec-book/parsec_service/source_code_structure.html).

If changes are made to the placement (in the filesystem) of service components or utility files,
please check the [build and
run](https://parallaxsecond.github.io/parsec-book/parsec_service/build_run.html), [secure
installation](https://parallaxsecond.github.io/parsec-book/parsec_service/install_parsec_linux.html)
pages.

If changes are made to the CLI arguments (Cargo features or other arguments parsed by the service
binary) that need to be passed to run Parsec or its tests, please check the [build and
run](https://parallaxsecond.github.io/parsec-book/parsec_service/build_run.html), [secure
installation](https://parallaxsecond.github.io/parsec-book/parsec_service/install_parsec_linux.html)
and [testing](https://parallaxsecond.github.io/parsec-book/parsec_service/tests/index.html) pages.

If new kinds of tests are added, please check the
[testing](https://parallaxsecond.github.io/parsec-book/parsec_service/tests/index.html) page and its
child.

## Testing

Pull requests introducing new features create new ways in which the service interacts with its
environment. All such new avenues must be thoroughly tested to check both for potential flaws in the
current implementation, and possible regressions due to future iterations or changes.

A list of current types of tests can be found
[here](https://parallaxsecond.github.io/parsec-book/parsec_service/tests/existing_tests.html). The
list only looks at the high-level types of tests that we support, but should be a good guide to what
types of tests must be enabled or written. For example:

- When a **new provider** is introduced, or when **support for some existing operations is added to
   an existing provider**, make sure all the end-to-end tests that cover the new functionality are
   enabled. This is generally done by means of Cargo features in the `e2e-tests` crate. If the
   provider doesn't support the functionality needed for some test, make sure it is disabled using
   such features, e.g. if only EC keys are supported for asymmetric signatures, tests based on RSA
   keys should be explicitly disabled (i.e. `#[cfg(not(feature = "some-provider"))]`), as we
   currently have no mechanism for runtime detection of supported parameters. If the provider
   includes functionality which does not have proper testing (e.g. a specific key type, an elliptic
   curve, etc.), tests must be added. Ideally, when creating a new test for cryptographic
   operations, it should be enabled on the Mbed Crypto provider by default. This allows us to make
   sure the interface we expose is consistent across all providers. Lots of care **must** also be
   taken when first implementing or when modifying the interaction model with key info managers, to
   ensure stability in the long run. As such, please ensure that the provider is set up in key
   mappings tests which take care of stability of data flows between providers and data stores.
- When a **new authenticator** is introduced, make sure tests that mimic the full environment for a
   number of clients are introduced. The tests should verify that clients are properly separated
   (they cannot access each other's objects), that clients without permissions (if that concept
   exists for the authenticator) cannot access the parts of the service which require
   authentication, and that admins are recognized properly. Some of these checks can be implemented
   as unit tests.
- When a **new operation** is introduced into the service, testing must ensure not only that the
   operation works and is supported consistently across providers, but also that it fails as
   expected for a wide range of potential problems. This testing can be carried out as unit tests
   across the stack and end-to-end tests in the service.
- When **new configuration features** are added to the service that have a significant effect on how
   the service behaves, config tests should be addded to confirm the functionality works, and to
   catch future regressions.
- When a **new key info manager** is implemented, a new testing framework to ensure long-term
   stability of the mappings must be set up. The existing framework(s) for key mapping tests should
   provide a good reference.

*Copyright 2020 Contributors to the Parsec project.*
