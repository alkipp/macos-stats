#!/usr/bin/env bash
# Installiert Stats aus dem mitgelieferten DMG und aktiviert die Menüleisten-Module.
# Kein sudo nötig, kein Netzwerkzugriff.
set -euo pipefail

VERSION="3.0.23"
SHA256="016517d559251f486aa0a47549de34c7dff56102392fa6273a58b0b2b815f392"
APP="/Applications/Stats.app"
DOMAIN="eu.exelban.Stats"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DMG="${SCRIPT_DIR}/dist/stats-${VERSION}.dmg"

info() { printf '  %s\n' "$*"; }
die() { printf 'Fehler: %s\n' "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || die "laeuft nur auf macOS"
[ -f "$DMG" ] || die "Image fehlt: $DMG"

printf 'Stats %s installieren\n' "$VERSION"

actual="$(shasum -a 256 "$DMG" | awk '{print $1}')"
[ "$actual" = "$SHA256" ] || die "SHA-256 stimmt nicht: erwartet $SHA256, gefunden $actual"
info "Image geprueft (SHA-256 $actual)"

# App beenden: Stats liest seine Einstellungen beim Start in einen Cache und
# wuerde frisch geschriebene Schluessel beim Beenden ueberschreiben.
osascript -e 'tell application "Stats" to quit' >/dev/null 2>&1 || true
sleep 2
pkill -x Stats >/dev/null 2>&1 || true

MOUNT="$(hdiutil attach -nobrowse -readonly "$DMG" | awk '/\/Volumes\// {print $NF}' | tail -1)"
[ -n "$MOUNT" ] || die "Image liess sich nicht einbinden"
trap 'hdiutil detach "$MOUNT" >/dev/null 2>&1 || true' EXIT

[ -d "${MOUNT}/Stats.app" ] || die "Stats.app fehlt im Image"
if [ -d "$APP" ]; then
  rm -rf "$APP"
fi
cp -R "${MOUNT}/Stats.app" /Applications/
hdiutil detach "$MOUNT" >/dev/null 2>&1 || true
trap - EXIT
info "installiert: $APP"

defaults write "$DOMAIN" temperature_units -string celsius
defaults write "$DOMAIN" dockIcon -bool false
# Battery und Bluetooth sind optional; auf dem Mac mini ohne Akku bleibt Battery leer.
for module in CPU GPU RAM Disk Network Clock Sensors Battery Bluetooth; do
  defaults write "$DOMAIN" "${module}_state" -bool true
done
info "Module gesetzt (CPU GPU RAM Disk Network Clock Sensors Battery Bluetooth)"

open -a Stats
sleep 5
if pgrep -x Stats >/dev/null; then
  info "Stats laeuft (PID $(pgrep -x Stats | head -1))"
else
  die "Stats startet nicht"
fi
printf 'Fertig. Menueleiste pruefen; Autostart in den Einstellungen der App aktivieren.\n'
