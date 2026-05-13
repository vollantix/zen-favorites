# ZEN Filter

First learning milestone: a minimal HEMTT project for a future Arma 3 / ZEN addon.

This repo intentionally starts small. The first goal is to make HEMTT recognize the project before adding addon runtime code.

## Development

Build and launch the development version:

```powershell
hemtt dev
hemtt launch
```

After testing in Arma, export only this addon's RPT lines:

```powershell
.\tools\export-zen-filter-log.cmd
```

The filtered log is written to:

```text
logs\zen_filter_latest.log
```

## Documentation

- [Feature description](docs/features.md)
- [Steam Workshop description draft](docs/steam-workshop.md)

## Runtime Log Level

ZEN Filter logs use this mission namespace variable:

```sqf
zen_filter_main_logLevel
```

Supported values:

```sqf
0 // ERROR
1 // WARN
2 // INFO, default
3 // DEBUG
4 // TRACE
```

Set it from the Arma debug console while testing:

```sqf
zen_filter_main_logLevel = 3;
```

Use `3` for debug logs and `4` for very noisy trace logs.

The same setting is also available in:

```text
Options > Addon Options > ZEN Filter > Debugging
```

## Maintenance Commands

Clear persisted Empty favorites from the Arma debug console:

```sqf
profileNamespace setVariable ["zen_filter_main_emptyFavorites_units", []];
profileNamespace setVariable ["zen_filter_main_emptyFavorites_groups", []];
saveProfileNamespace;
```

The Empty Unit favorites clear toggle is also available in:

```text
Options > Addon Options > ZEN Filter > Maintenance
```

Turn it on to clear saved favorites. It resets itself after clearing.

## Known Issues

- Favorite star clicks use a short delayed selection read to keep faction row paths reliable. Very fast double-clicks may toggle the same faction twice instead of toggling two different factions.
- Empty Units favorites are supported. Empty Groups and composition favorites are intentionally disabled while their placement behavior is investigated.
