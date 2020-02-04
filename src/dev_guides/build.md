<!--
  -- Copyright (c) 2020, Arm Limited, All Rights Reserved
  -- SPDX-License-Identifier: Apache-2.0
  --
  -- Licensed under the Apache License, Version 2.0 (the "License"); you may
  -- not use this file except in compliance with the License.
  -- You may obtain a copy of the License at
  --
  -- http://www.apache.org/licenses/LICENSE-2.0
  --
  -- Unless required by applicable law or agreed to in writing, software
  -- distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
  -- WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  -- See the License for the specific language governing permissions and
  -- limitations under the License.
--->

# How to build Parsec

This project is coded in the Rust Programming Language. To build it, you first need to [install Rust](https://www.rust-lang.org/tools/install).

Because the providers supported by Parsec are dependent on libraries and/or hardware features present on the platform, the build is fragmented through Rust features so that the resulting binary only contains the desired providers. Currently the service provides the following features: `mbed-crypto-provider`, `pkcs11-provider`, and `tpm-provider`.

In order for the service to be spun up, a number of parameters are required in a TOML file. The repository contains an [example](https://github.com/parallaxsecond/parsec/blob/master/config.toml) of such a configuration file which shows all the options and their default values.

To build and run the service, set `DESIRED_FEATURES` to be a subset of the features mentioned above, space or comma separated, and execute:
```bash
cargo run --features $DESIRED_FEATURES
```

`parsec` will then construct the service based on the configuration file and wait for clients. If the configuration file is not in the directory from which Parsec is run, its path must be passed via CLI:
```bash
cargo run --features $DESIRED_FEATURES -- --config $PATH_TO_CONFIG
```

To cross-compile the service for the Linux on Arm64 target, you will need to install the
appropriate toolchain for this target. By default the Arm GNU toolchain is used to
compile Mbed Crypto and link everything together. The `aarch64-linux-gnu-*` tools will be
needed. Change `build-conf.toml` and `.cargo/config` files to change the cross-compiling
toolchain used.
Just execute the following command to cross-compile for the Linux on Arm64 target:
```bash
cargo build --target aarch64-unknown-linux-gnu
```

Alternatively, you can install and use [`cross`](https://github.com/rust-embedded/cross)
to do the same without having to install the toolchain!
```bash
cargo install cross
docker build -t parsec-cross tests/
cross build --target aarch64-unknown-linux-gnu
```

