# Parsec Threat Model

This document presents the generic Parsec Threat Model in a multi-tenant environment with an
Identity Provider, as envisaged in the [System
Architecture](../../archive/system_architecture.md#participating-components-and-their-roles) page.

Parsec could also be deployed in different configurations with other types of authentication in
place and thus with other requirements for the host environment. The other configurations that have
been considered by the Parsec team are listed below.

- (GNRC) Generic deployment model with Identity Provider
- (DSPC) Unix Domain Socket Peer Credential authentication model - the operating system acts as a
   substitute identity provider
- (DRCT) Direct authentication with mutually trusted clients - no identity provider
- (JWTS) JWT SPIFFE Verifiable Identity Document authentication - the SPIFFE implementation acts as
   an identity provider for clients but it is also used by the service to verify the identities (the
   JWT-SVID tokens)

Items in the following sections may be marked as "applicable to a subset of configurations". Such
markings will **always** be written in *italic* and can take two forms:

- Short form - e.g. *(GNRC, DSPC)* , meaning the item at hand is only applicable to the (GNRC) and
   (DSPC) deployment models. Can also be reductive - *(not GNRC)*, meaning the item does not apply
   to the (GNRC) deployment model.
- Long form - e.g. *Not applicable for deployment (GNRC)*

## Dataflow Diagram

![Dataflow Diagram](diagrams/dataflow_diagram.png)

## Assumptions

Basic requirements based on which the service can operate securely. Mitigations can be implemented
to make the system more resilient, but if some of these assumptions are not met, the security stance
of the service cannot be guaranteed.

1. The hardware modules are physically and functionally secure. Only trusted agents can physically
   access the system.
2. The service is configured and started by a trusted administrator.
3. The OS can be trusted to enforce access-control over critical resources (configuration file, key
   info mappings, communication socket, etc.) and inter-process communication mechanisms. System
   calls are also trusted to execute correctly.
4. Users with privilege rights are trusted to exercise them in a non-malicious way.
5. *(GNRC, JWTS)* The authentication tokens are stored with confidentiality by the clients.
6. *(GNRC)* There is a trusted Identity Provider available.

## Assets

What we want to protect. Each one of these has a combination of security properties:
Confidentiality, Integrity and Availability. The assets are labelled so that it can be seen in the
threat tables below which ones are impacted by each threat.

### Authentication Token - AS1

The Client Library gets its Authentication Token from the Identity Provider. It is signed by the
IP's private key and sent by the Client Library on each request. Parsec verifies the Authentication
Token using the IP's public key.

**Confidentiality** : if known (the authentication token), an attacker could impersonate a specific
application and execute operations in their name. The admin application authentication token is
especially sensitive as if it is stolen by an attacker, they can then have access to operations
impacting all clients such as `DeleteClient`.

*(JWTS)*: the JWT-SVID tokens share the same Confidentiality property although the verification
happens remotely in the SPIFFE implementation.

*Not applicable for deployment (DSPC). The OS is trusted to enforce separation between users and to
provide correct peer credential information that the service will then rely upon for access
control.*

*Not applicable for deployment (DRCT). Clients are assumed to be mutually trusted and given that we
trust the OS to enforce access control on the service endpoint, there's no concern around the
confidentiality of client identity tokens.*

### Identity Provider Public Key- AS2

The IP's public certificate is sent to the service periodically. It is used by the service to verify
the authentication tokens.

**Integrity** : if sent by a malicious IP, attackers could then sign their own application
identities and Parsec will verify them successfully. If they know the Authentication Token of
clients, they can impersonate them.

**Availability** : Parsec needs it in order to execute a request.

*Not applicable for deployments (DSPC, DRCT, JWTS).*

### Private Keys- AS3

Private keys created by Parsec on behalf of its clients. They should be stored on hardware and never
be extractable.

**Confidentiality, Integrity and Availability** : by nature.

### Client's data- AS4

Data sent by the client as part of a request or data about a client processed by the service. This
could appear in logs.

**Confidentiality** : some of the client's data could be confidential (example: a buffer to
encrypt).

**Integrity** : the data should not be modifiable by attackers. Parsec should be sure that the
source is trusted, and that the client is not being impersonated.

**Availability** : the client should be able to access its stored data in a certain amount of time.

### Configuration data- AS5

Data stored in the configuration file, read at each reloading of Parsec to instantiate components.

