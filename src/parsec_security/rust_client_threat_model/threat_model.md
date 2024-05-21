# Parsec Rust Client Threat Model

This document presents the Threat Model for the Parsec Rust client crate. The interactions between
the Parsec client library and any external software components is assessed. Currently the presence
of an Identity Provider is not considered as part of the scheme due to uncertainty as to how the
dataflow would look in such a case and what security issues might arise. The threat model indirectly
covers a secondary use pattern, namely via a Secure Element Driver (SE Driver) that bridges between
Mbed Crypto and the Parsec client, allowing usage of the Rust stack from a C-language environment.

## Dataflow Diagram

![Dataflow Diagram](diagrams/rust_client_diagram.png)

## Assumptions

Basic requirements based on which the client can be used securely. Mitigations can be implemented to
make the system more resilient, but if some of these assumptions are not met, the security implied
by Parsec cannot be guaranteed.

1. The platform on which the client application is running is trusted by the client to host the
   Parsec service
2. With the lack of an identity provider, all applications running in parallel on the platform that
   could access the Parsec service are trusted to not interfere with or impersonate the client
   application.
3. The client application obtains or generates a persistent name that it uses consistently for
   accessing its service-side assets.
4. Invoking third party libraries using unsafe calls relies on their respective threat models and
   assurances, and is outside of the scope of the parsec client.

## Assets

What we want to protect. Each one of these has a combination of Security Property: Confidentiality,
Integrity and Availability. The assets are labelled so that it can be seen in the threat tables
below which ones are impacted by each threat.

### Application Identity - AS1

Ideally, the Client Library gets its Application Identity from the Identity Provider. However,
without an Identity Provider in the system applications are expected to handle their identities on
their own. The identity will be used by the service to partition the assets it stores for clients
into a namespace for each one.

**Confidentiality** : if known (the authentication token), an attacker could impersonate a specific
application and execute operations in their name.

### Client’s data- AS2

Data sent through the client as part of a request to the service.

**Confidentiality** : some of the client’s data could be confidential (example: a buffer to
encrypt).

**Integrity** : the data should not be modifiable by attackers. The client should be certain that it
is interacting with the legitimate Parsec service.

### Configuration data- AS3

Configuration data passed by the client application to the library. There is some overlap between
the configuration data and the application identity, as the identity is stored within the client
library and could thus be considered part of its configuration data.

**Confidentiality** : if known (the authentication token), an attacker could impersonate a specific
application and execute operations in their name.

**Integrity** : the data should only be modified by the client application as doing otherwise might
prevent the client application from accessing Parsec functionality.

### Client’s cryptographic keys - AS4

Keys provisioned by the client within the service.

**Confidentiality** : (private) key material is sensitive data and should not be exposed.

**Integrity** : neither public nor private key data should be modifiable by attackers.

**Availability** : the client must always be able to use their cryptographic material.

### System and client application stability - AS5

The application which is using the Parsec client library and the sytem as a whole must be kept
stable and responsive.

**Availability** : the client application must not be crashed by the library in any way.

## Attackers

Each dataflow is analysed from an attacker’s perspective using STRIDE method. Nothing is supposed
on the different components.

In the following tables are present the type of each possible threat, its description, its
mitigation status and the assets impacted. A threat can be unmitigated (U), mitigated (M) or
operational (O). The assumptions context applies for all threats but when one of them is
particularly relevant, it will be noted with ASUM.

### Attacker “Request to Service” - A1

This attacker uses the inter-process endpoint, presumably created by the service, to interfere with
the communication between client and service.

|   | Description                                                                                                                                       | Mitigation    | Assets        |
|---|---------------------------------------------------------------------------------------------------------------------------------------------------|---------------|---------------|
| S | An attacker impersonates the service by establishing an IPC endpoint that spoofs the one used by Parsec to exfiltrate any data found in requests. | O-0, O-1      | AS1, AS2, AS4 |
| S | An attacker impersonates the service and responds to requests using bogus or malicious data.                                                      | O-0, O-1      | AS2           |
| T | The attacker modifies the data sent or received by the client while it is in transit through the IPC.                                             | M-0           | AS2, AS4      |
| R | The service denies having sent responses to or received some requests from the client.                                                            | U-1, O-3      |               |
| I | An attacker obtains requests sent by the client by sniffing the IPC traffic or spoofing the endpoint.                                             | M-0, O-1      | AS2, AS4      |
| D | An attacker could remove the IPC endpoint or block traffic through it.                                                                            | O-1           | AS4           |
| D | An attacker could swamp the service with requests so that the client's requests take a long time to service.                                      | O-2           | AS2           |
| D | An attacker could tamper with incoming responses to exploit vulnerabilities in the client library and crash the client.                           | M-0, M-1, U-0 | AS5           |
| E | An attacker could tamper with incoming responses to exploit vulnerabilities in the client library and run code in the same user as the client.    | M-0, M-1, U-0 | AS5           |

### Attacker “Library Memory” - A2

This attacker gains access to memory released by the client library, containing potentially
sensitive information.

|   | Description                                                 | Mitigation | Assets   |
|---|-------------------------------------------------------------|------------|----------|
| I | An attacker reads requests and responses from memory.       | U-2        | AS2, AS4 |
| I | An attacker reads out the application identity from memory. | U-2        | AS1      |

## Unmitigations

| ID | Justification                                                                                                                                                | Consequences                                                                                                                                     |
|----|--------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| 0  | Client library dependencies are not checked for Security Vulnerabilities.                                                                                    | A vulnerability in one of the Parsec client dependencies will also impact the client application and the data it shares with the Parsec library. |
| 1  | Provider libraries using unsafe calls are not checked by Parsec                                                                                              | Provider libraries using unsafe calls rely on their respective threat models and assurances, and is outside of the scope of the parsec service.  |
| 2  | Authenticity of responses is not ensured through a MAC or asymmetric signature – it relies on trust in the platform administrator.                           | Any response from the service could have been spoofed or altered by any entity with sufficient capabilities.                                     |
| 3  | Parsec does not currently clear sensitive data in memory after use. [This is looked at here](https://github.com/parallaxsecond/parsec-client-rust/issues/9). | Any data that passes through the client library could be read after the memory is released.                                                      |

## Mitigations

| ID | Justification                                                                                                                                                                            | Details                                                                                                                                                                    |
|----|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 0  | Parsec interface uses an IPC mechanism respecting confidentiality and integrity of messages transmitted between the clients and the service (once the initial connection has been made). | Unix Domain Socket: the sockets used on the client and service side for the communication are represented by file descriptors that are only accessible by those processes. |
| 1  | The Parsec client is coded with safety in mind and is tested extensively.                                                                                                                | [Open](https://github.com/parallaxsecond/parsec-client-rust/issues/49)                                                                                                     |

## Operational mitigations

| ID | Justification                                                                                                                                 |
|----|-----------------------------------------------------------------------------------------------------------------------------------------------|
| 0  | Clients need to know from a trusted source that a trusted Parsec service is running on their machine so that they can trust the IPC endpoint. |
| 1  | The IPC endpoint should be secured so that only privileged users can remove or alter it.                                                      |
| 2  | A set of mutually trusted clients has restricted read-write access to the service IPC endpoint.                                               |
| 3  | The Parsec service is configured to display detailed logs about all requests made by clients.                                                 |

*Copyright 2020 Contributors to the Parsec project.*
