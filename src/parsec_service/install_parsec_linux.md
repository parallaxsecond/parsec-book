# How to securely install Parsec on Linux

Parsec can be built and installed as a Linux daemon using systemd. The daemon is a systemd user
daemon run by the `parsec` user. Some manual steps are needed to make sure that permissions are set
up correctly so that Parsec is installed respecting the operational mitigations of our [threat
model](../threat_model/threat_model.md). Similarly to the threat model, this guide proposes
different alternatives in case an Identity Provider is available or not. The role and description of
an Identity Provider in Parsec is described in the [System
Architecture](https://parallaxsecond.github.io/parsec-book/parsec_service/system_architecture.html)
page. Currently, Parsec does not support integration with any Identity Provider. To securely install
Parsec, please follow the steps of deployment **without an Identity Provider**.

If your Linux system uses systemd to manage daemons, you can follow these steps. `$DESIRED_FEATURES`
can be a space or comma-separated subset of: `mbed-crypto-provider`, `pkcs11-provider`, and
`tpm-provider`. Choose the providers you want to install depending on what is available on the
platform.

Create the Parsec socket directory.

```
mkdir /tmp/parsec
```

In a deployment **without an Identity Provider**, create the `parsec-clients` group and set the
correct permissions on the socket folder. Mutually trusted Parsec Clients will need to be in that
group.

```
sudo groupadd parsec-clients
sudo chown :parsec-clients /tmp/parsec
sudo chmod 750 /tmp/parsec
```

For example, adding the imaginary `parsec-client-1` user to the `parsec-clients` group:

```
sudo usermod -a -G parsec-clients parsec-client-1
```

Users just added to that group might need to log-out and log-in again to make sure the change apply.

In a deployment **with an Identity Provider**, set the correct permissions on the socket folder.

```
sudo chmod 755 /tmp/parsec
```

Create and log in to a new user named `parsec`.

```
sudo useradd -m parsec
sudo passwd parsec
su --login parsec
```

Depending on which features of Parsec the `parsec` user is going to use, it might need to be given
more privileges in order to access some resources on the system. Refer to the
[Providers](providers.md) page for more information.

In its home directory, pull and install Parsec as a daemon. If a Rust toolchain is not available
widely on the system, it will need to be [installed](https://www.rust-lang.org/tools/install) for
that specific user.

```
git clone https://github.com/parallaxsecond/parsec.git
cargo install --features $DESIRED_FEATURES --path parsec
```

Copy and adapt the [configuration](configuration.md) you want to use. For a secure deployment, make
sure to activate the `log_error_details` option and to use a `trace` log level.

```
cp parsec/config.toml config.toml
```

Install the systemd unit files and activate the Parsec socket.

```
mkdir -p ~/.config/systemd/user
cp -r parsec/systemd-daemon/parsec.service ~/.config/systemd/user
systemctl --user enable parsec
systemctl --user start parsec
```

`parsec-clients` users (with no IP) or every one (with IP) can now use Parsec! You can test it
(having logged in a `parsec-clients` user) going inside the `parsec/e2e_tests` directory and:

```
cargo test normal_tests
```

*Note:* if you encounter a "Permission Denied" error while executing the end-to-end tests, make sure
that the group change has taken effect. You can check it by calling `groups` with no arguments. If
you do not see `parsec-clients`, please try logging the user out and in again to apply the change.

Check the Parsec logs with:

```
journalclt --user -u parsec
```

Reload the service:

```
systemctl --user kill -s HUP parsec
```

*Copyright 2019 Contributors to the Parsec project.*
