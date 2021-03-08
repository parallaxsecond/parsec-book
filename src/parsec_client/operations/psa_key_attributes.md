# PSA Key Attributes

The attributes are used to fully describe a cryptographic key: its type, size and what is permitted
to do with that key.

Some of the algorithms defined here are deprecated and should not be used without a valid reason. It
is at the discretion of the system administrator whether those algorithms are permitted or not.

**Notice:** not all possible attributes are currently supported by Parsec. Please see the
[Operations Coverage](service_api_coverage.md) for an overview of what Parsec currently supports.
Some of the attributes might not be supported by some providers as it is not in their interface.

## KeyAttributes type

A `KeyAttributes` type contains the following members:

| Name         | Type                           | Description                                       |
|--------------|--------------------------------|---------------------------------------------------|
| `key_type`   | [`KeyType`](#keytype-type)     | Intrinsic category and type of a key              |
| `key_bits`   | Unsigned integer               | Size of a key in bits                             |
| `key_policy` | [`KeyPolicy`](#keypolicy-type) | Policy restricting the permitted usage of the key |

## KeyType type

A `KeyType` type can contain one of the following key types:

- [`RawData`](#rawdata-type)
- [`Hmac`](#hmac-type)
- [`Derive`](#derive-type)
- [`Aes`](#aes-type)
- [`Des`](#des-type)
- [`Camellia`](#camellia-type)
- [`Arc4`](#arc4-type)
- [`Chacha20`](#chacha20-type)
- [`RsaPublicKey`](#rsapublickey-type)
- [`RsaKeyPair`](#rsakeypair-type)
- [`EccKeyPair`](#ecckeypair-type)
- [`EccPublicKey`](#eccpublickey-type)
- [`DhKeyPair`](#dhkeypair-type)
- [`DhPublicKey`](#dhpublickey-type)

### RawData type

Not a valid key type for any cryptographic operation but can be used to store arbitrary data in the
key store.

The bit size of a raw key must be a non-zero multiple of 8.

### Hmac type

HMAC key. The key policy determines which underlying hash algorithm the key can be used for.

The bit size of an HMAC key must be a non-zero multiple of 8. An HMAC key is typically the same size
as the output of the underlying hash algorithm. An HMAC key that is longer than the block size of
the underlying hash algorithm will be hashed before use.

### Derive type

A secret key for derivation. The key policy determines which key derivation algorithm the key can be
used for.

The bit size of a secret for key derivation must be a non-zero multiple of 8.

### Aes type

Key for a cipher, AEAD or MAC algorithm based on the AES block cipher.

The size of the key is related to the AES algorithm variant. For algorithms except the XTS block
cipher mode, the following key sizes are used:

- AES-128 uses a 16-byte key: `key_bits` = 128
- AES-192 uses a 24-byte key: `key_bits` = 192
- AES-256 uses a 32-byte key: `key_bits` = 256

For the XTS block cipher mode, the following key sizes are used:

- AES-128-XTS uses two 16-byte keys: `key_bits` = 256
- AES-192-XTS uses two 24-byte keys: `key_bits` = 384
- AES-256-XTS uses two 32-byte keys: `key_bits` = 512

The AES block cipher is defined in `FIPS Publication 197: Advanced Encryption Standard (AES)`
[FIPS197](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf).

### Des type

Key for a cipher or MAC algorithm based on DES or 3DES (Triple-DES).

The size of the key determines which DES algorithm is used:

- Single DES uses an 8-byte key: `key_bits` = 64
- 2-key 3DES uses a 16-byte key: `key_bits` = 128
- 3-key 3DES uses a 24-byte key: `key_bits` = 192

**Warning**: Single DES and 2-key 3DES are weak and strongly deprecated and are only recommended for
decrypting legacy data. 3-key 3DES is weak and deprecated and is only recommended for use in legacy
protocols.

The DES and 3DES block ciphers are defined in *NIST Special Publication 800-67: Recommendation for
the Triple Data Encryption Algorithm (TDEA) Block Cipher*
[SP800-67](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-67r2.pdf).

### Camellia type

Key for a cipher, AEAD or MAC algorithm based on the Camellia block cipher.

The size of the key is related to the Camellia algorithm variant. For algorithms except the XTS
block cipher mode, the following key sizes are used:

- Camellia-128 uses a 16-byte key: `key_bits` = 128
- Camellia-192 uses a 24-byte key: `key_bits` = 192
- Camellia-256 uses a 32-byte key: `key_bits` = 256

For the XTS block cipher mode, the following key sizes are used:

- Camellia-128-XTS uses two 16-byte keys: `key_bits` = 256
- Camellia-192-XTS uses two 24-byte keys: `key_bits` = 384
- Camellia-256-XTS uses two 32-byte keys: `key_bits` = 512

The Camellia block cipher is defined in *Specification of Camellia — a 128-bit Block Cipher*
[NTT-CAM](https://info.isl.ntt.co.jp/crypt/eng/camellia/specifications) and also described in *A
Description of the Camellia Encryption Algorithm* [RFC3713](https://tools.ietf.org/html/rfc3713).

### Arc4 type

Key for the RC4 stream cipher.

The ARC4 cipher supports key sizes between 40 and 2048 bits, that are multiples of 8 (5 to 256
bytes).

Use a [`Cipher`](psa_algorithm.md#cipher-algorithm) algorithm with Stream Cipher variant to use this
key with the ARC4 cipher.

**Warning**: The RC4 cipher is weak and deprecated and is only recommended for use in legacy
protocols.

### Chacha20 type

Key for the ChaCha20 stream cipher or the Chacha20-Poly1305 AEAD algorithm.

The ChaCha20 key size is 256 bits (32 bytes).

- Use Cipher algorithm with Stream Cipher variant to use this key with the ChaCha20 cipher for
   unauthenticated encryption.
- Use Aead algorithm with ChaCha20-Poly1305 variant to use this key with the ChaCha20 cipher and
   Poly1305 authenticator for AEAD.

### RsaPublicKey type

RSA public key.

### RsaKeyPair type

RSA key pair: both the private and public key.

### EccKeyPair type

Elliptic curve key pair: both the private and public key. Uses one of the [ECC curve family
supported](#supported-ecc-curve-families).

### EccPublicKey type

Elliptic curve public key. Uses one of the [ECC curve family
supported](#supported-ecc-curve-families).

### DhKeyPair type

Diffie-Hellman key pair: both the private key and public key. Uses one of the [Diffie-Hellman group
family supported](#supported-dh-group-families).

### DhPublicKey type

Diffie-Hellman public key. Uses one of the [Diffie-Hellman group family
supported](#supported-dh-group-families).

### Supported ECC curve families

Enumeration of elliptic curve families supported. They are needed to create an ECC key. The specific
curve used for each family is given by the `key_bits` field of the key attributes.

- **SEC Koblitz curves over prime fields.** This family comprises the following curves:
   - secp192k1: `key_bits` = 192
   - secp224k1: `key_bits` = 225
   - secp256k1: `key_bits` = 256
- **SEC random curves over prime fields.** This family comprises the following curves:
   - secp192r1: `key_bits` = 192
   - secp224r1: `key_bits` = 224
   - secp256r1: `key_bits` = 256
   - secp384r1: `key_bits` = 384
   - secp521r1: `key_bits` = 512
- **SEC additional random curves over prime fields.** This family comprises the following curves:
   - secp160r2: `key_bits` = 160 (DEPRECATED)
- **SEC Koblitz curves over binary fields.** This family comprises the following curves:
   - sect163k1: `key_bits` = 163 (DEPRECATED)
   - sect233k1: `key_bits` = 233
   - sect239k1: `key_bits` = 239
   - sect283k1: `key_bits` = 283
   - sect409k1: `key_bits` = 409
   - sect571k1: `key_bits` = 571
- **SEC random curves over binary fields.** This family comprises the following curves:
   - sect163r1: `key_bits` = 163 (DEPRECATED)
   - sect233r1: `key_bits` = 233
   - sect283r1: `key_bits` = 283
   - sect409r1: `key_bits` = 409
   - sect571r1: `key_bits` = 571
- **SEC additional random curves over binary fields.** This family comprises the following curves:
   - sect163r2 : `key_bits` = 163 (DEPRECATED)
- **Brainpool P random curves.** This family comprises the following curves:
   - brainpoolP160r1: `key_bits` = 160 (DEPRECATED)
   - brainpoolP192r1: `key_bits` = 192
   - brainpoolP224r1: `key_bits` = 224
   - brainpoolP256r1: `key_bits` = 256
   - brainpoolP320r1: `key_bits` = 320
   - brainpoolP384r1: `key_bits` = 384
   - brainpoolP512r1: `key_bits` = 512
- **FRP.** Curve used primarily in France and elsewhere in Europe. This family comprises one 256-bit
   curve:
   - FRP256v1: `key_bits` = 256
- **Montgomery curves.** This family comprises the following Montgomery curves:
   - Curve25519: `key_bits` = 255
   - Curve448: `key_bits` = 448

### Supported DH group families

Enumeration of Diffie Hellman group families supported. They are needed to create a DH key. The
specific group used for each family is given by the `key_bits` field of the key attributes.

- **RFC7919.** Finite-field Diffie-Hellman groups defined for TLS in RFC 7919. This family includes
   groups with the following key sizes (in bits): 2048, 3072, 4096, 6144, 8192. Keys is this group
   can only be used with the FFDH key agreement algorithm.

## KeyPolicy type

Definition of the key policy, what is permitted to do with the key. A `KeyPolicy` type contains the
following members:

| Name              | Type                                           | Description                                  |
|-------------------|------------------------------------------------|----------------------------------------------|
| `key_usage_flags` | [`UsageFlags`](#usageflags-type)               | Usage flags for the key                      |
| `key_algorithm`   | [`Algorithm`](psa_algorithm.md#algorithm-type) | Permitted algorithms to be used with the key |

## UsageFlags type

Definition of the usage flags. They encode what kind of operations are permitted on the key. A
`UsageFlags` type contains the following members:

| Name             | Type    | Description                                        |
|------------------|---------|----------------------------------------------------|
| `export`         | Boolean | Permission to export the key                       |
| `copy`           | Boolean | Permission to copy the key                         |
| `cache`          | Boolean | Permission for the implementation to cache the key |
| `encrypt`        | Boolean | Permission to encrypt a message with the key       |
| `decrypt`        | Boolean | Permission to decrypt a message with the key       |
| `sign_message`   | Boolean | Permission to sign a message with the key          |
| `verify_message` | Boolean | Permission to verify a message with the key        |
| `sign_hash`      | Boolean | Permission to sign a hash with the key             |
| `verify_hash`    | Boolean | Permission to verify a hash with the key           |
| `derive`         | Boolean | Permission to derive other keys from this key      |

*Copyright 2019 Contributors to the Parsec project.*
