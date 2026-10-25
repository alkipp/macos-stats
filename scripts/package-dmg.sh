#!/usr/bin/env bash
# Creates the versioned image for the current VERSION, drops the legacy
# unprefixed file and keeps at most five repository versions.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

VERSION="$(tr -d '[:space:]' < VERSION)"
APP_VERSION="$(grep -oE '^APP_VERSION="[^"]+"' install.sh | cut -d'"' -f2)"
KEEP=5

TARGET="dist/stats-${APP_VERSION}-macos-stats-${VERSION}.dmg"
LEGACY="dist/stats-${APP_VERSION}.dmg"

info() { printf '  %s\n' "$*"; }
die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

[ -d dist ] || die "dist/ missing"
[ -n "$APP_VERSION" ] || die "APP_VERSION not found in install.sh"

# Pick a source image: prefer an already versioned file, fall back to the
# legacy one that predates this scheme.
if [ ! -f "$TARGET" ]; then
    SOURCE=""
    for candidate in dist/stats-"${APP_VERSION}"-macos-stats-*.dmg; do
        [ -f "$candidate" ] || continue
        SOURCE="$candidate"
    done
    if [ -z "$SOURCE" ] && [ -f "$LEGACY" ]; then
        SOURCE="$LEGACY"
    fi
    [ -n "$SOURCE" ] || die "no image for app version ${APP_VERSION} found in dist/"
    cp -p "$SOURCE" "$TARGET"
    info "created $TARGET from $SOURCE"
else
    info "$TARGET already exists"
fi

# The unprefixed legacy image is never kept.
if [ -f "$LEGACY" ]; then
    rm -f "$LEGACY"
    info "removed legacy $LEGACY"
fi

# Retention: sort by repository version, drop everything beyond KEEP.
WORK="$(mktemp)"
trap 'rm -f "$WORK"' EXIT

for image in dist/stats-"${APP_VERSION}"-macos-stats-*.dmg; do
    [ -f "$image" ] || continue
    version="${image##*-macos-stats-}"
    version="${version%.dmg}"
    key="$(printf '%s' "$version" | awk -F. '{printf "%05d%05d%05d", $1, $2, $3}')"
    printf '%s\t%s\n' "$key" "$image" >> "$WORK"
done

TOTAL="$(wc -l < "$WORK" | tr -d ' ')"
if [ "$TOTAL" -gt "$KEEP" ]; then
    REMOVE=$((TOTAL - KEEP))
    sort -k1,1 "$WORK" | awk -v limit="$REMOVE" 'NR <= limit {print $2}' | while IFS= read -r old; do
        rm -f "$old"
        info "removed $old (beyond the last ${KEEP} versions)"
    done
fi

info "images in dist/:"
{ ls -1 dist/*.dmg 2>/dev/null || true; } | sed 's/^/    /'
