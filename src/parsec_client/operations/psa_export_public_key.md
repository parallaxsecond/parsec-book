# PsaExportPublicKey

Export a public key or the public part of a key pair in binary format. Opcode: 7 (`0x0007`)

## Parameters

| Name       | Type   | Description                      |
|------------|--------|----------------------------------|
| `key_name` | String | Name of the public key to export |

## Results

| Name   | Type            | Description                    |
|--------|-----------------|--------------------------------|
| `data` | Vector of bytes | Buffer containing the key data |

## Specific response status codes

- `PsaErrorInvalidArgument`: The key is neither a public key nor a key pair.

## Description

The output of this function can be passed to [PsaImportKey](psa_import_key.md) to create an object
that is equivalent to the public key.

For standard key types, the output format is as follows:

- For RSA public keys, with key type [`RsaPublicKey`](psa_key_attributes.md#rsapublickey-type), the
   DER encoding of the representation defined by [RFC 3279
   §2.3.1](https://tools.ietf.org/html/rfc3279.html#section-2.3.1) as `RSAPublicKey` (`[1]`).
- For elliptic curve public keys, with key type
   [`EccPublicKey`](psa_key_attributes.md#eccpublickey-type), the format depends on the [curve
   family](psa_key_attributes.md#supported-ecc-curve-families):
   - For Weierstrass curve families sectXX, secpXX, FRP and Brainpool, the uncompressed
      representation defined by *Standards for Efficient Cryptography, SEC 1: Elliptic Curve
      Cryptography* §2.3.3 as the content of an `ECPoint`. If `m` is the bit size associated with
      the curve, i.e. the bit size of `q` for a curve over `F_q`. The representation consists of:
   - The byte `0x04`;
   - `x_P` as a `ceiling(m/8)`-byte string, big-endian;
   - `y_P` as a `ceiling(m/8)`-byte string, big-endian.
   - For Montgomery curve family, the scalar value of the ‘public key’ in little-endian order as
      defined by [RFC 7748 §6](https://tools.ietf.org/html/rfc7748.html#section-6). This is a
      `ceiling(m/8)`-byte string where `m` is the key size in bits.
   - This is 32 bytes for Curve25519, computed as `X25519(private_key, 9)`.
   - This is 56 bytes for Curve448, computed as `X448(private_key, 5)`.
- For Diffie-Hellman key exchange public keys, with key types
   [DhPublicKey](psa_key_attributes.md#dhpublickey-type), the format is the representation of the
   public key `y = g^x mod p` as a big-endian byte string. The length of the byte string is the
   length of the base prime `p` in bytes.

Exporting a public key object or the public part of a key pair is always permitted, regardless of
the key’s usage flags.

`[1]`: The `RSAPublicKey` representation is:

```
RSAPublicKey ::= SEQUENCE {
    modulus INTEGER,       -- n
    publicExponent INTEGER -- e
}
```

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_export_public_key.proto)

*Copyright 2019 Contributors to the Parsec project.*
