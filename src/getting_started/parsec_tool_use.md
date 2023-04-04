# Using Parsec from the Command Line

## Introduction

Many useful Parsec operations can be performed using Parsec's command-line tool, known as
`parsec-tool`. The tool can be useful when you need to perform administrative steps in order to
integrate Parsec with another component in your system. Such integrations might require the creation
of a key pair or a certificate request, for example. You can also use the `parsec-tool` in your
shell scripts when you need to automate seqeuences of operations for key management and
cryptogpraohy. Use this short guide to get familiar with basic use of the most common operations.

## Installing the Parsec Command-Line Tool

To use this guide, you need to have `parsec-tool` installed or built.

For installing, use the following command:

```
cargo install parsec-tool
```

For building it, use the following commands:

```
git clone git@github.com:parallaxsecond/parsec-tool.git
cd parsec-tool
cargo build
```

To run the example commands in this guide, you will also need to ensure that the `parsec-tool`
application is available on your `$PATH`. If you installed the tool using a package manager, then
this will happen automatically. If you downloaded a binary or built the tool yourself from source
code, you may need to modify your `$PATH`, or copy the `parsec-tool` application into a folder that
is already searched.

Before proceeding, ensure that you can run `parsec-tool` from your shell or terminal window as
follows:

```
parsec-tool
```

This should display a help summary.

## Checking the Version

The following command will display the version number for the `parsec-tool` installation that you
are using:

```
parsec-tool --version
```

You normally don't need to worry about the version. Parsec is designed with a robust protocol
between client applications and the service. It should be possible for any version of the
`parsec-tool` to work with any other version of the Parsec service. However, running an older
version of the `parsec-tool` might mean that some commands are unavailable.

## Getting Help With Commands

This document does not contain detailed man pages for all of the commands. We hope to be able to
make man pages for `parsec-tool` available online in the future. For the time being, you can use the
tool itself to generate help text for the available operations.

To generate a help summary for the tool as a whole, simply invoke `parsec-tool` without any
arguments, or with the `--help` argument. This will display the summary help text, which includes a
list of all available commands.

To get more detailed help text for a specific command, use the `--help` option for that command. For
example, to get help text for the `create-rsa-key` command, you would type:

```
parsec-tool create-rsa-key --help
```

This will provide a full help text for the command, including documentation for all of the
command-line parameters that this command accepts.

## Setting the Service API Endpoint

Parsec uses a Unix domain socket to carry commands and responses between client applications and the
service. Since `parsec-tool` is a Parsec client application, it also uses this domain socket to send
commands to the service. By default, the Parsec domain socket has a full path of
`/run/parsec/parsec.sock`. The `parsec-tool` will expect to find the socket endpoint at this
location.

If your service configuration has been modified to use a non-default socket path, then you will need
to tell the `parsec-tool` to find the socket at its correct place. Set the environment variable
`PARSEC_SERVICE_ENDPOINT` in your shell before using the `parsec-tool` as follows:

```
export PARSEC_SERVICE_ENDPOINT=unix:/correct/path/to/parsec/endpoint/parsec.sock
```

## Pinging the Service

Before running any other operations, it is useful first to check that the Parsec service is running
and healthy. To use the `parsec-tool`, you type `parsec-tool`, followed by the name of the command
that you want to run, followed by any additional arguments that are needed by that specific command.
The `ping` command is the simplest command, and it doesn't require any additional arguments:

```
parsec-tool ping
```

If the service is running and healthy, you will see output as follows:

```
[INFO] Service wire protocol version
1.0
```

If you see this message, your Parsec service is running and responding normally, and you can proceed
with the other examples in this guide.

If you don't see this message, check the troubleshooting steps below.

- If you see the error `parsec-tool: command not found` it means that `parsec-tool` is either not
   installed or cannot be found in any of the directories on your `$PATH`. Check the [installation
   guide](installation_options.md) to learn how to obtain the `parsec-tool` and to ensure that it
   can be found.
