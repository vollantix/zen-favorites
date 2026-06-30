# ZEN Favorites

ZEN Favorites is a small Zeus Enhanced addon for Zeus players who keep reaching for the same factions, units, groups, modules, and props every mission.

The addon adds favorite controls directly into the ZEN Create tree so Zeus users can keep commonly used entries close at hand without removing them from their normal categories.

ZEN Favorites is client-side. Favorites are stored per player and are not synced between players or stored on the server.

## Requirements

- Community Base Addons
- Zeus Enhanced

## Current Features

- Faction root favorites for BLUFOR, OPFOR, Independent, and Civilian Units/Groups.
- Faction root favorites move to the top and preserve the open or collapsed state you choose.
- Unit faction and leaf favorites are saved between missions by default under one CBA persistence setting.
- Individual faction Unit and Group favorites with configurable layouts; grouped Groups use one `Favorites: <Faction>` section per source faction.
- Group faction and leaf favorites are saved between missions by default under one CBA persistence setting.
- Empty Units and Empty Groups favorites are saved by default under one configurable persistence setting.
- Module favorites are saved by default under their own configurable persistence setting.
- Flat and otherwise qualified favorite rows show the leaf name first, adding parent context only for duplicate names; hover a row to see its full source path.
- Generated favorite rows for faction leaves, Empty Units, Empty Groups, and Modules select the matching original ZEN row internally so ZEN keeps its normal previews, placement bubbles, and settings.
- CBA Addon Options for log level, favorite star side, favorite list layouts, category-based persistence, and clearing favorites by type.

## Controls

- Left-click a star on the configured side of a top-level faction row: add or remove that faction favorite.
- Left-click a star on the configured side of a unit, group, Empty, or Module leaf row: add or remove that leaf favorite.
- Left-click a generated favorite leaf: select it through the matching original ZEN row so previews, placement bubbles, and ZEN settings behave normally.
- Right-click a generated favorite leaf: jump to the original item in the normal tree.
- Generated Favorites section rows are not favoritable; only the final leaf rows carry favorite stars.
- New leaf favorites are collected briefly while you keep clicking nearby source rows. After you pause, the Favorites section updates once, expands the newly added entries together, and retains the current tree position.
- Hold Shift while placing an Empty Units favorite: rotate the placement preview, following normal ZEN Placement behavior.

## Previews and ZEN Settings

ZEN Favorites does not override Zeus Enhanced preview settings or call ZEN's placement preview logic directly. Generated favorite rows select the matching original ZEN row internally, so Zeus Enhanced remains responsible for placement previews, placement bubbles, and preview-related settings.

The original Zeus Create entries are not replaced or rewritten. ZEN Favorites decorates them with star controls, may reorder favorited faction roots, and adds generated Favorites sections. Group favorites do not show placement previews because ZEN does not normally preview multiple group units or objects as one placement preview.

## Development

Tree behavior rules:

- Generated Favorites section, category, and branch rows are navigation only. They must never trigger placement, proxy selection, favorite toggling, or config lookups.
- Only final leaf rows may select or proxy-select an original ZEN row, and only after validating the row has the expected source data.
- When changing tree click, selection, or expansion behavior, always preserve the guard that branch rows exit before any `CfgVehicles`, `CfgGroups`, or module class lookup. This prevents recurring config errors outside the documented opt-in Grouped Module limitation.

Build and launch the development version:

```powershell
hemtt dev
hemtt launch
```

After testing in Arma, export only this addon's RPT lines:

```powershell
.\tools\export-zen-favorites-log.cmd
```

The filtered log is written to:

```text
logs\zen_favorites_latest.log
```

Prepare a signed release package:

```powershell
hemtt check
hemtt release
```

