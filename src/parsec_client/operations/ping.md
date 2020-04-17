# Ping

Determines whether the service is present and responsive on the expected endpoint. Opcode: 1
(`0x0001`)

## Parameters

No parameters are needed for this operation.

## Results

| Name                        | Type             | Description                 |
|-----------------------------|------------------|-----------------------------|
| `wire_protocol_version_maj` | Unsigned integer | Wire protocol version major |
| `wire_protocol_version_min` | Unsigned integer | Wire protocol version minor |

## Specific response status codes

No specific response status codes returned.

## Description

Clients should follow the following bootstrapping sequence if they want to switch to the highest
wire protocol version that the service support:

1. Client requests a Ping operation using the wire protocol version `1.0`.
2. Service responds with the highest wire protocol version supported `x.y`.
3. Client can now use any wire protocol version up to and including `x.y` for further requests.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/ping.proto)

*Copyright 2019 Contributors to the Parsec project.*
