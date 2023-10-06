# Parsec for users

## How to use Parsec

On a system where Parsec is installed, it can easily be used with a Parsec Client Library. Those
libraries communicate with the Parsec service and integrate with the rest of the software
idiomatically.

Parsec Client Libraries are available in the following languages:

- [Rust](https://docs.rs/parsec-client/*/parsec_client/): See examples on how to use the
   [`BasicClient`](https://docs.rs/parsec-client/*/parsec_client/core/basic_client/struct.BasicClient.html).
- [C](https://github.com/parallaxsecond/parsec-se-driver): support exists for using Parsec through
   the PSA Crypto API for a limited set of primitives. Non-PSA functionality is currently not
   supported.
- [Java](https://github.com/parallaxsecond/parsec-client-java): both a native Parsec client, as well
   as a JCA implementation based on that client.
- [Go](https://github.com/parallaxsecond/parsec-client-go): work in progress!
- [Erlang](https://github.com/jbevemyr/parsec-client-erlang): native Parsec client with both a high
   level API and a low level API. The low level API supports all Parsec API calls with protobuf
   specifications.

Also have a look at [`parsec-tool`](https://github.com/parallaxsecond/parsec-tool), a command-line
client to access Parsec from the terminal.

Please [contribute](parsec_client/writing_library.md) to add more Parsec Client Libraries in the
languages that you want!

## Building, running and installing Parsec

If you would like to compile and run the Parsec service on your system (if it does not exist),
follow these guides:

- [How to build and run Parsec](parsec_service/build_run.md)
- [How to securely install Parsec on Linux](parsec_service/install_parsec_linux.md)

*Copyright 2019 Contributors to the Parsec project.*
