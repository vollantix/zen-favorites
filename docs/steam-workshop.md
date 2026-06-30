[h1]ZEN Favorites[/h1]
Built for Zeus players who keep reaching for the same factions, units, groups, modules, props, and compositions every mission.

ZEN Favorites adds favorite controls directly into the Zeus Enhanced Create tree, keeping your go-to entries close at hand while leaving the normal ZEN categories intact.

The mod is client-side. Favorites are stored per player and are not synced between players or stored on the server.

Saved favorites from unloaded mods are skipped until that mod is loaded again.

[b]Latest update - 30 June 2026:[/b] Favorite stars can now be placed on the left or right, Unit, Group, and Module Favorites can use Grouped or Flat layouts, and persistence can be controlled separately for Units, Groups, Modules, and Empty favorites. Compact labels keep long names readable, new additions batch without losing the current tree position, and favorites from unloaded mods are safely skipped.

[h1]Features[/h1]
[list]
[*][b]Faction favorites:[/b] Star BLUFOR, OPFOR, Independent, or Civilian factions in the Units and Groups trees. Favorites move to the top and remember their expanded state.
[*][b]Faction units and groups:[/b] Favorite individual leaves inside non-empty side trees. Unit and Group persistence each include both their faction rows and generated Favorites contents.
[*][b]Empty Units:[/b] Favorite units, vehicles, objects, props, and entities. Uses the matching original row for normal ZEN Placement previews.
[*][b]Empty Groups:[/b] Favorite groups and compositions while retaining normal placement behavior.
[*][b]Modules:[/b] Favorite Zeus modules in a generated section at the top of the Modules tree.
[*]Unit, Group, and Module Favorites support Grouped or Flat layouts. Compact rows show the leaf name first, add parent context only for duplicate names, and show the full path on hover.
[*]Original Create entries remain in place. Generated favorites select the matching original ZEN row internally, and saved entries from unloaded mods are skipped until that mod is available again.
[/list]

[h1]Controls[/h1]
[list]
[*]Left-click a star on a faction, unit, group, Empty, or Module row to add or remove it.
[*]Left-click a generated favorite to use it through the matching original ZEN row. Right-click it to jump to that original row.
[*]Favorites section and category rows are navigation only; stars appear on final favorite leaves.
[*]New leaf favorites are collected briefly while you keep clicking nearby source rows. After you pause, the Favorites section updates once, expands the newly added entries together, and retains the current tree position.
[*]Hold Shift while placing an Empty Units favorite: rotate the placement preview, following normal ZEN Placement behavior.
[/list]

[h1]Previews and ZEN Settings[/h1]
ZEN Favorites does not override Zeus Enhanced preview settings. Generated favorites select their original row internally, leaving ZEN responsible for previews, placement bubbles, and related settings.

Group favorites do not show placement previews because ZEN does not normally preview multiple group units or objects as one placement preview.

[h1]Settings[/h1]
ZEN Favorites settings are available in:
[code]Options > Addon Options > ZEN Favorites[/code]

[list]
[*][b]Debugging > Log level:[/b] Controls RPT logging. Defaults to Error.
[*][b]Interface > Favorite star side:[/b] Places stars on the Left or Right. Defaults to Left to avoid the scrollbar.
[*][b]Interface layouts:[/b] Unit, Group, and Module Favorites each support Grouped or Flat. Units and Groups default to Grouped; Modules default to Flat.
[*][b]Persistence:[/b] Units, Groups, Modules, and Empty favorites are saved by default. Enabling a category saves its current favorites immediately; disabling it deletes the saved copy but keeps current favorites for the mission.
[*][b]Maintenance:[/b] Separate clear toggles remove Empty Unit, Empty Group, faction, faction unit/group, or Module favorites from the session and profile. Clear toggles reset automatically.
[/list]

[h1]Server Admins[/h1]
ZEN Favorites is optional and client-side. Servers do not need to run it. Servers using signature verification should allow the public key in the mod's [b]keys[/b] folder.

Releases currently use versioned keys, so update the server key from the same Workshop version as the mod.

[h1]Known Quirks[/h1]
[list]
[*]Favorite leaves that internally select a matching original ZEN row use gold active text instead of Arma's native white tree selection box. The native selection box stays tied to the original row.
[*]Selecting a generated favorite can scroll the Create tree down to the matching original ZEN row when that original row is far below the Favorites section.
[*]With Module Favorites set to Grouped, selecting a generated category may show a one-time missing CfgVehicles popup. Arma treats depth-2 Module rows as placeable leaves before addon handlers can cancel selection. Flat is the default and avoids this native-tree limitation.
[/list]

[h1]Source And License[/h1]
Source code:
[url=https://github.com/vollantix/zen-favorites]https://github.com/vollantix/zen-favorites[/url]

ZEN Favorites is licensed under the GNU General Public License v3.0.