**Confidentiality** : the data contains secrets like the user pin of the PKCS 11 device or the owner
hierarchy password of the TPM device.

**Integrity** : the data should only be modified by a trusted Parsec administrator.

**Availability** : the data should be available when loading or re-loading Parsec.

### Availability of the service- AS6

General asset to describe the fact that each client's request should be done in a sane amount of
time. The service should be available at any given point from the moment it is started by the
administrator.

### Key Identity Mappings- AS7

Data containing the mapping between a Key Identity (application identity, provider identity, key
name) and the key attributes with a provider-specific identifier of the key. For the Mbed Crypto and
PKCS11 providers this is an ID number, for the TPM provider this is the wrapped key.

**Integrity** : Parsec expects this data to be valid.

**Availability** : the data should be available when Parsec needs the specific key.

### Logs- AS8

Data stored in logs emitted by any component of the stack.

**Confidentiality** : the logs can contain confidential information of different parts of the
service.

**Integrity** : the integrity of the logs is essential to prove that some events took place in
Parsec.

**Availability** : the logs should be available for reading and writing when needed.

## Attackers

Each dataflow is analysed from an attacker's perspective using STRIDE method. Nothing is supposed on
the different components.

In the following tables are present the type of each possible threat, its description, its
mitigation status and the assets impacted. A threat can be unmitigated (U), mitigated within the
service (M) or mitigated through operational requirements (O). The assumptions context applies for
all threats but when one of them is particularly relevant, it will be noted with ASUM.

### Attacker "Client Request" - A1

This attacker uses the existing Listener endpoint, created by the service, to communicate with it.

*Not applicable for deployment (DRCT).*

|   | Description                                                                                                                                                                                   | Mitigation                       | Assets   |
|---|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------|----------|
| S | *(GNRC, JWTS)* An attacker uses another client's authentication token. He can then have access (reference) to any of the impersonated client's keys and execute any operation in their name.  | U-2, O-15                        | AS3      |
| S | *(GNRC, JWTS)* An attacker uses brute-force on the AUTH field of the request until he does not have an AuthenticationError response status to then deduce a valid authentication token.       | M-2                              | AS1      |
| S | *(DSPC)* An attacker uses another client's Unix account. He can then have access (reference) to any of the impersonated client's keys and execute any operation in their name.                | U-5                              | AS3      |
| S | *(DSPC)* An attacker uses a Unix account with the same UID as a client. He can then have access (reference) to any of the impersonated client's keys and execute any operation in their name. | O-11, ASUM-3                     | AS3      |
| S | An attacker uses a weakness or a bug of the current authenticator to access all keys created with past and present authentication methods.                                                    | O-12, U-6                        | AS3      |
| T | An attacker modifies the valid request of another client to modify the operation and make it non-secure.                                                                                      | M-3                              | AS4      |
| R | A client denies the authorship of a request.                                                                                                                                                  | U-7                              |          |
| I | An attacker can read the confidential information of a request from another client.                                                                                                           | M-3                              | AS1, AS4 |
| I | *(GNRC, JWTS)* An attacker steals the authentication token from a client's request to then execute any operation in their name.                                                               | M-3                              | AS4, AS3 |
| D | An attacker modifies the valid request of another client to modify the operation and make it fail.                                                                                            | M-3                              | AS6      |
| D | An attacker overloads/crashes the system and thus prevents any other user from making use of the service.                                                                                     | Crashes: M-0, M-5 Overloads: U-0 | AS6      |
| E | A malicious request, formatted in a specific way, triggers remote code execution in Parsec privilege level.                                                                                   | U-3, M-10, M-5                   | All      |
| E | A malicious request exploits a vulnerability in the software stack and leads to an attacker having Parsec privilege level on key management in the underlying hardware.                       | U-3, M-10, M-5                   | AS3, AS6 |

### Attacker "Service Response" - A2

This attacker uses the existing Listener endpoint, created by the service, to communicate with the
client. It can also create a spoofed endpoint, mimicking the service's one.

For protection of the clients' assets, please check the Parsec Clients Threat Models.

*Not applicable for deployment (DRCT).*

