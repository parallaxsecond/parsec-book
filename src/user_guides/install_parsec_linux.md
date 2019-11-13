<!--
  -- Copyright (c) 2019, Arm Limited, All Rights Reserved
  -- SPDX-License-Identifier: Apache-2.0
  --
  -- Licensed under the Apache License, Version 2.0 (the "License"); you may
  -- not use this file except in compliance with the License.
  -- You may obtain a copy of the License at
  --
  -- http://www.apache.org/licenses/LICENSE-2.0
  --
  -- Unless required by applicable law or agreed to in writing, software
  -- distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
  -- WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  -- See the License for the specific language governing permissions and
  -- limitations under the License.
--->

# How to install Parsec on Linux

Parsec can be built and installed as a Linux daemon using systemd. The Parsec daemon uses socket
activation which means that the daemon will be automatically started when a client request is
made on the socket. The daemon is a systemd user daemon run by the `parsec` user.

If your Linux system uses systemd to manage daemons, you can follow these steps.

* Create and log in to a new user named `parsec`
* In its home directory, pull and install Parsec as a daemon
```bash
git pull https://github.com/parallaxsecond/parsec.git
cargo install --path parsec
```
* Install the systemd unit files and activate the Parsec socket
```bash
mkdir -p ~/.config/systemd/user
cp -r systemd-daemon/parsec.service systemd-daemon/parsec.socket ~/.config/systemd/user
systemctl --user enable parsec.socket
systemctl --user start parsec.socket
```

Every user on the system can now use Parsec!

You can test it going inside the `parsec` directory and:
```bash
cargo test --test normal
```
Check the Parsec logs with:
```bash
journalclt --user -u parsec
```
