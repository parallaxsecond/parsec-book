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
# The Parsec Book 📖

![](https://github.com/parallaxsecond/parsec-book/workflows/Continuous%20Integration/badge.svg)
![](https://github.com/parallaxsecond/parsec-book/workflows/Deploy/badge.svg)

Official Parsec documentation source. User, Client and Service developer guides
of the Parsec project.

## Using

Access it online by visiting https://parallaxsecond.github.io/parsec-book

You can also build the book and read it locally with the following steps:

```bash
$ git clone https://github.com/parallaxsecond/parsec-book.git
$ cd parsec-book
$ cargo install mdbook
$ mdbook serve
```

This book uses the [Versioned Markdown](https://github.com/bobertlo/vmd) format which allows
us to use the `vmdfmt` formatting tool. The lines should be wrapped after 100 characters.
If you have the `vmdfmt` command available on the command-line,
```bash
vmdfmt -cols 100 -w -l src/
```
will format in-place all the markdown files in your current directory, and
```bash
$ ./ci/check_format.sh
```
will check if your files are formatted correctly.

## Contributing

Please check the [**Contributing**](CONTRIBUTING.md) to know more about the contribution process.

## License

This book is provided under Apache-2.0. Contributions to this project are accepted under the same license.
