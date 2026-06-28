#include "..\script_component.hpp"

// Restore a source-tree selection after generated Favorites rows were inserted or removed.
params ["_tree", ["_selectionState", []]];

if (isNull _tree || {_selectionState isEqualTo []}) exitWith {false};

private _displayPath = _selectionState;

if (_displayPath isEqualTo [] || {[_displayPath] call zen_favorites_main_fnc_isfavoritepath}) exitWith {false};

private _restorePath = [_tree, _displayPath] call zen_favorites_main_fnc_findtreepathbytexts;

if (_restorePath isEqualTo []) exitWith {false};
if ((tvCurSel _tree) isEqualTo _restorePath) exitWith {true};

_tree tvSetCurSel _restorePath;

true
