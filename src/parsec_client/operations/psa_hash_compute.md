# PsaHashCompute

Calculate the hash (digest) of a message. Opcode: 15 (`0x000F`)

## Parameters

| Name    | Type                                      | Description                       |
|---------|-------------------------------------------|-----------------------------------|
| `alg`   | [`Hash`](psa_algorithm.md#hash-algorithm) | The hash algorithm to compute     |
| `input` | Vector of unsigned bytes                  | Buffer containing message to hash |

## Results

| Name   | Type                     | Description                       |
|--------|--------------------------|-----------------------------------|
| `hash` | Vector of unsigned bytes | Buffer containing hash of message |

## Specific response status codes

- `PsaErrorNotSupported`: `alg` is not supported.

## Description

Calculates the hash of the given message, using the specified algorithm.

Note: To verify the hash of a message against an expected value, use
[PsaHashCompare](psa_hash_compare.md).

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_hash_compute.proto)

*Copyright 2020 Contributors to the Parsec project.*
