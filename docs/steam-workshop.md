# ZEN Filter Steam Workshop Description

ZEN Filter is a lightweight Zeus Enhanced addon that makes the Zeus Create menu faster to use during live missions.

The addon adds favorite controls directly into the ZEN Create tree so Zeus users can keep commonly used factions and Empty objects close at hand without removing them from their normal categories.

## Requirements

- Community Base Addons
- Zeus Enhanced

## Current Features

### Faction Favorites

ZEN Filter adds a star button to top-level faction rows in the Create menu.

Supported sides:

- BLUFOR
- OPFOR
- Independent
- Civilian

Clicking a star favorites that faction for the current mission. Favorited factions move to the top of the list and are expanded by default. Clicking the star again removes the favorite and returns the faction to the normal list.

Faction favorites are separate per side and per Create mode. For example, favoriting a BLUFOR Units faction does not favorite the same faction in BLUFOR Groups.

Faction favorites are mission-local and are not saved after restarting Arma.

### Empty Units Favorites

ZEN Filter adds a `Favorites` category at the top of the Empty Units tree.

Supported favorite types:

- Empty units
- Empty vehicles
- Empty objects
- Empty props and entities

Favorited Empty Units entries stay in their original category and are also shown under `Favorites`. The Favorites category preserves a compact version of the original tree path so favorites remain easy to recognize.

Empty Units favorites are saved client-side in the Arma profile and are available the next time the same player uses Zeus with the mod loaded.

If a saved favorite is missing because a mod was removed or a class no longer exists, ZEN Filter skips it silently and writes a debug log line.

## Controls

- Left-click a star: add or remove a favorite.
- Left-click an Empty Units favorite: select it for placement.
- Hold Shift while placing an Empty Units favorite: rotate the placement preview.
- Right-click an Empty Units favorite: jump to the original item in the normal tree.
- Right-click in Zeus while an Empty Units favorite preview is active: cancel the preview.

## Settings

ZEN Filter settings are available in:

```text
Options > Addon Options > ZEN Filter
```

- `Debugging > Log level`: controls RPT logging verbosity.
- `Maintenance > Clear Empty Unit favorites`: clears saved Empty Unit favorites from the current Arma profile.

## Known Quirks

- Very fast double-clicks on faction stars may toggle the same faction twice instead of toggling two different factions.
- Empty Groups and composition favorites are still experimental and may use temporary shortcut behavior while placement behavior is investigated.
- Empty Units favorite previews can be rotated with Shift, but placed objects may lose that preview rotation when placed.
- Favorites are client-side. They are not synced between players or stored on the server.
- Faction favorites only last for the current mission/session.

## Debugging And Maintenance

ZEN Filter writes diagnostic lines to the Arma RPT with the `[ZEN Filter]` prefix.

Empty Unit favorites are stored in the Arma profile. You can view or export them from the Arma debug console:

```sqf
copyToClipboard str (profileNamespace getVariable ["zen_filter_main_emptyFavorites_units", []]);
```

Restore saved Empty Unit favorites from a copied value:

```sqf
profileNamespace setVariable ["zen_filter_main_emptyFavorites_units", PASTE_ARRAY_HERE];
saveProfileNamespace;
```

Saved favorites may reference classes from mods that are not currently loaded. ZEN Filter skips unavailable favorites and keeps the rest working.

Runtime log levels can be changed from the Arma debug console:

```sqf
zen_filter_main_logLevel = 0; // ERROR
zen_filter_main_logLevel = 1; // WARN
zen_filter_main_logLevel = 2; // INFO, default
zen_filter_main_logLevel = 3; // DEBUG
zen_filter_main_logLevel = 4; // TRACE
```

Clear saved Empty favorites from the Arma debug console:

```sqf
profileNamespace setVariable ["zen_filter_main_emptyFavorites_units", []];
profileNamespace setVariable ["zen_filter_main_emptyFavorites_groups", []];
saveProfileNamespace;
```

The same clear toggle is available under the `Maintenance` section in CBA Addon Options. Turn it on to clear saved favorites; it resets itself after clearing.

## Planned Features

- CBA settings for clearing saved favorites.
- Better Empty Groups/composition support if it can be implemented without breaking normal ZEN placement behavior.
- Adjustable Zeus Create panel width, if the owning panel controls can be identified reliably.
- Additional filtering tools for the Zeus Create menu.
