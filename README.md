# macos-stats

*CPU-, GPU-, Speicher-, Netz-, Disk- und Sensor-Anzeige als Menüleisten-Module auf dem Mac mini – Installer, Einrichtung, Prüfung und Rollback an einer Stelle.*

[Stats](https://github.com/exelban/stats) ist eine quelloffene Menüleisten-App (MIT). Dieses Repo bündelt das geprüfte Installationsmedium, die Einrichtung der Module und die Doku, die auf dem Gerät gebraucht wird. Es ist **kein Fork** und enthält keinen eigenen Code der App.

## Was drin ist

| Pfad | Inhalt |
|---|---|
| `dist/stats-3.0.23.dmg` | Offizielles Release-Image, unverändert, SHA-256 geprüft |
| `install.sh` | Image prüfen, App installieren, Module setzen, App starten |
| `uninstall.sh` | App und Einstellungen entfernen |
| `docs/module-keys.md` | Modulschlüssel in `eu.exelban.Stats` |
| `assets/` | Vorschau der Menüleiste (SVG-Quelle + PNG) |

## Installieren

```bash
git clone https://github.com/alkipp/macos-stats.git
cd macos-stats
./install.sh
```

Das Skript braucht **kein sudo** und prüft vor dem Einbinden den SHA-256 des Images. Es beendet eine laufende Instanz, kopiert `Stats.app` nach `/Applications`, setzt die Modulschlüssel und startet die App neu.

Voraussetzungen: macOS ab 12, Apple Silicon, rund 10 MB Platz.

> Hinweis: Ab macOS 26 warnt `hdiutil attach`, es sei veraltet. Das Skript nutzt es weiter, weil es auf macOS 12 bis 27 zuverlässig funktioniert; die Warnung ist folgenlos.

## Module

Nach der Installation hat jedes Modul sein eigenes Menüleisten-Icon; ein Klick öffnet das Popover mit Verlauf und Detailwerten.

| Modul | Menüleiste | Popover |
|---|---|---|
| CPU | Verlaufsgraph + Prozent | Gesamt, System/Benutzer, Balken je Kern, Top-Prozesse |
| GPU | Mini-Graph | Device/Renderer/Tiler, GPU-Speicher, Temperatur |
| RAM | Balken + Prozent | Speicherdruck, belegt/verfügbar, Swap |
| Disk | Balken + Prozent | Belegung, Lesen/Schreiben je Sekunde |
| Network | Rate | Down/Up, Verlauf, Schnittstelle |
| Sensors | Wert | Temperaturen, Lüfterdrehzahl |
| Clock | Uhrzeit | Datum und Uhrzeit |

Details zu den Schlüsseln: [`docs/module-keys.md`](docs/module-keys.md).

## Prüfen

```bash
spctl -a -vvv /Applications/Stats.app   # Notarized Developer ID, Team RP2S87B72W
defaults read /Applications/Stats.app/Contents/Info.plist CFBundleShortVersionString
pgrep -x Stats
defaults read eu.exelban.Stats | grep _state
```

Der letzte Befehl muss für jedes gewünschte Modul `<Modul>_state = 1` zeigen. Schreibt die App zusätzlich `<Modul>_widget`, ist das Modul geladen.

## Deinstallieren

```bash
./uninstall.sh
```

## Grenzen

- **Watt pro Block** (CPU/GPU/ANE) und **ANE-Auslastung** liefert Stats nicht – dafür ist `powermetrics` mit root nötig.
- **Lüftersteuerung** setzt den SMC-Helfer der App voraus; hier ist nur Lesen eingerichtet.
- **Dauerhafte Historie** gibt es nicht; Verläufe leben nur im Popover. Für Messreihen gehört ein Exporter an Prometheus.

## Herkunft und Lizenz

Die App stammt von Serhiy Mytrovtsiy und steht unter MIT-Lizenz; das Image ist das unveränderte Release `v3.0.23`. Siehe [`THIRD-PARTY.md`](THIRD-PARTY.md) und [`LICENSE`](LICENSE) für Skripte und Doku dieses Repos.
