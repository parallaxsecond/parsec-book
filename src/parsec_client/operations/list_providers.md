# ListProviders

## Opcode: 8 (decimal), 0x0008 (hex)

## Summary

Gets a list of available Parsec providers to be used by clients.

The version triplet returned by this operation (`version_maj`, `version_min` and `version_rev`) is
the implementation version of the specific Parsec provider. For the Core Provider, this version is
the implementation version of the whole Parsec service.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/list_providers.proto)

*Copyright (c) 2019, Arm Limited. All rights reserved.*
