# PsaMacVerify

Calculate the MAC of a message and compare it to an expected value. Opcode: 23 (`0x0017`)

## Parameters

| Name       | Type                                    | Description                              |
|------------|-----------------------------------------|------------------------------------------|
| `key_name` | String                                  | Name of the key to use for the operation |
| `alg`      | [`Mac`](psa_algorithm.md#mac-algorithm) | Mac algorithm to compute                 |
| `input`    | Vector of bytes                         | Buffer containing the input message      |
| `mac`      | Vector of bytes                         | Buffer containing the expected MAC value |

- `key_name` must allow the [usage flag](psa_key_attributes.md#usageflags-type) `verify_message`.

## Results

No values are returned by this operation. If `Success` is returned the MAC is valid.

## Specific response status codes

- `PsaErrorNotPermitted`: The key does not have the `verify_message` flag, or it does not permit the
   requested algorithm.
- `PsaErrorInvalidSignature`: The MAC of the message was calculated successfully, but it differs
   from the expected value.

## Description

This function will calculate the message authentication code (MAC) of a message and compare it to an
expected value.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_mac_verify.proto)

*Copyright 2020 Contributors to the Parsec project.*
