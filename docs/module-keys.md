# Module keys

*Stats stores everything in `eu.exelban.Stats` (UserDefaults). Two keys per module decide whether and how it shows up in the menu bar.*

## State

| Key | Type | Meaning |
|---|---|---|
| `<Module>_state` | Bool | Module enabled (icon appears) |
| `<Module>_widget` | String | Active widget types, comma separated |
| `<Module>_<widget>_position` | Int | Icon order in the menu bar |
| `temperature_units` | String | `celsius`, `fahrenheit` or `system` |
| `dockIcon` | Bool | Show an additional Dock icon |
| `keep_menubar_positions` | Bool | Keep icon positions across launches |
| `pause` | Bool | Pause all modules |

Module names: `CPU`, `GPU`, `RAM`, `Disk`, `Network`, `Clock`, `Sensors`, `Battery`, `Bluetooth`, `Remote`.

## Widget types

Values in `<Module>_widget` come from each module's `config.plist`. Common ones:

| Type | Rendering |
|---|---|
| `line_chart` | history graph over time |
| `bar_chart` | bar with the current percentage |
| `mini` | small chart without a label |
| `speed` | up/down throughput as text |
| `label` | plain number |
| `pie_chart` | pie chart |
| `tachometer` | dial gauge |
| `memory` | memory blocks |

Measured on the Mac mini (M2 Pro) after installation:

| Module | `*_state` | `*_widget` |
|---|---|---|
| CPU | 1 | `line_chart` |
| GPU | 1 | `mini` |
| RAM | 1 | `bar_chart` |
| Disk | 1 | `bar_chart` |
| Network | 1 | `speed` |
| Sensors | 1 | `label` |
| Clock | 1 | clock widget |

## Mind the order

Stats reads the defaults into a cache (`Store`) at launch and writes changes back immediately. Anyone setting keys with `defaults write` must **quit the app first** – otherwise it overwrites the new values on exit. That is exactly what `install.sh` does.
