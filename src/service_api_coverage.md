# PSA Cryptography API coverage within Parsec

The current interface contracts defined for communication between Parsec and its clients is tracking
the [PSA Cryptography API version
1.0](https://developer.arm.com/architectures/security-architectures/platform-security-architecture/documentation).
This page describes the current state of Parsec support for the operations, attributes and options
that are defined in that specification. It covers two different sides of the issue:

- Coverage of the suite of operations that have been [defined for
   IPC](https://github.com/parallaxsecond/parsec-operations) and which can be requested from the
   service.
- Coverage of the operations and key attributes implemented for each provider (that is offered as
   part of the Parsec service).

**NOTE:** This is not a representation of the coverage available to clients using any particular
programming language. In that regard see the [clients API coverage page](clients_api_coverage.md).

## IPC operations coverage

The table below shows coverage only for single part operations. Multi-part operations will be added
in the future and will be organized by operation type.

### Single part operations

| Operation name                     | Protobuf contract exists                                                                                     |
|------------------------------------|--------------------------------------------------------------------------------------------------------------|
| `psa_import_key`                   | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_import_key.proto)         |
| `psa_generate_key`                 | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_generate_key.proto)       |
| `psa_key_derivation_output_key`    | ❌                                                                                                          |
| `psa_copy_key`                     | ❌                                                                                                          |
| `psa_export_public_key`            | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_export_public_key.proto)  |
| `psa_export_key`                   | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_export_key.proto)         |
| `psa_purge_key`                    | ❌                                                                                                          |
| `psa_destroy_key`                  | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_destroy_key.proto)        |
| `psa_hash_compute`                 | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_hash_compute.proto)       |
| `psa_hash_compare`                 | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_hash_compare.proto)       |
| `psa_mac_compute`                  | ❌                                                                                                          |
| `psa_mac_verify`                   | ❌                                                                                                          |
| `psa_cipher_encrypt`               | ❌                                                                                                          |
| `psa_cipher_decrypt`               | ❌                                                                                                          |
| `psa_aead_encrypt`                 | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_aead_encrypt.proto)       |
| `psa_aead_decrypt`                 | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_aead_decrypt.proto)       |
| `psa_asymmetric_encrypt`           | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_asymmetric_encrypt.proto) |
| `psa_asymmetric_decrypt`           | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_asymmetric_decrypt.proto) |
| `psa_sign_message`                 | ❌                                                                                                          |
| `psa_verify_message`               | ❌                                                                                                          |
| `psa_sign_hash`                    | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_sign_hash.proto)          |
| `psa_verify_hash`                  | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_verify_hash.proto)        |
| `psa_key_derivation_key_agreement` | ❌                                                                                                          |
| `psa_raw_key_agreement`            | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_raw_key_agreement.proto)  |
| `psa_generate_random`              | [✅](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_generate_random.proto)    |

You can help increase Parsec's API coverage! Take a look at our
[how-to](contributing/adding_new_operation_how_to.md) to get started.

## API support per-provider

This section gives information on the operations and attributes currently supported by each
provider. Only support for the operations marked as covered in the table(s) above is considered. Any
option marked as supported is necessarily supported for all operations on which it is usable.

### Operation support

| Operation          | Mbed Crypto provider | PKCS 11 provider | TPM 2.0 provider |
|--------------------|----------------------|------------------|------------------|
| Import key         | ✅                  | ✅              | ✅              |
| Generate key       | ✅                  | ✅              | ✅              |
| Export public key  | ✅                  | ✅              | ✅              |
| Export key         | ✅                  | ❌              | ❌              |
| Destroy key        | ✅                  | ✅              | ✅              |
| Sign hash          | ✅                  | ✅              | ✅              |
| Verify hash        | ✅                  | ✅              | ✅              |
| Hash compute       | ✅                  | ❌              | ❌              |
| Hash compare       | ✅                  | ❌              | ❌              |
| Asymmetric encrypt | ✅                  | ❌              | ❌              |
| Asymmetric decrypt | ✅                  | ❌              | ❌              |
| AEAD encrypt       | ✅                  | ❌              | ❌              |
| AEAD decrypt       | ✅                  | ❌              | ❌              |
| Raw key agreement  | ✅                  | ❌              | ❌              |

### Algorithm support

#### Hash algorithms

| Algorithm   | Mbed Crypto provider | PKCS 11 provider | TPM 2.0 provider |
|-------------|----------------------|------------------|------------------|
| MD2         | ✅                  | ❌              | ❌              |
| MD4         | ✅                  | ❌              | ❌              |
| MD5         | ✅                  | ❌              | ❌              |
| RIPEMD160   | ✅                  | ❌              | ❌              |
| SHA-1       | ✅                  | ❌              | ✅              |
| SHA-224     | ✅                  | ❌              | ❌              |
| SHA-256     | ✅                  | ✅              | ✅              |
| SHA-384     | ✅                  | ❌              | ✅              |
| SHA-512     | ✅                  | ❌              | ✅              |
| SHA-512-224 | ✅                  | ❌              | ❌              |
| SHA-512-256 | ✅                  | ❌              | ❌              |
| SHA3-224    | ✅                  | ❌              | ❌              |
| SHA3-256    | ✅                  | ❌              | ✅              |
| SHA3-384    | ✅                  | ❌              | ✅              |
| SHA3-512    | ✅                  | ❌              | ✅              |

#### Asymmetric signing algorithms

| Algorithm              | Mbed Crypto provider | PKCS 11 provider | TPM 2.0 provider |
|------------------------|----------------------|------------------|------------------|
| RSA PKCS 1v5 with hash | ✅                  | ✅              | ✅              |
| Raw RSA PKCS 1v5       | ❌                  | ❌              | ❌              |
| RSA PSS                | ❌                  | ❌              | ❌              |
| ECDSA                  | ❌                  | ❌              | ✅              |
| ECDSA with any hash    | ❌                  | ❌              | ❌              |
| Deterministic ECDSA    | ❌                  | ❌              | ❌              |

#### Asymmetric encryption algorithms

| Algorithm    | Mbed Crypto provider | PKCS 11 provider | TPM 2.0 provider |
|--------------|----------------------|------------------|------------------|
| RSA PKCS 1v5 | ✅                  | ❌              | ❌              |
| Raw OAEP     | ✅                  | ❌              | ❌              |

#### AEAD encryption algorithms

| Algorithm         | Mbed Crypto provider | PKCS 11 provider | TPM 2.0 provider |
|-------------------|----------------------|------------------|------------------|
| CCM               | ✅                  | ❌              | ❌              |
| GCM               | ✅                  | ❌              | ❌              |
| ChaCha20_Poly1305 | ✅                  | ❌              | ❌              |

#### Raw key agreement algorithms

| Algorithm | Mbed Crypto provider | PKCS 11 provider | TPM 2.0 provider |
|-----------|----------------------|------------------|------------------|
| FFDH      | ✅                  | ❌              | ❌              |
| ECDH      | ✅                  | ❌              | ❌              |

*Copyright 2020 Contributors to the Parsec project.*
