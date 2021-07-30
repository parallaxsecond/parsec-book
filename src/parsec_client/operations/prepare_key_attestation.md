# PrepareKeyAttestation

Prepare the backend for performing a key attestation with a given algorithm and retrieve any data
necessary prior to the attestation operation. Opcode: 31 (`0x001F`)

**(EXPERIMENTAL) This operation is in an experimental phase. No guarantees are offered around the
stability of the contracts.**

## Parameters

| Name         | Type                                                               | Description                               |
|--------------|--------------------------------------------------------------------|-------------------------------------------|
| `parameters` | [`PrepareKeyAttestationParams`](prepare_key_attestation_params.md) | Attestation mechanism-specific parameters |

## Results

| Name     | Type                                                               | Description                           |
|----------|--------------------------------------------------------------------|---------------------------------------|
| `output` | [`PrepareKeyAttestationOutput`](prepare_key_attestation_params.md) | Attestation mechanism-specific output |

## Specific response status codes

TBD

## Description

This operation performs any preparation steps required by the `AttestKey` operation. These steps are
attestation-mechanism specific and can include performing any service-side setup, as well as
obtaining any data necessary to the client or 3rd party requesting the attestation.

**NOTE:** Only some of the attestation mechanisms require preparation. You can check which ones do
in their descriptions on the [key attestation parameters page](attest_key_params.md). Their
corresponding preparation parameters can be found on the [key attestation preparation parameters
page](prepare_key_attestation_params.md).

## Contract

TBD

*Copyright 2021 Contributors to the Parsec project.*
