# PsaAeadDecrypt

Process and authenticated decryption operation. Opcode: 18 (`0x0012`)

## Parameters

| Name              | Type                                      | Description                                                   |
|-------------------|-------------------------------------------|---------------------------------------------------------------|
| `key_name`        | String                                    | Name of the key to use for the operation                      |
| `alg`             | [`Aead`](psa_algorithm.md#aead-algorithm) | The AEAD algorithm to compute                                 |
| `nonce`           | Vector of unsigned bytes                  | Nonce or IV to use                                            |
| `additional_data` | Vector of unsigned bytes                  | Additional data that has been authenticated but not encrypted |
| `ciphertext`      | Vector of unsigned bytes                  | Data that has been authenticated and encrypted                |

- `key_name` must allow the [usage flag](psa_key_attributes.md#usageflags-type) `decrypt`.
- `nonce` must be appropriate for the selected algorithm.
- For algorithms where the encrypted data and the authentication tag are defined as separate inputs,
   `ciphertext` must contain the encrypted data followed by the authentication tag.

## Results

| Name        | Type                     | Description                          |
|-------------|--------------------------|--------------------------------------|
| `plaintext` | Vector of unsigned bytes | Buffer containing the decrypted data |

## Specific response status codes

- `PsaErrorInvalidSignature`: The ciphertext is not authentic.
- `PsaErrorNotPermitted`: The key does not have the `decrypt` flag, or it does not permit the
   requested algorithm.
- `PsaErrorInvalidArgument`: The `key` is not compatible with `alg`.
- `PsaErrorNotSupported`: `alg` is not supported.

## Description

Authenticates and decrypts the given data using the given AEAD algorithm.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_aead_decrypt.proto)

*Copyright 2020 Contributors to the Parsec project.*
