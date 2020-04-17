# Adding a new Parsec Provider

Creating new providers means enabling Parsec to work on new platforms and is one of the main goals
of the project. As such, the interface that must be implemented by each provider was built with
modularity in mind, allowing developers to choose which operations they implement and when. This
interface is represented by a Rust [`trait`](https://doc.rust-lang.org/book/ch10-02-traits.html) -
more precisely, the
[`Provide`](https://github.com/parallaxsecond/parsec/blob/master/src/providers/mod.rs) trait.

The full list of operations that can be implemented can be found in the link above and will be
expanded as the project progresses towards supporting more use cases.

Apart from `list_opcodes` and `describe`, no method is mandatory and client libraries are expected
to use these two operations to bootstrap their usage of the service. Thus, once an operation is
correctly supported, its opcode can be added to those returned by `list_opcodes`. Any operation that
is not implemented will return a response code of `UnsupportedOperation` by default.

Each provider must offer a description of itself in the shape of a
[`ProviderInfo`](https://github.com/parallaxsecond/parsec-interface-rs/blob/master/src/operations/list_providers.rs)
value, by implementing the `describe` method. The UUID identifying the provider is
developer-generated and should not clash with existing providers. This process also requires the new
provider to be added to the
[`ProviderID`](https://github.com/parallaxsecond/parsec-interface-rs/blob/master/src/requests/mod.rs)
enum.

Lots of care must be taken when implementing operations that the inputs and outputs are in the
correct format, especially in the case of byte arrays. Detailed description of all input and output
can be found in the [operations documentation](../parsec_client/operations/README.md).

A helpful utility that the Parsec service offers to providers is the use of key ID managers. These
allow the provider to persist mappings between key names and key handles or material and is
generally needed since providers are expected to support UTF-8 encoded strings as key names.

*Copyright 2019 Contributors to the Parsec project.*
