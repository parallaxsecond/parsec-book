# Authenticators

## Direct Authenticator

The direct authenticator, [currently
named](https://github.com/parallaxsecond/parsec-interface-rs/issues/22) "simple authenticator" in
the code, directly parse the authentication field as a UTF-8 string and uses that as application
identity. The direct authenticator is the one currently used by the Parsec service.

*Copyright 2019 Contributors to the Parsec project.*
