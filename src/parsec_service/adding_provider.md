# Adding a new Parsec Provider

Creating new providers means enabling Parsec to work on new platforms and is one of the main goals
of the project. As such, the interface that must be implemented by each provider was built with
modularity in mind, allowing developers to choose which operations they implement and when. This
interface is represented by a Rust [`trait`](https://doc.rust-lang.org/book/ch10-02-traits.html) -
more precisely, the
[`Provide`](https://docs.rs/parsec-service/latest/parsec_service/providers/trait.Provide.html)
trait.

The full list of operations that can be implemented can be found in the link above and will be
expanded as the project progresses towards supporting more use cases.

## Mandatory methods

Some `Provide` trait methods are mandatory for the service to behave normally. They are used on a
service-level by the core provider and so must be supported by all providers.

- `describe`: Each provider must offer a description of itself in the shape of a
   [`ProviderInfo`](https://docs.rs/parsec-interface/latest/parsec_interface/operations/list_providers/struct.ProviderInfo.html)
   value, by implementing the `describe` method. The UUID identifying the provider is
   developer-generated and should not clash with existing providers. This process also requires the
   new provider to be added to the
   [`ProviderID`](https://docs.rs/parsec-interface/latest/parsec_interface/requests/enum.ProviderID.html)
   enum. The `describe` method is also used to return the supported opcodes by the provider.
- `list_keys`: the provider must implement this method to return all the keys stored within the
   provider for a particular application name.
- `list_clients`: the provider must implement this method to return the application names that have
   data stored within the provider.

`list_keys` and `list_clients` can often be implemented by directly using the
`KeyInfoManagerClient`.

## Data format

Lots of care must be taken when implementing operations that the inputs and outputs are in the
correct format, especially in the case of byte arrays. Detailed description of all input and output
can be found in the [operations documentation](../parsec_client/operations).

## Key management

A helpful utility that the Parsec service offers to providers is the use of key info managers. These
allow the provider to persist mappings between key names and key information material and is
generally needed since providers are expected to support UTF-8 encoded strings as key names. To use
the KeyInfoManager in a thread-safe and convenient way, the KeyInfoManagerClient structure can be
used. The key ID type used will have to implement `serde` `Serialize` and `DeserializedOwned`
traits.

### Dealing with key triple mappings coherency

During the lifetime of the Parsec service, it might happen that the mappings do not correctly
reflect the state of the actual key store: a key stored in the KeyInfoManager does not map to any
key in the keystore backend. Providers should implement the following policies to prevent that.

- During the provider construction, fetch all key infos linked to that provider. For each one of
   them, get the associated ID and issue one command to the backend to check if a key with that ID
   exists. If it does not, add the key to a `to_delete` list and then delete all the mappings in the
   `to_delete` list. Check the existing providers' constructors for an example.
- Follow the algorithm described in the documentation of `psa_generate_key`, `psa_import_key` and
   `psa_destroy_key` when implementing those `Provide` methods.

The goal of those policies is to make sure, in a best-effort way, that key management operations
have the behaviour wanted: it is possible to create a key with the same name if the key
creation/deletion operation failed and that at any given time only valid keys can be used.

Because of those policies focused on clients' convenience, it might be possible that some keys
become "zombies" in the keystore: they can no longer be accessed via Parsec but still exist.

Please also note that those policies do not protect against hardware attacks. In our threat model is
documented as an assumption (ASUM-1):

> The hardware modules are physically and functionally secure. Only trusted agents can physically
> access the system.

*Copyright 2019 Contributors to the Parsec project.*
