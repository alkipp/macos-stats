# Security policy

*How to report a problem in this repository or in the Stats fork.*

## Scope

- **This repository** contains installation scripts, documentation and the unmodified official release image (`dist/stats-3.0.23.dmg`). The application code is not modified here.
- **The fork** at <https://github.com/alkipp/stats> carries the source tree plus local patches (see `docs/quality.md` there). No binaries are published from the fork.

## Reporting

Please use GitHub's private vulnerability reporting instead of a public issue:

- Repository and scripts: <https://github.com/alkipp/macos-stats/security/advisories/new>
- Forked source: <https://github.com/alkipp/stats/security/advisories/new>

Include the affected version, macOS version and a reproduction. If the issue is in the upstream application and not in the patches applied here, it will be forwarded to <https://github.com/exelban/stats> as well.

## Known advisories

| Advisory | Affects | Status |
|---|---|---|
| CVE-2025-21606 / GHSA-qwhf-px96-7f6v – local privilege escalation through an exposed XPC method | Stats up to v2.11.20, fixed in v2.11.21 | Not affected: the bundled image is 3.0.23. The XPC service belongs to the SMC helper, which is only installed when fan control is enabled – not used in this setup |

Dependency surface is empty: no Swift Package Manager, CocoaPods or Carthage manifests, and the application bundle contains no third-party frameworks.

## Response

Maintained by Alexander Kippar on a best-effort basis, no guaranteed SLA. Reports are acknowledged in the advisory thread.