|   | Description                                                                                                                                          | Mitigation    | Assets                |
|---|------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|-----------------------|
| S | An attacker impersonates the Parsec service: clients share their data with a malicious entity.                                                       | O-2, O-9      | AS3, AS4, AS6         |
| T | An attacker modifies the response of another client to change its body or its header and thus alter the type, content or status of the response.     | M-3           | AS4                   |
| R | A client denies that the response was indeed sent by the Parsec service.                                                                             | O-2, U-7, O-9 |                       |
| I | An attacker can read the content of a response.                                                                                                      | M-3           | AS4                   |
| I | The response code of a request gives too much information about the way the data is processed by the service that an attacker can use for an attack. | M-1           | Depends on the attack |
| D | An attacker modifies the valid response of another client to pretend it failed or succeeded.                                                         | M-3           | AS6                   |
| D | An attacker modifies the response in such a way that it leads the client to crash.                                                                   | M-3           |                       |
| E | An attacker modifies the response in such a way that it leads to code execution in the client sandbox at the same level as the client.               | M-3           |                       |

### Attacker "OS Signal" - A3

This attacker has the capability of sending signals to the Parsec process. For example, on a Linux
machine a `SIGINT` signal.

|   | Description                                                                                                      | Mitigation | Assets |
|---|------------------------------------------------------------------------------------------------------------------|------------|--------|
| S | N/A                                                                                                              |            |        |
| T | A `SIGHUP` is modified by an attacker into `SIGTERM` or the other way around.                                    | ASUM-3     | AS6    |
| R | N/A                                                                                                              |            |        |
| I | N/A                                                                                                              |            |        |
| D | An attacker can kill the Parsec service, gracefully or not or trigger an infinite loop of configuration reloads. | O-0        | AS6    |
| E | N/A                                                                                                              |            |        |

### Attacker "Service Operation" - A4

This attacker communicates with the security hardware on the platform using the operating system
interfaces.

|   | Description                                                                                                         | Mitigation          | Assets        |
|---|---------------------------------------------------------------------------------------------------------------------|---------------------|---------------|
| S | An attacker directly drives the platform hardware to execute commands on it.                                        | O-8                 | AS3, AS6      |
| T | An attacker modifies the commands sent to hardware modules.                                                         | O-8, U-3, M-10      | AS3, AS6      |
| R | Commands cannot be proven to have originated in the service.                                                        | U-7                 |               |
| I | An attacker can read the content of commands to the hardware.                                                       | O-8, U-3, M-10      | AS3, AS4, AS5 |
| D | An attacker modifies the commands sent to the hardware to make them fail.                                           | O-8, U-3, M-10      | AS6           |
| D | Attacker causes the underlying hardware to fail or be generally unusable.                                           | O-8, U-3, M-10      | AS6           |
| D | Attacker disrupts the software stack that drives the hardware (e.g. replaces or removes PKCS 11 dynamic libraries). | O-8, U-3, M-10      | AS6           |
| E | An attacker uses the configured state of a hardware module to make operations with a higher privilege on it.        | O-8, U-3, M-10, U-4 | AS3, AS6      |

### Attacker "Hardware Result" - A5

This attacker communicates with the service using the operating system interfaces for hardware. It
can also create a spoofed hardware interface.

|   | Description                                                                                                          | Mitigation          | Assets        |
|---|----------------------------------------------------------------------------------------------------------------------|---------------------|---------------|
| S | An attacker impersonates a hardware module or uses a malicious module plugged to the machine.                        | O-1, ASUM-1         | AS4, AS6, AS7 |
| T | An attacker modifies the response of a hardware command.                                                             | O-8, U-3, M-10      | AS4, AS6      |
| R | Responses cannot be proven to originate from the hardware module.                                                    | U-7                 |               |
| I | An attacker can read the content of a command response.                                                              | U-3, M-10, O-8      | AS3, AS4, AS5 |
| D | An attacker modifies the valid command response to pretend it failed or succeeded.                                   | U-3, M-10, O-8      | AS6           |
| E | A malicious command response, formatted in a specific way, triggers remote code execution in Parsec privilege level. | U-3, M-10, M-5, O-8 | All           |

### Attacker "Key Mapping Storage" - A6

Attacker with access to the key info mapping stream generated by Key Info Managers when storing its
data and to the persistent storage mechanism used for this purpose.

