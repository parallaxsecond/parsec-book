# PsaHashCompare

Calculate the hash (digest) of a message and compare it with a reference value. Opcode: 16
(`0x0010`)

## Parameters

| Name    | Type                                      | Description                           |
|---------|-------------------------------------------|---------------------------------------|
| `alg`   | [`Hash`](psa_algorithm.md#hash-algorithm) | The hash algorithm to compute         |
| `input` | Vector of unsigned bytes                  | Buffer containing message to hash     |
| `hash`  | Vector of unsigned bytes                  | Buffer containing expected hash value |

## Results

No values are returned by this operation.

If no error occurs, the computed hash matches the expected hash value.

## Specific response status codes

- `PsaErrorInvalidSignature`: The hash of the message was calculated successfully, but it differs
   from the expected hash.
- `PsaErrorNotSupported`: `alg` is not supported.
- `PsaErrorInvalidArgument`: The length of `input` or `hash` does not match the hash size for `alg`.

## Description

Calculates the hash of the given message, using the specified algorithm, and compares the result
with an expected hash value.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_hash_compare.proto)

*Copyright 2020 Contributors to the Parsec project.*
