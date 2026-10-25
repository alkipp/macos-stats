# Changelog

All notable changes to this repository. Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html). See [docs/versioning.md](docs/versioning.md) for what counts as major, minor and patch.

## [Unreleased]

## [1.2.1] - 2026-10-25

### Fixed

- The release attached every image in `dist/` instead of the one for its version. The workflow now selects `stats-<app>-macos-stats-<VERSION>.dmg` and checksums only that file.

## [1.2.0] - 2026-10-25

### Added

- **Release retention**: after publishing, the workflow deletes all but the five newest releases, so the downloadable images do not pile up. Tags are kept as history.

### Notes

- The legacy release `v3.0.23` (the pre-scheme naming, same image) was removed; its tag stays for traceability.

## [1.1.0] - 2026-10-25

### Added

- **Versioned image**: the DMG is named `stats-<app version>-macos-stats-<repository version>.dmg`, created by `scripts/package-dmg.sh`, and referenced by the installer through `REPO_VERSION`.
- **Retention**: at most five images stay in `dist/`; older ones are removed, and the unprefixed legacy image is dropped. CI fails if the count or the naming pattern drifts.

## [1.0.0] - 2026-10-25

### Added

- Installer and uninstaller with a pinned release image and SHA-256 verification.
- Module key reference in `docs/module-keys.md`, provenance notes in `docs/upstream.md`.
- Security policy with the advisory channel and the status of CVE-2025-21606.
- CI: shell syntax, ShellCheck, pinned-image verification, workflow lint, Markdown lint.
- CodeQL for the workflows and an OpenSSF Scorecard run.
- Dependabot for GitHub Actions, issue and pull request templates, CODEOWNERS.
- **Versioning scheme** with a `VERSION` file, changelog discipline and CI enforcement (`Version` job).
- Release checklist in `CONTRIBUTING.md`.
- Tag protection ruleset for `v*`.

### Changed

- Repository content translated to English; the preview image replaced by an English rendering.
- README gained security and maintainer sections; the licence names the maintainer of this repository.
- `install.sh` names the app version `APP_VERSION` and its checksum `APP_SHA256`, so the package version and the shipped app version cannot be confused.

### Notes

- The application source of the delivered image is the unmodified upstream release `v3.0.23` (MIT). Attribution stays in `THIRD-PARTY.md` and `upstream/LICENSE`.
- The tag `v3.0.23` predates this scheme: it names the app version, not a release of this repository.
