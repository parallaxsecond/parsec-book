# ListAuthenticators

Gets a list of Parsec authenticators available for use at the listener endpoint. Opcode: 14
(`0x000E`)

## Parameters

No parameters are needed for this operation.

## Results

| Name             | Type                                                     | Description                       |
|------------------|----------------------------------------------------------|-----------------------------------|
| `authenticators` | Vector of [`AuthenticatorInfo`](#authenticatorinfo-type) | List of authenticator information |

### AuthenticatorInfo type

A `AuthenticatorInfo` type contains the following members:

| Name          | Type             | Description                                                                         |
|---------------|------------------|-------------------------------------------------------------------------------------|
| `description` | String           | Short description of the authenticator                                              |
| `version_maj` | Unsigned integer | Authenticator implementation version major                                          |
| `version_min` | Unsigned integer | Authenticator implementation version minor                                          |
| `version_rev` | Unsigned integer | Authenticator implementation version revision number                                |
| `id`          | Unsigned integer | Authenticator ID to use on the wire protocol to communicate with this authenticator |

## Specific response status codes

No specific response status codes returned.

## Description

The version triplet returned by this operation (`version_maj`, `version_min` and `version_rev`) is
the implementation version of the specific Parsec authenticator.

The `authenticators` vector returned is in priority order. The primary authenticator will always
occupy index 0 in the vector.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/list_authenticators.proto)

*Copyright 2019 Contributors to the Parsec project.*
