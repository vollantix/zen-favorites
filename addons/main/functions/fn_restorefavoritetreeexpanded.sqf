#include "..\script_component.hpp"

// Restore generated Favorites branch expansion from visible text paths.
params [
    "_tree",
    ["_expandedTextPaths", []],
    ["_stateVariable", ""]
];

if (isNull _tree) exitWith {[]};

private _restoredTextPaths = [];

{
    private _textPath = _x;
    private _treePath = [_tree, _textPath, [], ""] call zen_favorites_main_fnc_findtreepathbytexts;

    if (_treePath isNotEqualTo []) then {
        _tree tvExpand _treePath;
        _restoredTextPaths pushBack _textPath;
    };
} forEach _expandedTextPaths;

if (_stateVariable != "") then {
    _tree setVariable [_stateVariable, _restoredTextPaths];
    missionNamespace setVariable [_stateVariable, _restoredTextPaths];
};

_restoredTextPaths
