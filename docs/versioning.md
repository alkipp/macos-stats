# Versioning

*Every change to this repository gets a version. The rules are short and the CI enforces them.*

## Scheme

[Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html), stored in the `VERSION` file – one line, `MAJOR.MINOR.PATCH`, no `v` prefix.

| Part | Bump when |
|---|---|
| **MAJOR** | the installer or a documented workflow stops working for existing users: dropped module keys, a new minimum macOS, a changed directory layout, a removed script |
| **MINOR** | something new appears: a module key, a script option, a documented capability, a new automation that users can trigger |
| **PATCH** | nothing user-visible changes: fixes, typos, documentation, CI, refactoring, dependency bumps of the workflows |

`VERSION` is the version of **this repository**. It is not the version of the application: that one lives in `install.sh` as `APP_VERSION` and is shipped in `dist/`. The two are deliberately separate – `macos-stats 1.4.0` may well ship `Stats 3.0.23`.

## Every change

1. Bump `VERSION` according to the table above.
2. Add or extend the matching section in `CHANGELOG.md`: `## [X.Y.Z] - YYYY-MM-DD`, categories from Keep a Changelog (`Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`).
3. Open the pull request. The **Version** job fails if `VERSION` still equals the base branch or the changelog section is missing, and the branch protection blocks the merge.
4. Merge, then tag the merged commit: `git tag -a vX.Y.Z -m "…" && git push origin vX.Y.Z`. The **Version** job fails the tag push if the tag and `VERSION` disagree.

```bash
# a patch change
echo 1.0.1 > VERSION
$EDITOR CHANGELOG.md
git add VERSION CHANGELOG.md
```

## Image and retention

The installer never refers to a bare app version. The image in `dist/` is named

```text
stats-<APP_VERSION>-macos-stats-<VERSION>.dmg
```

`scripts/package-dmg.sh` creates that file for the current `VERSION` and keeps the last **five** repository versions. Everything older is deleted, including the old unprefixed `stats-<app>.dmg`. The CI fails when there are more than five images or when a file does not follow the pattern.

## Releases

A tag `vX.Y.Z` triggers `.github/workflows/release.yml`, which attaches `dist/*.dmg` and `SHA256SUMS.txt` to the release. The release is labelled with the repository version; the release notes state which app version the image contains.

## History

| Tag | Meaning |
|---|---|
| `v3.0.23` | legacy: names the shipped app version, created before this scheme existed. Do not use it as a template. |
| `v1.0.0` and later | a release of this repository, `VERSION` at the time of tagging |

## Why the strictness

A packaging repository without versions cannot answer the only question that matters when something breaks: *which state of the scripts produced this install?* The `Version` job makes the answer cheap – the tag, `VERSION`, the changelog section and the release assets always agree.
