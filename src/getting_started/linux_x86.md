# Quickstart for Linux on x86

Run Parsec with the Mbed Crypto provider natively on your machine.

## Overview

In this guide you will learn how to quickly get started with Parsec in a toy environment. More
specifically you will:

- download and start the Parsec service
- perform some Parsec commands using `parsec-tool`
- see (and maybe run) Rust and Go clients code example

Note that this installation method is only made for educational purposes and is not secure. To
securely install Parsec on Linux for production, check [this guide
instead](../parsec_service/install_parsec_linux.md).

## Prerequisites

- a 64 bit Linux running on x86
- GLIBC version 2.27+ (check it with `ldd --version`)

## Downloading Parsec

Run the following command to download and unpack the `quickstart-1.0.0-linux_x86` folder. It
contains the Parsec service (`parsec`), its pre-built configuration (`config.toml`) and the Parsec
tool (`parsec-tool`).

```
curl -s -N -L https://github.com/parallaxsecond/parsec/releases/download/1.0.0/quickstart-1.0.0-linux_x86.tar.gz | tar xz
```

## Starting Parsec

From within the `quickstart-1.0.0-linux_x86` directory, start the Parsec service:

```
$ ./parsec &
[INFO  parsec] Parsec started. Configuring the service...
[INFO  parsec_service::key_info_managers::on_disk_manager] Found 0 mapping files
[INFO  parsec_service::utils::service_builder] Creating a Mbed Crypto Provider.
[INFO  parsec] Parsec is ready.
```

The Parsec service will now wait listening from clients connecting via `parsec.sock`.

## Using the Parsec Tool

As the Parsec socket file is at a non-default location, you will need to set the
`PARSEC_SERVICE_ENDPOINT` environment variable first.

```
export PARSEC_SERVICE_ENDPOINT=unix:$(pwd)/parsec.sock
```

Then, a ping should work using `parsec-tool`:

```
$ ./parsec-tool ping
[INFO ] Service wire protocol version
1.0
```

Generate an ECC key pair and sign with it:

```
$ ./parsec-tool create-ecc-key -k toto
[INFO ] Creating ECC key...
[INFO ] Key "toto" created.
$ ./parsec-tool sign -k toto "Hello Parsec!"
[INFO ] Hashing data with Sha256...
[INFO ] Signing data with Ecdsa { hash_alg: Specific(Sha256) }...
MEYCIQCrc9cys35NeXwNAr8lYu8WPu0RiutkoAIWn+jYfYofPwIhAKPlNNsW//ykW8nX11KABNpWWYsNGNoZXt0yiGyBEtnb
```

Execute the tool without any argument to check all the possible commands!

## Running the `parsec-cli-tests.sh` script
It's a script running simple end-two-end Parsec tests using parsec-tool and openssl

As it uses the `parsec-tool`, `PARSEC_SERVICE_ENDPOINT` environment variable need to be set first.
```
export PARSEC_SERVICE_ENDPOINT=unix:$(pwd)/parsec.sock
```

Also `PARSEC_TOOL` environment variable should point to the parsec tool.
```
export PARSEC_TOOL=unix:$(pwd)/parsec-tool
```
or the path of the `parsec-tool` is included in the `PATH` environment variable.

To run the script:
```
$ ./parsec-cli-tests.sh
Checking Parsec service...
[INFO ] Service wire protocol version
1.0

Testing Mbed Crypto provider

- Test random number generation
[DEBUG] Parsec BasicClient created with implicit provider "Mbed Crypto provider" and authentication data "UnixPeerCredentials"
[INFO ] Generating 10 random bytes...
[DEBUG] Running getuid
[INFO ] Random bytes:
A6 F5 90 24 DF FF 50 1F 29 2E
....
```

Note: If `openssl` is not installed globaly in the system.
`OPENSSL` environment variable need to be set first.

## Killing and reloading Parsec

Kill the Parsec service with:

```
$ pkill parsec
[INFO  parsec] SIGTERM signal received. Shutting down Parsec, waiting for all threads to finish...
[INFO  parsec] Parsec is now terminated.
```

If you make any change to its configuration, reload it with:

```
$ pkill -SIGHUP parsec
[INFO  parsec] SIGHUP signal received. Reloading the configuration...
[INFO  parsec_service::key_info_managers::on_disk_manager] Found 1 mapping files
[INFO  parsec_service::utils::service_builder] Creating a Mbed Crypto Provider.
[WARN  parsec_service::front::domain_socket] Removing the existing socket file at ./parsec.sock.
[INFO  parsec] Parsec configuration reloaded.
```

## Rust example

TODO

## Go example

TODO

*Copyright 2021 Contributors to the Parsec project.*
