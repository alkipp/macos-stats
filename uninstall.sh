#!/usr/bin/env bash
# Removes Stats together with its preferences and program data.
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
  info "removed: $APP"
fi

defaults delete "$DOMAIN" >/dev/null 2>&1 || true
info "preferences deleted ($DOMAIN)"

if [ -d "$SUPPORT" ]; then
  rm -rf "$SUPPORT"
  info "removed: $SUPPORT"
fi

printf 'Done. If the app registered a launch-at-login helper, remove the leftover\n'
printf 'entry under System Settings > General > Login Items.\n'
