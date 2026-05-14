# Empty Groups Favorites Plan

Empty Groups favorites are still an important feature, but they need a separate design from Empty Units favorites.

The Empty Units implementation works because a favorite leaf can be represented by a `CfgVehicles` class name. ZEN placement can preview and place that class directly.

Empty Groups and compositions are different. They are not always simple `CfgVehicles` leaves, and ZEN often relies on selection state, profile composition data, or existing tree paths to know what should be placed.

## Current Status

- Empty Units favorites are supported and persistent.
- Empty Groups favorites are disabled for now.
- Clicking a star in Empty Groups currently shows a hint and logs that group favorites need a separate implementation.
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

The safest direction is to treat Empty Groups favorites as shortcuts to the original ZEN tree rows, not as independently placeable generated rows.

Instead of trying to make a fake Favorites row behave exactly like the original row:

1. Store enough information to find the original row again.
2. Show the favorite in a Favorites area.
3. On click or right-click, jump to and select the original row.
4. Let ZEN's own placement logic handle previews and placement.

This is less magical than placing directly from the Favorites row, but it should preserve the behavior of groups, custom compositions, Steam compositions, and Eden-created compositions.

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

First proof of concept should be intentionally narrow:

1. In Empty Groups, star one normal built-in group row.
2. Store its original display path.
3. Add a Favorites row that acts as a shortcut.
4. Clicking the favorite expands and selects the original row.
5. Confirm ZEN's normal preview/placement works.

Do not support custom compositions, Steam compositions, or generated direct placement in the first proof of concept.

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

- Can a favorite shortcut select the original row without stealing placement focus?
- Does left-click on a favorite shortcut feel acceptable, or should right-click jump and left-click attempt direct placement?
- Can ZEN composition categories be resolved reliably from display path alone?
- Do Steam and profile compositions share the same selection data path?
- Should Empty Groups favorites appear at the top or bottom of the Groups tree?

## Cleanup Notes

There is still experimental composition-selection code in the current tree rendering path. Before implementing the proof of concept, review that code and either remove it or isolate it behind the new shortcut-based experiment.