HEMTT writes release output to `.hemttout\release` and zip archives to `releases\`.

## Release Signing

ZEN Favorites release builds are signed by HEMTT because `.hemtt/project.toml` enables release signing:

```toml
[hemtt.release]
sign = true
```

The current signing policy uses HEMTT's default versioned signing authority, which is based on the addon prefix and release version:

```text
zen_favorites_1.0.0
zen_favorites_1.0.1
zen_favorites_1.1.0
zen_favorites_1.2.0
```

For each public release, HEMTT writes a matching public server key and PBO signature:

```text
.hemttout\release\keys\zen_favorites_1.2.0.bikey
.hemttout\release\addons\zen_favorites_main.pbo.zen_favorites_1.2.0.bisign
```

Server admins using `verifySignatures = 2` should allow the `.bikey` shipped with the current Workshop release. When the Workshop item is updated to a new version, the server key should be updated with it.

Do not commit or publish private signing keys. The repository ignores `.hemttprivatekey`, `*.biprivatekey`, `*.bikey`, and `*.bisign`.

## Documentation

- [Changelog](CHANGELOG.md)
- [Backlog](docs/backlog.md)
- [Steam Workshop page text](docs/steam-workshop.md)
- [Codex tree behavior guide](.codex/tree-behavior.md)
- [Release process guide](docs/release-process.md)

The Steam Workshop description has a hard limit of 8,000 UTF-8 bytes, including BBCode and line breaks. Keep `docs/steam-workshop.md` at or below the project target of 6,500 bytes to preserve at least 1,500 bytes for future updates.

Check the current size with:

```powershell
$text = [System.IO.File]::ReadAllText((Resolve-Path "docs/steam-workshop.md"))
[System.Text.Encoding]::UTF8.GetByteCount($text)
```

## Settings

ZEN Favorites settings are available in:

```text
Options > Addon Options > ZEN Favorites
```

- `Debugging > Log level`: chooses how much information is written to Arma's log file. Defaults to Error for normal play.
- `Interface > Favorite star side`: places stars on the left or right of Create tree rows. Defaults to Left to avoid the scrollbar.
- `Interface > Unit favorites layout`: uses category folders or one flat list for faction Units and Empty Units. Defaults to Grouped.
- `Interface > Group favorites layout`: uses faction/category folders or one flat list for faction Groups and Empty Groups. Defaults to Grouped.
- `Interface > Module favorites layout`: keeps module categories or shows one flat list. Defaults to Flat.
- `Persistence > Save Unit favorites`: saves Unit factions and individual Unit favorites between missions. Defaults to On.
- `Persistence > Save Group favorites`: saves Group factions and individual Group favorites between missions. Defaults to On.
- `Persistence > Save Module favorites`: saves Module favorites between missions. Defaults to On.
- `Persistence > Save Empty favorites`: saves both Empty Units and Empty Groups favorites between missions. Defaults to On.

Enabling persistence saves the current favorites immediately. Disabling it deletes that category's saved copy but keeps the current favorites for the rest of the mission.
- `Maintenance > Clear Empty Unit favorites`: clears Empty Unit favorites from the current session and Arma profile.
- `Maintenance > Clear Empty Group favorites`: clears Empty Group favorites from the current session and Arma profile.
- `Maintenance > Clear faction favorites`: clears top-level faction favorites from the current session and Arma profile.
- `Maintenance > Clear faction unit/group favorites`: clears faction unit and group leaf favorites from the current session and Arma profile.
- `Maintenance > Clear Module favorites`: clears Module favorites from the current session and Arma profile.

Maintenance clear toggles reset themselves after clearing.

## Runtime Log Level

ZEN Favorites writes diagnostic lines to the normal Arma RPT with this prefix:

```text
[ZEN Favorites]
```

On Windows, Arma normally writes RPT files under:

```text
%LOCALAPPDATA%\Arma 3\
```

The exact filename changes per launch, for example `Arma3_x64_YYYY-MM-DD_HH-MM-SS.rpt`.

The current log level uses this mission namespace variable:

```sqf
zen_favorites_main_logLevel
```

Supported values:

```sqf
0 // ERROR, default
1 // WARN
2 // INFO
3 // DEBUG
4 // TRACE
```

Set it from the Arma debug console while testing:

```sqf
zen_favorites_main_logLevel = 3;
```

Use `3` for debug logs and `4` for very noisy trace logs.

The same setting is also available in:

```text
Options > Addon Options > ZEN Favorites > Debugging
```

## Maintenance Commands

Empty Unit favorites are stored in the Arma profile:

```sqf
profileNamespace getVariable ["zen_favorites_main_emptyFavorites_units", []];
```

Module favorites are stored in the Arma profile:

```sqf
profileNamespace getVariable ["zen_favorites_main_moduleFavorites", []];
```

Empty Group favorites are stored in the Arma profile:

```sqf
profileNamespace getVariable ["zen_favorites_main_emptyFavorites_groups", []];
```

Unit and Group faction/leaf favorites are saved by default. Their category persistence settings save only the matching `units:*` or `groups:*` entries in these shared profile stores:

```sqf
profileNamespace getVariable ["zen_favorites_main_factionFavorites", []];
profileNamespace getVariable ["zen_favorites_main_factionLeafFavorites", []];
```

Units and Groups share these two profile stores. `zen_favorites_main_fnc_savefavoritecategory` updates only the matching `units:*` or `groups:*` keys, and `zen_favorites_main_fnc_syncfavoritepersistence` removes only the disabled category's saved keys. Live mission favorites are never cleared by a persistence toggle.

View saved Empty Unit favorites in the debug console:

```sqf
copyToClipboard str (profileNamespace getVariable ["zen_favorites_main_emptyFavorites_units", []]);
```

Restore saved Empty Unit favorites from a copied value:

```sqf
profileNamespace setVariable ["zen_favorites_main_emptyFavorites_units", PASTE_ARRAY_HERE];
saveProfileNamespace;
```

Saved favorites can reference classes from mods that are not currently loaded. ZEN Favorites skips unavailable favorites and keeps the rest working.

Clear persisted favorites from the Arma debug console:

```sqf
profileNamespace setVariable ["zen_favorites_main_emptyFavorites_units", []];
profileNamespace setVariable ["zen_favorites_main_emptyFavorites_groups", []];
profileNamespace setVariable ["zen_favorites_main_moduleFavorites", []];
profileNamespace setVariable ["zen_favorites_main_factionFavorites", []];
profileNamespace setVariable ["zen_favorites_main_factionLeafFavorites", []];
saveProfileNamespace;
```

Favorite clear toggles are also available in:

```text
Options > Addon Options > ZEN Favorites > Maintenance
```

Turn one on to clear that saved favorite type. Each toggle resets itself after clearing.

## Known Quirks

- Favorite leaves that internally select a matching original ZEN row use gold active text instead of Arma's native white tree selection box. The native selection box stays tied to the original row.
- With Module Favorites set to Grouped, selecting a generated category such as `Favorites > Reinforcements` may show a one-time `No entry 'bin\config.bin/CfgVehicles.'` popup. Arma treats depth-2 Module rows as native placeable leaves before addon handlers can cancel selection; Unit folders are safe because their native leaves are one level deeper. Flat is the default and avoids generated Module category rows.

## Planned Features

- Optional no-simulation placement modifier, such as holding Ctrl while placing an Empty favorite. Single objects are likely feasible; compositions need more investigation.
- Additional filtering tools for the Zeus Create menu.
- Keep the Favorites section in view when selecting generated favorites whose original rows are below the visible page.

## License

ZEN Favorites is licensed under the GNU General Public License v3.0. See [LICENSE](LICENSE).
