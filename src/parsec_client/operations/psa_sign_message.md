# PsaSignMessage

Sign a message with a private key. Opcode: 24 (`0x0018`)

## Parameters

| Name       | Type                                                                    | Description                                                                                                              |
|------------|-------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| `key_name` | String                                                                  | Name of the key to use for the operation                                                                                 |
| `alg`      | [`AsymmetricSignature`](psa_algorithm.md#asymmetricsignature-algorithm) | An asymmetric signature algorithm that separates the message and sign operations that is compatible with the type of key |
| `message`  | Vector of bytes                                                         | The message to sign                                                                                                      |

- `key_name` must be the name of an asymmetric key pair. The key must allow the [usage
   flag](psa_key_attributes.md#usageflags-type) `sign_message`.

## Results

| Name        | Type            | Description                     |
|-------------|-----------------|---------------------------------|
| `signature` | Vector of bytes | Buffer containing the signature |

## Specific response status codes

- `PsaErrorNotPermitted`: The key does not have the `sign_message` flag, or it does not permit the
   requested algorithm.

## Description

This function will sign a message with a private key. For hash-and-sign algorithms, this includes
the hashing step.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_sign_message.proto)

*Copyright 2020 Contributors to the Parsec project.*
