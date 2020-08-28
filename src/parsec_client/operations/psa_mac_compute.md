# PsaMacCompute

Calculate the MAC of a message. Opcode: 22 (`0x0016`)

## Parameters

| Name       | Type                                    | Description                              |
|------------|-----------------------------------------|------------------------------------------|
| `key_name` | String                                  | Name of the key to use for the operation |
| `alg`      | [`Mac`](psa_algorithm.md#mac-algorithm) | Mac algorithm to compute                 |
| `input`    | Vector of bytes                         | Buffer containing the input message      |

- `key_name` must allow the [usage flag](psa_key_attributes.md#usageflags-type) `sign_message`.

## Results

| Name  | Type            | Description               |
|-------|-----------------|---------------------------|
| `mac` | Vector of bytes | Buffer containing the MAC |

## Specific response status codes

- `PsaErrorNotPermitted`: The key does not have the `sign_message` flag, or it does not permit the
   requested algorithm.

## Description

This function will calculate the message authentication code (MAC) of a message.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_mac_compute.proto)

*Copyright 2020 Contributors to the Parsec project.*
