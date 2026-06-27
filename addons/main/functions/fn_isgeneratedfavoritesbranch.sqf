#include "..\script_component.hpp"

// Generated Favorites folder rows are navigation only; only final leaves may proxy-select ZEN rows.
params ["_tree", ["_path", []]];

if (isNull _tree || {_path isEqualTo []}) exitWith {false};
if ((_tree tvCount _path) == 0) exitWith {false};

private _displayPath = [_tree, _path] call zen_favorites_main_fnc_gettreepathtexts;

"Favorites" in _displayPath
