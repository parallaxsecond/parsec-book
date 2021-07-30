# AttestKey

Attest that a Parsec-managed key is protected by a hardware backend. Opcode: 30 (`0x001E`)

**(EXPERIMENTAL) This operation is in an experimental phase. No guarantees are offered around the
stability of the contracts and abstract definition of the operation, or of any associated key
attestation mechanism.**

## Parameters

| Name                 | Type                                                 | Description                               |
|----------------------|------------------------------------------------------|-------------------------------------------|
| `attested_key_name`  | String                                               | Name of the key to attest                 |
| `parameters`         | [`AttestationMechanismParams`](attest_key_params.md) | Attestation mechanism-specific parameters |
| `attesting_key_name` | String                                               | Name of the key to use for attesting      |

- The exact usage flags required by the attesting key are determined by the mechanism used, also
   described on the [key attestation parameters page](attest_key_params.md).

## Results

| Name     | Type                                        | Description                           |
|----------|---------------------------------------------|---------------------------------------|
| `output` | [`AttestationOutput`](attest_key_params.md) | Attestation mechanism-specific output |

## Specific response status codes

TBD

## Description

This operation performs a key attestation using a mechanism supported by the backend holding the
key. The purpose of the operation is to help a Parsec client provide proof to a 3rd party that some
key provisioned by the client is indeed stored and secured by a hardware backend. As such, the
operation is backed by native functionality in the hardware to attest to ownership of the key.

Given the wide variety of possible mechanisms, many of the properties, restrictions, and formats
involved are mechanism-dependent, including:

- Properties of the attested key (e.g. whether it was created within the backend or imported)
- Properties of the attesting key (e.g. if it must be able to sign or decrypt)
- Number, content, and purpose of parameters required by the attestation
- Contents and format of the output
- Whether or not the attesting key can be specified

All such characteristics are thoroughly described per mechanism on the [key attestation parameters
page](attest_key_params.md).

All instances of backends that support `AttestKey` must be configured with a default, root key that
has been pre-provisioned and which can be used to produce attestations. This default attesting key
is selected by leaving the `attesting_key_name` empty. If the backend allows other keys to be used
for attesting, attestation chains can be created starting from the root key.

`AttestKey` applies to asymmetric key pairs only.

## Contract

TBD

*Copyright 2021 Contributors to the Parsec project.*
