# CanDoCrypto

Check if the provider supports:

- using a specific algorithm with an existing key
- generating a key and optionally using it for a specific algorithm
- importing a key and optionally using it for a specific algorithm
- deriving a key and optionally using it for a specific algorithm (to be checked)

Opcode: 32 (`0x0020`)

**(EXPERIMENTAL) This operation is still being implemented and so no guarantees are offered around
the stability of the interface for any capability discovery mechanism.**

## Parameters

| Name         | Type                                                        | Description                 |
|--------------|-------------------------------------------------------------|-----------------------------|
| `check_type` | [`CheckType`](#checktype-type)                              | Type of the check performed |
| `attributes` | [`KeyAttributes`](psa_key_attributes.md#keyattributes-type) | Value to be checked         |

### CheckType type

A `CheckType` type can contain one of the following:

- Use
- Generate
- Import
- Derive

## Results

No values are returned by this operation

## Specific response status codes

- `Success`: the check is successful
- `PsaErrorNotSupported`: the check failed (not supported)

## Description

The meaning of the operation depends of the value of `check_type`:

- Use: the operation checks if an existing key of the same key type than in the attributes and the
   same length can be used to perform the algorithm in `key_policy.key_algorithm`. If the `key_bits`
   is 0, check for a key of any size.
- Generate: checks if a key with the same attributes can be generated. If the `key_algorithm` is not
   `None`, also perform the Use check. If the `key_bits` is 0, check for a key of any size.
- Import: checks if a key with the same attributes can be imported. If the `key_algorithm` is not
   `None`, also perform the Use check. If the `key_bits` is 0, check for a key of any size.
- Derive: checks if a key with the same attributes can be derived. If the `key_algorithm` is not
   `None`, also perform the Use check. If the `key_bits` is 0, check for a key of any size.

## Contract

Contract currently being written

*Copyright 2021 Contributors to the Parsec project.*
