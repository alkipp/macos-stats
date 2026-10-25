# Upstream source

*Verbatim source tree of the Stats app at release `v3.0.23`, vendored here for reading, diffing and patching.*

| Item | Value |
|---|---|
| Project | <https://github.com/exelban/stats> |
| Author | Serhiy Mytrovtsiy |
| License | MIT (see `upstream/LICENSE`) |
| Tag | `v3.0.23` |
| Commit | `5cf09a8cb0561ff24c28be4e5374d579d0601818` |
| Fork | <https://github.com/alkipp/stats> |
| Export | `git archive v3.0.23`, no `.git` directory |
| Volume | 312 files, 7.1 MB |

The tree is unmodified. The installer in `dist/` is the official binary built from exactly this tag; `install.sh` verifies its SHA-256 before installing.

## Build

Building requires Xcode with the macOS SDK – the Xcode Command Line Tools alone are not enough, because the project ships a `.xcodeproj` and widget extensions. Deployment target is macOS 12.0, Swift 5.0.

```bash
open upstream/Stats.xcodeproj   # Cmd+R
```

## Updating

```bash
git -C ../stats fetch --tags origin
git -C ../stats archive vX.Y.Z | tar -x -C upstream
git add upstream && git commit -m "Vendor upstream vX.Y.Z"
```

Then replace `dist/stats-X.Y.Z.dmg`, update the checksum in `install.sh` and `THIRD-PARTY.md`, and adjust the version table in the README.

## Why vendored as well as forked

The fork tracks upstream history and can be rebased or patched. The copy here keeps this repository self-contained: a clone shows the source that produces the binary in `dist/`, without a second checkout.
