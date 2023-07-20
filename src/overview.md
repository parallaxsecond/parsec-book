# Welcome to Parsec

**Parsec** is the **P**latform **A**bst**R**action for **SEC**urity, a new open-source initiative to
provide a common [API](parsec_client/api_overview.md) to secure services in a platform-agnostic way.

Parsec aims to define a universal software standard for interacting with secure object storage and
cryptography services, creating a common way to interface with functions that would traditionally
have been accessed by more specialised APIs. Parsec establishes an ecosystem of developer-friendly
libraries in a variety of popular programming languages. Each library is designed to be highly
ergonomic and simple to consume. This growing ecosystem will put secure facilities at the fingertips
of developers across a broad range of use cases in infrastructure computing, edge computing and the
secure Internet of Things.

# Why Platform-Agnostic Security?

Today's computing platforms have evolved to offer a range of facilities for secure storage and
secure operations. There are hardware-backed facilities such as the Hardware Security Module (HSM)
or Trusted Platform Module (TPM). There are firmware services running in Trusted Execution
Environments (TEE). There are also cloud-based security services. At a bare minimum, security
facilities may be provided purely in software, where they are protected by mechanisms provided in
the operating system.

Over the years, software standards have emerged to allow developers to use these facilities from
their applications. But these standards bring with them the following challenges:

- They are defined with the expectation that the caller is the "owner" of the platform, meaning that
   it has sole access to the underlying hardware. In reality, this is often not the case, because
   the caller might reside in a container or virtual machine, where it is sharing the host hardware
   with other applications. Existing software standards do not cater well for this situation.
- They are defined exhaustively, with lengthy specifications detailing all permissible operations
   and parameters. They are written from the perspective of the security device and its
   capabilities, rather than from the perspective of the application and its use case. This can
   offer a daunting and bewildering experience for developers, who spend a lot of time and effort
   figuring out how to map their use case onto the API. There is nothing to tailor the API so that
   it can be consumed easily for common, simple cases.
- They are specific to a programming language such as C. To consume them in other languages, it is
   necessary to use interoperability layers such as Foreign Function Interface (FFI), which can make
   the developer experience even more cumbersome and unnatural. Interoperability layers can also be
   a source of vulnerabilities.
- Standards tend to be adopted based on some knowledge of the target platform. So while it might be
   possible for code to be portable across multiple HSM vendors, for example, it is much harder to
   make code portable between an HSM-based platform and a TPM-based platform.

Parsec inverts this traditional approach to standardizing security interfaces, and it does so by
putting applications front and center. It offers an API that is no less comprehensive, but it does
so in a way that puts the needs of applications and their common use cases first.

Applications simply want the best-available security, and they want to be able to consume it in a
way that is simple, natural, and hard to get wrong.

The following observations can be made about such applications:

- They can be written in a variety of programming languages.
- They may be written with no explicit knowledge of the hardware capabilities of the target
   platform, such as whether an HSM or TPM is available.
- They are often sharing the target platform hardware with other applications due to the use of
   virtualization or containerization technology.
- The secure assets owned by one application must be isolated from those owned by another. For
   example, private keys provisioned on a hardware device must be isolated such that only the
   provisioning application would be able to perform subsequent operations with those keys.
- They have differing requirements in terms of permissible cryptographic algorithms and key
   strengths.

These observations motivate the need for a new platform abstraction that offers a common palette of
security primitives via a software interface that is both agnostic with respect to the underlying
hardware capabilities, and also capable of supporting multiple client applications on the same host,
whether those be within containers or within traditional virtual machines.

Parsec is a new software architecture and ecosystem that addresses this need.

# Basis in Platform Security Architecture

