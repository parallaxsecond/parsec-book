# Authenticators

## Direct Authenticator

The direct authenticator directly parses the authentication field as a UTF-8 string and uses that as
application identity.

## Unix Peer Credentials Authenticator

The Unix peer credentials authenticator uses Unix peer credentials to authenticate the client. Here
'Unix peer credentials' refers to metadata about the connection between client and server that
contains the effective Unix user identifier (UID) and Unix group identifier (GID) of the connecting
process.

To use this authenticator, the application must self-declare its UID (**not** username) in the
authentication field of the request as a zero-padded little-endian 32-bit unsigned integer. This
authenticator will then verify that the UID sourced from the peer credentials matches the one
self-declared in the request. If they match up, authentication is successful and the application
identity is set to the UID.

Note that a Unix domain socket transport is not limited to the Unix peer credentials authenticator;
this transport can be used with a different authenticator if required.

The GID and PID components of the Unix peer credentials are currently unused by the peer credentials
authenticator.

*Copyright 2019 Contributors to the Parsec project.*
