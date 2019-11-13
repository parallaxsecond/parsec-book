<!--
  -- Copyright (c) 2019, Arm Limited, All Rights Reserved
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
To build and run the service, execute `cargo run`. `parsec` will then wait for clients.

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