Parsec is founded on the [**Platform Security Architecture
(PSA)**](https://developer.arm.com/architectures/security-architectures/platform-security-architecture).
The PSA is a holistic set of threat models, security analyses, hardware and firmware architecture
specifications, and an open source firmware reference implementation. The PSA provides a recipe,
based on industry best practice, that allows security to be consistently designed in, at both a
hardware and firmware level.

One of the provisions of the PSA is the [**PSA Crypto
API**](https://github.com/ARMmbed/mbed-crypto/blob/psa-crypto-api/docs/PSA_Cryptography_API_Specification.pdf).
The PSA Crypto API is a comprehensive library of modern security primitives covering the following
functional areas:

- Key provisioning and management
- Hashing
- Signing
- Message Authentication Codes (MAC)
- Asymmetric encryption
- Symmetric encryption
- Authenticated Encryption with Associated Data (AEAD)
- Key derivation
- Entropy (random number generation)

A crucial characteristic of the PSA Crypto API is that applications always reference the keys
opaquely, making it ideally suited to implementations where keys are provisioned within hardware and
are never exposed.

The PSA Crypto API is defined in the C language. Parsec adopts the operations and contracts of the C
API, and uses them as the basis for a language-independent [**wire
protocol**](parsec_client/wire_protocol.md). Each [operation](parsec_client/operations) is defined,
along with all of its inputs and outputs, as a serializable contract, making it suitable to be
invoked over an Inter-Process Communication (IPC) transport. Parsec maintains functional equivalence
with the PSA Crypto API, but allows for out-of-process callers in any programming language.

# The Parsec Service

The core component of Parsec is the **security service** (or **security daemon**). This is a
background process that runs on the host platform and provides connectivity with the secure
facilities of that host and surfaces the wire protocol based on PSA Crypto.

The security service listens on a suitable transport medium. The transport technology is one of
Parsec's many pluggable components, and no single transport is mandated. Choice of transport is
dependent on the operating system and the deployment. On Linux-based systems where the client
applications are running in containers (isolation with a shared kernel), the transport can be based
on Unix sockets.

Client applications make connections with the service by posting API requests to the transport
endpoint. This is usually done via a client library that hides the details of both the wire protocol
and the transport. This is one of the ways in which the client library simplifies the experience of
Parsec for application developers.

A single instance of the Parsec service executes on each physical host. In virtualized environments,
the Parsec service may reside on a specially-assigned guest, or potentially within the hypervisor.

The security service does not support remote client applications. Each physical host or node must
have its own instance of the service. However, it is possible for the service to initiate outbound
remote calls of other services, such as cloud-hosted HSM services.

# Multitenancy and Access Control

In addition to surfacing the common API, the Parsec service is also responsible for brokering access
to the underlying security facilities amongst the multiple client applications. The exact way that
this is done will vary from one deployment to another. (See the section below on pluggable back-end
modules). Some of the brokering functionality may already reside in kernel drivers and other parts
of the software stack. The Parsec service is responsible for creating isolated views of key storage
and cryptographic services for each client application. The secure assets of one client must be kept
protected from those of another.

Central to this multi-tenant operation is the notion of **application identity** and the need for a
separate **identity provider** service. A Parsec-enabled host must contain an identity provider
service in addition to the Parsec service itself.

For more information about application identities and the identity provider, please refer to the
[**system architecture**](archive/system_architecture.md) document.

# Pluggable Back-End Modules

The Parsec service employs a layered architecture, structured into a front-end and a back-end.

The front-end module provides the transport endpoint and listens for connections from clients. The
front-end understands the wire protocol and the common API. It is responsible for serialization and
de-serialization of the operation contracts.

The back-end modules are known as **providers**. An instance of the Parsec security service can load
one or more providers. Providers implement the API operations using platform-specific or
vendor-specific code. They provide the "last mile" of connectivity down to the underlying hardware,
software or firmware.

For a deeper dive into the modular structure of the Parsec service, please take a look at the
[**interfaces and dataflow**](parsec_service/interfaces_and_dataflow.md) design document.

Then delve into the [**source code**](parsec_service/source_code_structure.md) to discover the
back-end provider modules that exist. If you cannot find one that is compatible with the platform
you intend to use, then please consider contributing a new provider.

# Beautiful Client Libraries

A key aim of Parsec is to evolve an ecosystem of developer-friendly client libraries in multiple
programming languages.

Parsec avoids the cumbersome, auto-generated language bindings that are so often a part of
standardized interfaces.

Parsec's client libraries are beautiful.

Each client library is carefully crafted to follow the idioms of the language that it targets.
Consuming a Parsec client library will always feel natural to a developer who works in that
language. Everything from naming conventions to object lifecycle will be blended to create a
highly-idiomatic developer experience.

But Parsec's focus on developer ergonomics goes further than this. Parsec's client interface is
filled with conveniences to eliminate complexity unless complexity is required. The Parsec API is
functionally equivalent with the PSA Crypto API, and none of this functional completeness is lost in
the client layer. All possible variants of key type and algorithm type are exposed in case they are
needed. But the client library offers smart default behaviours so that simple use cases can be
achieved with very little code. Parsec enables client code to be small and elegant. And even if it
needs to be less small, it should still be elegant.

# Source Code Structure

Parsec is composed of multiple code repositories. For more information about how the code in the
repository is organized, please see the [**source code
structure**](parsec_service/source_code_structure.md) document.

*Copyright 2019 Contributors to the Parsec project.*
