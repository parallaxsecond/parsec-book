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
overview](https://parallaxsecond.github.io/parsec-book/parsec_client/api_overview.html#authentication-and-sessions),
[system
architecture](https://parallaxsecond.github.io/parsec-book/parsec_service/system_architecture.html#authentication)
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

*Copyright 2020 Contributors to the Parsec project.*
