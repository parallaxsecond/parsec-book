# PsaCipherDecrypt

Decrypt a short message with a symmetric cipher. Opcode: 21 (`0x0015`)

## Parameters

| Name         | Type                                          | Description                                                |
|--------------|-----------------------------------------------|------------------------------------------------------------|
| `key_name`   | String                                        | Name of the key to use for the operation                   |
| `alg`        | [`Cipher`](psa_algorithm.md#cipher-algorithm) | A cipher algorithm that is compatible with the type of key |
| `ciphertext` | Vector of bytes                               | IV followed by the ciphertext                              |

- `key_name` must allow the [usage flag](psa_key_attributes.md#usageflags-type) `decrypt`.
- `ciphertext` must be the IV followed by the ciphertext.

## Results

| Name        | Type            | Description                         |
|-------------|-----------------|-------------------------------------|
| `plaintext` | Vector of bytes | Buffer containing decrypted message |

## Specific response status codes

- `PsaErrorNotPermitted`: The key does not have the `decrypt` flag, or it does not permit the
   requested algorithm.
- `PsaErrorInvalidPadding`: The decrypted padding is incorrect. See Warning below.

## Description

This function will decrypt a short message using the provided initialisation vector (IV).

**Warning:** In some protocols, when decrypting data, it is essential that the behavior of the
application does not depend on whether the padding is correct, down to precise timing. Protocols
that use authenticated encryption are recommended for use by applications, rather than plain
encryption. If the application must perform a decryption of unauthenticated data, the application
writer must take care not to reveal whether the padding is invalid.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_cipher_decrypt.proto)

*Copyright 2020 Contributors to the Parsec project.*
