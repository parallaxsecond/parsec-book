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

# How to test Parsec

Parsec relies on a mix of unit, integration and fuzz tests. Unit tests are usually found in the same module as the code they verify. Integration tests can be found in the `tests` directory (along with the code framework required for running them), and come in two flavours: single-provider and all-providers.

Single-provider tests do a thorough verification of each individual provider, while all-providers tests check that the common functionality is capable of supporting multiple providers at the same time. Another subcategory of integration tests are persistance tests which check that key material is persisted through service restarts.

The `tests/ci.sh` script executes all tests. [`rustfmt`](https://github.com/rust-lang/rustfmt)
and [`clippy`](https://github.com/rust-lang/rust-clippy) are needed for code formatting and static checks.

You can execute unit tests with `cargo test --lib`.

The [test client](https://github.com/parallaxsecond/parsec-client-test) is used for integration
testing. Check that repository for more details.

## Fuzz testing

Fuzz testing works, at the moment, on a service level, generating random requests and sending them to be processed. Running the fuzz tests can be done through the `fuzz.sh` script in the root of the repository. 

`./fuzz.sh run` builds a Docker image where the fuzz tests will run. It then sets up the environment and initiates the test in the container. The fuzzing engine ([libFuzzer](http://llvm.org/docs/LibFuzzer.html)) works by generating random inputs for a fuzzing target and then observing the code segments reached using said input.

To stop the fuzzer, simply run `./fuzz.sh stop`. To view the logs of a currently executing fuzzer, run `./fuzz.sh follow`.

Any crashes or slow tests, as well as tests that lead to a timeout, are stored in `./fuzz/artifacts/fuzz_service/`.
