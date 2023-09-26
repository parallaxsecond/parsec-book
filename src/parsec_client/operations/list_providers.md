# ListProviders

Gets a prioritized list of available Parsec providers to be used by clients. Opcode: 8 (`0x0008`)

## Parameters

No parameters are needed for this operation.

## Results

| Name        | Type                                           | Description                  |
|-------------|------------------------------------------------|------------------------------|
| `providers` | Vector of [`ProviderInfo`](#providerinfo-type) | List of provider information |

### ProviderInfo type

A `ProviderInfo` type contains the following members:

| Name          | Type             | Description                                                               |
|---------------|------------------|---------------------------------------------------------------------------|
| `uuid`        | String           | Unique, permanent, identifier of the provider (version 4 UUID)            |
| `description` | String           | Short description of the provider                                         |
| `vendor`      | String           | Provider vendor                                                           |
| `version_maj` | Unsigned integer | Provider implementation version major                                     |
| `version_min` | Unsigned integer | Provider implementation version minor                                     |
| `version_rev` | Unsigned integer | Provider implementation version revision number                           |
| `id`          | Unsigned integer | Provider ID to use on the wire protocol to communicate with this provider |

## Specific response status codes

No specific response status codes returned.

## Description

The version triplet returned by this operation (`version_maj`, `version_min` and `version_rev`) is
the implementation version of the specific Parsec provider. For the Core Provider, this version is
the implementation version of the whole Parsec service.

The `providers` vector returned is in order of provider priority: the highest priority providers
come first. The core provider will always come last. The provider at position zero, if not the core
provider, can be treated as default provider by the client. Clients should still check the supported
opcodes of the provider, even the default one, as it might not implement the operations they want.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/list_providers.proto)

*Copyright 2019 Contributors to the Parsec project.*
