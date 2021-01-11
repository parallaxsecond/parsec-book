# DeleteClient

Delete all keys a client has in the service. Opcode: 28 (`0x001C`)

## Parameters

| Name     | Type   | Description      |
|----------|--------|------------------|
| `client` | String | Client to delete |

## Results

No values are returned by this operation.

## Specific response status codes

- `AdminOperation`: this operation is an admin operation and cannot be requested by a user
   application.

## Description

This operation deletes all data a client owns in Parsec. The `client` parameter string must match
one of the clients returned by the `ListClients` operation.

This operation necessitates **admin** privilege.

Only the clients using the same authentication method as this request will be deleted. It has no
impact currently as only one authentication method in the service is supported but might do if the
service supports multiple.

**Note:** this operation might return wrong results if clients' data is being modified while it
executes. For example, if the client named creates a new key while this operation is being
performed, this key might not be deleted.

## Contract

No contract yet.

*Copyright 2021 Contributors to the Parsec project.*
