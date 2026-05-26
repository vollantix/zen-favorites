[h1]ZEN Favorites[/h1]
Built for Zeus players who keep reaching for the same factions, props, vehicles, and compositions every mission.

ZEN Favorites adds favorite controls directly into the Zeus Enhanced Create tree, keeping your go-to entries close at hand while leaving the normal ZEN categories intact.

The mod is client-side. Favorites are stored per player and are not synced between players or stored on the server.

[h1]Current Features[/h1]
[b]Faction Favorites[/b]
[list]
[*]Adds a star button to top-level faction rows in the Create menu.
[*]Supports BLUFOR, OPFOR, Independent, and Civilian.
[*]Favorited factions move to the top of the list.
[*]New favorites expand once, then keep the open or collapsed state you choose.
[*]Favorites are separate per side and per Create mode.
[*]Faction favorites are mission-local and reset when Arma is restarted.
[/list]

[b]Empty Units Favorites[/b]
[list]
[*]Adds a Favorites category at the top of the Empty Units tree.
[*]Supports empty units, vehicles, objects, props, and entities.
[*]Favorited entries stay in their original category and also appear under Favorites.
[*]Favorites preserve a compact version of the original tree path so entries remain easy to recognize.
[*]Selecting an Empty Units favorite uses ZEN Placement for the advanced placement preview.
[*]Empty Units favorites are saved client-side in the Arma profile.
[/list]

[b]Empty Groups Favorites[/b]
[list]
[*]Empty Groups favorites are currently available as shortcut-style favorites.
[*]Selecting an Empty Groups favorite jumps to the matching original ZEN tree row.
[*]This keeps ZEN's normal group and composition placement behavior intact while direct placement support is investigated.
[/list]

[h1]Controls[/h1]
[list]
[*]Left-click a star: add or remove a favorite.
[*]Left-click an Empty Units favorite: select it for placement using ZEN Placement advanced preview behavior.
[*]Hold Shift while placing an Empty Units favorite: rotate the placement preview.
[*]Right-click an Empty Units favorite: jump to the original item in the normal tree.
[*]Right-click in Zeus while an Empty Units favorite preview is active: cancel the preview.
[/list]

[h1]Settings[/h1]
ZEN Favorites settings are available in:
[code]Options > Addon Options > ZEN Favorites[/code]

[list]
[*]Debugging > Log level: controls RPT logging verbosity.
[*]Maintenance > Clear Empty Unit favorites: clears saved Empty Unit favorites from the current Arma profile.
[/list]

[h1]Server Admins[/h1]
ZEN Favorites is optional and client-side. Servers do not need to run it, but servers with signature verification enabled should allow the public key shipped in the mod's [b]keys[/b] folder.

The current release process uses versioned keys. When updating the Workshop item, update the server key from the same Workshop version as well.

[h1]Known Quirks[/h1]
[list]
[*]Very fast double-clicks on faction stars may toggle the same faction twice instead of toggling two different factions.
[*]Empty Groups and composition favorites currently use temporary shortcut behavior while placement behavior is investigated.
[*]Favorites are client-side. They are not synced between players or stored on the server.
[*]Faction favorites only last for the current mission/session.
[/list]

[h1]Planned Features[/h1]
[list]
[*]Better Empty Groups and composition support if it can be implemented without breaking normal ZEN placement behavior.
[*]Module favorites for the Zeus Create Modules tree.
[*]Individual faction unit and group favorites, session-based by default, with a CBA option to save them persistently.
[*]Placement preview options that respect existing ZEN Placement settings where possible, with ZEN Favorites CBA settings for behavior ZEN does not expose.
[*]Optional no-simulation placement modifier, such as holding Ctrl while placing an Empty favorite.
[*]Adjustable Zeus Create panel width, if the owning panel controls can be identified reliably.
[*]Additional filtering tools for the Zeus Create menu.
[/list]

[h1]Source And License[/h1]
Source code:
[url=https://github.com/vollantix/zen-favorites]https://github.com/vollantix/zen-favorites[/url]

ZEN Favorites is licensed under the GNU General Public License v3.0.
