# PsaExportKey

Export a key in binary format. Opcode: 12 (`0x000C`)

## Parameters

| Name       | Type   | Description               |
|------------|--------|---------------------------|
| `key_name` | String | Name of the key to export |

- The key must allow the [usage flag](psa_key_attributes.md#usageflags-type) `export`.

## Results

| Name   | Type            | Description                    |
|--------|-----------------|--------------------------------|
| `data` | Vector of bytes | Buffer containing the key data |

## Specific response status codes

- `PsaErrorNotPermitted`: The key is not have the [`export`] usage flag.

## Description

The output of this function can be passed to [PsaImportKey](psa_import_key.md) to create an object
that is equivalent to key.

For standard key types, the output format is as follows:

- For symmetric keys, including MAC keys, the format is the raw bytes of the key.
- For [`DES`](psa_key_attributes.md#des-type), the key data consists of 8 bytes. The parity bits
   must be correct.
- For [`Triple-DES`](psa_key_attributes.md#des-type), the format is the concatenation of the two or
   three DES keys.
- For RSA key pairs, with key type [`RsaKeyPair`](psa_key_attributes.md#rsakeypair-type), the format
   is the non-encrypted DER encoding of the representation defined by PKCS#1 in [`RFC
   8017`](https://tools.ietf.org/html/rfc8017.html) as RSAPrivateKey, version 0 (`[1]`).
- For elliptic curve key pairs, with key type [`EccKeyPair`](psa_key_attributes.md#ecckeypair-type),
   the format is a representation of the private value.
   - For Weierstrass curve families `sectXX`, `secpXX`, `FRP` and `Brainpool`, the content of the
      privateKey field of the ECPrivateKey format defined by [`RFC
      5915`](https://tools.ietf.org/html/rfc5915.html). This is a ceiling(m/8)-byte string in
      big-endian order where m is the key size in bits.
   - For Montgomery curve family, the scalar value of the ‘private key’ in little-endian order
      as defined by [RFC 7748 §6](https://tools.ietf.org/html/rfc7748.html#section-6). This is a
      `ceiling(m/8)`-byte string where `m` is the key size in bits.
      - This is 32 bytes for Curve25519, computed as `X25519(private_key, 9)`.
      - This is 56 bytes for Curve448, computed as `X448(private_key, 5)`.
- For Diffie-Hellman key exchange key pairs, with key types
   [DhKeyPair](psa_key_attributes.md#dhkeypair-type), the format is the representation of the
   private key `x` as a big-endian byte string. The length of the byte string is the private key
   size in bytes, and leading zeroes are not stripped.
- For public keys, the format is the same as for [PsaExportPublicKey](psa_export_public_key.md)

`[1]`: The `RSAPrivateKey` representation is:

```
RSAPrivateKey ::= SEQUENCE {
             version           Version,
             modulus           INTEGER,  -- n
             publicExponent    INTEGER,  -- e
             privateExponent   INTEGER,  -- d
             prime1            INTEGER,  -- p
             prime2            INTEGER,  -- q
             exponent1         INTEGER,  -- d mod (p-1)
             exponent2         INTEGER,  -- d mod (q-1)
             coefficient       INTEGER,  -- (inverse of q) mod p
             otherPrimeInfos   OtherPrimeInfos OPTIONAL
         }
```

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_export_key.proto)

*Copyright 2020 Contributors to the Parsec project.*
