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
