# Package management and versioning guide

This page presents the details around packaging management and versioning for Parsec-related
repositories. Currently our repos are mainly Rust crates, so this guide is accordingly geared
towards them - when other guidelines become relevant, e.g. specific to Go libraries, new sections
should be added below.

The following points are relevant to all software we publish to package management repositories:

- For published versions of a project a tag carrying the version number should be upstreamed to
   GitHub, e.g. if version 2.3.1 was published, a tag named "2.3.1" must be added to the commit in
   GitHub.
- If multiple projects that end up in a package manager reside in the same repo, the tags should
   reflect both the project and the version number, e.g. if version 2.3.1 of project X was
   published, a tag named "X-2.3.1" or similar must be used.
- Projects should follow [Semantic Versioning](https://semver.org/) rules.
- Following the release of a new version of publicly-facing projects, update the `CHANGELOG.md`
   file. For some projects it's also advised to create a GitHub Release from the tag mentioned
   above.

## Rust crates

The process around publishing Rust crates is tightly linked with crates.io. In order to publish or
have control over crates, you must own an account on the website. Before you decide whether you want
to publish a crate, check out the [Dependency management](#dependency-management) section below.

- Follow the instructions [here](https://doc.rust-lang.org/cargo/reference/publishing.html) to
   create your account and to set your workspace up.
- If you'd like to publish a new version of an existing crate using the ownership granted to the
   Parallaxsecond Admin group, you need to enable crates.io to access that organisation. You can do
   so from the [applications page](https://github.com/settings/applications) in your account
   settings - in the [crates.io
   application](https://github.com/settings/connections/applications/9fe8110dfe185fe90b5c) settings
   you must request permission for the parallaxsecond org to be linked. One of the org owners must
   approve that request.
- Alternatively, if you'd like to publish a new version but are not part of the Admin group, you can
   request to become an owner of the crate from one of the admins.

Once you are able to publish crates you can start doing so, but being aware of the following facts
is helpful.

- If the crate you are publishing is new or has major changes in its build steps, its documentation
   might not be built properly by docs.rs. This is because docs.rs has its own build system where
   crates are built in complete isolation from the internet and with a set of dependencies that
   might not cover the ones you require. Check out their documentation
   [here](https://docs.rs/about/builds).
- Once you have settled on a crate to upstream, make sure you are on the most recent version of the
   main branch (e.g. `master`) - you should have no uncommited changes lingering.
- Run a `cargo publish --dry-run` - this ensures that the publishing process is possible with the
   current state of the repo.
- Change the version number of the crate in `Cargo.toml` following semantic versioning rules.
- If any other (small) changes must be made, such as updating a dependency, you can also add them in
   this commit. No specific limit is given to "small", but if the dependency update includes changes
   to an API or to how some internal components work, then a separate pull request is needed.
- Commit the previous changes and either upstream them directly to the main branch or create a pull
   request.
- Once the version change is on the main branch, run another dry-run publishing, followed by the
   real operation. Once that is complete, tag the latest commit and upstream the tag.
- Repeat these steps for every crate along the way in the dependency tree.

### Dependency management

Producing a release of the Parsec service requires some understanding of the way in which all the
components, and especially the various crates found under the Parallaxsecond organization, relate to
each other. You can find some details of the code structure
[here](../parsec_service/source_code_structure.md). A detailed list of direct dependencies to
Parallaxsecond crates that can be found on crates.io is given below.

`parsec-service` dependencies:

- `parsec-interface`: used for managing IPC communication
- `psa-crypto`: used in the Mbed Crypto provider as the interface to a PSA Crypto implementation
- `tss-esapi`: used in the TPM provider as the interface to the TSS stack
- `parsec-client`: **NOT** used in the service, but as a dependency for the test client

`parsec-interface` dependencies:

- `psa-crypto`: used to represent the Rust-native PSA Crypto data types

`parsec-client` dependencies:

- `parsec-interface`: used for managing IPC communication

`parsec-tool` dependencies:

- `parsec-client`: used to handle all communication with the service

Publishing new versions of dependencies is not always required. If you're not planning to
immediately publish some crate, then you don't *need* to publish any of its dependencies, you can
simply import updates, using the
[`git`](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html#specifying-dependencies-from-git-repositories)
syntax, as transient dependencies in `Cargo.toml`. By doing so, however, you're removing the option
of publishing to crates.io until all those `git` dependencies are removed. Because of this issue we
suggest adding transient dependencies to crates not residing under the Parallaxsecond organization
only when a published version of the third party crate is due soon. This is to limit the likelihood
of an urgent release of Parsec being stalled behind a third-party release cycle. If you're unsure
about or would want to discuss such an approach, we welcome discussions and proposals in our
community channels!

*Copyright 2021 Contributors to the Parsec project.*
