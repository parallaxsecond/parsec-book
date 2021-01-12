# ListKeys

Lists all keys belonging to the application. Opcode: 26 (`0x001A`)

## Parameters

No parameters are needed for this operation.

## Results

| Name   | Type                                 | Description             |
|--------|--------------------------------------|-------------------------|
| `keys` | Vector of [`KeyInfo`](#keyinfo-type) | List of key information |

### KeyInfo type

A `KeyInfo` type contains the following members:

| Name          | Type                                                        | Description                        |
|---------------|-------------------------------------------------------------|------------------------------------|
| `provider_id` | Unsigned integer                                            | ID of the provider holding the key |
| `name`        | String                                                      | Name of the key                    |
| `attributes`  | [`KeyAttributes`](psa_key_attributes.md#keyattributes-type) | Attributes of the key              |

## Specific response status codes

No specific response status codes returned.

## Description

This operation lists all the keys that an application created in all providers.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/list_keys.proto)

*Copyright 2020 Contributors to the Parsec project.*
