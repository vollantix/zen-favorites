# Empty Groups Favorites Plan

Empty Groups favorites are still an important feature, but they need a separate design from Empty Units favorites.

The Empty Units implementation works because a favorite leaf can be represented by a `CfgVehicles` class name. ZEN placement can preview and place that class directly.

Empty Groups and compositions are different. They are not always simple `CfgVehicles` leaves, and ZEN often relies on selection state, profile composition data, or existing tree paths to know what should be placed.

## Current Status

- Empty Units favorites are supported and persistent.
- Empty Groups favorites currently support saved metadata and a temporary shortcut Favorites section.
- Clicking a generated Empty Groups favorite selects the matching original ZEN tree row.
- This shortcut behavior is intentionally temporary. It proves that saved favorites can resolve back to original rows, but it still collapses/rebuilds the Favorites branch and visibly selects the original row.
- `zen_compositions` remains a required addon because Empty Groups support is planned.

## What We Learned

- Generated Favorites rows worked well for simple Empty Units classes.
- Generated Favorites rows did not reliably work for Empty Groups/compositions.
- Some generated composition rows selected visually but did not place anything.
- Some generated rows produced config errors when selected.
- Some composition previews did not show placement bubbles.
- Some custom or Eden-created compositions appear in different tree categories and may use different backing data.
- Selecting or previewing a generated row can leave ZEN placement state in a bad state if we do not follow ZEN's expected selection path.

## Design Direction

The current safe direction is to treat Empty Groups favorites as shortcuts to the original ZEN tree rows while we learn ZEN's internal placement state.

Instead of trying to make a fake Favorites row behave exactly like the original row:

1. Store enough information to find the original row again.
2. Show the favorite in a Favorites area.
3. On click or right-click, jump to and select the original row.
4. Let ZEN's own placement logic handle previews and placement.

This is less magical than placing directly from the Favorites row, but it should preserve the behavior of groups, custom compositions, Steam compositions, and Eden-created compositions.

The final direction should not stop at visible shortcuts. The desired behavior is still a real Favorites section where selecting a favorite activates the same behavior as the original ZEN row, ideally without visibly jumping the tree selection.

Preview quality note:

- The final behavior does not need to use ZEN's richer object-preview style if that is difficult for groups/compositions.
- It is acceptable, and probably preferable, to make group favorites use the same placement bubbles that the original Empty Groups tree uses.
- Uniform behavior with the original ZEN rows is more important than a fancier generated preview.

## ZEN Source Findings

Useful source files inspected:

- `.tmp/ZEN-source/addons/placement/XEH_postInit.sqf`
- `.tmp/ZEN-source/addons/placement/functions/fnc_handleTreeSelect.sqf`
- `.tmp/ZEN-source/addons/compositions/functions/fnc_initDisplayCurator.sqf`
- `.tmp/ZEN-source/addons/compositions/functions/fnc_handleTreeSelect.sqf`
- `.tmp/ZEN-source/addons/compositions/functions/fnc_processTreeAdditions.sqf`
- `.tmp/ZEN-source/addons/compositions/functions/fnc_initHelper.sqf`

Important findings:

- ZEN placement attaches `TreeSelChanged` preview handling only to Create Units trees and the Recent tree, not to the Empty Groups tree.
- Empty Groups composition handling lives in the `zen_compositions` addon.
- ZEN custom composition rows use `tvData == "zen_compositions_composition"`.
- When a custom composition row is selected, `zen_compositions_fnc_handleTreeSelect` reads the composition array from a variable stored on the tree control.
- That variable key is based on the row's parent category and row name: `zen_compositions_<category>:<name>`.
- `zen_compositions_fnc_initHelper` places the composition by deserializing `zen_compositions_selected` at the helper object's position.

Implication:

- For ZEN custom compositions, a generated Favorites row can probably become a real selectable row if it copies both the visible row data and the tree variable used by ZEN.
- For built-in engine groups/compositions, behavior is likely still tied to the original tree path/config data. These may need a different strategy or may remain shortcut-based longer.

## Data To Capture

For each Empty Groups favorite, capture:

- display path text, for example `["Compositions", "Custom", "AA", "Igla"]`
- row text
- `tvData`
- `tvValue`
- picture/icon path if useful
- whether the row is a leaf
- the original tree IDC
- the original mode and side, expected to be `groups` and `empty`

