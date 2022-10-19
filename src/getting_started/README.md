# Getting Started With Parsec

## Welcome!

Welcome to the Parsec Getting Started guide. Take a look through the headings below and follow the
links that best describe what you would like to do.

## I Want to Check if Parsec is Running

The [installation guide](installation_options.md) includes a quick method that you can use to see if
Parsec is already installed and running on your system.

## I Want to Install the Parsec Service

There are a few different ways to get the Parsec service up and running on your system. You may be
able to install via your package manager, or use a different method. Go
[here](installation_options.md) to check out your installation options.

## I Want to Use Parsec API's in My Own Code

You can consume Parsec API's in several programming languages. You can learn how to do this
[here](../parsec_users.md).

## I Want to Use Parsec from the Command Line

Take your first steps with Parsec using the command-line `parsec-tool`. Follow our [familiarisation
guide](parsec_tool_use.md) to learn how to use the tool to check the service configuration, create
key pairs, sign/decrypt messages and create certificate requests.

## I Want to Understand How Parsec Works Internally

If you want to understand the internal details of Parsec, including the structure of the project
source code, then the best place to start is the [service developer
guide](../parsec_service/README.md).

## I Want to Create a New Parsec Client Library

Fantastic! Parsec client libraries in new programming languages are always welcomed by the
maintenance team and the community. Head over to the [client developer
guide](../parsec_client/README.md) and learn how to get started.

## I Want to Make Sure that My Parsec Installation Is Secure

Read the procedure for [creating secure installations](../parsec_service/install_parsec_linux.md) to
learn the steps for setting up a secure deployment. If you have installed Parsec using a package
manager, then these steps should already have been followed by the installation scripts on your
system, and there should be nothing more to do. However, you can also use the [secure deployment
guide](../parsec_security/secure_deployment.md) to ensure that your system is installed according to
best practices.

## I Want to Configure the Correct Hardware Back-End for My Device

Parsec back-end modules are known as *providers*. Default installations of Parsec use a
software-based provider, also known as the Mbed provider, which is very simple to use but does not
integrate with the secure hardware that you might have on your device. Follow the [configuration
guide](../parsec_service/configuration.md) to learn how to edit Parsec's configuration file to
select the right kind of provider. You can also learn how to set up and use the different providers
[here](../parsec_service/providers.md).

If you are not sure how your Parsec service is configured, or whether it is using a hardware
back-end, the [command-line tooling guide](parsec_tool_use.md) has some steps to help you check
this.

## I Want to Get Involved With the Parsec Community

We will be delighted to have you! Head over to our
[community](https://github.com/parallaxsecond/community) repository to discover how to join and
contribute to the Parsec conversation on Slack, Zoom and GitHub.

*Copyright 2021 Contributors to the Parsec project.*
