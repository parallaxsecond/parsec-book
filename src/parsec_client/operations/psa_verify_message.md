# PsaVerifyMessage

Verify the signature of a message using a public key. Opcode: 25 (`0x0019`)

## Parameters

| Name        | Type                                                                    | Description                                                                                                              |
|-------------|-------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| `key_name`  | String                                                                  | Name of the key to use for the operation                                                                                 |
| `alg`       | [`AsymmetricSignature`](psa_algorithm.md#asymmetricsignature-algorithm) | An asymmetric signature algorithm that separates the message and sign operations that is compatible with the type of key |
| `message`   | Vector of bytes                                                         | The message whose signature is to be verified                                                                            |
| `signature` | Vector of bytes                                                         | Buffer containing the signature to verify                                                                                |

- `key_name` must be the name of a public key or an asymmetric key pair. The key must allow the
   [usage flag](psa_key_attributes.md#usageflags-type) `verify_hash`.

No values are returned by this operation. If `Success` is returned the signature is valid.

## Specific response status codes

- `PsaErrorNotPermitted`: The key does not have the `verify_hash` flag, or it does not permit the
   requested algorithm.
- `PsaErrorInvalidSignature`: The calculation was performed successfully, but the passed signature
   is not a valid signature.

## Description

This function will verify the signature of a message with a public key, using a hash-and-sign
verification algorithm.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_verify_message.proto)

*Copyright 2020 Contributors to the Parsec project.*