|   | Description                                                                                                                                      | Mitigation | Assets   |
|---|--------------------------------------------------------------------------------------------------------------------------------------------------|------------|----------|
| S | An attacker stores spoofed key handles/material, e.g. allowing themselves to access keys they should not have access to.                         | O-3        | AS3, AS6 |
| T | An attacker modifies the data stored for a mapping to either divert another user to use a different key, or to allow himself access to some key. | O-3        | AS3, AS6 |
| R | The mappings cannot be proven to have been generated by the service.                                                                             | U-7        |          |
| I | Key handles could be leaked and thus used to access keys through other means.                                                                    | O-3        | AS3,AS4  |
| D | An attacker could prevent the storage to be completed, e.g. by filling up the disk and running into space-related issues.                        | O-4        | AS6      |
| E | N/A                                                                                                                                              |            |          |

### Attacker "Key Mapping Retrieval" - A7

Attacker with access to the data stream returning to the Key Info Manager from its source of
persistent storage.

|   | Description                                                                                                                                         | Mitigation          | Assets        |
|---|-----------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|---------------|
| S | Attacker spoofs the existence of a mapping and makes the service use an incorrect or invalid key (handle).                                          | M-6, O-3            | AS3, AS4, AS6 |
| T | An attacker alters the retrieval of stored material to change the key that is used for an operation initiated by either himself or some other user. | M-6                 | AS3, AS6      |
| R | There is no way to guarantee that the mapping being retrieved was previously stored by the service.                                                 | U-7                 |               |
| I | An attacker can read the mapping in transit.                                                                                                        | M-6                 | AS3           |
| D | An attacker prevents the value from being read.                                                                                                     | M-6                 | AS6           |
| D | An attacker removes all stored values, preventing users from utilizing their keys.                                                                  | O-3                 | AS6           |
| D | A malicious key handle, formatted in a specific way, leads to a service crash.                                                                      | O-3, M-5, U-3, M-10 | AS6           |
| E | A malicious key handle, formatted in a specific way, triggers remote code execution in Parsec privilege level.                                      | O-3, M-5, U-3, M-10 | All           |

### Attacker "Logging" - A8

Attacker with access to the log stream generated by the Parsec service and to the log file.

|   | Description                                                                                                                                  | Mitigation | Assets        |
|---|----------------------------------------------------------------------------------------------------------------------------------------------|------------|---------------|
| S | An attacker could write to the log file, pretending to be the Parsec service and dilute the true logs, potentially hiding errors or crashes. | O-5        | AS6           |
| S | An attacker uses the same logging façade mechanism to write on the logs from a malicious Parsec dependency.                                  | M-7        | AS6           |
| T | Attacker can modify logs to hide/modify details about crashes, errors or any other suspicious activity.                                      | O-5        | AS6           |
| T | An attacker can delete the log file, removing all evidence of previous activity.                                                             | O-5        | AS6           |
| R | There is no guarantee about the true origin of log messages.                                                                                 | O-5        |               |
| I | Log messages can be read by an adversary and their contents can disclose information about the activity of other users.                      | O-5        | AS1, AS4, AS5 |
| D | An attacker prevents access to the logging system by the service putting it in a stall state or triggering errors/crashes.                   | O-5, O-4   | AS6           |
| E | N/A                                                                                                                                          |            |               |

### Attacker "Configuration" - A9

Attacker with access to the configuration file for the Parsec service or to the OS-provided
mechanism for reading it.

|   | Description                                                                                                                                   | Mitigation          | Assets        |
|---|-----------------------------------------------------------------------------------------------------------------------------------------------|---------------------|---------------|
| S | An adversary can spoof a configuration file, leading to the service operating in an unsecure state, ineffective state or not starting at all. | O-6                 | AS3, AS5, AS6 |
| T | The configuration file set up by the administrator might be modified, leading to the service being unsecure, ineffective or broken.           | O-6                 | AS3, AS5, AS6 |
| R | There are no guarantees that the person setting up the configuration file was authorised to do so.                                            | O-6                 |               |
| I | The configuration file might, if read by an adversary, provide information that opens different attack avenues.                               | O-6                 | AS5           |
| I | If the configuration file is tampered, information about the existing keys can be extracted through rogue providers.                          | O-6                 | AS5           |
| D | Removing or altering the configuration file can lead to the Parsec service not starting or working in a broken state.                         | O-6                 | AS6           |
| E | Parsing a malicious configuration file can lead to code execution at the Parsec privilege level.                                              | M-5, U-3, M-10, O-6 | All           |

### Attacker "Identity Provider" - A10

Attacker with access to the communication running from the Identity Provider to the Parsec service.