- The fault message `[ERROR] Error spinning up the BasicClient: the socket address provided in the
   URL is not valid` might be seen. This might mean that `parsec-tool` is trying to locate the
   service API endpoint at the wrong location. By default, `parsec-tool` expects the Parsec service
   endpoint to be `/run/parsec/parsec.sock`. If your Parsec service is using a different endpoint,
   then you need to set the `PARSEC_SERVICE_ENDPOINT` environment variable to the correct path. See
   the section above on [setting the endpoint](#setting-the-service-api-endpoint). Another cause of
   this error might be that your current user is not a member of the `parsec-clients` group. When
   you install Parsec using a package manager, the package scripts normally create `parsec-clients`
   group, and only users who are members of this group are allowed to contact the service endpoint.
   Use the `groups` command to list the groups that your current user is a member of, and refer to
   the [installation guide](installation_options.md#setting-up-user-permissions) for help on setting
   the correct permissions.

If these steps do not help, the Parsec community may be able to assist you. We are always very happy
to hear from users with your questions and queries. Head over to the
[community](https://github.com/parallaxsecond/community) repo to learn how to get in touch via Slack
and Zoom.

## Checking the Service Back-End Configuration

The `parsec-tool` includes commands that can help you check on how the service has been set up.
These checks can be useful, for example, if you wish to make sure that the Parsec service is using
the correct secure hardware on your device, such as your Trusted Platform Module (TPM) or Hardware
Security Module (HSM).

To check the hardware back-end configuration of Parsec on your device, run this command:

```
parsec-tool list-providers
```

This command displays a list of the back-end provider modules that have been activated in the Parsec
service. The entry at the **top** of this list is the most important one, because this entry tells
you which back-end provider will be used by default. You should pay particular attention to this
entry, and ensure that it matches your expectations for how Parsec has been integrated with your
device hardware.

If you are experimenting or prototyping with Parsec in a Proof-of-Concept (PoC) or non-production
environment, you will probably be using the software back-end (also known as the *Mbed Crypto* or
*Mbed TLS* back-end). This is the back-end provider that is configured out of the box in new Parsec
installations. It will appear in the list as follows:

```
ID: 0x01 (Mbed Crypto provider)
Description: User space software provider, based on Mbed Crypto - the reference implementation of the PSA crypto API
Version: 0.1.0
Vendor: Arm
UUID: 1c1139dc-ad7c-47dc-ad6b-db6fdb466552
```

If you are using this back-end, then you should be aware that it does not offer any specific
security features. This back-end provider is suitable for evaluation and experimentation only.

For Parsec to be integrated with a hardware or firmware TPM on your device, the topmost back-end
provider should be the TPM provider, which will appear as follows:

```
ID: 0x03 (TPM provider)
Description: TPM provider, interfacing with a library implementing the TCG TSS 2.0 Enhanced System API specification.
Version: 0.1.0
Vendor: Trusted Computing Group (TCG)
UUID: 1e4954a4-ff21-46d3-ab0c-661eeb667e1d
```

For Parsec to be integrated with a hardware module using the PKCS#11 interface, the topmost entry
should be:

```
ID: 0x02 (PKCS #11 provider)
Description: PKCS #11 provider, interfacing with a PKCS #11 library.
Version: 0.1.0
Vendor: OASIS Standard.
UUID: 30e39502-eba6-4d60-a4af-c518b7f5e38f
```

For hardware accessed through a `CryptoAuthLib` interface, the entry should be:

```
ID: 0x05 (CryptoAuthentication Library provider)
Description: User space hardware provider, utilizing MicrochipTech CryptoAuthentication Library for ATECCx08 chips
Version: 0.1.0
Vendor: Arm
UUID: b8ba81e2-e9f7-4bdd-b096-a29d0019960c
```

For Parsec to integrate with a [PSA
root-of-trust](https://www.psacertified.org/blog/what-is-a-root-of-trust/) implementation via the
[Trusted Services](https://www.trustedfirmware.org/projects/trusted-services/) project, the entry
should be:

```
ID: 0x04 (Trusted Service provider)
Description: Software exposing functionality provided by the Crypto Trusted Service running in a Trusted Execution Environment
Version: 0.1.0
Vendor: Arm
UUID: 71129441-508a-4da6-b6e8-7b98a777e4c0
```

In all configurations, there will be a final entry in the list that reads as follows, indicating the
core back-end that is always enabled for administrative operations:

```
ID: 0x00 (Core Provider)
Description: Software provider that implements only administrative (i.e. no cryptographic) operations
Version: 0.8.0
Vendor: Unspecified
UUID: 47049873-2a43-4845-9d72-831eab668784
```

You can learn more details about the different Parsec back-end providers
[here](../parsec_service/providers.md).

## Checking the Service Front-End Configuration

The Parsec service includes front-end configuration modules known as *authenticators*. These are
used to ensure that the operations of multiple client applications are kept separate from one
another. Parsec authenticator modules contain logic to decide on the identity of any client
application that is using the service. Client applications of any given identity will each have
their own namespace, which means that any named keys that they create will be visible only to them,
and never to other client applications.

The following command can be used to display the authenticator mechanism that is in use:

```
parsec-tool list-authenticators
```

By default, this command will output the following:

```
[INFO ] Available authenticators:
ID: 0x03 (Unix Peer Credentials authentication)
Description: Uses Unix peer credentials to authenticate the client. Verifies that the self-declared Unix user identifier (UID) in the request's authentication header matches that which is found from the peer credentials.
Version: 0.1.0
```

This message means that Parsec will use the Unix user identifier of each client process as the scope
of the namespace. Any client applications that run as the same Unix user will be considered the same
client, and will see the same set of created keys. Client applications running as different Unix
users will likewise see different sets of keys.

It is also possible for client applications to be differentiated based on a
[SPIFFE](https://spiffe.io) identity. If authentication has been configured in this way, then the
command output will look as follows:

```
[INFO ] Available authenticators:
ID: 0x04 (JWT SPIFFE Verifiable Identity Document authentication)
Description: Authenticator validating a JWT SPIFFE Verifiable Identity Document
Version: 0.1.0
```

The final supported method is known as *Direct Authentication*. This method is not recommended for
production environments, but it can be used for evaluation. In this mode, the Parsec service will
allow each client application to declare its own identity as a simple string, which will not be
validated in any way. Client applications need to trust each other to use distinct strings in a
sensible way. When this method is configured, the command output will read as follows:

```
[INFO ] Available authenticators:
ID: 0x01 (Direct authentication)
Description: Directly parses the authentication field as a UTF-8 string and uses that as the application identity. Should be used for testing only.
Version: 0.1.0
```

You can learn more details about the different Parsec front-end authenticators
[here](../parsec_service/authenticators.md).

## Signing with an Elliptic Curve Key

Let's learn how to create an Elliptic Curve (EC) key pair in Parsec, and use it to sign a message.
Create an EC key pair with the default curve and settings as follows:

```
parsec-tool create-ecc-key --key-name my-ecc-key
```

This command will produce the following output:

```
[INFO ] Creating ECC signing key...
[INFO ] Key "my-ecc-key" created.
```

You can also use the `list-keys` command:

```
parsec-tool list-keys
```

This will list the key that you just created, in addition to any others that have been created by
the same client:

```
* my-ecc-key (Mbed Crypto provider, EccKeyPair { curve_family: SecpR1 }, 256 bits, permitted algorithm: AsymmetricSignature(Ecdsa { hash_alg: Specific(Sha256) }))
```

You can export the public part of the key using the `export-public-key` command:

```
parsec-tool export-public-key --key-name my-ecc-key
```

This will output the public part of the key in PEM format, similar to the output shown below:

```
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEt6IxxREfORO2+Se/4AlBQQDpPydx
JymgCiCUi6A6w+lYVGLy8W9HWSSC8fQwgRvDTWmQc6zJLl59XizBEtNlMQ==
-----END PUBLIC KEY-----
```

To sign a simple plaintext messsage with this key, use the `sign` command:

```
parsec-tool sign --key-name my-ecc-key "Hello Parsec"
```

This command will automatically hash the message with the SHA-256 algorithm and then ask the Parsec
service to use the private key to sign the hash. The resulting signature will be shown in a base-64
encoding:

```
[INFO ] Hashing data with Sha256...
[INFO ] Signing data with Ecdsa { hash_alg: Specific(Sha256) }...
MEUCIDZz+ywOKc8kyst5DlJ9GZ9TPpeMXUD3xeTolwp9fENMAiEAxCYfOHt2jvtkz2SpXdo2IYuBjlht9DX+lXorpGcAU5U=
```

## Signing with an RSA Key

We can use RSA keys for digital signatures. The following command will create a new RSA key pair and
set its purpose as a signing key:

```
parsec-tool create-rsa-key --key-name my-rsa-signing-key --for-signing
```

This will create an RSA signing key of the default key strength, which is 2048 bits. You can use the
`list-keys` command to check that this key was created:

```
parsec-tool list-keys
```

This will list the key that you just created, in addition to any others that have been created by
the same client:

```
* my-rsa-signing-key (Mbed Crypto provider, RsaKeyPair, 2048 bits, permitted algorithm: AsymmetricSignature(RsaPkcs1v15Sign { hash_alg: Specific(Sha256) }))
```

You can export the public part of the key using the `export-public-key` command:

```
parsec-tool export-public-key --key-name my-rsa-signing-key
```

This will output the public part of the key in PEM format, similar to the output shown below:

```
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4+XKkuDB9p06E/oxKHmK
Pzh58/eEQLZL9rTetOGxSJoruFAinC13zn76KHQfLYRYZhoFbXDdel/LHxHzVNB2
0LIrcQ8+3Sk2BZMyAUReCxV9IZ/3L4yrbbCaJCWSrK20KVjIgoymhBZhwbqKmM2s
rqGZZ3ZHAe+9bphQKjcFoooDQyzk6XNY3TM2PFYsRt41Q+u+4Dcp/Jusi1cv5Cij
hfvJV41yUV8I24H0GkQiJDidH/OdSiVytBZb7G7sfjwlPP3x3BB5hfE56QShNjWk
23ko0a1vgE8vIIlXNfQ/HjEgYPst0YmeJpPb/eSeWTPjxOYyfLn6d2XoS7gjsZwG
CwIDAQAB
-----END PUBLIC KEY-----
```

To sign a simple plaintext message with this key, use the `sign` command:

```
parsec-tool sign --key-name my-rsa-signing-key "Hello Parsec"
```

This command will automatically hash the message with the SHA-256 algorithm and then ask the Parsec
service to use the private key to sign the hash. The resulting signature will be shown in a base-64
encoding:

```
[INFO ] Hashing data with Sha256...
[INFO ] Signing data with RsaPkcs1v15Sign { hash_alg: Specific(Sha256) }...
O6VLgOT3pXDqvJi7faUguDvpKIfoQw4r8XlIgFn+gBOlTkW2nBmyHJyi8UU3RIo7f2AF5P9g+8MY4RKbADFSl7446iew4CjkZxWe+5M2sbYEKVZ+wGdhvWQRGXDeo5foW7TqqbdMU4i0tRp9tnq5GcXtpNgTAhtajWTuAnNgEv7IQHypeOgOomfK80q9P4wVbRvS9RCfE6tsyVikT8QgIUDYQjnY7inn4tW1a5HsFTVP4rSy2htHLgS/l9FLxW6ZyTXfdWF33zpNoGrmVx7IU0HapFiIgIBmBuNVq3gelQiXRAXK5mYEJvkLvba7TiAJJMUDQc/uKSY7GUAMh/SCZQ==
```

## Encryption with an RSA Key

We can use RSA keys for asymmetric encryption and decryption. Encryption is performed using the
public key, while decryption uses the private key.

Create an RSA key pair for encryption as follows:

```
parsec-tool create-rsa-key --key-name my-rsa-enc-key
```

Use the `list-keys` command to check that the key exists:

```
parsec-tool list-keys
```

The output will include a line for the key that you just created, similar to the following:

```
* my-rsa-enc-key (Mbed Crypto provider, RsaKeyPair, 2048 bits, permitted algorithm: AsymmetricEncryption(RsaPkcs1v15Crypt))
```

Export the public part of the key using the `export-public-key` command:

```
parsec-tool export-public-key --key-name my-rsa-enc-key
```

This command will output the public key in PEM format as follows:

```
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtfeDG1fFd88koc1Fcksi
X17fkm4U2ljLOHaBSSpWaSoBWo2dMRUtzF+Ijogt9DhR2bv3ej7BLGN6DF1YDVGb
M+6bkzD7vSXkT45fe2FYn+86nBpG4znsJBBmQoH19YNTXF7MSxiq2WTVyJfikSTV
/r2bQzHFTkMh0iTPJlfx0et9JSTltK2ApZ6tWiKJX0Kw2kNw2iCKUmLqNGxc8XM2
H6sk0I24M0VpIMWy6c8W2z7TnhvogD32ct+AiJtCwqqo0gMQKgvOHSTctys5i1pE
3ozcS/smaWhYTVPZLUK3bBgA7XaXD37FzLu6qhRCyv/DdrhwcqvIYWtOo2d0pvSO
/wIDAQAB
-----END PUBLIC KEY-----
```

For convenience, you can use the `parsec-tool` to encrypt a simple plaintext message using the
public key:

```
parsec-tool encrypt --key-name my-rsa-enc-key "secret message"
```

The ciphertext will be output as a base-64 encoding:

```
[INFO ] Encrypting data with RsaPkcs1v15Crypt...
ivk6yCKxFlIXRaQkfI5SrvhJtVXUz2VoXwC2xK7zU6UG1w0LNk7ZScz1pgpghc0IgftjjvhzK+6R4z0iT+KCVP8V0jbn7TatqyN6BK0n9Fvjit6fS1mgIGwUfK0U5bG9oQV6j3GXzfoiX6LyOGNRsY8rH4dvk1Qh894qtY1bGCj2sNsA5DRpwXvY5fIP6UWgbTGJ+gtXDNpdlQl2nT6XlWWgOZmddYukQMQhXrg0LelODPEHrphJBz3Dh2KTw2DNj2f6io1hP3JSnkillPyvAN2RdmRACDXmwE76L1lISh4n8O784s1mZwGLPqpnDS+gQfnxhk2XBn/rUAU4rTAexg==
```

Now use the `decrypt` command to decrypt this same piece of ciphertext using the private part of the
key pair, which should recover the original message:

```
parsec-tool decrypt --key-name my-rsa-enc-key ivk6yCKxFlIXRaQkfI5SrvhJtVXUz2VoXwC2xK7zU6UG1w0LNk7ZScz1pgpghc0IgftjjvhzK+6R4z0iT+KCVP8V0jbn7TatqyN6BK0n9Fvjit6fS1mgIGwUfK0U5bG9oQV6j3GXzfoiX6LyOGNRsY8rH4dvk1Qh894qtY1bGCj2sNsA5DRpwXvY5fIP6UWgbTGJ+gtXDNpdlQl2nT6XlWWgOZmddYukQMQhXrg0LelODPEHrphJBz3Dh2KTw2DNj2f6io1hP3JSnkillPyvAN2RdmRACDXmwE76L1lISh4n8O784s1mZwGLPqpnDS+gQfnxhk2XBn/rUAU4rTAexg==
```

Output:

```
[INFO ] Decrypting data with RsaPkcs1v15Crypt...
secret message
```

You wouldn't normally perform both the encryption and decryption using `parsec-tool` in this way.
More commonly, the encryption part would be done by an external component using the exported public
key, and only the decryption part would be performed inside Parsec (which has exclusive access to
the private key). This [tutorial video](https://youtu.be/ows1-_dxZfw?t=47) shows a similar
demonstration of an RSA encryption workflow using `parsec-tool`, where the encryption is performed
externally using an online encryption tool.

## Generating a Random Number

The Parsec command-line tool can be used to generate random numbers using the entropy facilities
provided by the configured back-end provider. Use the following command:

```
parsec-tool generate-random --nbytes 8
```

The output will be similar to the following:

```
[INFO ] Generating 8 random bytes...
[INFO ] Random bytes:
4B 9B FB 11 55 D9 7F 41
```

Vary the `--nbytes` argument to generate random sequences of different sizes.

## Creating a Certificate Signing Request (CSR)

We can create CSRs using the `parsec-tool`. Before a CSR can be created, an asymmetric key pair must
exist. In this example, you'll start with a 2048-bit RSA key pair for signing, created as follows:

```
parsec-tool create-rsa-key --key-name my-rsa-csr-key --for-signing
```

Once we have a signing key, we can output a CSR using the `create-csr` command as follows:

```
parsec-tool create-csr --key-name my-rsa-csr-key --cn my-common-name
```

This will output an encoded CSR:

```
-----BEGIN CERTIFICATE REQUEST-----
MIICXjCCAUYCAQAwGTEXMBUGA1UEAwwObXktY29tbW9uLW5hbWUwggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQC1ijnwCyFk0Q2VjsM6UPtov+oR/Bl8UeEh
/pu+kVnPgMcIumK5QJVBlVEhAFq0lJ4jpXb7no3P0GDbn9tUgpdrS0xp5/OSXHWs
CcZJzWZ9n6zHnFQLQD4Z4LAiVlmfhidF6wNhLihZywn7+aqH5fAOsaFVzIjDElXp
ZGxmd22M5Qqjs0sDuKS1I5+AeedDmlwi+HMNMMaxczgokEbYO3TUSUBX/D1BFUlN
5vv0YTxqir+qzVBYvK47eczEQE0vZhQKZa6Dw4DmDdBQQtob0mQjxXjuYcoj2w9a
XAZZmv+4CJ6K0XZlkr7+CFZgQDMz5B2Mv+gPJU3Mo82qjYGBCXPXAgMBAAGgADAN
BgkqhkiG9w0BAQsFAAOCAQEAG2OyzSuDi/jl0j6WAUaW79ChzZbthzrv03/IiEu9
CLEtXbi8NNwLbwT+zz8fw3/OQnDHfnJ0YAb9WfH3GIdd32TyK1YdqooCyPoQoUzv
crfUrm8sAVRKqD2XU3KRzh+6H6WHnl4ASWfTKdWgvlX4cZ54ztZ52zSHbdHKZmxP
Po3n5Dngxj2GP8nT6tMJsgDG/k7h6//vlgSLChxyDf39ZAXBRJTBGf99Jc8d2Ox3
4EavDuBuXTTDbz5ePz4OLnXCizZSHAZCbPUAcErL/q3vY8zR2O2vo712J2WD1Wdh
I60pltRTP3MAwE554zj/FM6J0Do25B453Rg7H+Pvt1VTUQ==
-----END CERTIFICATE REQUEST-----
```

The `create-csr` command allows many components of the Distinguished Name (DN) to be customized,
including the serial number. It is also possible to specify one or more Subject Alternative Names
(SAN) in the CSR. Display the help text for this command as follows:

```
parsec-tool create-csr --help
```

*Copyright 2022 Contributors to the Parsec project.*
