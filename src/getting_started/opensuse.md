# Quickstart for openSUSE and SUSE

`parsec` and `parsec-tool` are built for openSUSE and SUSE distributions and tested in openQA for
Arm and x86 architectures.

## Installation

To install parsec on openSUSE Tumbleweed or openSUSE Leap 15.3 (and later), just install `parsec`
and `parsec-tool` from YaST (graphical UI), or from zypper (command line):

```
$ sudo zypper install parsec parsec-tool
```

Note: If you use SUSE SLE15-SP3 (or later), `parsec` and `parsec-tool` are available from
Package-Hub repository. So, please enable Package-Hub before trying to install those packages.

## Configuration

A default config file is installed as `/etc/config.toml`. Only Mbed TLS (software) backend is
enabled by default, but you can easily enable other backends, such as Tpm, CryptoAuthLib or Pkcs11.
A full template is available at `/usr/share/doc/packages/config.toml`.

You need to add the current linux user to `parsec-clients` group from YaST or from command line:

```
$ sudo usermod -a -G parsec-clients $USER
```

To apply the changes, you need to (re)login as `$USER`, or use `newgrp parsec-clients` command line

## Start Parsec service

To start Parsec service now and also enable auto-start on next boots, you can run:

```
$ sudo systemctl enable --now parsec.service
```

The Parsec service will now wait listening from clients connecting via
`/var/run/parsec/parsec.sock`, and you can interact with `parsec-tool`.

## Using the Parsec Tool

A ping should work using `parsec-tool`:

```
$ parsec-tool ping
[INFO ] Service wire protocol version
1.0
```

Generate an ECC key pair and sign with it:

```
$ parsec-tool create-ecc-key -k toto
[INFO ] Creating ECC key...
[INFO ] Key "toto" created.

$ parsec-tool sign -k toto "Hello Parsec!"
[INFO ] Hashing data with Sha256...
[INFO ] Signing data with Ecdsa { hash_alg: Specific(Sha256) }...
MEYCIQCrc9cys35NeXwNAr8lYu8WPu0RiutkoAIWn+jYfYofPwIhAKPlNNsW//ykW8nX11KABNpWWYsNGNoZXt0yiGyBEtnb
```

Execute the tool without any argument to check all the possible commands!

## Stop and reload Parsec

Stop the Parsec service with:

```
$ sudo systemctl stop parsec.service
```

If you make any change to its configuration, reload it with:

```
$ sudo systemctl restart parsec.service
```

*Copyright 2021 Contributors to the Parsec project.*
