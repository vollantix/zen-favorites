# ZEN Favorites Tree Behavior

This file documents the rules Codex should preserve when changing the Zeus Create tree, favorite stars, or generated Favorites sections.

## Hard Rules

- Generated `Favorites` section, category, and branch rows are navigation only.
- Generated branch rows must never trigger placement, proxy selection, favorite toggling, or config lookups.
- Only final generated favorite leaf rows may proxy-select an original ZEN row.
- Before any proxy selection or config lookup, verify the selected row is a leaf with valid source data.
- Branch clicks must not produce errors such as `No entry 'bin\config.bin/CfgVehicles'`.
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
- Include the `Favorites` root and any category/grouping row below it.
- Must never carry final leaf/placeable `tvData`.
- Should keep empty `tvData`; only final favorite leaves carry source data.
- Must not carry favorite star click behavior.
- Body clicks may select the branch, but must not trigger placement, proxy selection, favorite toggling, or config lookup.
- Arrow clicks should still expand or collapse the row.
- Double-clicking the branch body should toggle expand/collapse without jumping to a source row.
- Faction Unit Favorites compact source paths to one generated category level, such as `Favorites > CTRG / Cars > Prowler`.
- Faction Group Favorites must be flat, such as `Favorites > CTRG / Infantry / Fire Team`, because a generated row at native four-level `CfgGroups` depth triggers a config lookup before proxy selection.

Generated favorite leaves:

- Synthetic rows under `Favorites`.
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
- If branch clicks start showing config popups or leave a cursor bubble, treat that as a failed inert-branch guard even if expand/collapse still works.
- Rebuilding a generated Favorites branch above the current source selection must park native selection first, then restore the original source selection. Otherwise Arma/ZEN can treat the shifted selected index as a generated branch and try to look up `CfgVehicles.` or `CfgGroups/West.`.

## Proxy Selection Rules

Proxy selection is used so generated favorite leaves behave like the original ZEN row.

- Empty Units, Empty Groups, Modules, and faction leaf favorites should use `zen_favorites_main_fnc_selectfavoriteproxy` when practical.
- Branch rows must exit before calling the proxy helper.
- Missing source rows from unloaded mods should be skipped silently or logged at debug/warn level, not resolved to the wrong row.
- Group favorites normally do not show placement previews because ZEN does not preview multiple units or objects as one placement preview.
- ZEN preview settings are not overridden by this addon.

## Regression Checklist

After tree behavior changes, test these manually in Arma:

- Click a generated `Favorites` root/category/branch row body. It should not show `No entry 'bin\config.bin/CfgVehicles'` or try to place anything.
- After dismissing any unexpected popup during testing, the cursor should not be holding a placement bubble/icon.
- Click the expand/collapse arrow for the same branch. It should still open and close.
- Click a generated favorite leaf. It should select/place through the original ZEN row.
- Add and select a faction Group favorite. Its generated row must stay flat and fully qualified, and neither tree rebuilding nor selection may trigger a missing `CfgGroups` entry.
- Right-click a generated favorite leaf. It should jump to the original row.
- Click normal source-row stars at multiple depths. The visible star and clickable hotspot should line up.
- Switch `Interface > Favorite star side` between `Left` and `Right`, then repeat star and branch tests.
- Search in Modules and clear the search. Generated Favorites should disappear while searching and return afterward.
