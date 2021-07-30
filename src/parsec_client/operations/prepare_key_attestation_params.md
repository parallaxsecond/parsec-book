# Prepare Key Attestation Parameters

This page defines the mechanism-specific inputs and outputs of `PrepareKeyAttestation`. For an
in-depth look at the mechanisms and hardware tokens that we've considered, you can read our write-up
[here](https://drive.google.com/file/d/11jLLv8zN_xRunj9BEkk_L_tj5DiQOtkG/view?usp=sharing).

Each mechanism that needs preparation comes with its own definitions for
`PrepareKeyAttestationParams` and `PrepareKeyAttestationOutput`.

**(EXPERIMENTAL) The parameters for key attestation are in an experimental phase. No guarantees are
offered around the stability of the interface for any key attestation mechanism.**

## ActivateCredential (TPM provider) {#activatecredential}

The preparation necessary for `ActivateCredential` involves retrieving the data necessary for
performing the `TPM2_MakeCredential` computations outside of a TPM. The results from
`MakeCredential` can then be passed to `AttestKey`.

The service returns the TPM-specific name of the object to be attested, its public parameters, and
the public part of the attesting key. These three components can then be used by a 3rd party to
generate an encrypted credential to be used in `AttestKey`. The algorithm for protecting the
credential is defined in the [TPM 2.0 Architecture
spec](https://trustedcomputinggroup.org/wp-content/uploads/TCG_TPM2_r1p59_Part1_Architecture_pub.pdf),
section B.10.4.

The public parameters of the key which will be attested are not strictly necessary in generating the
encrypted credential. The reason for its inclusion, however, rests on the need of the 3rd party to
verify that the object they are about to attest is indeed the one they expect. The process of
encrypting the credential involves deriving a symmetric key using the TPM-specific name of the
object to be attested. This name is obtained by performing a hash over the public parameters of the
object, and can thus be verified by the 3rd party if those parameters are available.

### PrepareKeyAttestationParams

| Name                 | Type   | Description                          |
|----------------------|--------|--------------------------------------|
| `attested_key_name`  | String | Name of the key to be attested       |
| `attesting_key_name` | String | Name of the key to use for attesting |

- if `attesting_key_name` is empty, the default key for the `ActivateCredential` mechanism will be
   used

### PrepareKeyAttestationOutput

| Name                | Type                     | Description                                            |
|---------------------|--------------------------|--------------------------------------------------------|
| `name`              | Vector of unsigned bytes | TPM-specific name of the key object to be attested     |
| `public`            | Vector of unsigned bytes | Public parameters of the key object to be attested     |
| `attesting_key_pub` | Vector of unsigned bytes | Buffer containing the public part of the attesting key |

- `name` represents the contents of the `name` field within the `TPM2B_NAME` structure.
- `public` represents the contents of the `publicArea` field within the `TPM2B_PUBLIC` structure.
- `attesting_key_pub` represents a public key encoded in the format specified for
   [`PsaExportPublicKey`](psa_export_public_key.md)

*Copyright 2021 Contributors to the Parsec project.*
