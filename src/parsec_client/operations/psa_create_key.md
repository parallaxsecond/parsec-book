# PsaCreateKey

## Opcode: 2 (decimal), 0x0002 (hex)

## Summary

Generate a key or key pair.

The key is generated randomly. Its location, policy, type and size are taken from `key_attributes`.

The following type-specific considerations apply:

- For RSA keys (`RSA_Keypair`), the public exponent is 65537. The modulus is a product of two
   probabilistic primes between 2^{n-1} and 2^n where n is the bit size specified in the attributes.

## Parameters

- **key_name** - Name of the key used for signing the hash.
- **key_attributes** - Attributes of the key to be created (see the [**key
   attributes**](key_attributes.md) file for more details).

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/generate_key.proto)

*Copyright (c) 2019, Arm Limited. All rights reserved.*
