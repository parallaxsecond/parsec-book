# Listeners

## Domain Socket Listener

This listener communicates with its client using a [Unix domain
socket](https://en.wikipedia.org/wiki/Unix_domain_socket).

When running the service executable directly, the socket path is fixed to
`/tmp/security-daemon-socket`. When launched as a daemon by systemd, the socket is at
`/home/parsec/parsec.sock`. Clients communicating with a Parsec service configured with that
listener must connect to that socket path.

*Copyright (c) 2020, Arm Limited. All rights reserved.*
