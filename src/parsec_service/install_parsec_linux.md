# How to securely install Parsec on Linux

Parsec can be built and installed as a Linux daemon using systemd. The daemon is a systemd user
daemon run by the `parsec` user. Some manual steps are needed to make sure that permissions are set
up correctly so that Parsec is installed respecting the operational mitigations of our [threat
model](../parsec_security/parsec_threat_model/threat_model.md). Currently, Parsec does not support
integration with any Identity Provider. More installation methods will be added in the future when
new identity providers/authenticators are supported.

If your Linux system uses systemd to manage daemons, you can follow these steps. `$DESIRED_FEATURES`
can be a space or comma-separated subset of: `mbed-crypto-provider`, `pkcs11-provider`, and
`tpm-provider`. Choose the providers you want to install depending on what is available on the
platform.

## From an admin user with privileges

Create the `parsec` user.

```
sudo useradd -m parsec
sudo passwd parsec
```

Create the following Parsec directories, with good permissions.

`/var/lib/parsec` for storing persistent data like the `mappings` folder. The service will run from
here.

```
sudo mkdir /var/lib/parsec
sudo chown parsec /var/lib/parsec
sudo chmod 700 /var/lib/parsec
```

`/etc/parsec` to contain the configuration file.

```
sudo mkdir /etc/parsec
sudo chown parsec /etc/parsec
sudo chmod 700 /etc/parsec
```

`/usr/libexec/parsec` to contain the `parsec` executable binary file.

```
sudo mkdir /usr/libexec/parsec
sudo chown parsec /usr/libexec/parsec
sudo chmod 700 /usr/libexec/parsec
```

`/run/parsec` to contain the socket file. The `parsec-clients` group needs to be created. Mutually
trusted Parsec Clients will need to be in that group.

```
sudo groupadd parsec-clients
sudo mkdir /run/parsec
sudo chown parsec:parsec-clients /run/parsec
sudo chmod 750 /run/parsec
```

For example, adding the imaginary `parsec-client-1` user to the `parsec-clients` group:

```
sudo usermod -a -G parsec-clients parsec-client-1
```

Users just added to that group might need to log-out and log-in again to make sure the change apply.
They can also try the `newgrp` command with no parameters to re-initialize their environment.

## From the parsec user

Log in to `parsec`.

```
su --login parsec
```

Depending on which features of Parsec the `parsec` user is going to use, it might need to be given
more privileges in order to access some resources on the system. Refer to the
[Providers](providers.md) page for more information.

In its home directory, clone and compile Parsec. If a Rust toolchain is not available widely on the
system, it will need to be [installed](https://www.rust-lang.org/tools/install) for that specific
user.

Below is an example with Parsec 0.5.0, update with the version you want!

```
git clone --branch 0.5.0 https://github.com/parallaxsecond/parsec
cargo build --manifest-path parsec --features $DESIRED_FEATURES --release
cp parsec/target/release/parsec /usr/libexec/parsec
```

Adapt and copy the [configuration](configuration.md) you want to use.

```
cp parsec/config.toml /etc/parsec/config.toml
```

Install the systemd unit files and activate the Parsec socket.

```
mkdir -p ~/.config/systemd/user
cp -r parsec/systemd-daemon/parsec.service ~/.config/systemd/user
systemctl --user enable parsec
systemctl --user start parsec
```

Check the Parsec logs with:

```
journalctl --user -u parsec
```

Also reload the service with:

```
systemctl --user kill -s HUP parsec
```

## From a parsec-clients user

`parsec-clients` users can now use Parsec! You can test it (having logged in a `parsec-clients`
user) by installing the [`parsec-tool`](https://github.com/parallaxsecond/parsec-tool):

```
$ parsec-tool ping
[INFO] Pinging Parsec service...
[SUCCESS] Service wire protocol version is 1.0.
```

*Note:* if you encounter a "Permission Denied" error while executing the end-to-end tests, make sure
that the group change has taken effect. You can check it by calling `groups` with no arguments. If
you do not see `parsec-clients`, please try logging the user out and in again to apply the change.

*Copyright 2019 Contributors to the Parsec project.*
