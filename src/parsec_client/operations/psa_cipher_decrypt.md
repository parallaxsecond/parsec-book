# PsaCipherDecrypt

Decrypt a short message with a symmetric cipher. Opcode: 21 (`0x0015`)

## Parameters

| Name         | Type                                          | Description                                                |
|--------------|-----------------------------------------------|------------------------------------------------------------|
| `key_name`   | String                                        | Name of the key to use for the operation                   |
| `alg`        | [`Cipher`](psa_algorithm.md#cipher-algorithm) | A cipher algorithm that is compatible with the type of key |
| `ciphertext` | Vector of bytes                               | IV followed by the ciphertext                              |

- `key_name` must allow the [usage flag](psa_key_attributes.md#usageflags-type) `decrypt`.

## Results

| Name        | Type            | Description                         |
|-------------|-----------------|-------------------------------------|
| `plaintext` | Vector of bytes | Buffer containing decrypted message |

## Specific response status codes

- `PsaErrorNotPermitted`: The key does not have the `decrypt` flag, or it does not permit the
   requested algorithm.

## Description

This function will decrypt a short message using the provided initialisation vector (IV). The input
must be the IV followed by the ciphertext.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_cipher_decrypt.proto)

*Copyright 2020 Contributors to the Parsec project.*
