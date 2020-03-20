# PsaDestroyKey

## Opcode: 3 (decimal), 0x0003 (hex)

## Summary

Destroy a key.

This function destroys a key from both volatile memory and, if applicable, non-volatile storage.
Implementations shall make a best effort to ensure that that the key material cannot be recovered.

This function also erases any metadata such as policies and frees all resources associated with the
key.

## Parameters

- **key_name** - Name of the key to be destroyed.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_destroy_key.proto)

*Copyright (c) 2019, Arm Limited. All rights reserved.*
