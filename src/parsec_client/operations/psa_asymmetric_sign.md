# PsaAsymmetricSign

## Opcode: 4 (decimal), 0x0004 (hex)

## Summary

Sign a hash or short message with a private key.

Note that to perform a hash-and-sign signature algorithm, you must first calculate the hash of the
data you want to sign. Then pass the resulting hash as the `hash` parameter to this function.

## Parameters

- **key_name** - Name of the key used for signing the hash.
- **hash** - Digest of the data to be signed. The digest must be in a raw binary format, with no
   padding or encoding unless the `RsaPkcs1v15Sign` algorithm is used, with no associated hash
   algorithm.

## Result values

- **signature** - Bytes forming up the requested signature

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/asym_sign.proto)

*Copyright (c) 2019, Arm Limited. All rights reserved.*
