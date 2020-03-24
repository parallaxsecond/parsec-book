# PsaGenerateKey

Generate a key or key pair. Opcode: 2 (`0x0002`)

## Parameters

| Name         | Type                                                        | Description                   |
|--------------|-------------------------------------------------------------|-------------------------------|
| `key_name`   | String                                                      | Name of the key to generate   |
| `attributes` | [`KeyAttributes`](psa_key_attributes.md#keyattributes-type) | The attributes of the new key |

## Results

No values are returned by this operation.

## Specific response status codes

- `PsaErrorAlreadyExists`: There is already a key with the given name.

## Description

The key is generated randomly. Its location, policy, type and size are taken from `attributes`.

The following type-specific considerations apply:

- For RSA keys (key type is [`RsaKeyPair`](psa_key_attributes.md#rsakeypair-type)), the public
   exponent is 65537. The modulus is a product of two probabilistic primes between 2^{n-1} and 2^n
   where n is the bit size specified in the attributes.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_generate_key.proto)

*Copyright (c) 2019-2020, Arm Limited. All rights reserved.*
