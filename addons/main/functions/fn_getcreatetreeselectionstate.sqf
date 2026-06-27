#include "..\script_component.hpp"

// Capture the current Create tree selection by stable row identity before tree rows are rebuilt.
params ["_tree"];

if (isNull _tree) exitWith {[]};

private _path = tvCurSel _tree;

if (_path isEqualTo []) exitWith {[]};

[[_tree, _path] call zen_favorites_main_fnc_gettreepathtexts, _tree tvData _path]
