# Parsec API coverage within client libraries

The current interface contracts defined for communication between Parsec and its clients is tracking
the [PSA Cryptography API version
1.0](https://developer.arm.com/architectures/security-architectures/platform-security-architecture/documentation).
This page describes the current state of support within clients for the operations, attributes and
options that are defined in that specification and for Parsec-related functionality (e.g. support
for various providers).

For an overview of the functionality supported by the service, see the [service API coverage
page](service_api_coverage.md).

**Note:** Only client libraries that are developed by the Parsec organisation are represented in the
tables below. This does not guarantee or imply the same amount of support within other libraries. We
encourage each library author to publish their own coverage figures in their format of choice. Links
will be added here for any other such coverage report.

## Provider support

| Provider    | Rust client |
|-------------|-------------|
| Mbed Crypto | ✅         |
| PKCS11      | ✅         |
| TPM 2.0     | ✅         |

## Operation support

| Operation          | Rust client |
|--------------------|-------------|
| Import key         | ✅         |
| Generate key       | ✅         |
| Export public key  | ✅         |
| Export key         | ✅         |
| Destroy key        | ✅         |
| Sign hash          | ✅         |
| Verify hash        | ✅         |
| Hash compute       | ✅         |
| Hash compare       | ✅         |
| Asymmetric encrypt | ✅         |
| Asymmetric decrypt | ✅         |
| Aead encrypt       | ✅         |
| Aead decrypt       | ✅         |
| RawKeyAgreement    | ✅         |

## Algorithm support

### Hash algorithms

| Algorithm   | Rust client |
|-------------|-------------|
| MD2         | ✅         |
| MD4         | ✅         |
| MD5         | ✅         |
| RIPEMD160   | ✅         |
| SHA-1       | ✅         |
| SHA-224     | ✅         |
| SHA-256     | ✅         |
| SHA-384     | ✅         |
| SHA-512     | ✅         |
| SHA-512-224 | ✅         |
| SHA-512-256 | ✅         |
| SHA3-224    | ✅         |
| SHA3-256    | ✅         |
| SHA3-384    | ✅         |
| SHA3-512    | ✅         |

### Asymmetric signing algorithms

| Algorithm              | Rust client |
|------------------------|-------------|
| RSA PKCS 1v5 with hash | ✅         |
| Raw RSA PKCS 1v5       | ✅         |
| RSA PSS                | ✅         |
| ECDSA                  | ✅         |
| ECDSA with any hash    | ✅         |
| Deterministic ECDSA    | ✅         |

### Asymmetric encryption algorithms

| Algorithm          | Rust client |
|--------------------|-------------|
| RSA PKCS 1v5       | ✅         |
| RSA OAEP with hash | ✅         |

### AEAD encryption algorithms

| Algorithm         | Rust client |
|-------------------|-------------|
| CCM               | ✅         |
| GCM               | ✅         |
| ChaCha20_Poly1305 | ✅         |

### Raw key agreement algorithms

| Algorithm | Rust client |
|-----------|-------------|
| FFDH      | ✅         |
| ECDH      | ✅         |

*Copyright 2020 Contributors to the Parsec project.*
