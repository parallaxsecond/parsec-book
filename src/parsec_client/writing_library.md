# Writing a new Parsec Client Library

If a client library does not already exist in your preferred programming language, you can create
one. Writing a new client library is a great way to enhance the Parsec client ecosystem.

When creating a new client library, please make sure you understand the [Parsec philosophy for
client libraries](../parsec#beautiful-client-libraries). It is very important that you design your
client library to provide a highly ergonomic and idiomatic developer experience.

Take a look at the [**client library for Go**](https://github.com/parallaxsecond/parsec-client-go)
as an example. The [Rust Test Client](https://github.com/parallaxsecond/parsec-client-test) is a
client library used for testing but with no goal of being ergonomic nor easy to use. It can however
help how to build a real Rust client library.

You will need to understand the [**wire protocol specification**](wire_protocol.md) and the [**API
specification**](api_overview.md) in depth in order to create a client library.

*Copyright (c) 2019, Arm Limited. All rights reserved.*
