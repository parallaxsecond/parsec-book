# Installation Options

## Is Parsec Already Running?

The easiest way to check whether Parsec is already installed and running on your system is to open a
terminal window and issue this command:

```
parsec-tool ping
```

If the Parsec components are installed and running, this command will produce output similar to the
following:

```
[INFO] Service wire protocol version
1.0
```

If this fails, then do not worry. Read on to learn the best way to get Parsec up and running on your
system.

## Option 1: Install Parsec Using the Package Manager

The easiest way to install Parsec is by using the package manager on your system. Parsec is
available as a package in Fedora and openSUSE Linux distributions. If you are using one of these
distributions, follow the guide below to get Parsec installed and working.

### Installing the Parsec Packages

To install Parsec on **openSUSE Tumbleweed or openSUSE Leap 15.3 (and later)**, just install
`parsec` and `parsec-tool` from YaST (graphical UI), or from zypper (command line):

```
sudo zypper install parsec parsec-tool
```

**Note:** If you use SUSE SLE15-SP3 (or later), `parsec` and `parsec-tool` are available from
Package-Hub repository. So, please enable Package-Hub before trying to install those packages.

To install Parsec on **Fedora 34 (and later)**, you can run the following command from the terminal:

```
sudo dnf install parsec parsec-tool
```

### Setting Up User Permissions

When you install Parsec with the package manager (on either openSUSE or Fedora), the package
installation scripts will include the creation of a `parsec-clients` user group. Client applications
that wish to use the Parsec service should first be made members of this group, otherwise they will
be denied permission to access the service endpoint. To make your current user a member of
`parsec-clients`, issue this command:

```
sudo usermod -a -G parsec-clients $USER
```

Please note that this change will *not* be applied immediately within your current terminal window.
To ensure that these changes take effect, you can either log out and log back in as the same user,
or you can forcibly apply the changes using this command:

```
newgrp parsec-clients
```

To ensure that the current user is a member of the `parsec-clients` group, use this command:

```
groups
```

and ensure that `parsec-clients` is in the list of groups.

### Starting the Parsec Service

When you install Parsec with the package manager, it will be installed as a system service. Use the
following command to start the service immediately, and also ensure that it is enabled for automatic
start on subsequent system boot:

```
sudo systemctl enable --now parsec.service
```

### Checking the Installation

To check that the installation is functional, issue this command:

```
parsec-tool ping
```

If the Parsec components are correctly installed and running, you should see output similar to the
following:

```
[INFO] Service wire protocol version
1.0
```

If instead you see an error message, go back through the above steps and ensure that the service was
started, and that your current user is a member of the `parsec-clients` group.

## Option 2: Download a Quick-Start Release

If you are using a system that does not support installing Parsec through the package manager, you
can get familiar with Parsec by downloading the latest release from GitHub and running it manually
as a quick-start package. This is currently supported for any 64-bit Linux system running on the x86
architecture.

**Note:** this method is suitable for familiarisation and experimentation only. **Do not** use this
method in production environments. To securely install Parsec on Linux for production, check [this
guide instead](../parsec_service/install_parsec_linux.md).

### Check that Your System is Suitable

To download a pre-built release of Parsec, you need to be running a 64-bit Linux system on the x86
architecture, and you need to have at least version 2.27 of the Gnu C Library (`GLIBC`), which you
can check by running the following command:

```
ldd --version
```

### Download the Latest Quick-Start Release Bundle

Run the following command to download and unpack the `quickstart-1.1.0-linux_x86` folder. It
contains the Parsec service (`parsec`), its pre-built configuration (`config.toml`) and the Parsec
tool (`parsec-tool`).

```
curl -s -N -L https://github.com/parallaxsecond/parsec/releases/download/1.1.0/quickstart-1.1.0-linux_x86.tar.gz | tar xz
```

### Start the Parsec Service

From within the `quickstart-1.1.0-linux_x86` directory, start the Parsec service with this command:

```
./parsec &
```

You should see some lines of console output as the service starts, ending with the following:

```
[INFO  parsec] Parsec is ready.
```

### Using the Parsec Tool

As the Parsec socket file is at a non-default location, you will need to set the
`PARSEC_SERVICE_ENDPOINT` environment variable first.

```
export PARSEC_SERVICE_ENDPOINT=unix:$(pwd)/parsec.sock
```

You can now use the `parsec-tool` to check that the service is running:

```
./parsec-tool ping
```

If the Parsec components are correctly downloaded and running, you should see output similar to the
following:

```
[INFO] Service wire protocol version
1.0
```

### Controlling the Service Manually

When using the Parsec service as a pre-built download, it will not be installed as a system service.
Therefore, to stop the service, issue the following command:

```
pkill parsec
```

You should see some lines of output ending with:

```
[INFO parsec] Parsec is now terminated.
```

You can also cause the service to restart, which can be useful if you have made some configuration
changes for example. This command will cause the service to reload its configuration and restart:

```
pkill -SIGHUP parsec
```

Again, this will produce some lines of output, and the final line will be:

```
[INFO parsec] Parsec configuration reloaded.
```

### Running the Test Script

The quick-start bundle also contains the `parsec-cli-tests.sh` testing script, which executes a
simple set of tests to ensure that the Parsec service is operating correctly. Some of these tests
use the local `openssl` installation as a point of comparison, ensuring that Parsec's results are
equivalent to those expected by `openssl`.

As this script uses the `parsec-tool`, the `PARSEC_SERVICE_ENDPOINT` environment variable needs to
be set as follows:

```
export PARSEC_SERVICE_ENDPOINT="unix:$(pwd)/parsec.sock"
```

If parsec-tool is not installed into a directory included in `PATH`, then you also need to define
`PARSEC_TOOL` environment variable with a full path to it:

```
export PARSEC_TOOL="$(pwd)/parsec-tool"
```

To run the script, simply execute it without any arguments as follows:

```
./parsec-cli-tests.sh
```

The script will run a sequence of operations and produce output along the following lines:

```
Checking Parsec service...
[INFO ] Service wire protocol version
1.0

Testing Mbed Crypto provider

- Test random number generation
[DEBUG] Parsec BasicClient created with implicit provider "Mbed Crypto provider" and authentication data "UnixPeerCredentials"
[INFO ] Generating 10 random bytes...
[DEBUG] Running getuid
[INFO ] Random bytes:
A6 F5 90 24 DF FF 50 1F 29 2E
....
```

The `parsec-cli-tests.sh` script also accepts some command-line parameters to adjust its behaviour.
You can use the `-h` option to get additional help on these.

**Note:** If openssl is not installed into a directory included in `PATH` then you also need to
define `OPENSSL` environment variable with a full path to it:

```
export OPENSSL="<full path>/openssl"
```

## Option 3: Build from Source Code

If the above installation options are not suitable, please refer to the instructions for [building
from source code](../parsec_service/build_run.md) and [secure installation on
Linux](../parsec_service/install_parsec_linux.md).

The [Parsec video tutorial
series](https://www.youtube.com/playlist?list=PLKjl7IFAwc4S7WQqqphCsyy6DPDxJ2Skg) demonstrates the
full set of steps needed to build Parsec from source code on a Raspberry Pi, and is applicable to
similar Linux systems.

## Option 4: Include Parsec in a Custom Embedded Linux Distribution using Yocto Project

If you are building a [Yocto](https://www.yoctoproject.org)-based custom Linux distribution and you
wish to include Parsec in your image, refer to the documentation for the
[meta-parsec](https://git.yoctoproject.org/meta-security/tree/meta-parsec/README.md) layer.

*Copyright 2022 Contributors to the Parsec project.*
