# Key Attestation Parameters

This page defines the mechanism-specific inputs and outputs of `AttestKey`. For an in-depth look at
the mechanisms and hardware tokens that we've considered, you can read our write-up
[here](https://drive.google.com/file/d/11jLLv8zN_xRunj9BEkk_L_tj5DiQOtkG/view?usp=sharing).

Each mechanism comes with its own definitions for `AttestationMechanismParams` and
`AttestationOutput`.

**(EXPERIMENTAL) The parameters for key attestation are in an experimental phase. No guarantees are
offered around the stability of the interface for any key attestation mechanism.**

## ActivateCredential (TPM provider)

The [TPM 2.0 Commands
spec](https://trustedcomputinggroup.org/wp-content/uploads/TCG_TPM2_r1p59_Part3_Commands_pub.pdf)
describes the `TPM2_ActivateCredential` operation as follows:

> This command enables the association of a credential with an object in a way that ensures that the
> TPM has validated the parameters of the credentialed object.

`TPM2_ActivateCredential` allows a 3rd party to be assured of the protection of a key by means of an
encrypted credential. The 3rd party produces a random credential and encrypts it using the algorithm
defined in the [TPM 2.0 Architecture
spec](https://trustedcomputinggroup.org/wp-content/uploads/TCG_TPM2_r1p59_Part1_Architecture_pub.pdf),
section B.10.4. The outputs of that algorithm (the encrypted and HMAC-protected credential, and a
secret seed encrypted with the public part of the attesting key) are sent to the Parsec service
which proceeds to perform the operation and returns the decrypted credential. The 3rd party can then
be certain that the key is protected by a TPM by confirming that the credential sent and the one
received are identical.

The computation mentioned previously relies on a number of parameters that must be obtained from the
Parsec service. As some of these parameters are strictly TPM-specific, they can be retrieved with
the [`PrepareKeyAttestation`](prepare_key_attestation.md) operation. You can see how to perform the
preparation step for `ActivateCredential`
[here](prepare_key_attestation_params.md#activatecredential-tpm-provider).

**This mechanisms is thus aimed at attesting keys that are configured for decryption** (as opposed
to signing) and is of particular interest because the Endorsement Keys for which TPM manufacturers
produce certificates are overwhelmingly decryption keys.

The parameters and output follow the inputs and outputs of `TPM2_ActivateCredential` as defined in
the [TPM 2.0 Structures
spec](https://trustedcomputinggroup.org/wp-content/uploads/TCG_TPM2_r1p59_Part2_Structures_pub.pdf).

### AttestationMechanismParams

| Name              | Type                     | Description                    |
|-------------------|--------------------------|--------------------------------|
| `credential_blob` | Vector of unsigned bytes | Protected credential           |
| `secret`          | Vector of unsigned bytes | Attesting key-encrypted secret |

- `credential_blob` represents the contents of the `credential` field within the `TPM2B_ID_OBJECT`
   structure.
- `secret` represents the contents of the `secret` field within the `TPM2B_ENCRYPTED_SECRET`
   structure.

### AttestationOutput

| Name         | Type                     | Description                    |
|--------------|--------------------------|--------------------------------|
| `credential` | Vector of unsigned bytes | Credential returned by the TPM |

- `credential` represents the contents of the `buffer` field within the `TPM2B_DIGEST` structure.

*Copyright 2021 Contributors to the Parsec project.*
