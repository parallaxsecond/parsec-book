# PsaDestroyKey

Destroy a key. Opcode: 3 (`0x0003`)

## Parameters

| Name       | Type   | Description              |
|------------|--------|--------------------------|
| `key_name` | String | Name of the key to erase |

## Results

No values are returned by this operation.

## Specific response status codes

- `PsaErrorNotPermitted`: The key cannot be erased because it is read-only, either due to a policy
   or due to physical restrictions.
- `PsaErrorCommunicationFailure`: There was an failure in communication with the cryptoprocessor.
   The key material might still be present in the cryptoprocessor.
- `PsaErrorStorageFailure`: The storage operation failed. Implementations must make a best effort to
   erase key material even in this situation, however, it might be impossible to guarantee that the
   key material is not recoverable in such cases.
- `PsaErrorDataCorrupt`: The storage is corrupted. Implementations must make a best effort to erase
   key material even in this situation, however, it might be impossible to guarantee that the key
   material is not recoverable in such cases.
- `PsaErrorCorruptionDetected`: An unexpected condition which is not a storage corruption or a
   communication failure occurred. The cryptoprocessor might have been compromised.

## Description

This function destroys a key from storage. This function also erases any metadata such as policies
and frees resources associated with the key. If a key is currently in use in a multi-part operation,
then destroying the key will cause the multi-part operation to fail.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_destroy_key.proto)

*Copyright (c) 2019, Arm Limited. All rights reserved.*
