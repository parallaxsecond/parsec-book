# Key Info Managers

The key info stored by the key info managers consist in a structure composed of:

- an `id`, which is the reference to a key in the specific provider
- `attributes`, which are the attributes of the key

# On-Disk Key Info Manager

The on-disk key info manager stores the mapping between key triple and key information directly on
disk, in a folder with a configurable path.

The application and key name length are limited by the operating system Parsec is running on.

*Copyright 2020 Contributors to the Parsec project.*
