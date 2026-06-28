# ZEN Favorites Tree Behavior

This file documents the rules Codex should preserve when changing the Zeus Create tree, favorite stars, or generated Favorites sections.

## Hard Rules

- Generated `Favorites` section, category, and branch rows are navigation only.
- Generated branch rows must never trigger placement, proxy selection, or favorite toggling. The only accepted config-lookup exception is the optional Grouped Module category limitation documented below.
- Only final generated favorite leaf rows may proxy-select an original ZEN row.
- Before any proxy selection or config lookup, verify the selected row is a leaf with valid source data.
- Branch clicks must not produce config errors outside the accepted one-time Grouped Module category popup.
- Branch clicks must not leave a placement bubble or module/unit icon attached to the mouse after the error dialog is dismissed.
- If a mouse-down handler consumes a favorite star or branch body click, the matching left mouse-up must be consumed too.
- Expand/collapse arrows must keep working. Do not block the arrow lane while preventing branch body selection.

## Row Types

Top-level faction rows:

- Real ZEN rows.
- May have favorite stars.
- Clicking the star toggles top-level faction favorites.
- Clicking the row body should behave like the normal ZEN tree unless there is a specific guard.

Normal source leaves:

- Real ZEN rows for units, groups, Empty entries, or modules.
- May have favorite stars.
- Clicking the star toggles a generated favorite.
- Their original ZEN data, value, tooltip, and icon are the source of generated favorite leaves.

Generated Favorites branch rows:

- Synthetic UI rows created by ZEN Favorites.
- Include `Favorites`, `Favorites: <Faction>`, and any category/grouping row below them.
- Must never carry final leaf/placeable `tvData`.
- Should keep empty `tvData`; only final favorite leaves carry source data.
- Must not carry favorite star click behavior.
- Body clicks may select safe branch depths, but must not trigger placement, proxy selection, favorite toggling, or config lookup.
- A grouped Module branch at tree depth 2 occupies native placement depth. The addon avoids selecting it directly, but Arma may still select it natively and show a one-time missing `CfgVehicles` popup. This is accepted opt-in behavior.
- Arrow clicks should still expand or collapse the row.
- Double-clicking the branch body should toggle expand/collapse without jumping to a source row.
- Unit, Group, and Module Favorites each support `Grouped` and `Flat` layouts through separate CBA Interface settings. Units and Groups default to Grouped; Modules default to Flat.
- Grouped Unit Favorites compact deep source paths, such as `Favorites > CTRG / Cars > Prowler`; Flat uses one qualified leaf under `Favorites`.
- Grouped faction Group Favorites use sibling roots such as `BLUFOR > Favorites: CTRG > Fire Team`; Flat uses one qualified leaf under `BLUFOR > Favorites`.
- Grouped Module Favorites follow their source categories; Flat uses the shortest unique leaf label, such as `Favorites > Create LZ`.
- Layout is presentation only. Both modes must resolve leaves through the same exact source-path map and proxy helper.
- Qualified single-row favorites use the shortest unique leaf-first label. Add nearest-parent context only when duplicate leaf names require it, and keep the full source path in the tooltip.
- Visible text paths are also reverse-map keys. Never shorten labels without preserving uniqueness within their generated Favorites root.
- Every generated grouping row must keep empty `tvData` and pass through the inert branch guard. Module Flat is the default because it avoids generated rows at native Module leaf depth.

Generated favorite leaves:

- Synthetic rows under `Favorites` or `Favorites: <Faction>`.
- Must map back to a real original ZEN row.
- Left-click proxy-selects the original row so ZEN keeps previews, bubbles, placement, and settings.
- Right-click jumps to the original row for discoverability.

## Star Rules

- Use `zen_favorites_main_fnc_setfavoritestar` and `zen_favorites_main_fnc_clearfavoritestar`.
- Do not set star pictures directly in render code unless there is a deliberate reason.
- Stars are rendered with `ZEN_FAVORITES_STAR_TEXTURE` on the side chosen by `zen_favorites_main_starAlignment`.
- `Left` uses the row's left icon slot and is the default because it avoids the scrollbar.
- `Right` uses Arma's right picture slot and restores the original right-edge layout.
- The CBA `LIST` setting for star alignment must use numeric values internally. CBA can throw load-time params errors when list values are strings.
- The three CBA layout `LIST` settings must use the numeric `ZEN_FAVORITES_LAYOUT_*` constants. Units and Groups default to Grouped; Modules default to Flat.
- Texture comparisons must normalize case and leading slash differences because Arma can return texture paths differently than the macro.
- Original icon cache keys must not include row indexes. Sorting and inserted Favorites rows change paths, so use stable text/data identity through `zen_favorites_main_fnc_gettreepicturekey`.
- Runtime star click metadata must use the same stable row identity because generated Favorites rows are sorted after creation.
- Never cache `ZEN_FAVORITES_STAR_TEXTURE` as an original icon. Switching star sides must clear the old side before rendering the new side.
- Generated branch rows should copy the original source icon through `zen_favorites_main_fnc_gettreeoriginalpicture`, not the currently visible icon. This avoids copying an overlaid star into a category row.

