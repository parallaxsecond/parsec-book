# Listeners

## Domain Socket Listener

This listener communicates with its client using a [Unix domain
socket](https://en.wikipedia.org/wiki/Unix_domain_socket).

The socket default path is: `/run/parsec/parsec.sock`.

The `socket_path` option can be used to modify the socket path, for example for testing. By default,
clients will expect the socket to be at this path but clients libraries should also implement the
[service discovery](../parsec_client/api_overview.md#service-discovery) feature to dynamically
change it.

*Copyright 2020 Contributors to the Parsec project.*
