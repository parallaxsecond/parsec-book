# The Parsec Release Process

This page describes the process by which the Parsec project is released, and sets expectations
around the schedule of releases so that consumers know when to expect them.

## Release Schedule

The Parsec project aims to make major releases twice a year: in early March and early September.
Precise dates are agreed by the maintainers and the project community on each cycle. A fixed release
cadence helps with the process of packaging Parsec releases into Operating System distributions and
other downstream consumers.

This page focuses on the process for twice-yearly major releases. Naturally, it is expected that
minor point releases will also take place to address defects or to add other improvements that are
needed urgently and cannot wait for the next major cycle. A fixed process for such point releases
has not yet been established, but this will be determined according to which practices appear to
work well within the project community.

## Responsibility for Releases

It is the collective responsibility of the [Parsec project
maintainers](https://github.com/parallaxsecond/parsec/blob/main/MAINTAINERS.toml) to ensure that
Parsec releases are made according to the schedule and process outlined on this page. However, all
project contributors have a role to play in ensuring that the release cycles are timely and
successful. All contributors are encouraged to familiarise themselves with the release process, and
all are expected to abide by its associated rules.

## Release Roadmap

A public roadmap for the Parsec project is under construction. In the meantime, the [Project
dashboard](https://github.com/orgs/parallaxsecond/projects/1) can be used to track the items that
are being prepared for the next release. Use the
[milestones](https://github.com/parallaxsecond/parsec/milestones) to filter the dashboard view in
order to see the issue tickets that have been targeted for each release.

Please be aware that the content of a release cannot be guaranteed. In order to ensure a fixed
release schedule, it is sometimes necessary to modify the scope of each release. The project
dashboard always provides the best available indication of the current plan.

## Released Components

A Parsec release always includes the following two components, which are released together as a
pair:

- The [Parsec service](https://github.com/parallaxsecond/parsec), which is the primary component of
   the project, and is the daemon that provides security services to client applications and
   interfaces with the secure hardware facilities of the host platform.
- The [Parsec tool](https://github.com/parallaxsecond/parsec-tool), which is a command-line tool
   that allows the functionality of the service to be accessed easily from shell environments and
   scripts.

Both of these components are included because they are both built from Rust and share a common set
of dependencies. A coordinated release allows for the versions of the shared Rust crates to be kept
synchronized. These two components are also both commonly packaged for Operating System
distributions.

Additionally, each release includes a convenient
[quickstart](https://parallaxsecond.github.io/parsec-book/getting_started/linux_x86.html) package,
which contains the binaries for just the Parsec service and the Parsec tool, along with a basic
configuration file and a README document with a link to the quickstart guide. This is to help new
users gain some early familiarity with the system.

Other components of the Parsec project, such as documentation and client libraries in languages
other than Rust, are currently not included in the scheduled release cadence. These components are
instead being released according to their own separate schedules. The release processes and timings
for those components are not described on this page.

## Release Version Numbering

The many components and repositories that make up the Parsec project all have their own version
numbering schemes, which are not necessarily aligned with each other. However, since the primary
component of the Parsec project is the Parsec service, it is the version number of the Parsec
service that is used to denote the version number of each Parsec release.

For example, the Parsec `0.7.0` release, which was made in March 2021, was so called because the
Parsec service was at version `0.7.0` for that particular release, even though the Parsec tool was
at `0.3.0`, and the various other component repositories were tagged according to their own schemes.

## Common Rust Dependencies

All of the Rust crates that make up a Parsec release will be published at a single common version
number for the release. This is to ensure that the Parsec service and Parsec tool will always be
consuming a single common version of each crate. Having multiple versions of the same crate in a
single release makes it difficult for packaging the release into Operating System distributions, and
so this is avoided.

For example, the Parsec `0.7.0` release was composed from version `0.7.0` of the Parsec service, and
`0.3.0` of the Parsec tool. The
[parsec-interface-rs](https://github.com/parallaxsecond/parsec-interface-rs) crate is consumed into
both of these components. Its version was set at `0.24.0`, and this single common version was
consumed into both the Parsec service and the Parsec tool for the combined `0.7.0` release. A
similar strategy was adopted for other common Rust crates in the project.

For more information about the Rust crate dependencies, including full details on how to release
them individually, please refer to the [Package Management and Versioning
Guide](package_management.md).

## Release Codenames

The Parsec project does not employ codenames for releases. Future releases are simply named
according to the expected version number of the Parsec service.

## Code Freeze and Release Branching

Shortly before each Parsec release, a code freeze will be put into effect, and a release branch will
be cut from main. Precise details around code freezing and branching will be communicated through
the community channels by the maintainers on each release cycle. Branching details may vary, and not
all repositories will necessarily be branched for every release.

Code freeze dates may also vary depending on the content of each release. Typically, a code freeze
will occur at around 2-4 weeks before the target release date.

During the code freeze period, code submissions will only be accepted if they address critical
defects or other issues that are blocking the release.

Shortly after the code freeze date, a release candidate will be published for each of the Parsec
service and Parsec tool. The availability of this release candidate will be communicated to
downstream consumers such as Operating System maintainers, giving them the opportunity to perform
integration testing before the release is finalized.

## Testing of Releases

In addition to the regular CI tests, contributors and integrators are invited to perform their own
targeted testing ahead of each release. For example, if a contributor has developed a feature that
requires testing with a specific hardware platform or configuration, then they would be expected to
perform whatever testing is necessary to verify that the new feature has reached a sufficient
quality level for the release. Systems integrators and known adopters of Parsec will also be
notified that a new release is available for integration testing.

As part of the release testing, we run the end-to-end tests on a RaspberryPi for the following
backends:

- mbed crypto
- TPM
- Nitrokey HSM

Further platforms and backends will be added to this in future releases. The results of the release
testing are critical in determining if the parsec service and the tool are ready for release, and
whether they meet the requirements and expectations of the end users. Any regressions will result in
the creation of a new GitHub issue and will be flagged to the community for assessment as to whether
it is a blocking issue for the release.

## Release Expectations

Formal release expectations are still to be determined but all releases should follow the [Parsec
Release Checklist](https://parallaxsecond.github.io/parsec-book/contributing/release_checklist.html)
and enure that the new release works on a fixed set of platforms. Parsec is a public open source
project and it can be used in a variety of contexts. It is the responsibility of the system
integrator or Parsec adopter to ensure its suitability for use in any product or other context. Any
questions around specific expectations and requirements can be raised with the Parsec maintainers
through the available [community channels](https://github.com/parallaxsecond/community).

## Feature Branches

For complex features whose development is likely to go beyond the code freeze date for the next
scheduled release, the use of feature branches may be appropriate, and this can be agreed between
the relevant contributors and project maintainers on a case-by-case basis. It is not always
necessary to use a feature branch. However, if any partially-complete features are merged into the
main branch, this *must* be done in a way that does not disrupt the release process. To ensure this,
please abide by the following rules:

- Use [Cargo features](https://doc.rust-lang.org/cargo/reference/features.html) to allow the changes
   to be compiled conditionally, and ensure that any new dependencies are made optional and
   conditional on the Cargo features.
- Avoid the use of [Git
   dependencies](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html#specifying-dependencies-from-git-repositories)
   in the main branch of Parsec repositories. Git dependencies are sometimes appropriate and useful
   in feature branches, but they should be avoided in main branches where possible. Git dependencies
   block the release process, and they must always be replaced with numbered crate versions well
   before the next code freeze period.
- Ensure that all relevant Continuous Integration tests are passing for code that is promoted to
   main branches.

If you are planning to contribute a significant feature or major architectural change, please
contact the maintainers via the available community channels, such as the Slack channel or the
weekly meetings. Please see the [community](https://github.com/parallaxsecond/community) repository
for more details. The project maintainers will be available to advise you on whether to use a
feature branch.

When using feature branches, please ensure that commits are reviewed by the project maintainers
through the pull request process at suitable intervals, so that reviews can be kept small and
manageable. Do not wait until the entire feature is complete before requesting code reviews, since
large and bulky code reviews are generally not well received by the maintainers, and this might
delay the approval of changes.

To keep the repositories tidy, the maintainers will aim to delete feature branches as soon as
possible after the code changes have been promoted into the mainline. Please contact the maintainers
through the community channels to request the deletion of a feature branch.

*Copyright 2021 Contributors to the Parsec project.*
