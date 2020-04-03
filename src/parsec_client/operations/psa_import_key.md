# PsaImportKey

Import a key in binary format. Opcode: 6 (`0x0006`)

## Parameters

| Name         | Type                                                        | Description                    |
|--------------|-------------------------------------------------------------|--------------------------------|
| `key_name`   | String                                                      | Name of the key to import      |
| `attributes` | [`KeyAttributes`](psa_key_attributes.md#keyattributes-type) | The attributes of the new key  |
| `data`       | Vector of bytes                                             | Buffer containing the key data |

The content of the `data` buffer is interpreted according to the type declared in attributes. Parsec
supports the formats described in the documentation of PsaExportKey or
[PsaExportPublicKey](psa_export_public_key.md) for the chosen type.

## Results

No values are returned by this operation.

## Specific response status codes

- `PsaErrorAlreadyExists`: There is already a key with the given name.
- `PsaErrorNotSupported`: The key type or key size is not supported.
- `PsaErrorInvalidArgument`: The key attributes, as a whole, are invalid.
- `PsaErrorInvalidArgument`: The key data is not correctly formatted.
- `PsaErrorInvalidArgument`: The size in attributes is nonzero and does not match the size of the
   key data.

## Description

This function supports any output from PsaExportKey. Refer to the documentation of
[PsaExportPublicKey](psa_export_public_key.md) for the format of public keys and to the
documentation of PsaExportKey for the format for other key types.

This specification supports a single format for each key type. Parsec might support other formats in
the future.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/psa_import_key.proto)

*Copyright (c) 2019, Arm Limited. All rights reserved.*
