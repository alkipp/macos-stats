# Modulschlüssel

*Stats speichert alles in `eu.exelban.Stats` (UserDefaults). Zwei Schlüssel je Modul entscheiden, ob und wie es in der Menüleiste erscheint.*

## Zustand

| Schlüssel | Typ | Bedeutung |
|---|---|---|
| `<Modul>_state` | Bool | Modul aktiv (Icon erscheint) |
| `<Modul>_widget` | String | Aktive Widget-Form, mehrere durch Komma getrennt |
| `<Modul>_<widget>_position` | Int | Reihenfolge des Icons in der Menüleiste |
| `temperature_units` | String | `celsius`, `fahrenheit` oder `system` |
| `dockIcon` | Bool | Zusätzliches Dock-Icon |
| `keep_menubar_positions` | Bool | Positionen beim Start beibehalten |
| `pause` | Bool | Alle Module pausiert |

Modulnamen: `CPU`, `GPU`, `RAM`, `Disk`, `Network`, `Clock`, `Sensors`, `Battery`, `Bluetooth`, `Remote`.

## Widget-Formen

Die Werte in `<Modul>_widget` stammen aus dem `config.plist` des jeweiligen Moduls. Üblich sind:

| Form | Darstellung |
|---|---|
| `line_chart` | Verlaufsgraph über die Zeit |
| `bar_chart` | Balken mit aktuellem Prozentwert |
| `mini` | Kleiner Graph ohne Beschriftung |
| `speed` | Up-/Down-Rate als Text |
| `label` | Reiner Zahlenwert |
| `pie_chart` | Kreisdiagramm |
| `tachometer` | Zeigerinstrument |
| `memory` | Belegung als Speicherblock |

Gemessene Belegung nach der Installation auf dem Mac mini (M2 Pro):

| Modul | `*_state` | `*_widget` |
|---|---|---|
| CPU | 1 | `line_chart` |
| GPU | 1 | `mini` |
| RAM | 1 | `bar_chart` |
| Disk | 1 | `bar_chart` |
| Network | 1 | `speed` |
| Sensors | 1 | `label` |
| Clock | 1 | Uhrzeit-Widget |

## Reihenfolge beachten

Stats liest die Defaults beim Start in einen Cache (`Store`) und schreibt bei Änderungen sofort zurück. Wer Schlüssel per `defaults write` setzt, muss die App **vorher beenden** – sonst überschreibt sie beim Beenden die neuen Werte. Genau das macht `install.sh`.
