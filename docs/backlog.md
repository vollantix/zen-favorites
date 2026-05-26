# ZEN Favorites Backlog

This document tracks planned work, known quirks, and investigation notes. Shipped user-facing changes belong in `CHANGELOG.md`.

## Known Quirks

- `ZF-007` Favorite leaves that proxy-select a matching original ZEN row cannot also keep Arma's native white tree selection box on the generated favorite row. The favorite row uses gold active text instead. This is accepted behavior, not a planned fix.

## Planned Features

- `ZF-103` Optional no-simulation placement modifier, such as holding Ctrl while placing an Empty favorite.
- `ZF-104` Adjustable Zeus Create panel width, if the owning panel controls can be identified reliably.
- `ZF-105` Additional filtering tools for the Zeus Create menu.
- `ZF-106` Faction Units and Groups leaf favorites for individual unit/group rows under BLUFOR, OPFOR, Independent, and Civilian. These should use a generated Favorites branch similar to Empty Units favorites, stay session-based by default, and include a CBA option to persist them in the player's profile.
- `ZF-107` Separate CBA persistence settings for top-level faction favorites and faction leaf favorites.

## Release Process

- `ZF-301` Consider switching from versioned release keys to a stable `zen_favorites.bikey` if server-admin key updates become a recurring support issue.
