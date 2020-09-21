# Operations

## Introduction

This document provides links to full descriptions for all of the operations in the API. The
operations are defined in a format-neutral language where types can easily and implicitely be
translated to the specific operation implementation language used.

## Overview

| Operation                                         | Opcode   |
|---------------------------------------------------|----------|
| [Ping](ping.md)                                   | `0x0001` |
| [PsaGenerateKey](psa_generate_key.md)             | `0x0002` |
| [PsaDestroyKey](psa_destroy_key.md)               | `0x0003` |
| [PsaSignHash](psa_sign_hash.md)                   | `0x0004` |
| [PsaVerifyHash](psa_verify_hash.md)               | `0x0005` |
| [PsaImportKey](psa_import_key.md)                 | `0x0006` |
| [PsaExportPublicKey](psa_export_public_key.md)    | `0x0007` |
| [ListProviders](list_providers.md)                | `0x0008` |
| [ListOpcodes](list_opcodes.md)                    | `0x0009` |
| [PsaAsymmetricEncrypt](psa_asymmetric_encrypt.md) | `0x000A` |
| [PsaAsymmetricDecrypt](psa_asymmetric_decrypt.md) | `0x000B` |
| [PsaExportKey](psa_export_key.md)                 | `0x000C` |
| [PsaGenerateRandom](psa_generate_random.md)       | `0x000D` |
| [ListAuthenticators](list_authenticators.md)      | `0x000E` |
| [PsaHashCompute](psa_hash_compute.md)             | `0x000F` |
| [PsaHashCompare](psa_hash_compare.md)             | `0x0010` |
| [PsaAeadEncrypt](psa_aead_encrypt.md)             | `0x0011` |
| [PsaAeadDecrypt](psa_aead_decrypt.md)             | `0x0012` |
| [PsaRawKeyAgreement](psa_raw_key_agreement.md)    | `0x0013` |
| [PsaCipherEncrypt](psa_cipher_encrypt.md)         | `0x0014` |
| [PsaCipherDecrypt](psa_cipher_decrypt.md)         | `0x0015` |
| [PsaMacCompute](psa_mac_compute.md)               | `0x0016` |
| [PsaMacVerify](psa_mac_verify.md)                 | `0x0017` |
| [PsaSignMessage](psa_sign_message.md)             | `0x0018` |
| [PsaVerifyMessage](psa_verify_message.md)         | `0x0019` |

Find here the [current level of support](service_api_coverage.md) of those operations in Parsec.

## Status Note

This is preliminary documentation. It may be incomplete, and is subject to change without notice.
Some operations are listed without being linked to documentation pages. These operations are not
currently supported, but are intended for future roadmap. Only a small number of the PSA Crypto
operations are supported in the current version.

## Identity Operations

Identity operations are not supported by the security service. These operations are reserved for use
only by the identity provider, which is a separate service in the system, but supports a common wire
protocol.

- [AddClient](add_client.md)
- [ProveClient](prove_client.md)

## Core Operations

Core operations are non-cryptographic operations supported by the core provider. Set the
**provider** field of the request header to 0 (`0x00`) to invoke these operations.

### Service Health

- [Ping](ping.md)

### Service Configuration

- [ListProviders](list_providers.md)
- [ListOpcodes](list_opcodes.md)
- [ListAuthenticators](list_authenticators.md)

### Trust

- [ShareTrustBundle](share_trust_bundle.md)

## PSA Crypto Operations

These operations are all derived from equivalent function definitions in the [**PSA Crypto API
Specification**](https://developer.arm.com/architectures/security-architectures/platform-security-architecture/documentation).
Most of the documentation in this book directly come from the specification.

### Key Management

- [PsaImportKey](psa_import_key.md)
- [PsaGenerateKey](psa_generate_key.md)
- PsaCopyKey
- [PsaDestroyKey](psa_destroy_key.md)
- PsaPurgeKey
- [PsaExportKey](psa_export_key.md)
- [PsaExportPublicKey](psa_export_public_key.md)

### Message Digests

- [PsaHashCompute](psa_hash_compute.md)
- [PsaHashCompare](psa_hash_compare.md)
- PsaHashOperationInit
- PsaHashSetup
- PsaHashUpdate
- PsaHashFinish
- PsaHashVerify
- PsaHashAbort
- PsaHashSuspend
- PsaHashResume
- PsaHashClone

### Message Authentication Codes (MAC)

- [PsaMacCompute](psa_mac_compute.md)
- [PsaMacVerify](psa_mac_verify.md)
- PsaMacOperationInit
- PsaMacSignSetup
- PsaMacVerifySetup
- PsaMacUpdate
- PsaMacSignFinish
- PsaMacVerifyFinish
- PsaMacAbort

### Unauthenticated Ciphers

- [PsaCipherEncrypt](psa_cipher_encrypt.md)
- [PsaCipherDecrypt](psa_cipher_decrypt.md)
- PsaCipherOperationInit
- PsaCipherEncryptSetup
- PsaCipherDecryptSetup
- PsaCipherGenerateIv
- PsaCipherSetIv
- PsaCipherUpdate
- PsaCipherFinish
- PsaCipherAbort

### Authenticated Encryption with Associated Data (AEAD)

- [PsaAeadEncrypt](psa_aead_encrypt.md)
- [PsaAeadDecrypt](psa_aead_decrypt.md)
- PsaAeadOperationInit
- PsaAeadEncryptSetup
- PsaAeadDecryptSetup
- PsaAeadGenerateNonce
- PsaAeadSetNonce
- PsaAeadSetLengths
- PsaAeadUpdateAd
- PsaAeadUpdate
- PsaAeadFinish
- PsaAeadVerify
- PsaAeadAbort

### Key Derivation

- PsaKeyDerivationOperationInit
- PsaKeyDerivationSetup
- PsaKeyDerivationGetCapacity
- PsaKeyDerivationSetCapacity
- PsaKeyDerivationInputBytes
- PsaKeyDerivationInputKey
- PsaKeyDerivationOutputBytes
- PsaKeyDerivationOutputKey
- PsaKeyDerivationAbort

### Asymmetric Signature

- [PsaSignMessage](psa_sign_message.md)
- [PsaVerifyMessage](psa_verify_message.md)
- [PsaSignHash](psa_sign_hash.md)
- [PsaVerifyHash](psa_verify_hash.md)

### Asymmetric Encryption

- [PsaAsymmetricEncrypt](psa_asymmetric_encrypt.md)
- [PsaAsymmetricDecrypt](psa_asymmetric_decrypt.md)

### Key Agreement

- [PsaRawKeyAgreement](psa_raw_key_agreement.md)
- PsaKeyDerivationKeyAgreement

### Random Number Generation

- [PsaGenerateRandom](psa_generate_random.md)

*Copyright 2019 Contributors to the Parsec project.*
