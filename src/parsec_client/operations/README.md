# Operations

## Introduction

This document provides links to full descriptions for all of the operations in the API.

## Status Note

This is preliminary documentation. It may be incomplete, and is subject to change without notice.
Some operations are listed without being linked to documentation pages. These operations are not
currently supported, but are intended for future roadmap. Only a small number of the PSA Crypto
operations are supported in the current version.

## Identity Operations

Identity operations are not supported by the security service. These operations are reserved for use
only by the identity provider, which is a separate service in the system, but supports a common wire
protocol.

- [**AddClient**](add_client.md)
- [**ProveClient**](prove_client.md)

## Core Operations

Core operations are non-cryptographic operations supported by the core provider. Set the
**provider** field of the request header to 0 (`0x00`) to invoke these operations.

### Service Health

- [**Ping**](ping.md)

### Service Configuration

- [**ListProviders**](list_providers.md)
- [**ListOpcodes**](list_opcodes.md)

### Trust

- [**ShareTrustBundle**](share_trust_bundle.md)

## PSA Crypto Operations

These operations are all derived from equivalent function definitions in the [**PSA Crypto API
Specification**](https://github.com/ARMmbed/mbed-crypto/blob/psa-crypto-api/docs/PSA_Cryptography_API_Specification.pdf).

### Key Management

- [**PsaCreateKey**](psa_create_key.md)
- **PsaExportKey**
- [**PsaExportPublicKey**](psa_export_public_key.md)
- [**PsaImportKey**](psa_import_key.md)
- **PsaCopyKey**
- [**PsaDestroyKey**](psa_destroy_key.md)

### Symmetric Cryptography

- **PsaCipherEncrypt**
- **PsaCipherDecrypt**
- **PsaCipherOperationInit**
- **PsaCipherEncryptSetup**
- **PsaCipherDecryptSetup**
- **PsaCipherGenerateIv**
- **PsaCipherSetIv**
- **PsaCipherUpdate**
- **PsaCipherFinish**
- **PsaCipherAbort**

### Asymmetric Cryptography

- [**PsaAsymmetricSign**](psa_asymmetric_sign.md)
- [**PsaAsymmetricVerify**](psa_asymmetric_verify.md)
- **PsaAsymmetricEncrypt**
- **PsaAsymmetricDecrypt**

### Authenticated Encryption with Associated Data (AEAD)

- **PsaAeadEncrypt**
- **PsaAeadDecrypt**
- **PsaAeadOperationInit**
- **PsaAeadEncryptSetup**
- **PsaAeadDecryptSetup**
- **PsaAeadGenerateNonce**
- **PsaAeadSetNonce**
- **PsaAeadSetLengths**
- **PsaAeadUpdateAd**
- **PsaAeadUpdate**
- **PsaAeadFinish**
- **PsaAeadVerify**
- **PsaAeadAbort**

### Digests

- **PsaHashCompute**
- **PsaHashCompare**
- **PsaHashOperationInit**
- **PsaHashSetup**
- **PsaHashUpdate**
- **PsaHashFinish**
- **PsaHashVerify**
- **PsaHashAbort**
- **PsaHashClone**

### Message Authentication Codes (MAC)

- **PsaMacCompute**
- **PsaMacVerify**
- **PsaMacOperationInit**
- **PsaMacSignSetup**
- **PsaMacVerifySetup**
- **PsaMacUpdate**
- **PsaMacSignFinish**
- **PsaMacVerifyFinish**
- **PsaMacAbort**

### Key Derivation

- **PsaKeyDerivationOperationInit**
- **PsaKeyDerivationSetup**
- **PsaKeyDerivationGetCapacity**
- **PsaKeyDerivationSetCapacity**
- **PsaKeyDerivationInputBytes**
- **PsaKeyDerivationInputKey**
- **PsaKeyDerivationKeyAgreement**
- **PsaKeyDerivationOutputBytes**
- **PsaKeyDerivationOutputKey**
- **PsaKeyDerivationAbort**
- **PsaRawKeyAgreement**

### Entropy

- **PsaGenerateRandom**

*Copyright (c) 2019, Arm Limited. All rights reserved.*
