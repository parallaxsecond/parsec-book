# How to securely install Parsec on Linux

Parsec can be built and installed as a Linux daemon using systemd. The daemon is a systemd user
daemon run by the `parsec` user. Some manual steps are needed to make sure that permissions are set
up correctly so that Parsec is installed respecting the operational mitigations of our [threat
model](../parsec_security/parsec_threat_model/threat_model.md).

If your Linux system uses systemd to manage daemons, you can follow these steps. `$DESIRED_FEATURES`
can be a space or comma-separated subset of `*-provider` and `*-authenticator` features. Choose the
providers you want to install depending on what is available on the platform. Only one authenticator
can be chosen at runtime, the Unix Peer Credentials one is compiled in by default.

This guide will assume that an authenticator is used. If you wish to install Parsec with Direct
Authentication and mutually trusted clients, please follow this guide first and then go to the
[dedicated section](#using-direct-authentication) for the subsequent steps. You will need to add the
`direct-authenticator` feature to your `$DESIRED_FEATURES` variable.

## From an admin user with privileges

Create the `parsec` user with a strong password.

```
sudo useradd -m parsec
sudo passwd parsec
```

Create the following Parsec directories, with good permissions:

- `/var/lib/parsec` for storing persistent data like the `mappings` folder.
- `/etc/parsec` to contain the configuration file.
- `/usr/libexec/parsec` to contain the `parsec` executable binary file.
- `/run/parsec` to contain the socket file.

Commands:

```
sudo mkdir /var/lib/parsec
sudo chown parsec /var/lib/parsec
sudo chmod 700 /var/lib/parsec
sudo mkdir /etc/parsec
sudo chown parsec /etc/parsec
sudo chmod 700 /etc/parsec
sudo mkdir /usr/libexec/parsec
sudo chown parsec /usr/libexec/parsec
sudo chmod 700 /usr/libexec/parsec
sudo mkdir /run/parsec
sudo chown parsec /run/parsec
sudo chmod 755 /run/parsec
```

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

Below is an example with Parsec 0.6.0, update with the version you want!

```
git clone --branch 0.6.0 https://github.com/parallaxsecond/parsec
cargo build --manifest-path parsec/Cargo.toml --features $DESIRED_FEATURES --release
cp parsec/target/release/parsec /usr/libexec/parsec
```

Adapt and copy the [configuration](configuration.md) you want to use. Particulary, add and configure
the providers you set in the `$DESIRED_FEATURES`.

```
cp parsec/config.toml /etc/parsec/config.toml
```

**Warning:** do not set `"Direct"` for `auth_type` as this will make Parsec insecure. If you would
like to use Direct Authentication with mutually trusted clients, please continue the steps described
below and then go to the [dedicated section](#using-direct-authentication).

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

If later you change the configuration file, you can reload the service with:

```
systemctl --user kill -s HUP parsec
```

## From a Parsec client

The definition of a client will depend on the [authenticator](authenticators.md) that you configured
Parsec with.

Clients can now use Parsec! They can test it by installing the
[`parsec-tool`](https://github.com/parallaxsecond/parsec-tool):

```
$ parsec-tool ping
[INFO] Pinging Parsec service...
[SUCCESS] Service wire protocol version is 1.0.
```

## Using Direct Authentication

Using this authentication method, clients will be able to declare their own identity. Clients using
Parsec with this authentication need to be mutually trusted and part of the `parsec-clients` group.

**Warning:** you must only follow those steps if Parsec is not currently storing any keys.

As the `parsec` user, stop the service.

```
systemctl --user stop parsec
```

As the admin, add the `parsec-clients` group and restrict the visibility of the socket folder to
that group.

```
sudo groupadd parsec-clients
sudo chown parsec:parsec-clients /run/parsec
sudo chmod 750 /run/parsec
```

Add mutually trusted clients to the `parsec-clients` group. For example, adding the imaginary
`parsec-client-1` user to the `parsec-clients` group:

```
sudo usermod -a -G parsec-clients parsec-client-1
```

Users just added to that group might need to log-out and log-in again to make sure the change apply.
They can also try the `newgrp` command with no parameters to re-initialize their environment.

Modify the `auth_type` in `/etc/parsec` to `"Direct"`.

```
[authenticator]
auth_type = "Direct"
```

As the `parsec` user, start the service again.

```
systemctl --user start parsec
```

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
