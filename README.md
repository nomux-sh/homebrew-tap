# homebrew-tap

The Homebrew tap of nomux: a formula that installs the nomux binaries on macOS and Linux.

This repository is a part of [nomux](https://github.com/nomux-sh), a native and lightweight agentic development environment. Sessions stay alive on the host when the client disconnects.

## Status

In development. Versions earlier than 1.0.0 are pre-releases: interfaces can change between minor versions.

## Install

```sh
brew install nomux-sh/tap/nomux
```

The command adds the tap and installs three binaries: `nomux` (the CLI), `nomuxd` (the daemon) and `nomux-holder` (the session holder). To examine the result:

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

| Host | Archive |
|---|---|
| macOS, Apple silicon | `aarch64-apple-darwin` |
| macOS, Intel | `x86_64-apple-darwin` |
| Linux, aarch64 | `aarch64-unknown-linux-musl` |
| Linux, x86_64 | `x86_64-unknown-linux-musl` |

The Linux binaries are static. They do not use the C library of the host. The formula has no dependencies.

## Where the binaries come from

The formula does not build nomux. It downloads the archive of your platform from a [release of nomux](https://github.com/nomux-sh/nomux/releases). The release workflow of the [`nomux`](https://github.com/nomux-sh/nomux) repository builds the archives from a version tag and publishes a `SHA256SUMS` file with them.

The formula has the SHA-256 checksum of each of the four archives. The values are a copy of the `SHA256SUMS` file of the release. Before Homebrew installs an archive, it calculates the checksum of the download. If the checksum is not the same as in the formula, Homebrew stops and installs nothing.

The macOS binaries have an ad hoc signature from the linker. They do not have a Developer ID signature and Apple did not notarize them: the code signing of nomux starts with the first stable release. Homebrew does not put the quarantine attribute on the files of a formula, thus macOS starts the binaries without a Gatekeeper message. CI showed this on macOS 26 with Apple silicon.

For each pull request, CI downloads all four archives, compares them with the checksums of the formula, then installs and tests the formula on Linux (x86_64) and on macOS (Apple silicon).

## How the formula is updated

The workflow [`update-formula.yml`](.github/workflows/update-formula.yml) runs one time each day. You can also start it by hand: **Actions**, **Update formula**, **Run workflow**.

1. The workflow runs [`scripts/update-formula.sh`](scripts/update-formula.sh). The script reads the releases of nomux from the GitHub API and selects the newest version that has no suffix. A version such as `0.2.0-beta.1` is not a candidate. This is the same rule as in `install.sh` of nomux.
2. If that version is newer than the formula, the script writes the new version and the four checksums from `SHA256SUMS` into the formula.
3. The workflow opens a pull request with the title `build: update nomux to X.Y.Z`. It uses the token of the workflow run and no secret.
4. GitHub does not start the checks of a pull request that this token opens. A maintainer selects **Approve workflows to run**, then merges the pull request when all checks pass.

To update the formula on your computer, run the script from the repository root and open the pull request yourself:

```sh
scripts/update-formula.sh
```

## Development

Refer to [AGENTS.md](AGENTS.md) for the rules of this repository and for the commands that CI runs. The organization rules are in the [contributing guide](https://github.com/nomux-sh/.github/blob/main/CONTRIBUTING.md). To report a vulnerability, obey the [security policy](https://github.com/nomux-sh/.github/blob/main/SECURITY.md).

## License

Licensed under either of [Apache License, Version 2.0](LICENSE-APACHE) or [MIT license](LICENSE-MIT) at your option.
