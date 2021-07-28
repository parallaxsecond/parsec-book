# Parsec Stability

Work in progress, see the [related issue](https://github.com/parallaxsecond/parsec-book/issues/83).

## Why is stability important?

Parsec is a long-running service that will be configured, deployed, upgraded and maintained over a
long period of time. The environment will also have client applications that are calling it, and
persistent state that is collected on storage. Components will be upgraded over time. For Parsec to
be supportable in enterprise system, it must not be brittle against upgrades. If Parsec is upgraded
and restarted, client applications should continue working, and all persistent state from prior
versions should remain valid and usable.

## What does stability mean for the Parsec service?

The following definition of stability is chosen for the Parsec service: *whatever two versions A and
B of the Parsec binary, B being newer than A, A and B are stable if A can be removed and replaced by
B without breaking anything*.

Note that we are not looking at stability in the reverse direction: B cannot be replaced by A
without breaking anything. The only exception is for the communication channel with clients where
any version of the client library can successfully communicate with any version of the service.

The principle of [semantic versioning](https://semver.org/) is used to describe the stability of
Parsec versions and when breaking changes are done. If `parsec` version is at `1.0.0` then all
future stable version to that will be `1.x.y`. Note that, although semver is used to describe Parsec
stability, it is a strong goal for Parsec to remain stable at a `1.x.y` version. This document
introduces the efforts that are made so that a `MAJOR` version bump should hopefully never happen.

## What needs to be stable?

With the above definition, Parsec stays stable if it keeps the exact same communication channels and
format with its environment. Those are already described in the [dataflow
diagram](../parsec_security/parsec_threat_model/threat_model.md#dataflow-diagram) in the threat
model.

The communication channels that need to be stable are (some of them are not in the diagram):

1. Communication with clients
   1. Definition of requests/responses (their format)
   2. Definition of operation contracts (their intended behaviour)
   3. Definition of Listeners endpoints (how to contact Parsec)
2. Communication with authenticators
3. Communication received from the CLI invocation
4. Configuration file (including default configuration options)
5. Persistent data stored internally
   1. Key mappings
6. OS signals
7. systemd communication
8. Dynamic libraries dependencies
9. Environment variables
10. Hardware backends
11. Build toolchain

Those will be described as "stability requirement" in the remainder of this document. As new
features are added to the codebase, new stability requirements might appear. Those should be added
to the list above and looked in detail below.

## Stability Review

Let's look at each of the points above and check:

- what stability exactly means
- how stability is ensured
- how stability is tested

| Stability Requirement                            | Stability Definition                                                                                                                                   | Stability Enforcement                                                                                                                                                                                                                                               | Stability Test                                                                                             |
|--------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------|
| Communication with clients (requests/responses)  | Requests and responses must be understood correctly by different versions of the service/clients.                                                      | The Wire Protocol is [stable by design](../parsec_client/wire_protocol.md#wire-protocol-versions).                                                                                                                                                                  | [Done](https://github.com/parallaxsecond/parsec/issues/388)                                                |
| Communication with clients (operation contracts) | The behaviour of operations must remain the same for all versions of the service.                                                                      | There is a [defined behaviour](https://parallaxsecond.github.io/parsec-book/parsec_client/operations/index.html) for all operations that is respected.                                                                                                              | [Done](https://github.com/parallaxsecond/parsec/issues/389)                                                |
| Communication with clients (listeners endpoint)  | Listeners endpoint must be discovered in a stable way.                                                                                                 | A [service discovery mechanism](../parsec_client/api_overview.md#service-discovery) exists.                                                                                                                                                                         | [Done](https://github.com/parallaxsecond/parsec/issues/390)                                                |
| Authenticators                                   | Authentication requests sent by future stable versions of Parsec should be understood by the same version of the authenticators present on the system. | Unix Peer Crendentials: based on top of stable C standard library APIs. JWT SVID: authentication is based on the [SPIFFE Workload API](https://github.com/spiffe/spiffe/blob/master/standards/SPIFFE_Workload_API.md) which is a standard and should remain stable. | [Done](https://github.com/parallaxsecond/parsec/issues/391)                                                |
| CLI invocation                                   | Old CLI invocations of Parsec should still work with for future stable Parsec versions. Optional flags should have the same defaults.                  | CLI flags should not be removed. Defaults should not be changed. New flags should be optional.                                                                                                                                                                      | [Done](https://github.com/parallaxsecond/parsec/issues/392)                                                |
| Configuration file                               | Old configuration files should still work with future stable Parsec versions, with the same default for optional options.                              | Configuration options should not disappear in future stable Parsec versions. Configuration defaults should remain the same. New options should be optional.                                                                                                         | [Done](https://github.com/parallaxsecond/parsec/issues/393)                                                |
| Persistent state (key mappings)                  | Old key mappings should still be read correctly by future stable Parsec versions.                                                                      | The way the KIM persistently stores the mappings need to be backward-compatible in regards with reading/writing.                                                                                                                                                    | [Done](https://github.com/parallaxsecond/parsec/issues/394) for the Mbed Crypto, PKCS11 and TPM providers. |
| OS signals                                       | OS signals should still have the same behaviour in future stable Parsec versions.                                                                      | Signal handlers must not be removed in Parsec.                                                                                                                                                                                                                      | [Done](https://github.com/parallaxsecond/parsec/issues/395)                                                |
| systemd communication                            | systemd should receive the same status information from Parsec in future stable versions.                                                              | Status notifications must not be removed.                                                                                                                                                                                                                           | [Done](https://github.com/parallaxsecond/parsec/issues/396)                                                |
| Dynamic libraries dependencies                   | Linking and loading the same versions of libraries should still work in future stable versions of Parsec.                                              | Stable versions of Parsec should not require newer dependencies.                                                                                                                                                                                                    | [Done](https://github.com/parallaxsecond/parsec/issues/397) and see [the list](#dynamic-libraries)         |
| Environment variables                            | Environment variables should still have the same behaviour in future stable Parsec versions.                                                           | Environment variable behaviours must not be removed in Parsec.                                                                                                                                                                                                      | [Done](https://github.com/parallaxsecond/parsec/issues/405)                                                |
| Hardware backends                                | Communication with hardware backends for crypto and key management should still work in future Parsec versions.                                        | The communication channels with the hardware backends should remain the same.                                                                                                                                                                                       | [Done](https://github.com/parallaxsecond/parsec/issues/412)                                                |
| Build toolchain                                  | Parsec build should not break for defined versions of the Rust compiler.                                                                               | Each commit is tested with specific supported versions of the Rust compiler.                                                                                                                                                                                        | [Done](https://github.com/parallaxsecond/parsec/issues/408)                                                |

### Dynamic libraries

We use the specific versions of those dynamic libraries and test it on CI:

- PKCS#11 version 2.40
- libclang version 6.0
- TSS libraries version 2.3.3

Mbed Crypto is currently compiled from scratch. When a new LTS version of Mbed TLS ships a PSA
Crypto compliant version of Mbed Crypto, stability guarantees will be made on that version.

*Copyright 2021 Contributors to the Parsec project.*
