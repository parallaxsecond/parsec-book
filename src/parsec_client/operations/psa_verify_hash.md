# PsaVerifyHash

Verify the signature of a hash or short message using a public key. Opcode: 5 (`0x0005`)

## Parameters

| Name        | Type                                                                    | Description                                                                                                           |
|-------------|-------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| `key_name`  | String                                                                  | Name of the key to use for the operation                                                                              |
| `alg`       | [`AsymmetricSignature`](psa_algorithm.md#asymmetricsignature-algorithm) | An asymmetric signature algorithm that separates the hash and sign operations that is compatible with the type of key |
| `hash`      | Vector of bytes                                                         | The input whose signature is to be verified                                                                           |
| `signature` | Vector of bytes                                                         | Buffer containing the signature to verify                                                                             |

- `key_name` must be the name of a public key or an asymmetric key pair. The key must allow the
   [usage flag](psa_key_attributes.md#usageflags-type) `verify_hash`.
- `hash` is usually the hash of a message. See the detailed description of this function and the
   description of individual signature algorithms for a detailed description of acceptable inputs.

## Results

No values are returned by this operation. If `Success` is returned the signature is valid.

## Specific response status codes

- `PsaErrorNotPermitted`: The key does not have the `verify_hash` flag, or it does not permit the
   requested algorithm.
- `PsaErrorInvalidSignature`: The calculation was performed successfully, but the passed signature
   is not a valid signature.

## Description

With most signature mechanisms that follow the hash-and-sign paradigm, the hash input to this
function is the hash of the message to sign. The hash algorithm is encoded in the signature
algorithm. Some hash-and-sign mechanisms apply a padding or encoding to the hash. In such cases, the
encoded hash must be passed to this function. The current version of this specification defines one
such signature algorithm: Raw PKCS#1 v1.5 signature.

**Note:** To perform a hash-and-sign algorithm, the hash must be calculated before passing it to
this function. This could be done with the operation PsaHashCompute or with a multi-part hash
operation. Those operations are not yet implemented. Alternatively, to hash and verify a message
signature in a single call, you could use PsaVerifyMessage.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_verify_hash.proto)

*Copyright 2019 Contributors to the Parsec project.*
