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
- If the crate you are publishing is new or has major changes in its build steps, its documentation
   might not be built properly by docs.rs. This is because docs.rs has its own build system where
   crates are built in complete isolation from the internet and with a set of dependencies that
   might not cover the ones you require. Check out their documentation
   [here](https://docs.rs/about/builds). If you want to be extra-careful and sure that your
   documentation will build successfully, you can set up a local `docs.rs` and attempt to build your
   crate. You can find the instructions
   [here](https://github.com/rust-lang/docs.rs#getting-started). Follow them up to setting up the
   external services, then run the command for building a local crate from
   [here](https://github.com/rust-lang/docs.rs#build-subcommand). Be advised that setting up the
   docs.rs build locally requires 10 GiB of disk space (or more) and is quite slow the first time
   around, but caching helps with subsequent builds. It is therefore not recommended for CI runs,
   though manually triggered builds might be ok. Also be advised that even if the build fails, the
   command itself will **not** fail - instead, you have to either visually check that the crate was
   built successfully, or to look for a string marking a successful build, e.g. `cargo run -- build
   crate tss-esapi-sys 0.1.1 2>&1 >/dev/null | grep "\[INFO\] rustwide::cmd: \[stderr\] Finished
   dev"`.

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

### Docker images

End-to-end testing for the Parsec service (and for some of the other projects under the
Parallaxsecond organisation) is built on top of Docker images. These images are required because of
the multitude of dependencies needed, generally for connecting to various backends through 3rd party
libraries. The Docker images separate the process of setting up this environment from the actual
running of tests, allowing very short CI runs.

Our Docker images are stored as [packages](https://github.com/orgs/parallaxsecond/packages) within
the [Github Container
Registry](https://docs.github.com/en/packages/guides/container-guides-for-github-packages). The ones
used for the service have [their own
folder](https://github.com/parallaxsecond/parsec/tree/main/e2e_tests/docker_image).

The process for updating an existing image (or indeed creating a new one) goes as follows:

- Figure out if what you need should be included in a Docker image. Anything that is sure to be
   common between builds should be included: compilers, toolchains, libraries...
- Modify or create a new Docker image. This involves not just the development side, but also
   building the image and testing locally that your expected flow works correctly.
- Modify any CI-related files to set up workflows to build the image and to perform any new actions
   with it (if necessary). You should also include changes to the rest of the code-base that
   produced the need for the image change.
- Create a PR with your changes. This allows other reviewers to provide feedback on the image
   definition before it is published. Once the changes are approved you can continue to the next
   step.
- Build the image with the correct tag: for images stored in Github Container Registry, the tag
   should be `ghcr.io/parallaxsecond/<your-image-name>:latest`.
- Create a Github Personal Access Token for publishing the image, as described
   [here](https://docs.github.com/en/packages/guides/pushing-and-pulling-docker-images). Follow the
   steps on the page to then publish your image.
- If this is a new image being published, after the upload succeeds, follow the steps
   [here](https://docs.github.com/en/packages/guides/configuring-access-control-and-visibility-for-container-images#configuring-access-to-container-images-for-an-organization)
   to allow the `parallaxsecond/admin` group admin access to the image. If you are using the image
   in CI builds, you will also need to [make it
   public](https://docs.github.com/en/packages/guides/configuring-access-control-and-visibility-for-container-images#configuring-visibility-of-container-images-for-an-organization).
- Change the workflows to use the published image and update the PR.

*Copyright 2021 Contributors to the Parsec project.*
