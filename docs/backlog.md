# ZEN Favorites Backlog

This document tracks planned work, known quirks, and investigation notes. Shipped user-facing changes belong in `CHANGELOG.md`.

## Known Quirks

- `ZF-007` Favorite leaves that proxy-select a matching original ZEN row cannot also keep Arma's native white tree selection box on the generated favorite row. The favorite row uses gold active text instead. This is accepted behavior, not a planned fix.
- `ZF-009` Grouped Module categories occupy native Module leaf depth. Selecting one may show a one-time missing `CfgVehicles` popup because Arma performs its native lookup before addon handlers can cancel selection. Flat is the default and avoids the issue; the optional Grouped behavior is accepted and not planned for a fix.

## Investigation Notes

- `ZF-201` One observed session expanded the entire Units tree without direct user action, after which unit leaf stars disappeared in that tree. Groups leaf stars and other BLUFOR unit stars still appeared normally. This may be related to delayed ZEN tree initialization or a tree rebuild finishing after ZEN Favorites rendered. Needs reproduction with debug logging before treating it as confirmed addon behavior.

## Planned Features

- `ZF-103` Optional no-simulation placement modifier, such as holding Ctrl while placing an Empty favorite.
- `ZF-105` Additional filtering tools for the Zeus Create menu.

## Release Process

- `ZF-301` Consider switching from versioned release keys to a stable `zen_favorites.bikey` if server-admin key updates become a recurring support issue.
