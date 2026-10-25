# Changelog

All notable changes to this repository. Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [2026.10.25]

### Added

- Installer and uninstaller with a pinned release image and SHA-256 verification.
- Module key reference in `docs/module-keys.md`, provenance notes in `docs/upstream.md`.
- Security policy with the advisory channel and the status of CVE-2025-21606.
- CI: shell syntax, ShellCheck, pinned-image verification, workflow lint, Markdown lint.
- CodeQL for the workflows and an OpenSSF Scorecard run.
- Dependabot for GitHub Actions, issue and pull request templates, CODEOWNERS.

### Changed

- Repository content translated to English; the preview image replaced by an English rendering.
- README gained security and maintainer sections; the licence names the maintainer of this repository.

### Notes

- The application source of the delivered image is the unmodified upstream release `v3.0.23` (MIT). Attribution stays in `THIRD-PARTY.md` and `upstream/LICENSE`.
