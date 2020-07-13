# PsaAsymmetricDecrypt

Decrypt a short message with a private key. Opcode: 11 (`0x000B`)

## Parameters

| Name         | Type                                                                      | Description                                                                |
|--------------|---------------------------------------------------------------------------|----------------------------------------------------------------------------|
| `key_name`   | String                                                                    | Name of the key to use for the operation                                   |
| `alg`        | [`AsymmetricEncryption`](psa_algorithm.md#asymmetricencryption-algorithm) | An asymmetric encryption algorithm that is compatible with the type of key |
| `ciphertext` | Vector of bytes                                                           | Short message to decrypt                                                   |
| `salt`       | Vector of bytes                                                           | Salt to use during encryption, if supported by the algorithm               |

- `key_name` must be the name of an RSA asymmetric key pair. The key must allow the [usage
   flag](psa_key_attributes.md#usageflags-type) `decrypt`.
- `salt` can be provided if supported by the algorithm. If the algorithm does not support salt, pass
   an empty vector. If the algorithm supports optional salt, pass an empty vector to indicate no
   salt. For RSA PKCS#1 v1.5 encryption, no salt is supported.

## Results

| Name        | Type            | Description                             |
|-------------|-----------------|-----------------------------------------|
| `plaintext` | Vector of bytes | Buffer containing the decrypted message |

## Specific response status codes

- `PsaErrorNotPermitted`: The key does not have the `decrypt` flag, or it does not permit the
   requested algorithm.

## Description

This function will decrypt a short message with the private key of the provided key pair.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_asymmetric_decrypt.proto)

*Copyright 2020 Contributors to the Parsec project.*
