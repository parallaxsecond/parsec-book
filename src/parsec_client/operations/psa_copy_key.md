# PsaCopyKey

Copy key material from one location to another. Opcode: 14 (`0x000E`)

## Parameters

| Name               | Type                                                        | Description                   |
|--------------------|-------------------------------------------------------------|-------------------------------|
| `key_to_copy_name` | String                                                      | Name of the key to copy       |
| `copied_key_name`  | String                                                      | Name of the new copy          |
| `attributes`       | [`KeyAttributes`](psa_key_attributes.md#keyattributes-type) | The attributes of the new key |

- The key must allow the [usage flag](psa_key_attributes.md#usageflags-type) `copy`. If a private
   key is being copied outside of a secure element, it must also allow `export`.
- For `attributes`, the size can be 0. If it is nonzero, it must match the corresponding attributes
   of the source key. The key location (the lifetime and, for presistent keys, the key identifier)
   is used directly. The [usage flags](psa_key_attributes.md#usageflags-type) and algorithm policy
   are combined from the source key and `attributes`, so that the new copy only contains the flags
   and algorithms common to both.

## Results

No values are returned by this operation.

## Specific response status codes

- `PsaErrorAlreadyExists`: There is already a key with the given name `copied_key_name`.
- `PsaErrorInvalidArgument`: The lifetime or identifier in `attributes` are invalid.
- `PsaErrorInvalidArgument`: The policy constraints on the source key and specified in `attributes`
   are incompatible.
- `PsaErrorInvalidArgument`: `attributes` specifies a key type or key size which does not match that
   of the source key.
- `PsaErrorNotPermitted`: The source key does not have the `copy` [usage
   flag](psa_key_attributes.md#usageflags-type).
- `PsaErrorNotPermitted`: The source key's lifetime does not allow copying to the target's lifetime
   and does not have the `export` flag.

## Description

This function is primarily useful to copy a key from one location to another, as it populates a key
using the material from another key which can have a different lifetime.

This function can be used to share a key with a different party, subject to implementation-defined
restrictions on key sharing.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_copy_key.proto)

*Copyright 2020 Contributors to the Parsec project.*
