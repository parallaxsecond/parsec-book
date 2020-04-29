# ListOpcodes

Gets a list of available opcodes supported by a Parsec provider. Opcode: 9 (`0x0009`)

## Parameters

| Name          | Type             | Description                                             |
|---------------|------------------|---------------------------------------------------------|
| `provider_id` | Unsigned integer | Provider for which the supported opcodes are requested. |

## Results

| Name      | Type                        | Description               |
|-----------|-----------------------------|---------------------------|
| `opcodes` | Vector of unsigned integers | List of supported opcodes |

## Specific response status codes

No specific response status codes returned.

## Description

Gets a list of available opcodes supported by a Parsec provider.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/list_opcodes.proto)

*Copyright 2019 Contributors to the Parsec project.*
