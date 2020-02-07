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

# Adding a new Parsec Provider

Creating new providers means enabling Parsec to work on new platforms and is one of the main goals of the project. As such, the interface that must be implemented by each provider was built with modularity in mind, allowing developers to choose which operations they implement and when. This interface is represented by a Rust [`trait`](https://doc.rust-lang.org/book/ch10-02-traits.html) - more precisely, the [`Provide`](https://github.com/parallaxsecond/parsec/blob/master/src/providers/mod.rs) trait.

The full list of operations that can be implemented can be found in the link above and will be expanded as the project progresses towards supporting more use cases.

Apart from `list_opcodes` and `describe`, no method is mandatory and client libraries are expected to use these two operations to bootstrap their usage of the service. Thus, once an operation is correctly supported, its opcode can be added to those returned by `list_opcodes`. Any operation that is not implemented will return a response code of `UnsupportedOperation` by default.

Each provider must offer a description of itself in the shape of a [`ProviderInfo`](https://github.com/parallaxsecond/parsec-interface-rs/blob/master/src/operations/list_providers.rs) value, by implementing the `describe` method. The UUID identifying the provider is developer-generated and should not clash with existing providers. This process also requires the new provider to be added to the [`ProviderID`](https://github.com/parallaxsecond/parsec-interface-rs/blob/master/src/requests/mod.rs) enum.

Lots of care must be taken when implementing operations that the inputs and outputs are in the correct format, especially in the case of byte arrays. Detailed description of all input and output can be found in the [operations documentation](../parsec/operations/README.md).
