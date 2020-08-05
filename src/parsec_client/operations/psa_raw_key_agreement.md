# PsaRawKeyAgreement

Perform a key agreement and return the raw shared secret. Opcode: 19 (`0x0013`)

## Parameters

| Name               | Type                                                       | Description                            |
|--------------------|------------------------------------------------------------|----------------------------------------|
| `alg`              | [RawKeyAgreement](psa_algorithm.md#keyagreement-algorithm) | The key agreement algorithm to compute |
| `private_key_name` | String                                                     | Name of the private key to use         |
| `peer_key`         | Vector of unsigned bytes                                   | Public key of the peer                 |

- `private_key_name` must allow the [usage flag](psa_key_attributes.md#usageflags-type) `derive`.
- `peer_key` must be in the same format that [PsaImportKey](psa_import_key.md) accepts.

## Results

| Name            | Type                     | Description           |
|-----------------|--------------------------|-----------------------|
| `shared_secret` | Vector of unsigned bytes | The raw shared secret |

## Specific response status codes

- `PsaErrorNotPermitted`: The key does not have the `derive` [usage
   flag](psa_key_attributes.md#usageflags-type), or does not permit the requested algorithm.
- `PsaErrorInvalidArgument`: `private_key_name` is not compatible with `alg`, or `peer_key_name` is
   not valid for `alg` or not compatible with `private_key_name`.
- `PsaErrorNotSupported`: `alg` is not a supported key agreement algorithm.

## Description

**Warning:** The raw result of a key agreement algorithm such as finite-field Diffie-Hellman or
elliptic curve Diffie-Hellman has biases, and is not suitable for use as key material. Instead it is
recommended that the result is used as input to a key derivation algorithm. To chain a key agreement
with a key derivation, use psa_key_derivation_key_agreement() and other functions from the key
derivation interface.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_raw_key_agreement.proto)

*Copyright 2020 Contributors to the Parsec project.*