The favorite ID should probably be path-based, not only class-based, because multiple composition rows can share generic data such as `zen_compositions_composition`.

## ZEN Systems To Inspect

Inspect these areas before implementing:

- ZEN composition tree population
- ZEN group/composition placement logic
- any code that writes or reads `zen_compositions_selected`
- any tree selection handlers for Create Groups, especially IDC `279`
- profile namespace keys used by ZEN compositions, including `zen_compositions_data`
- how Steam subscribed compositions and Eden/custom compositions are represented

Useful local search terms:

```text
zen_compositions_selected
zen_compositions_data
RscDisplayCurator
displayCtrl 279
TreeSelChanged
setupPreview
```

## Proof Of Concept

### Milestone 1: Inspect Original Rows

Implemented as debug-only logging through `zen_filter_main_fnc_inspectemptygrouprow`.

Set the ZEN Filter log level to `Debug`, select rows in Empty Groups, then export the filtered log.

The inspector logs:

- path
- display path
- row text
- `tvData`
- `tvValue`
- child count
- picture and right picture
- tooltip
- current `zen_compositions_selected` type/count
- a sample of child rows for folders

### Milestone 2: Save Favorite Metadata

Implemented. Empty Groups leaf rows get favorite stars and clicking a star stores/removes metadata.

Stored metadata shape:

```sqf
[
    displayPath,
    tvData,
    favoriteId,
    tvValue,
    tvText,
    tvPicture
]
```

For now, `favoriteId` is the stringified display path. This is deliberately path-based because multiple composition rows can share generic `tvData`, especially `zen_compositions_composition`.

First proof of concept should be intentionally narrow:

1. In Empty Groups, star one normal built-in group row.
2. Store its original display path.
3. Add a Favorites row that acts as a shortcut.
4. Clicking the favorite expands and selects the original row.
5. Confirm ZEN's normal preview/placement works.

Do not support custom compositions, Steam compositions, or generated direct placement in the first proof of concept.

### Milestone 3: Temporary Shortcut Favorites

Implemented as a temporary baseline.

- Empty Groups renders a top-level Favorites category.
- Favorite rows keep the full original display path.
- Selecting a favorite leaf resolves the original row by display path and selects it.
- This preserves original ZEN behavior but visibly jumps to the original row.
- Unfavoriting works, but the Favorites branch may collapse because it is rebuilt.

### Milestone 4: Real Custom Composition Favorites

Planned next investigation/implementation.

For generated Favorites rows that represent ZEN custom compositions:

1. Set `tvData` on the generated leaf to `zen_compositions_composition`.
2. Copy the original tree variable containing the composition array.
3. Store that variable under the generated favorite row's parent category/name key.
4. Let ZEN's existing `zen_compositions_fnc_handleTreeSelect` populate `zen_compositions_selected`.
5. Test whether the helper placement works without selecting the original row.

This should be tested first with one ZEN-created custom composition before supporting Steam or Eden composition categories.

The first target is not a custom object preview. The first target is getting the same placement bubbles and placement behavior that the original Empty Groups row provides.

## Test Checklist

Run each test with the normal row first, then the favorite shortcut:

- built-in Empty group
- custom composition from ZEN
- composition created from Eden
- Steam subscribed composition
- favorite while search is active
- favorite after clearing search
- close and reopen Zeus
- restart mission
- restart Arma
- missing mod/class scenario

Expected behavior for missing content:

- unavailable favorites are skipped
- no user-facing error popup
- a debug log line explains what was skipped

## Open Questions

- Can generated favorite rows for custom compositions fully replace shortcut selection by copying ZEN's tree variables?
- Does left-click on a favorite shortcut feel acceptable, or should right-click jump and left-click attempt direct placement?
- Can ZEN composition categories be resolved reliably from display path alone?
- Do Steam and profile compositions share the same selection data path?
- For built-in engine groups, is there a public or reliable internal path to trigger the same placement behavior without selecting the original tree row?
- Can expansion state be preserved when rebuilding the Favorites branch?

## Cleanup Notes

There is still experimental composition-selection code in the current tree rendering path. Before implementing the proof of concept, review that code and either remove it or isolate it behind the new shortcut-based experiment.
