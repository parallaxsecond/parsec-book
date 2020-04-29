# Providers

This document offers details on the currently supported providers.

For information regarding the function providers play in the Parsec service, read the [*Interfaces
and Dataflow*](interfaces_and_dataflow.md) doc. For details on how the service code is structured
around providers, read the [*Source Code Structure*](source_code_structure.md) doc.

## Core Provider

**Provider UUID: 47049873-2a43-4845-9d72-831eab668784**

The core provider is a non-cryptographic provider, tasked with storing and distributing both static
and dynamic information about the service. It is the base for service discovery, helping clients
identify what functionality is available.

One instance of the core provider must always be running with a provider ID of 0.

## Mbed Provider

**Provider UUID: 1c1139dc-ad7c-47dc-ad6b-db6fdb466552**

The Mbed provider is a software-based provider built on top of Mbed Crypto - the reference
implementation of the PSA cryptography specification. Mbed Crypto is loaded as a static library and
executes with the rest of the service in user-space.

The software version of the Mbed provider is meant as a proof-of-concept and should not be used in
real-world environments. Future improvements will expand the security guarantee of Mbed Crypto-based
providers.

## TPM Provider

**Provider UUID: 1e4954a4-ff21-46d3-ab0c-661eeb667e1d**

The TPM provider offers an abstraction over hardware (or software) Trusted Platform Modules (TPM)
version 2. It uses the TPM2 Software Stack [Enhanced System
API](https://trustedcomputinggroup.org/resource/tcg-tss-2-0-enhanced-system-api-esapi-specification/)
to communicate with the TPM and thus requires the TSS libraries to be on the machine.

Follow the [installation guide](https://github.com/tpm2-software/tpm2-tss/blob/master/INSTALL.md) to
install the TSS libraries. To use the "device" TCTI, the user running Parsec will need to have
access rights on `/dev/tpm0` and `/dev/tpmrm0`. For that matter, installing the udev rules is needed
and the user running Parsec will need to be in the `tss` group.

The provider operates with keys based in the Owner Hierarchy. Thus, Parsec needs to be able to
authenticate with the TPM and to create a primary key and children keys derived from the primary.
Given current constraints, only one request at a time can be serviced by this provider - the rest
being blocked, waiting their turn.

## PKCS 11 Provider

**Provider UUID: 30e39502-eba6-4d60-a4af-c518b7f5e38f**

The PKCS11 provider is a wrapper around the PKCS 11 standard interface, capable of working with
software or hardware modules that expose this API. Linking is done dynamically, and requires a
library that can drive the crypto engine.

Connecting to the PKCS11 module requires a slot number and, ideally, a PIN number that secures the
slot.

*Copyright 2019 Contributors to the Parsec project.*
