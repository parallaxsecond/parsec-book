# Key Info Managers

The key info stored by the Key Info Managers (KIM) consist in a structure composed of:

- an `id`, which is the reference to a key in the specific provider
- `attributes`, which are the attributes of the key

Providers can directly use a `KeyInfoManagerClient` instance to simplify handling of the KIM with
their own provider ID and their own key ID type.

# SQLite Key Info Manager

The SQLite KIM stores mappings between key identities and their provider-specific metadata in an
SQLite database stored on disk at a given path.

This KIM is intended as a more flexible, safe, and stable alternative to the on-disk manager and is
the recommended choice for any new deployments.

# On-Disk Key Info Manager

**Warning:** The on-disk KIM will be deprecated in future versions of the Parsec service in favour
of the SQLite manager described above.

The on-disk KIM stores the mapping between key identity and key information directly on disk, in a
folder with a configurable path.

The application and key name length are limited by the operating system Parsec is running on.

*Copyright 2020 Contributors to the Parsec project.*
