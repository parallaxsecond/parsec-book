# Parsec for users

## How to use Parsec

On a system where Parsec is installed, it can easily be used with a Parsec Client Library. Those
libraries communicate with the Parsec service and integrate with the rest of the software
idiomatically.

Parsec Client Libraries are available in the following languages:

- [Rust](https://docs.rs/parsec-client/*/parsec_client/). See examples on how to use the
   [`BasicClient`](https://docs.rs/parsec-client/*/parsec_client/core/basic_client/struct.BasicClient.html).
- [C](https://github.com/parallaxsecond/parsec-se-driver): support is currently being built to use
   Parsec through the PSA Crypto API
- [Go](https://github.com/parallaxsecond/parsec-client-go) (not currently working but contributions
   are welcome!)

Please [contribute](parsec_client/writing_library.md) to add more Parsec Client Libraries in the
languages that you want!

## Building, running and installing Parsec

If you would like to compile and run the Parsec service on your system (if it does not exist),
follow these guides:

- [How to build and run Parsec](parsec_service/build_run.md)
- [How to securely install Parsec on Linux](parsec_service/install_parsec_linux.md)

*Copyright 2019 Contributors to the Parsec project.*
