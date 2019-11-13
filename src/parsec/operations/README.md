<!--
  -- Copyright (c) 2019, Arm Limited, All Rights Reserved
  -- SPDX-License-Identifier: Apache-2.0
  --
  -- Licensed under the Apache License, Version 2.0 (the "License"); you may
  -- not use this file except in compliance with the License.
  -- You may obtain a copy of the License at
  --
  -- http://www.apache.org/licenses/LICENSE-2.0
  --
  -- Unless required by applicable law or agreed to in writing, software
  -- distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
  -- WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  -- See the License for the specific language governing permissions and
  -- limitations under the License.
--->
# Operations

## Introduction

This document provides links to full descriptions for all of the operations in the API.

## Status Note

This is preliminary documentation. It may be incomplete, and is subject to change without notice. Some operations are listed without being linked to documentation pages. These operations are not currently supported, but are intended for future roadmap. Only a small number of the PSA Crypto operations are supported in the current version.

## Identity Operations

Identity operations are not supported by the security service. These operations are reserved for use only by the identity provider, which is a separate service in the system, but supports a common wire protocol.

* [**AddClient**](add_client.md)
* [**ProveClient**](prove_client.md)


## Core Operations

Core operations are non-cryptographic operations supported by the core provider. Set the **provider** field of the request header to 0 (`0x00`) to invoke these operations.

### Service Health

* [**Ping**](ping.md)

### Service Configuration

* [**ListProviders**](list_providers.md)
* [**ListOpcodes**](list_opcodes.md)

### Trust

* [**ShareTrustBundle**](share_trust_bundle.md)

## PSA Crypto Operations

These operations are all derived from equivalent function definitions in the [**PSA Crypto API Specification**](https://github.com/ARMmbed/mbed-crypto/blob/psa-crypto-api/docs/PSA_Cryptography_API_Specification.pdf). 

### Key Management

* [**PsaCreateKey**](psa_create_key.md)
* **PsaExportKey**
* [**PsaExportPublicKey**](psa_export_public_key.md)
* [**PsaImportKey**](psa_import_key.md)
* **PsaCopyKey**
* [**PsaDestroyKey**](psa_destroy_key.md)

### Symmetric Cryptography

* **PsaCipherEncrypt**
* **PsaCipherDecrypt**
* **PsaCipherOperationInit**
* **PsaCipherEncryptSetup**
* **PsaCipherDecryptSetup**
* **PsaCipherGenerateIv**
* **PsaCipherSetIv**
* **PsaCipherUpdate**
* **PsaCipherFinish**
* **PsaCipherAbort**

### Asymmetric Cryptography

* [**PsaAsymmetricSign**](psa_asymmetric_sign.md)
* [**PsaAsymmetricVerify**](psa_asymmetric_verify.md)
* **PsaAsymmetricEncrypt**
* **PsaAsymmetricDecrypt**

### Authenticated Encryption with Associated Data (AEAD)

* **PsaAeadEncrypt**
* **PsaAeadDecrypt**
* **PsaAeadOperationInit**
* **PsaAeadEncryptSetup**
* **PsaAeadDecryptSetup**
* **PsaAeadGenerateNonce**
* **PsaAeadSetNonce**
* **PsaAeadSetLengths**
* **PsaAeadUpdateAd**
* **PsaAeadUpdate**
* **PsaAeadFinish**
* **PsaAeadVerify**
* **PsaAeadAbort**
  
### Digests

* **PsaHashCompute**
* **PsaHashCompare**
* **PsaHashOperationInit**
* **PsaHashSetup**
* **PsaHashUpdate**
* **PsaHashFinish**
* **PsaHashVerify**
* **PsaHashAbort**
* **PsaHashClone**
  
### Message Authentication Codes (MAC)

* **PsaMacCompute**
* **PsaMacVerify**
* **PsaMacOperationInit**
* **PsaMacSignSetup**
* **PsaMacVerifySetup**
* **PsaMacUpdate**
* **PsaMacSignFinish**
* **PsaMacVerifyFinish**
* **PsaMacAbort**
  
### Key Derivation

* **PsaKeyDerivationOperationInit**
* **PsaKeyDerivationSetup**
* **PsaKeyDerivationGetCapacity**
* **PsaKeyDerivationSetCapacity**
* **PsaKeyDerivationInputBytes**
* **PsaKeyDerivationInputKey**
* **PsaKeyDerivationKeyAgreement**
* **PsaKeyDerivationOutputBytes**
* **PsaKeyDerivationOutputKey**
* **PsaKeyDerivationAbort**
* **PsaRawKeyAgreement**

### Entropy

* **PsaGenerateRandom**

