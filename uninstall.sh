#!/usr/bin/env bash
# Entfernt Stats, seine Einstellungen und die Programmdaten.
set -euo pipefail

APP="/Applications/Stats.app"
DOMAIN="eu.exelban.Stats"
SUPPORT="${HOME}/Library/Application Support/Stats"

info() { printf '  %s\n' "$*"; }

osascript -e 'tell application "Stats" to quit' >/dev/null 2>&1 || true
sleep 2
pkill -x Stats >/dev/null 2>&1 || true

if [ -d "$APP" ]; then
  rm -rf "$APP"
  info "entfernt: $APP"
fi

defaults delete "$DOMAIN" >/dev/null 2>&1 || true
info "Einstellungen geloescht ($DOMAIN)"

if [ -d "$SUPPORT" ]; then
  rm -rf "$SUPPORT"
  info "entfernt: $SUPPORT"
fi

printf 'Fertig. Ein Eintrag unter Systemeinstellungen > Allgemein > Anmeldeobjekte kann\n'
printf 'restlos entfernt werden, falls die App den Autostart-Helfer registriert hatte.\n'
