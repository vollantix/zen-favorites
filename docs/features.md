# ZEN Filter Feature Description

ZEN Filter is a lightweight Zeus Enhanced addon focused on making the Zeus Create window faster to navigate during live missions.

The addon will provide two favorite systems:

- mission-local faction favorites for normal sides
- persistent client-side favorites for Empty-side placeable content

This document describes intended behavior, not final implementation.

## Faction Favorites

Faction favorites apply to the faction and group trees shown in the Zeus Create window for these sides:

- BLUFOR
- OPFOR
- Independent
- Civilian

When one of these sides is selected, each top-level faction row should have a favorite star aligned on the far right side of the faction or group list row, ideally just left of the scrollbar if the list has one.

Example:

- BLUFOR is selected.
- The faction list contains `CTRG`, `FIA`, `NATO`, and others.
- The Zeus user clicks the star for `NATO`.
- `NATO` becomes a favorite faction for BLUFOR.

Favorited factions should move to the top of that side's faction list. If multiple factions are favorited for the same side, the favorite section should be sorted alphabetically.

Unfavoriting a faction should remove it from the favorites group and return it to its normal position in the side's faction list.

Faction favorites are independent per side and per create mode. Favoriting a BLUFOR units faction must not affect OPFOR, Independent, Civilian, Empty, or BLUFOR groups. Favoriting a BLUFOR group faction is a separate favorite from favoriting a BLUFOR units faction.

Favorited factions should be expanded by default at the first tree level. They should not appear collapsed when the user first opens or refreshes that side's list.

Faction favorites are mission-local. They should last for the current mission/session, but they do not need to persist across game restarts, Arma profile changes, or future missions.

The first version will not support favoriting units, subgroups, vehicles, or individual classes inside normal side factions or groups.

## Empty Favorites

The Empty side has different behavior from the normal faction sides.

When Empty Units is selected in the Zeus Create window, ZEN Filter should add a new top-level category named `Favorites` at the very top of the Empty tree.

The user should be able to favorite Empty-side Units placeable content, including:

- units
- entities
- objects

Favorited Empty items should appear inside the new `Favorites` category while also remaining in their original category. Favoriting an Empty item must not remove it from its original location.

The Favorites category should preserve the original structure of favorited items instead of flattening everything into one list.

Example:

- An object originally appears under `Props > Furniture`.
- The user favorites that object.
- It appears under `Favorites > Props > Furniture`.
- It also remains under `Props > Furniture`.

Empty favorites should persist on the client side. The intent is that whenever a user launches Arma, loads Zeus, and has this mod enabled, their Empty favorites are available again.

If a saved favorite no longer exists because a required mod is missing or the class was removed, ZEN Filter should silently skip that favorite and write a debug log line. Missing favorites should not show an error popup to the Zeus user.

Empty Groups and compositions are intentionally paused for now. ZEN/ZEN composition placement uses different runtime state than single Empty objects, and the first stable pass should keep the normal tree functional instead of forcing generated Favorites rows into a path that places incorrectly.

## Debugging Expectations

While the addon is in early development, important behavior should be visible in the Arma RPT through `[ZEN Filter]` log lines.

Debug logging should be useful but not noisy. Temporary inspection logs are acceptable during development, but stable feature code should keep logs focused on meaningful lifecycle and data events.

## Non-Goals For The First Feature Pass

The first feature pass will not implement:

- favorite units inside BLUFOR, OPFOR, Independent, or Civilian factions
- synced multiplayer favorite state
- server-side favorite persistence
- custom settings UI
- import/export of favorite lists
- advanced search or filtering beyond favorites
