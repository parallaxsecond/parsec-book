# The Parsec Release Checklist

The release process is divided into 4 stages as shown below. Each stage has a discrete set of
activities to be completed before progressing to the next stage. The list shown below is only a
template, as there might be additional tasks specific to that release that might be added to
different stages.

Stages:

- Prior to Code freeze
   - [ ]  Publish new versions of all managed crates and configure parsec service and tool to use
      them. See
      this [guide](https://parallaxsecond.github.io/parsec-book/contributing/package_management.html).
   - [ ]  Fix any pending issues
   - [ ]  Check common dependency crates versions between the parsec service, parsec tool, and
      other crates
   - [ ]  Review PRs across Parsec repos
   - [ ]  Merge approved PRs
   - [ ]  Check the milestone list
- During code freeze
   - [ ]  Issue release candidate tag x.x.x-rc1
   - [ ]  OpenSUSE packaging for the RC
   - [ ]  Pull in the latest git dependencies in the crates to ensure the latest release would
      work.
   - [ ]  Execute the normal e2e tests on Raspberry Pi hardware:
      - mbed-crypto
      - TPM
      - Nitrokey HSM (pluggable USB)
   - [ ]  Execute fuzz testing for a week
   - [ ]  Ask the Linux distributions packagers to try the tagged version
   - [ ]  Ask the Parsec Yocto maintainers to try the tagged version
   - [ ]  Ask any interested people to try the tagged version
   - [ ]  Review the book and make sure all pages are up-to-date. In particular, make sure the
      Threat Model is up to date.
   - [ ]  Make sure all the markdown pages (like the README) look good.
   - [ ]  Make sure the rustdoc pages (on docs.rs) are looking good (before and after the release).
   - [ ]  If any bugs are reported, we fix bugs and then issue another release candidate, x.x.x-rcx
   - [ ]  When All reported issues are addressed, make a GitHub release out of the last tag, which
      includes its changelog, and ask maintainers to release this version of Parsec.
- Release
   - [ ]  Push the release tag for the service and the parsec-tool
   - [ ]  Publish the new quickstart bundle and update the quickstart guide with it
- Post-release
   - [ ]  Close issues fixed in the release and the past milestone
   - [ ]  Update, test, and upstream Yocto recipes for Parsec and parsec-tool
   - [ ]  Make a new issue milestone for the next release
   - [ ]  Update the [Roadmap](https://github.com/parallaxsecond/community/blob/main/ROADMAP.md)
   - [ ]  Update the [Parsec Release
      Process](https://parallaxsecond.github.io/parsec-book/contributing/release_process.html) 
      with what we learned.
   - [ ]  If any bugs are reported, make new MINOR or PATCH tags
   - [ ]  Update the Parsec Tool demo

*Copyright 2023 Contributors to the Parsec project.*
