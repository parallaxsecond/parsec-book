# ListClients

Lists all clients currently having keys in the service. Opcode: 27 (`0x001B`)

## Parameters

No parameters are needed for this operation.

## Results

| Name      | Type             | Description     |
|-----------|------------------|-----------------|
| `clients` | Vector of String | List of clients |

## Specific response status codes

- `AdminOperation`: this operation is an admin operation and cannot be requested by a user
   application.

## Description

This operation lists all clients that are currently storing data in the Parsec service. The
`clients` field contain a vector of the application names used by clients.

This operation necessitates **admin** privilege.

Only the clients using the same authentication method as this request will be listed. It has no
impact currently as only one authentication method in the service is supported but might do if the
service supports multiple.

**Note:** this operation might return wrong results if clients' data is being modified while it
executes. For example, if a new client is creating keys while this operation is being performed,
this new client might not show in the output.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/list_clients.proto)

*Copyright 2021 Contributors to the Parsec project.*