*Not applicable for deployment (DRCT). For deployment (DSPC) the operating system is considered
sufficiently secure, as described in assumption 3.*

|   | Description                                                                                                                                                                        | Mitigation     | Assets           |
|---|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|------------------|
| S | The initial trust bundle can be spoofed, and an attacker can thus gain complete control over the service.                                                                          | O-7            | AS2 and then all |
| T | The trust bundle shared by the identity provider can be modified in transit to disrupt the operation of the service or take control of it.                                         | M-3            | AS2 and then all |
| R | The service cannot guarantee that the trust bundle it received comes from the trusted identity provider.                                                                           | O-7            |                  |
| I | N/A - the trust bundle contains public information                                                                                                                                 |                |                  |
| D | If the communication path between identity provider and service is disrupted, the service will not be in a fully functional state as it will not be able to authenticate requests. | M-3            | AS2, AS6         |
| D | A malicious share bundle could trigger a parsing bug and lead the service to crash.                                                                                                | M-5, U-3, M-10 | AS2, AS6         |
| E | A malicious share bundle could trigger a parsing bug and lead to code execution at the Parsec privilege level.                                                                     | M-5, U-3, M-10 | All              |

### Attacker "Local Memory" - A11

Attacker with access to the local memory regions used by Parsec. This attacker can be another
process scheduled by the OS in the same timeframe than Parsec and reading the memory which was not
cleared.

|   | Description                                                                              | Mitigation | Assets                |
|---|------------------------------------------------------------------------------------------|------------|-----------------------|
| I | The attacker can read all the confidential assets placed in local memory by the service. | M-8        | AS1, AS2, AS4 and AS5 |

### Attacker "SPIFFE Validation Request" - A12

This attacker uses the SPIFFE Workload API endpoint created by the SPIFFE implementation to
interfere with the validation of the JWT-SVID token sent by the client.

*Only applicable for deployment (JWTS).*

