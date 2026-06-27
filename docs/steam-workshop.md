[h1]ZEN Favorites[/h1]
Built for Zeus players who keep reaching for the same factions, units, groups, modules, props, and compositions every mission.

ZEN Favorites adds favorite controls directly into the Zeus Enhanced Create tree, keeping your go-to entries close at hand while leaving the normal ZEN categories intact.

The mod is client-side. Favorites are stored per player and are not synced between players or stored on the server.

Saved favorites from unloaded mods are skipped until that mod is loaded again.

[h1]Current Features[/h1]
[b]Faction Favorites[/b]
[list]
[*]Adds a star button to top-level faction rows in the Create menu.
[*]Supports BLUFOR, OPFOR, Independent, and Civilian.
[*]Favorited factions move to the top of the list.
[*]New favorites expand once, then keep the open or collapsed state you choose.
[*]Favorites are separate per side and per Create mode.
[*]Faction favorites are session-based by default, with an optional CBA setting to save current favorites immediately and keep them in your Arma profile.
[/list]

[b]Faction Unit and Group Favorites[/b]
[list]
[*]Adds generated Favorites branches for individual units and groups inside the non-empty side trees.
[*]Favorite sections are grouped by source faction and category so entries stay easy to recognize.
[*]Generated section rows are not favoritable; the individual unit or group leaves carry the favorite star.
[*]Selecting a favorite uses the matching original ZEN row, keeping normal previews, placement bubbles, and ZEN settings intact.
[*]Faction unit and group favorites are session-based by default, with an optional CBA setting to save current favorites immediately and keep them in your Arma profile.
[/list]

[b]Empty Units Favorites[/b]
[list]
[*]Adds a Favorites category at the top of the Empty Units tree.
[*]Supports empty units, vehicles, objects, props, and entities.
[*]Favorited entries stay in their original category and also appear under Favorites.
[*]Favorites preserve a compact version of the original tree path so entries remain easy to recognize.
[*]Selecting an Empty Units favorite uses the matching original ZEN row, so ZEN Placement keeps its normal preview behavior and settings.
[*]Empty Units favorites are saved client-side in the Arma profile.
[/list]

[b]Empty Groups Favorites[/b]
[list]
[*]Adds a Favorites category at the top of the Empty Groups tree.
[*]Favorited groups and compositions stay in their original category and also appear under Favorites.
[*]Selecting an Empty Groups favorite uses the matching original ZEN row, keeping normal group and composition placement behavior intact.
[*]Empty Groups favorites are saved client-side in the Arma profile.
[/list]

[b]Module Favorites[/b]
[list]
[*]Adds a Favorites category at the top of the Zeus Create Modules tree.
[*]Favorited modules stay in their original category and also appear under Favorites.
[*]Selecting a Module favorite uses the matching original ZEN row, keeping normal module selection behavior intact.
[*]Module favorites are saved client-side in the Arma profile.
[/list]

[h1]Controls[/h1]
[list]
[*]Left-click a star on the configured side of a top-level faction row: add or remove that faction favorite.
[*]Left-click a star on the configured side of a unit, group, Empty, or Module leaf row: add or remove that leaf favorite.
[*]Left-click a generated favorite leaf: select it through the matching original ZEN row so previews, placement bubbles, and ZEN settings behave normally.
[*]Right-click a generated favorite leaf: jump to the original item in the normal tree.
[*]Generated Favorites section rows are not favoritable; only the final leaf rows carry favorite stars.
[*]Hold Shift while placing an Empty Units favorite: rotate the placement preview, following normal ZEN Placement behavior.
[/list]

[h1]Previews and ZEN Settings[/h1]
ZEN Favorites does not override Zeus Enhanced preview settings or call ZEN's placement preview logic directly. Generated favorite rows select the matching original ZEN row internally, so Zeus Enhanced remains responsible for placement previews, placement bubbles, and preview-related settings.

The original Zeus Create entries are not replaced or rewritten. ZEN Favorites decorates them with star controls, may reorder favorited faction roots, and adds generated Favorites sections.

Group favorites do not show placement previews because ZEN does not normally preview multiple group units or objects as one placement preview.

[h1]Settings[/h1]
ZEN Favorites settings are available in:
[code]Options > Addon Options > ZEN Favorites[/code]

[list]
[*]Debugging > Log level: controls RPT logging verbosity. Defaults to Error for normal play.
[*]Interface > Favorite star side: chooses whether favorite stars appear on the left side or the original right side of Zeus Create tree rows. Defaults to Left to avoid the scrollbar.
[*]Persistence > Save faction favorites: saves current top-level faction favorites immediately, then loads and saves them through your Arma profile. Off by default.
[*]Persistence > Save faction unit/group favorites: saves current faction unit and group favorites immediately, then loads and saves them through your Arma profile. Off by default.
[*]Maintenance > Clear Empty Unit favorites: clears Empty Unit favorites from the current session and Arma profile.
[*]Maintenance > Clear Empty Group favorites: clears Empty Group favorites from the current session and Arma profile.
[*]Maintenance > Clear faction favorites: clears top-level faction favorites from the current session and Arma profile.
[*]Maintenance > Clear faction unit/group favorites: clears faction unit and group favorites from the current session and Arma profile.
[*]Maintenance > Clear Module favorites: clears Module favorites from the current session and Arma profile.
[/list]

Maintenance clear toggles reset themselves after clearing.

[h1]Server Admins[/h1]
ZEN Favorites is optional and client-side. Servers do not need to run it, but servers with signature verification enabled should allow the public key shipped in the mod's [b]keys[/b] folder.

The current release process uses versioned keys. When updating the Workshop item, update the server key from the same Workshop version as well.

[h1]Known Quirks[/h1]
[list]
[*]Favorite leaves that internally select a matching original ZEN row use gold active text instead of Arma's native white tree selection box. The native selection box stays tied to the original row.
[*]Selecting a generated favorite can scroll the Create tree down to the matching original ZEN row when that original row is far below the Favorites section.
[/list]

[h1]Planned Features[/h1]
[list]
[*]Optional no-simulation placement modifier, such as holding Ctrl while placing an Empty favorite.
[*]Additional filtering tools for the Zeus Create menu.
[*]Keep the Favorites section in view when selecting generated favorites whose original rows are below the visible page.
[/list]

[h1]Source And License[/h1]
Source code:
[url=https://github.com/vollantix/zen-favorites]https://github.com/vollantix/zen-favorites[/url]

ZEN Favorites is licensed under the GNU General Public License v3.0.
