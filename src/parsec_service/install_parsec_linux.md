# How to install Parsec on Linux

Parsec can be built and installed as a Linux daemon using systemd. The Parsec daemon uses socket
activation which means that the daemon will be automatically started when a client request is made
on the socket. The daemon is a systemd user daemon run by the `parsec` user.

If your Linux system uses systemd to manage daemons, you can follow these steps. `$DESIRED_FEATURES`
can be a space or comma-separated subset of: `mbed-crypto-provider`, `pkcs11-provider`, and
`tpm-provider`. Choose the providers you want to install depending on what is available on the
platform.

Create and log in to a new user named `parsec`.

```
sudo useradd -m parsec
sudo passwd parsec
su --login parsec
```

In its home directory, pull and install Parsec as a daemon.

```
git clone https://github.com/parallaxsecond/parsec.git
cargo install --no-default-features --features $DESIRED_FEATURES --path parsec
```

Copy and adapt the [configuration](configuration.md) you want to use.

```
cp parsec/config.toml config.toml
```

Install the systemd unit files and activate the Parsec socket.

```
mkdir -p ~/.config/systemd/user
cp -r parsec/systemd-daemon/parsec.service parsec/systemd-daemon/parsec.socket ~/.config/systemd/user
systemctl --user enable parsec.socket
systemctl --user start parsec.socket
```

Every user on the system can now use Parsec! You can test it going inside the `parsec` directory
and:

```
cargo test --test normal
```

Check the Parsec logs with:

```
journalclt --user -u parsec
```

*Copyright (c) 2019, Arm Limited. All rights reserved.*
