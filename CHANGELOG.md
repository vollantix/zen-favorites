# Changelog

All notable user-facing changes to ZEN Favorites are tracked here.

## [Unreleased]

### Added

- Empty Groups favorites for the Zeus Create Empty Groups tree.
- Module favorites for the Zeus Create Modules tree.
- CBA maintenance toggles for clearing Empty Group favorites and Module favorites separately.

### Changed

- Empty Units, Empty Groups, and Module favorites now share the same proxy-selection helper so generated Favorites rows use the matching original ZEN row behavior.
- Empty Groups favorites now keep a compact Favorites tree while preserving ZEN's normal group and composition placement behavior.
- Removed obsolete direct Empty Unit preview and debug inspection helpers from the runtime path.

### Fixed

- Very fast repeated clicks on the same faction favorite star are now ignored briefly to avoid accidental add/remove toggles.
- Empty Groups and Module Favorites sections are removed when their last favorite is cleared.

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
