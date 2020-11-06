# Authenticators

The `auth_type` field in the configuration allows to change the authenticator currently used by
Parsec. Because keys are not namespaced with the authentication method, the authenticator **must
not** be changed while there are keys stored in Parsec. In a future version, Parsec might support
multiple concurrent authenticators, see [this
issue](https://github.com/parallaxsecond/parsec/issues/271) for details.

## Direct Authenticator

The direct authenticator directly parses the authentication field as a UTF-8 string and uses that as
application identity.

**Warning notice**: The Direct Authenticator is only secure under specific requirements. Please make
sure to read the [Recommendations on a Secure Parsec
Deployment](../parsec_security/secure_deployment.md). Please only use it for testing or if you are
really sure what you are doing.

## Unix Peer Credentials Authenticator

The Unix peer credentials authenticator uses Unix peer credentials to authenticate the clients as
different Unix users. Here 'Unix peer credentials' refers to metadata about the connection between
client and server that contains the effective Unix user identifier (UID) and Unix group identifier
(GID) of the connecting process.

To use this authenticator, the application must self-declare its UID (**not** username) in the
authentication field of the request as a zero-padded little-endian 32-bit unsigned integer. This
authenticator will then verify that the UID sourced from the peer credentials matches the one
self-declared in the request. If they match up, authentication is successful and the application
identity is set to the UID.

Note that a Unix domain socket transport is not limited to the Unix peer credentials authenticator;
this transport can be used with a different authenticator if required.

The GID and PID components of the Unix peer credentials are currently unused by the peer credentials
authenticator.

## JWT SPIFFE Verifiable Identity Document Authenticator

The JWT-SVID authenticator uses the JWT-SVID token to authenticate clients. The SPIFFE ID contained
and verified in the JWT-SVID is used as application identity for each client.

Please see the [JWT SPIFFE Verifiable Identity
Document](https://github.com/spiffe/spiffe/blob/master/standards/JWT-SVID.md) for more information
about the structure of the JWT-SVID token.

The token is passed in the authentication field using the JWS Compact Serialization.

The SPIFFE Workload API is used by clients to fetch their JWT-SVID token and by the service to
verify it. Its `aud` claim (audience) must be set to `parsec`. A low expiration time is recommended
through the `exp` claim.

*Copyright 2019 Contributors to the Parsec project.*
