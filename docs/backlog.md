# ZEN Favorites Backlog

This document tracks planned work, known quirks, and investigation notes. Shipped user-facing changes belong in `CHANGELOG.md`.

## Known Issues

- `ZF-001` BLUFOR Units favorite collapse behavior can be inconsistent after reopening Zeus if a favorited row was already selected. OPFOR collapse behavior appears more consistent.
- `ZF-002` Favorite action hint text, such as `Added Favorite: NATO`, may linger instead of disappearing.
- `ZF-003` Empty Groups favorites currently use temporary shortcut behavior while direct placement behavior is investigated.

## Planned Features

- `ZF-101` Module favorites for the Zeus Create Modules tree.
- `ZF-102` Respect existing ZEN Placement settings for Empty Unit favorite previews where possible, and add ZEN Favorites CBA settings only for preview behavior ZEN does not expose.
- `ZF-103` Optional no-simulation placement modifier, such as holding Ctrl while placing an Empty favorite.
- `ZF-104` Adjustable Zeus Create panel width, if the owning panel controls can be identified reliably.
- `ZF-105` Additional filtering tools for the Zeus Create menu.
- `ZF-106` Faction Units and Groups leaf favorites for individual unit/group rows under BLUFOR, OPFOR, Independent, and Civilian. These should use a generated Favorites branch similar to Empty Units favorites, stay session-based by default, and include a CBA option to persist them in the player's profile.

## Empty Groups Investigation

`ZF-201` Empty Groups and compositions need a separate design from Empty Units favorites. ZEN composition placement uses different runtime state than single Empty objects, so generated favorite rows currently select the matching original ZEN row while direct placement behavior is investigated.

See `docs/empty-groups-plan.md` for the detailed investigation notes.

## Release Process

- `ZF-301` Consider switching from versioned release keys to a stable `zen_favorites.bikey` if server-admin key updates become a recurring support issue.
