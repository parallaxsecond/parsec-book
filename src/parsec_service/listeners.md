# Listeners

## Domain Socket Listener

This listener communicates with its client using a [Unix domain
socket](https://en.wikipedia.org/wiki/Unix_domain_socket).

The socket path is: `/run/parsec/parsec.sock`.

The `socket_path` option can be used to modify the socket path, for example for testing. Clients
will expect the socket to be at the default path and hence this option should not be modified for
deployment.

*Copyright 2020 Contributors to the Parsec project.*
