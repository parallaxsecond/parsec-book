<!--
  -- Copyright (c) 2020, Arm Limited, All Rights Reserved
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

# Developer guides

These notes are meant as a guide for those looking to work hands-on with the Parsec service source code. They cover the following concepts:

* [Building](build.md) - description of the options that can be used for building the service and how they relate to the build environment
* [Testing](test.md) - details about the kinds of tests we employ and how to set up your environment in preparation for running them
* [Writing a client](writing_library.md) - guide for implementing a new client library
* [Writing a provider](adding_provider.md) - guide for implementing a new provider that will add Parsec support for new platforms