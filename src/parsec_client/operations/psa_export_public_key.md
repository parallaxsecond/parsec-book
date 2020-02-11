# PsaExportPublicKey

## Opcode: 7 (decimal), 0x0007 (hex)

## Summary

Export a public key or the public part of a key pair in binary format.

The output of this function can be passed to [*PSA Import Key*](psa_import_key.md) to create an
object that is equivalent to the public key.

This specification supports a single format for each key type. Implementations may support other
formats as long as the standard format is supported. Implementations that support other formats
should ensure that the formats are clearly unambiguous so as to minimize the risk that an invalid
input is accidentally interpreted according to a different format.

For standard key types, the output format is as follows:

- For RSA public keys ([`RSA_Public_Key`](key_attributes.md)), the DER encoding of the
   representation defined by *RFC 3279 §2.3.1* as `RSAPublicKey`:
- For elliptic curve public keys (key of type [`ECC_Public_Key`](key_attributes.md)), the format is
   the uncompressed representation defined by *SEC1 §2.3.3* as the content of an `ECPoint`. Let `m`
   be the bit size associated with the curve, i.e. the bit size of `q` for a curve over `F\_q`. The
   representation consists of:
- The byte `0x04`;
- `x\_P` as a `ceiling(m/8)`-byte string, big-endian;
- `y\_P` as a `ceiling(m/8)`-byte string, big-endian.
- For DSA public keys ([`DSA_Public_Key`](key_attributes.md)), the `subjectPublicKey` format is
   defined by *RFC 3279 §2.3.2* as `DSAPublicKey`, with the OID `id-dsa`, and with the parameters
   `DSS-Parms`.

## Parameters

- **key_name** - Name of the key used for signing the hash.

## Result values

- **key_data** - Bytes of the key in one of the formats described above.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/export_public_key.proto)

*Copyright (c) 2019, Arm Limited. All rights reserved.*
