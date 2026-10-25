# Contributing

*Short version: keep the installer reproducible, keep the documentation true, keep secrets out.*

## What this repository is

`macos-stats` packages the menu bar monitor **Stats** for one Mac mini: the unmodified release image in `dist/`, the installer and uninstaller, the module key reference and the provenance notes. The application source is **not** developed here – it lives in the fork [`alkipp/stats`](https://github.com/alkipp/stats), which also carries the quality and design reports.

* `upstream/` is a verbatim export of the upstream tag. Do not edit it; it exists so the delivered binary can be traced to a commit.
* Changes to the scripts or the documentation are welcome here.
* Changes to the app belong in the fork.

## Before opening a pull request

```bash
bash -n install.sh uninstall.sh
shellcheck install.sh uninstall.sh
```

The CI additionally checks that the version and SHA-256 pinned in `install.sh` match the image in `dist/`, lints the workflows and the Markdown, and verifies that no documentation links point at local absolute paths.

## Rules

1. Work on a branch (`feat/…`, `fix/…`, `docs/…`), never directly on `main`.
2. One topic per pull request.
3. English for everything that lands in the repository – code comments, commit messages, documentation, issue text.
4. No secrets. Not in code, not in logs, not in commit messages. The installer never stores credentials.
5. If a change alters behaviour, update the documentation in the same pull request.

## Commit messages

Imperative subject line, up to about 70 characters, then a blank line and a body that explains *why*. Example:

```
Verify the pinned image in CI

The installer trusts a hard-coded checksum, so a replaced image would go
unnoticed until install time. CI now compares the hash against dist/.
```

## Reporting problems

* Bugs and feature requests: use the issue templates.
* Security: see [SECURITY.md](SECURITY.md) – private advisory, not a public issue.
* Questions about the app itself belong in the [upstream project](https://github.com/exelban/stats).
