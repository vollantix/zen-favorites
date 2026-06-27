#include "..\script_component.hpp"

// Build a stable row identity for icon caching that survives sorting and re-rendering.
params ["_tree", ["_path", []]];

if (isNull _tree || {_path isEqualTo []}) exitWith {""};

str [
    ctrlIDC _tree,
    [_tree, _path] call zen_favorites_main_fnc_gettreepathtexts,
    _tree tvText _path,
    _tree tvData _path
]
