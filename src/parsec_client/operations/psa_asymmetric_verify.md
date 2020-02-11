# PsaAsymmetricVerify

## Opcode: 5 (decimal), 0x0005 (hex)

## Summary

Verify the signature of a hash or short message using a public key

Note that to perform a hash-and-sign signature algorithm, you must first calculate the hash of the
data you want to sign. Then pass the resulting digest as the `hash` parameter to this function.

## Parameters

- **key_name** - Name of the key to be used for verifying the hash.
- **hash** - Digest of the data that was signed. The digest must be in a raw binary format, with no
   padding or encoding unless the `RsaPkcs1v15Sign` algorithm is used, with no associated hash
   algorithm.
- **signature** - Signature that must be verified, in raw binary format.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/asym_verify.proto)

*Copyright (c) 2019, Arm Limited. All rights reserved.*
