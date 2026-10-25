#!/usr/bin/env bash
# Installs Stats from the bundled DMG and enables the menu bar modules.
# No sudo required, no network access.
set -euo pipefail

VERSION="3.0.23"
SHA256="016517d559251f486aa0a47549de34c7dff56102392fa6273a58b0b2b815f392"
APP="/Applications/Stats.app"
DOMAIN="eu.exelban.Stats"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DMG="${SCRIPT_DIR}/dist/stats-${VERSION}.dmg"

info() { printf '  %s\n' "$*"; }
die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || die "macOS only"
[ -f "$DMG" ] || die "image not found: $DMG"

printf 'Installing Stats %s\n' "$VERSION"

actual="$(shasum -a 256 "$DMG" | awk '{print $1}')"
[ "$actual" = "$SHA256" ] || die "SHA-256 mismatch: expected $SHA256, got $actual"
info "image verified (SHA-256 $actual)"

# Quit the app first: Stats caches its settings at launch and would write the
# cached values back on exit, discarding keys set while it is running.
osascript -e 'tell application "Stats" to quit' >/dev/null 2>&1 || true
sleep 2
pkill -x Stats >/dev/null 2>&1 || true

MOUNT="$(hdiutil attach -nobrowse -readonly "$DMG" | awk '/\/Volumes\// {print $NF}' | tail -1)"
[ -n "$MOUNT" ] || die "could not mount the image"
trap 'hdiutil detach "$MOUNT" >/dev/null 2>&1 || true' EXIT

[ -d "${MOUNT}/Stats.app" ] || die "Stats.app missing from the image"
if [ -d "$APP" ]; then
  rm -rf "$APP"
fi
cp -R "${MOUNT}/Stats.app" /Applications/
hdiutil detach "$MOUNT" >/dev/null 2>&1 || true
trap - EXIT
info "installed: $APP"

defaults write "$DOMAIN" temperature_units -string celsius
defaults write "$DOMAIN" dockIcon -bool false
# Battery and Bluetooth are optional; on a Mac mini without a battery the
# Battery module stays empty.
for module in CPU GPU RAM Disk Network Clock Sensors Battery Bluetooth; do
  defaults write "$DOMAIN" "${module}_state" -bool true
done
info "modules enabled (CPU GPU RAM Disk Network Clock Sensors Battery Bluetooth)"

open -a Stats
sleep 5
if pgrep -x Stats >/dev/null; then
  info "Stats is running (PID $(pgrep -x Stats | head -1))"
else
  die "Stats did not start"
fi
printf 'Done. Check the menu bar; enable launch at login in the app settings.\n'
