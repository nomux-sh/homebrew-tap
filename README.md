# homebrew-tap

The Homebrew tap of nomux: a formula that installs the nomux binaries on macOS and Linux.

This repository is a part of [nomux](https://github.com/nomux-sh), a native and lightweight agentic development environment. Sessions stay alive on the host when the client disconnects.

## Status

In development. Versions earlier than 1.0.0 are pre-releases: interfaces can change between minor versions.

## Install

```sh
brew install nomux-sh/tap/nomux
```

The command adds the tap and installs three binaries: `nomux` (the CLI), `nomuxd` (the daemon) and `nomux-holder` (the session holder). Homebrew installs a bottle, thus the install does not need Xcode or the Command Line Tools on a Mac with Apple silicon, and does not need current ones on an Intel Mac. To examine the result:

```sh
nomux --version
```

Homebrew 6.0.0 and later versions load a formula of a tap that is not from Homebrew only after you trust it. An install with the full name `nomux-sh/tap/nomux` trusts this one formula. Refer to [Tap Trust](https://docs.brew.sh/Tap-Trust) in the Homebrew documentation.

The [README of nomux](https://github.com/nomux-sh/nomux#readme) tells you how to start a session.

## Upgrade

```sh
brew update
brew upgrade nomux-sh/tap/nomux
```

`brew update` gets the newest formula from this repository. `brew upgrade` installs the new version.

## Uninstall

```sh
brew uninstall nomux-sh/tap/nomux
brew untap nomux-sh/tap
```

The first command removes the binaries. The second command removes the tap. A daemon or a session that runs at that time does not stop. To stop the daemon before the uninstall, run `nomux daemon stop`.

## Platforms

| Host | Archive | Bottle |
|---|---|---|
| macOS 11 or later, Apple silicon | `aarch64-apple-darwin` | `arm64_big_sur` |
| macOS 11 or later, Intel | `x86_64-apple-darwin` | `big_sur` |
| Linux, aarch64 | `aarch64-unknown-linux-musl` | `arm64_linux` |
| Linux, x86_64 | `x86_64-unknown-linux-musl` | `x86_64_linux` |

The Linux binaries are static. They do not use the C library of the host. The formula has no dependencies.

## Where the binaries come from

The formula does not build nomux. It downloads the archive of your platform from a [release of nomux](https://github.com/nomux-sh/nomux/releases). The release workflow of the [`nomux`](https://github.com/nomux-sh/nomux) repository builds the archives from a version tag and publishes a `SHA256SUMS` file with them.

The formula has the SHA-256 checksum of each of the four archives. The values are a copy of the `SHA256SUMS` file of the release. Before Homebrew installs an archive, it calculates the checksum of the download. If the checksum is not the same as in the formula, Homebrew stops and installs nothing.

Homebrew installs a formula that has no bottle as a build from source. Before a build from source, Homebrew stops if the Xcode or the Command Line Tools of the Mac are missing or older than the minimum for the macOS version, also when the formula compiles nothing ([issue #5](https://github.com/nomux-sh/homebrew-tap/issues/5)). Thus the formula has a bottle for each platform. A bottle contains the three binaries of the release archive without a change, and the files that Homebrew adds to each installation. The workflow `update-formula.yml` makes the bottles with `brew bottle` and attaches them to the release `nomux-X.Y.Z` of this repository. The formula has the SHA-256 checksum of each bottle.

A Homebrew bottle for macOS has the tag of a macOS version, and Homebrew installs it on that version and on later versions. The macOS binaries need macOS 11.0 or later, thus the bottles have the tag of macOS 11 (`big_sur`). If no bottle agrees with the computer, Homebrew installs the archive as before and needs current developer tools.

On an Intel Mac, Homebrew requires Xcode or the Command Line Tools of some version also for a bottle. A Mac with Apple silicon needs neither.

The macOS binaries have an ad hoc signature from the linker. They do not have a Developer ID signature and Apple did not notarize them: the code signing of nomux starts with the first stable release. Homebrew does not put the quarantine attribute on the files of a formula, thus macOS starts the binaries without a Gatekeeper message. CI showed this on macOS 26 with Apple silicon.

For each pull request, CI downloads all four archives and the bottles, compares them with the checksums of the formula, then installs and tests the formula on Linux (x86_64 and aarch64) and on macOS (Apple silicon and Intel). Before the install on macOS, CI writes an old version into the package receipt of the Command Line Tools. CI shows that a build from source stops, that the install of the bottle succeeds, and that `nomux new` and `nomux ls` work.

## How the formula is updated

The workflow [`update-formula.yml`](.github/workflows/update-formula.yml) runs one time each day. You can also start it by hand: **Actions**, **Update formula**, **Run workflow**.

1. The workflow runs [`scripts/update-formula.sh`](scripts/update-formula.sh). The script reads the releases of nomux from the GitHub API and selects the newest version that has no suffix. A version such as `0.2.0-beta.1` is not a candidate. This is the same rule as in `install.sh` of nomux.
2. If that version is newer than the formula, the script writes the new version and the four checksums from `SHA256SUMS` into the formula and removes the `bottle` block.
3. If the formula has no `bottle` block, one job on each of the four platforms installs the formula and makes its bottle with `brew bottle`. A different job attaches the bottles to the release `nomux-X.Y.Z` of this repository and writes the `bottle` block into the formula.
4. The workflow opens a pull request with the title `build: update nomux to X.Y.Z`. It uses the token of the workflow run and no secret.
5. GitHub does not start the checks of a pull request that this token opens. A maintainer selects **Approve workflows to run**, then merges the pull request when all checks pass.

A release of nomux needs no other step. To see the change of the formula without a release and a pull request, start the workflow by hand and select **dry-run**. The workflow then makes the bottles and shows the change in the log of the `publish` job.

If you start the workflow on a branch that is not `main`, the workflow adds the commit to that branch and opens no pull request. Use this after a change to the installed files: delete the `bottle` block, push the branch, then start the workflow on it.

## Development

Refer to [AGENTS.md](AGENTS.md) for the rules of this repository and for the commands that CI runs. The organization rules are in the [contributing guide](https://github.com/nomux-sh/.github/blob/main/CONTRIBUTING.md). To report a vulnerability, obey the [security policy](https://github.com/nomux-sh/.github/blob/main/SECURITY.md).

## License

Licensed under either of [Apache License, Version 2.0](LICENSE-APACHE) or [MIT license](LICENSE-MIT) at your option.
