# Changelog

All notable user-facing changes to ZEN Favorites are tracked here.

## [Unreleased]

### Added

- CBA Interface setting to choose whether favorite stars appear on the left side or the original right side of Zeus Create tree rows.
- Separate CBA Interface settings for Unit, Group, and Module Favorites layouts, each offering Grouped or Flat.

### Changed

- Favorite stars default to the left side of Create tree rows so they no longer interfere with the scrollbar.
- Module Favorites default to Flat; Unit and Group Favorites default to Grouped.
- Qualified favorite rows now show the leaf name first and add only enough parent context to distinguish duplicate names; their full source path remains available in the tooltip.

### Fixed

- Module favorites from unloaded addons are now hidden until their original module path is available again, instead of resolving through reused ZEN custom module class names.
- Favorite star clicks now use the configured star lane and consume the tree click so the row itself is not selected accidentally.
- Favorite star click bounds now avoid the expand/collapse arrow area and are better aligned for deeper unit and group leaf rows.
- Left mouse button release no longer toggles favorites after the button-down handler already handled the star click.
- Generated folder/category body clicks remain inert for placement; safe-depth branches can be selected while native placement-depth branches are consumed without selection.
- Generated favorite leaves keep their yellow favorite star color after refreshes.
- Generated Favorites branch rows are treated as navigation only, preventing placement/config lookups outside the accepted Grouped Module limitation.
- Generated Favorites branch rows no longer jump to source rows when selected, and double-clicking a generated branch toggles it open or closed.
- Generated Favorites branch rows copy the original source icon instead of inheriting a visible favorite star overlay.
- Faction Unit and Group Favorites can switch between compact grouped branches and flat qualified rows without changing their original-row proxy behavior.
- Left mouse-up is now consumed after handled favorite star or branch body clicks, preventing generated Favorites branches from leaking into ZEN placement/config selection.
- Source tree selection is now parked before and restored after generated Favorites branches are rebuilt, preventing shifted indexes from changing the selected source row.
- Switching the favorite star side no longer leaves a stale star on the previous side or disables stars inside generated Favorites sections.
- Selecting a faction Group favorite no longer triggers missing `CfgGroups` configuration warnings before placing the original group.
- Unavailable faction Group favorites now require their exact stored source path and cannot resolve to a similarly named group from another loaded faction or addon.
- Module Favorites now use exact source-path mappings in both layouts instead of resolving generated leaves through their displayed labels.
- Grouped faction Group favorites now use safe `Favorites: <Faction>` sections with qualified leaves, avoiding synthetic rows at native `CfgGroups` placement depth.

### Known Quirks

- Grouped Module categories occupy native Module leaf depth. Selecting one may show a one-time missing `CfgVehicles` popup because Arma performs its native lookup before addon handlers can cancel selection. Flat is the default and avoids generated Module category rows.

## [1.1.1] - 2026-05-29

### Fixed

- Faction root favorite stars now render on every visible faction row instead of only the first 21 rows.
- Module Favorites now rebuild after ZEN repopulates the module tree following a search, instead of staying stuck on a filtered tree state.

### Changed

- The default RPT log level is now Error for normal play, with Info, Debug, and Trace still available for troubleshooting.

## [1.1.0] - 2026-05-27

### Added

- Empty Groups favorites for the Zeus Create Empty Groups tree.
- Module favorites for the Zeus Create Modules tree.
- CBA maintenance toggles for clearing Empty Group favorites and Module favorites separately.
- Individual faction unit and group leaf favorites for non-empty side trees.
- Optional CBA persistence settings for top-level faction favorites and faction unit/group leaf favorites. Both are off by default.
- CBA maintenance toggles for clearing top-level faction favorites and faction unit/group favorites separately.

### Changed

- Empty Units, Empty Groups, and Module favorites now share the same proxy-selection helper so generated Favorites rows use the matching original ZEN row behavior.
- Faction leaf favorites use the same proxy-selection helper so ZEN keeps its normal previews, placement bubbles, and settings.
- Empty Groups favorites now keep a compact Favorites tree while preserving ZEN's normal group and composition placement behavior.
- Removed obsolete direct Empty Unit preview and debug inspection helpers from the runtime path.

### Fixed

- Very fast repeated clicks on the same faction favorite star are now ignored briefly to avoid accidental add/remove toggles.
- Empty Groups and Module Favorites sections are removed when their last favorite is cleared.
- Faction leaf Favorites rendering now preserves top-level faction favorite ordering instead of restoring the original faction order.
- Faction leaf favorite selection now selects the matching original ZEN row on the next frame so ZEN placement previews receive a normal selection event.
- Enabling faction persistence now immediately saves the current session favorites, and disabling it no longer clears live or saved faction favorites.

### Known Quirks

- Favorite leaves that proxy-select original ZEN rows use gold active styling instead of Arma's native white tree selection box.

## [1.0.1] - 2026-05-26

### Changed

- Faction favorite reordering now tracks faction tree expansion state and restores open rows after sorting, instead of forcing favorited factions open during every Zeus Create tree render.

### Fixed

- Removed a leftover visible debug chat message when the Zeus display opens.
- Favorite action messages now show as short Zeus UI toasts in the top-right of the Zeus display instead of using the default engine hint position.

## [1.0.0] - 2026-05-20

### Added

- Initial Steam Workshop release.
- Faction favorites for BLUFOR, OPFOR, Independent, and Civilian Units/Groups.
- Persistent client-side Empty Units favorites.
- ZEN Placement advanced preview support for Empty Units favorites.
- Temporary shortcut behavior for Empty Groups favorites.
- CBA Addon Options for log level and clearing Empty Unit favorites.
- Steam Workshop preview image and GPL-3.0 license.

### Known Issues

- Empty Groups favorites use temporary shortcut behavior while direct placement behavior is investigated.
