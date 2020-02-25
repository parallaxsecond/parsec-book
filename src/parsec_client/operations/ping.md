# Ping

## Opcode: 1 (decimal), 0x0001 (hex)

## Summary

Determines whether the service is present and responsive on the expected endpoint. Clients should
follow the following bootstrapping sequence if they want to switch to the highest wire protocol
version that the service support:

1. Client requests a Ping operation using the wire protocol version `1.0`.
2. Service responds with the highest wire protocol version supported `x.y`.
3. Client can now use any wire protocol version up to and including `x.y` for further requests.

## Contract

[Protobuf](https://github.com/parallaxsecond/parsec-operations/blob/master/protobuf/ping.proto)

*Copyright (c) 2019, Arm Limited. All rights reserved.*
