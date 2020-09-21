# Recommendations on a Secure Parsec Deployment

The following recommendations should be applied in order for Parsec to respect some of the
operational mitigations. These recommendations have been thought of for a Linux system and should be
modified/ported for other operating systems. The linked [operational
mitigations](parsec_thread_model/threat_model.md#operational-mitigations) are noted with `O-n`.

- The service must be running as the `parsec` user (O-0).
- Key mappings must only be read/write by the `parsec` user (O-3).
- The logs must be redirected to a file only readable by the `parsec` user (O-5).
- The configuration file must only be read/write by the `parsec` user (O-6).
- For the Domain Socket Listener, the socket must be in a folder with specific permissions (O-9).
   The folder must be owned by the `parsec` user which must have read, write and execute rights on
   it.
   - In a deployment **without Identity Provider**, the folder must be group owned by the
      `parsec-clients` group which has only read and execute permission on it (O-10). Everyone else
      must have no permission on the folder. The `parsec-clients` group is composed of mutually
      trusted clients only.
   - In a deployment **with Identity Provider**, everyone else can have read and execute permission
      on the folder.
- Before accessing the service, clients must check the permissions of the folder containing the
   socket (O-2). The owner, group owner and permissions must be the same as the previous point,
   depending on an Identity Provider is available or not.

# Using systemd

Installing Parsec using systemd with the unit files provided and [following the
guide](../parsec_service/install_parsec_linux.md) will make sure that the recommendations above are
respected.

*Copyright 2020 Contributors to the Parsec project.*