## Click Handling

The main click rules live in `fn_registercreatetreehandlers.sqf`.

- `MouseButtonDown` decides whether the click is a star click, a branch body click, or a normal tree click.
- Star clicks and generated branch body clicks return handled and set `zen_favorites_main_swallowNextLeftMouseUp`.
- `MouseButtonUp` must consume that matching left mouse-up. If it does not, Arma/ZEN can still turn a branch body click into a selection/placement attempt.
- `fn_getfavoritestarbounds.sqf` owns the configured star hotspot math. Keep arrow safety in that helper rather than scattering coordinate constants.
- The branch body guard must be independent of star side. Switching stars to `Right` must not reopen branch selection/config lookup bugs.
- `fn_isgeneratedfavoritesbranch.sqf` is the shared branch guard. Use it before adding new branch click, selection, or lookup behavior.
- `fn_guardgeneratedfavoritebranchselection.sqf` selects the generated branch itself while suppressing placement/proxy side effects. It must not jump to or expand the matching source branch.
- Grouped faction Group rendering must never create a synthetic row at native depth 4. Use `Favorites: <Faction>` roots with direct qualified leaves at depth 3.
- The guard must not call `tvSetCurSel` for generated Module depth-2 branches. Arma can still perform its native config lookup after the mouse handler returns; this is why Grouped Modules remain optional and Flat is the default.
- If branch clicks start showing config popups or leave a cursor bubble outside the accepted Grouped Module popup, treat that as a failed inert-branch guard even if expand/collapse still works.
- Rebuilding a generated Favorites branch above the current source selection must park native selection first, then restore the original source selection. Otherwise Arma/ZEN can treat the shifted selected index as a generated branch and try to look up `CfgVehicles.` or `CfgGroups/West.`.

## Proxy Selection Rules

Proxy selection is used so generated favorite leaves behave like the original ZEN row.

- Empty Units, Empty Groups, Modules, and faction leaf favorites should use `zen_favorites_main_fnc_selectfavoriteproxy` when practical.
- Branch rows must exit before calling the proxy helper.
- Missing source rows from unloaded mods should be skipped silently or logged at debug/warn level, not resolved to the wrong row.
- Faction Group favorites must resolve by their full stored source path. Never fall back to a global `tvData` search because nested `CfgGroups` class names are not globally unique.
- Group favorites normally do not show placement previews because ZEN does not preview multiple units or objects as one placement preview.
- ZEN preview settings are not overridden by this addon.

## Regression Checklist

After tree behavior changes, test these manually in Arma:

- In default layouts, click generated `Favorites` root/category/branch row bodies. They should not show config errors or try to place anything.
- After dismissing any unexpected popup during testing, the cursor should not be holding a placement bubble/icon.
- Click the expand/collapse arrow for the same branch. It should still open and close.
- Click a generated favorite leaf. It should select/place through the original ZEN row.
- For Unit, Group, and Module Favorites, switch between `Grouped` and `Flat`; the active Favorites section should rebuild immediately and remain usable.
- In Grouped Unit and Group modes, click every generated category/branch depth. No branch may trigger a missing config entry or attach a placement bubble to the cursor.
- Confirm grouped faction Groups render as `Favorites: <Faction>` roots with direct qualified leaves and no generated depth-4 rows.
- Confirm Modules default to Flat. When deliberately testing Grouped Modules, the first selection of a generated depth-2 category may show the accepted missing `CfgVehicles` popup; it should not recur for that category during the same tree state.
- In both layouts, add, remove, left-click, and right-click a generated favorite leaf. It must resolve the same original ZEN row.
- Right-click a generated favorite leaf. It should jump to the original row.
- Click normal source-row stars at multiple depths. The visible star and clickable hotspot should line up.
- Switch `Interface > Favorite star side` between `Left` and `Right`, then repeat star and branch tests.
- Search in Modules and clear the search. Generated Favorites should disappear while searching and return afterward.