|   | Description                                                                                                      | Mitigation                                                                                                                                                                                                           | Assets   |
|---|------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| I | An attacker steals the authentication token from a client's request to then execute any operation in their name. | M-9                                                                                                                                                                                                                  | AS4, AS3 |
| D | An attacker modifies the validation request to make it fail.                                                     | M-9                                                                                                                                                                                                                  | AS6      |
| D | An attacker overloads/crashes the SPIFFE implementation and thus prevents the service from making use of it.     | SPIFFE implementation specific. An ["Unavailable" error](https://github.com/spiffe/spiffe/blob/master/standards/SPIFFE_Workload_Endpoint.md#6-error-codes) can be used for implementations to perform load-shedding. | AS6      |

### Attacker "SPIFFE Validation Response" - A13

This attacker uses the SPIFFE Workload API endpoint created by the SPIFFE implementation to
interfere with the validation of the JWT-SVID token sent by the client. It can also create a spoofed
endpoint, mimicking the SPIFFE implementation's one.

*Only applicable for deployment (JWTS).*

|   | Description                                                                                                                | Mitigation | Assets                  |
|---|----------------------------------------------------------------------------------------------------------------------------|------------|-------------------------|
| S | An attacker impersonates the SPIFFE implementation: Parsec sends the authentication data of clients to malicious entity.   | O-14       | AS1                     |
| T | An attacker modifies the validation response of the SPIFFE implementation to yield the application identity of its choice. | O-14       | AS1                     |
| D | An attacker modifies the validation response to pretend it failed or succeeded.                                            | M-9        | AS6                     |
| D | An attacker modifies the validation response in such a way that it leads the service to crash.                             | M-9        | AS6                     |
| E | An attacker modifies the validation response in such a way that it leads to code execution at the service privilege level. | M-9        | AS4, AS5, AS6, AS7, AS8 |

## Unmitigations

| ID | Justification                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Consequences                                                                                                                   |
|----|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| 0  | An attacker can use all the threads of the service's thread pool, requesting for a time-consuming operation on each one of them, to leave the less amount of free time possible to other clients.                                                                                                                                                                                                                                                                            | The requests take more time to execute.                                                                                        |
| 2  | The authentication token is stored with confidentiality by the clients. If it is stolen, the service cannot prevent access with it unless the token is revoked.                                                                                                                                                                                                                                                                                                              | All the client's keys can be used, and exported if allowed by the key's policy.                                                |
| 3  | Parsec dependencies are not (visually) investigated for Security Vulnerabilities. (See M-10 for our mitigation.)                                                                                                                                                                                                                                                                                                                                                             | A vulnerability in one of Parsec dependency will also impact Parsec and the data Parsec shares with that dependency.           |
| 4  | While Parsec is authenticated on the device, anyone can brute force a key ID to execute operations with the key. Unmitigated for the PKCS 11 Provider: all sessions share the login state; if one session logs in then all other opened sessions will also be logged in. Other sessions only need a valid key ID to execute operations with private keys. Mitigated for the TPM Provider: each key is protected by a long, random authentication value, generated by the TPM | All the client's PKCS 11 keys can be used with PKCS 11 operations.                                                             |
| 5  | *(DSPC)* Parsec does not know about the security quality of a client's Unix password.                                                                                                                                                                                                                                                                                                                                                                                        | All the client's keys can be used, and exported if allowed by the key's policy.                                                |
| 6  | Parsec does not support using multiple authenticators concurrently ([open issue](https://github.com/parallaxsecond/parsec/issues/272)).                                                                                                                                                                                                                                                                                                                                      | If there is weakness in one authenticator, all the client's keys can be used, and exported if allowed by the key's policy.     |
| 7  | Parsec does not protect from some of the repudiation threats. Logging is used as best-effort way throughout the codebase to note the identity, time and date of important events such as: "new request received", "response sent back", "new mapping created", "mapping is read from the persistent store", "a hardware command is issued" and "a hardware command is received".                                                                                             | There might be no proof that some event took place. See [this issue](https://github.com/parallaxsecond/parsec-book/issues/84). |

## Mitigations

| ID | Justification                                                                                                                                                                                        | Details                                                                                                                                                                                                             |
|----|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 0  | Parsec uses a thread pool with a configurable amount of threads to limit the number of concurrent operations it can support so that the machine is not overloaded.                                   | [Done](https://github.com/parallaxsecond/parsec/commit/e87984c4d3eaafa1a1cb977dceadf773aca1f7db)                                                                                                                    |
| 1  | Response statuses are audited to not give too much information to the client.                                                                                                                        | [Done](https://github.com/parallaxsecond/parsec-interface-rs/issues/59)                                                                                                                                             |
| 2  | *(not DRCT)* The authenticators should only allow authentication tokens that are secure enough that brute-force attacks are not feasible.                                                            | *(JWTS)* The [algorithms](https://github.com/spiffe/spiffe/blob/master/standards/JWT-SVID.md#21-algorithm) prescribed by the JWT-SVID standard are secure enough to prevent brute-force attacks in most cases.      |
| 3  | Listener implementations use an IPC mechanism respecting confidentiality and integrity of messages transmitted between the clients and the service (once the initial connection has been made).      | Unix Domain Socket Listener: the sockets used on the client and service side for the communication are represented by file descriptors that are only accessible by those processes.                                 |
| 5  | Parsec is coded with safety in mind and is tested extensively.                                                                                                                                       | [Done](https://github.com/parallaxsecond/parsec-book/issues/35)                                                                                                                                                     |
| 6  | The `ManageKeyInfo` implementations communicate with its persistence storage backend through a mechanism respecting confidentiality, integrity and availability.                                     | On-Disk Key Info Manager: the mappings are stored on-disk using the filesystem provided by the OS. OS file permissions are used.                                                                                    |
| 7  | Logging is configured to include the software component from where logs are generated.                                                                                                               | [Done](https://github.com/parallaxsecond/parsec/commit/aafd176b49dd01c3f08866d564f2fff092d1305e)                                                                                                                    |
| 8  | Sensitive data that was found in the Parsec service memory is cleared once the buffer holding it is no longer used.                                                                                  | [Done](https://github.com/parallaxsecond/parsec/pull/239)                                                                                                                                                           |
| 9  | *(JWTS)* The SPIFFE Workload API endpoint is accessed through an IPC mechanism respecting confidentiality and integrity of messages transmitted between the workloads and the SPIFFE implementation. | The [SPIFFE Workload Endpoint document](https://github.com/spiffe/spiffe/blob/master/standards/SPIFFE_Workload_Endpoint.md#3-transport) prescribes the use of Unix Domain Socket or TCP with strong authentication. |
| 10 | Any vulnerabilities relating to our Rust dependencies which get added to the [Rust Security Advisory Database](https://rustsec.org/) get reported on a nightly basis by the CI.                      | The [Parsec Security Policy](https://github.com/parallaxsecond/parsec/blob/main/SECURITY.md) describes the process we follow to identify and report these to users.                                                 |

## Operational mitigations

Most of these operational mitigations are implemented when following the [Recommendations on a
Secure Parsec Deployment guide](../secure_deployment.md).

| ID | Justification                                                                                                                                                             | Details                                                                                                                                                                                                                                                                          |
|----|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 0  | A trusted administrator should start the service in such a way that un-privileged processes cannot send signals to the service.                                           | In a Unix OS, using a separate user to run the service prevents that.                                                                                                                                                                                                            |
| 1  | A trusted administrator should check the validity of the providers and hardware modules written in the service's configuration before starting/reloading it.              | This is a manual step that has to be done as part of configuring the service.                                                                                                                                                                                                    |
| 2  | Clients need to know from a trusted source that a trusted Parsec service is running on their machine so that they can trust the Listener endpoint.                        | The endpoint folder is in a location that only the trusted privileged administrator could have created so clients can trust the existance of a Parsec service.                                                                                                                   |
| 3  | Mappings should be put in a location that only the Parsec service and the trusted administrator can access.                                                               | The mappings are inside a folder for which the Parsec user should have exclusive access.                                                                                                                                                                                         |
| 4  | The trusted administrator needs to be notified when any kind of resource is running out.                                                                                  | Currently only the logs can be used as a way of knowing that the system is failing because a resource is running out.                                                                                                                                                            |
| 5  | Parsec logs coming from the service binary should be redirected to a file that is only writable by the service and readable by the trusted administrator.                 | Using systemd, the logs can only be written by the service and read by the Parsec user. Otherwise, they can be stored in the Parsec user home folder.                                                                                                                            |
| 6  | Parsec configuration file should be only writable by the trusted administrator and readable by the service.                                                               | The configuration is in a folder configured to be readable only by the Parsec user.                                                                                                                                                                                              |
| 7  | *(GNRC)* The trusted administrator needs to check that during the boot process the trusted identity provider has successfully given the root trust bundle to the service. | This is a manual check. It is possible that Parsec would not initialize correctly if the root trust bundle has not been given to it.                                                                                                                                             |
| 8  | The hardware descriptors should only be accessible by trusted privileged processes.                                                                                       | Manual check but this should be the default on most systems.                                                                                                                                                                                                                     |
| 9  | The Listener endpoint is contained in a location that only the Parsec service and the trusted administrator can access (only they can create the endpoint).               | The endpoint folder is owned by the Parsec user and only writable by them.                                                                                                                                                                                                       |
| 10 | *(DRCT)* A set of mutually trusted clients has restricted read-write access to the service IPC endpoint.                                                                  | A Parsec Clients Unix group needs to be created for it to exclusively have read-access on the socket.                                                                                                                                                                            |
| 11 | *(DSPC)* Before a client's Unix account is deleted, all of its Parsec keys must be deleted as well.                                                                       | The OS might recycle the same UID previously used by a deleted user and give it to an attacker's account.                                                                                                                                                                        |
| 12 | The administrator should not change Parsec authentication method while it is currently storing keys.                                                                      | The keys are not namespaced with authentication type which means the authentication is as strong as the weakest used.                                                                                                                                                            |
| 13 | *(JWTS)* A short expiration time should be set on the JWT-SVID token so that if it is stolen, it can only be used temporarily by attackers.                               | The way to set the expiration time of JWT-SVID tokens is implementation-specific. The administrator should ensure it is not too long.                                                                                                                                            |
| 14 | *(JWTS)* The SPIFFE Workload API endpoint must exist before Parsec is started and owned by an independant user. It must not be deleted while Parsec is running.           | It must not be possible for an attacker to put their own socket where the Parsec service and clients expect it. Doing a local validation of the JWT-SVID would remove the need for this mitigation. See [here](https://github.com/parallaxsecond/parsec/issues/289) for details. |
| 15 | *(JWTS)* The Parsec clients must be registered as SPIFFE workloads with unique SPIFFE ID.                                                                                 | Two Parsec clients should not be assigned the same SPIFFE ID.                                                                                                                                                                                                                    |

*Copyright 2020 Contributors to the Parsec project.*
