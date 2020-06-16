# PSA Algorithm

The algorithm is used to select the specific cryptographic operation and to set a policy on a new
key.

Some of the algorithms defined here are deprecated and should not be used without a valid reason. It
is at the discretion of the system administrator whether those algorithms are permitted or not.

**Notice:** not all possible algorithms are currently supported by Parsec. Please see the [API
coverage](../../api_coverage.md) for an overview of what Parsec currently supports. Some of the
attributes might not be supported by some providers as it is not in their interface.

## Algorithm type

An `Algorithm` type can contain one of the following algorithm types:

- [`None`](#none-algorithm)
- [`Hash`](#hash-algorithm)
- [`Mac`](#mac-algorithm)
- [`Cipher`](#cipher-algorithm)
- [`Aead`](#aead-algorithm)
- [`AsymmetricSignature`](#asymmetricsignature-algorithm)
- [`AsymmetricEncryption`](#asymmetricencryption-algorithm)
- [`KeyAgreement`](#keyagreement-algorithm)
- [`KeyDerivation`](#keyderivation-algorithm)

### None algorithm

An invalid algorithm identifier value. None does not allow any cryptographic operation with the key.
The key can still be used for non-cryptographic actions such as exporting, if permitted by the usage
flags.

### Hash algorithm

Possible hash algorithms are:

- **MD2.** DEPRECATED: the MD2 hash is weak and deprecated and is only recommended for use in legacy
   protocols.
- **MD4.** DEPRECATED: the MD4 hash is weak and deprecated and is only recommended for use in legacy
   protocols.
- **MD5.** DEPRECATED: the MD5 hash is weak and deprecated and is only recommended for use in legacy
   protocols.
- **RIPEMD-160.**
- **SHA-1.**
- **SHA-224.**
- **SHA-256.**
- **SHA-384.**
- **SHA-512.**
- **SHA-512/224.**
- **SHA-512/256.**
- **SHA3-224.**
- **SHA3-256.**
- **SHA3-384.**
- **SHA3-512.**

### Mac algorithm

The Message Authentication Code algorithms supported are:

- **HMAC.** Uses one of the hash algorithm supported.
- **CBC-MAC** construction over a block cipher. **Warning:** CBC-MAC is insecure in many cases. A
   more secure mode, such as CMAC, is recommended.
- **CMAC** construction over a block cipher.

Truncated MAC algorithms are also supported. A truncated MAC algorithm is identical to the
corresponding MAC algorithm except that the MAC value for the truncated algorithm consists of only
the first wanted bytes of the MAC value for the untruncated algorithm.

### Cipher algorithm

Unauthenticated cipher alhorithms.

**Warning:** The unauthenticated cipher API is provided to implement legacy protocols and for use
cases where the data integrity and authenticity is guaranteed by non-cryptographic means. It is
recommended that newer protocols use Authenticated Encryption with Associated Data (AEAD).

- **Stream Cipher**: the stream cipher mode of a stream cipher algorithm. The underlying stream
   cipher is determined by the key type:
   - To use ChaCha20, use the [`Chacha20`](psa_key_attributes.md#chacha20-type) key type.
   - To use ARC4, use the [`Arc4`](psa_key_attributes.md#arc4-type) key type.
- **CTR**: A stream cipher built using the Counter (CTR) mode of a block cipher. CTR is a stream
   cipher which is built from a block cipher. The underlying block cipher is determined by the key
   type. For example, to use AES-128-CTR, use this algorithm with a key of type AES and a length of
   128 bits (16 bytes).
- **CFB**: A stream cipher built using the Cipher Feedback (CFB) mode of a block cipher. The
   underlying block cipher is determined by the key type.
- **OFB**: A stream cipher built using the Output Feedback (OFB) mode of a block cipher. The
   underlying block cipher is determined by the key type.
- **XTS**: The XTS cipher mode of a block cipher. XTS is a cipher mode which is built from a block
   cipher. It requires at least one full block of input, but beyond this minimum the input does not
   need to be a whole number of blocks.
- **ECB with no padding**: The Electronic Code Book (ECB) mode of a block cipher, with no padding.
   The underlying block cipher is determined by the key type. **Warning:** ECB mode does not protect
   the confidentiality of the encrypted data except in extremely narrow circumstances. It is
   recommended that applications only use ECB if they need to construct an operating mode that the
   implementation does not provide. Implementations are encouraged to provide the modes that
   applications need in preference to supporting direct access to ECB.
- **CBC with no padding**: The Cipher Block Chaining (CBC) mode of a block cipher, with no padding.
   The underlying block cipher is determined by the key type.
- **CBC with PKCS#7 padding**: The Cipher Block Chaining (CBC) mode of a block cipher, with PKCS#7
   padding. The underlying block cipher is determined by the key type.

### Aead algorithm

Authenticated encryption with associated data (AEAD). The supported algorithms are:

- **CCM**: the CCM authenticated encryption algorithm. The underlying block cipher is determined by
   the key type.
- **GCM**: the GCM authenticated encryption algorithm. The underlying block cipher is determined by
   the key type.
- **ChaCha20-Poly1305**: the ChaCha20-Poly1305 AEAD algorithm. The ChaCha20-Poly1305 construction is
   defined in [RFC 7539](https://tools.ietf.org/html/rfc7539.html).

AEAD algorithms with a shortened tag are also supported. An AEAD algorithm with a shortened tag is
similar to the corresponding AEAD algorithm, but has an authentication tag that consists of fewer
bytes. Depending on the algorithm, the tag length might affect the calculation of the ciphertext.

### AsymmetricSignature algorithm

Asymmetric signature algorithms. Supported algorithms:

- **RSA PKCS#1 v1.5 signature with hashing.** This is the signature scheme defined by [RFC
   8017](https://tools.ietf.org/html/rfc8017.html) (PKCS#1: RSA Cryptography Specifications) under
   the name RSASSA-PKCS1-v1_5. Uses one of the hash algorithm supported.
- **Raw PKCS#1 v1.5 signature.** The input to this algorithm is the DigestInfo structure used by
   [RFC 8017](https://tools.ietf.org/html/rfc8017.html) §9.2 (PKCS#1: RSA Cryptography
   Specifications), in steps 3–6.
- **RSA PSS signature with hashing.** This is the signature scheme defined by [RFC
   8017](https://tools.ietf.org/html/rfc8017.html) (PKCS#1: RSA Cryptography Specifications) under
   the name RSASSA-PSS, with the message generation function MGF1, and with a salt length equal to
   the length of the hash. The specified hash algorithm is used to hash the input message, to create
   the salted hash, and for the mask generation. Uses one of the hash algorithm supported.
- **ECDSA signature with hashing.** This is the Elliptic Curve Digital Signature Algorithm (ECDSA)
   defined by ANSI X9.62-2005, with a random per-message secret number (k). The representation of
   the signature as a byte string consists of the concatenation of the signature values r and s.
   Each of r and s is encoded as an N-octet string, where N is the length of the base point of the
   curve in octets. Each value is represented in big-endian order, with the most significant octet
   first. Uses one of the hash algorithm supported.
- **ECDSA signature without hashing.** This is the same signature scheme as above, but without
   specifying a hash algorithm. This algorithm is only recommended to sign or verify a sequence of
   bytes that are an already-calculated hash. Note that the input is padded with zeros on the left
   or truncated on the left as required to fit the curve size.
- **Deterministic ECDSA signature with hashing.** This is the deterministic ECDSA signature scheme
   defined by [RFC 6979](https://tools.ietf.org/html/rfc6979.html). Uses one of the hash algorithm
   supported.

When defining the permitted algorithms in a key policy, the hash-and-sign algorithms above can use
the value **Any Hash** for their hash algorithm, meaning that it will allow any hash algorithm. This
value must not be used to build an algorithm specification to perform an operation. It is only valid
to build policies.

### AsymmetricEncryption algorithm

Asymmetric encryption algorithms. Supported algorithms:

- **RSA PKCS#1 v1.5 encryption.**
- **RSA OAEP encryption.** This is the encryption scheme defined by [RFC
   8017](https://tools.ietf.org/html/rfc6979.html) (PKCS#1: RSA Cryptography Specifications) under
   the name RSAES-OAEP, with the message generation function MGF1. Uses one of the supported hash
   algorithms.

### KeyAgreement algorithm

Key agreement algorithms.

- **FFDH**: the finite-field Diffie-Hellman (DH) key agreement algorithm.
- **ECDH**: the elliptic curve Diffie-Hellman (ECDH) key agreement algorithm.

A combined algorithm that chains a key agreement with a key derivation is also supported.

### KeyDerivation algorithm

Key derivation algorithms.

- **HKDF algorithm.** Uses of the hash algorithms supported.
- **TLS-1.2 PRF algorithm.** Uses of the hash algorithms supported.
- **TLS-1.2 PSK-to-MasterSecret algorithm.** Uses of the hash algorithms supported.

*Copyright 2020 Contributors to the Parsec project.*
