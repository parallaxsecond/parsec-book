# PsaCipherEncrypt

Encrypt a short message with a symmetric cipher. Opcode: 20 (`0x0014`)

## Parameters

| Name        | Type                                          | Description                                                |
|-------------|-----------------------------------------------|------------------------------------------------------------|
| `key_name`  | String                                        | Name of the key to use for the operation                   |
| `alg`       | [`Cipher`](psa_algorithm.md#cipher-algorithm) | A cipher algorithm that is compatible with the type of key |
| `plaintext` | Vector of bytes                               | Short message to encrypt                                   |

- `key_name` must allow the [usage flag](psa_key_attributes.md#usageflags-type) `encrypt`.

## Results

| Name         | Type            | Description                                                       |
|--------------|-----------------|-------------------------------------------------------------------|
| `ciphertext` | Vector of bytes | Buffer containing the random IV followed by the encrypted message |

## Specific response status codes

- `PsaErrorNotPermitted`: The key does not have the `encrypt` flag, or it does not permit the
   requested algorithm.

## Description

This function will encrypt a short message with a random initialisation vector (IV). The output is
the IV followed by the ciphertext.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_cipher_encrypt.proto)

*Copyright 2020 Contributors to the Parsec project.*
