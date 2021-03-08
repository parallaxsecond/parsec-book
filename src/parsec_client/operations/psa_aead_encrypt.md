# PsaAeadEncrypt

Process an authenticated encryption operation. Opcode: 17 (`0x0011`)

## Parameters

| Name              | Type                                      | Description                                                  |
|-------------------|-------------------------------------------|--------------------------------------------------------------|
| `key_name`        | String                                    | Name of the key to use for the operation                     |
| `alg`             | [`Aead`](psa_algorithm.md#aead-algorithm) | The AEAD algorithm to compute                                |
| `nonce`           | Vector of unsigned bytes                  | Nonce or IV to use                                           |
| `additional_data` | Vector of unsigned bytes                  | Additional data that will be authenticated but not encrypted |
| `plaintext`       | Vector of unsigned bytes                  | Data that will be authenticated and encrypted                |

- `key_name` must allow the [usage flag](psa_key_attributes.md#usageflags-type) `encrypt`.
- `nonce` must be appropriate for the selected algorithm.

## Results

| Name         | Type                     | Description                                            |
|--------------|--------------------------|--------------------------------------------------------|
| `ciphertext` | Vector of unsigned bytes | Buffer containing the authenticated and encrypted data |

- The additional data is not part of `ciphertext`. For algorithms where the encrypted data and the
   authentication tag are defined as separate outputs, the authentication tag is appended to the
   encrypted data.

## Specific response status codes

- `PsaErrorNotPermitted`: The key does not have the `encrypt` flag, or it does not permit the
   requested algorithm.
- `PsaErrorInvalidArgument`: The `key` is not compatible with `alg`.
- `PsaErrorNotSupported`: `alg` is not supported.

## Description

Authenticates and encrypts the given data using the given AEAD algorithm.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_aead_encrypt.proto)

*Copyright 2020 Contributors to the Parsec project.*
