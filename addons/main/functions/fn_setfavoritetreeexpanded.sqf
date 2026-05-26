#include "..\script_component.hpp"

// Track expansion state for generated Favorites branches by visible text path.
params [
    "_tree",
    ["_path", []],
    ["_expanded", false],
    ["_stateVariable", ""]
];

if (isNull _tree) exitWith {};
if (_path isEqualTo []) exitWith {};
if (_stateVariable == "") exitWith {};

private _displayPath = [_tree, _path] call zen_favorites_main_fnc_gettreepathtexts;

if (_displayPath isEqualTo []) exitWith {};

private _expandedTextPaths = +(missionNamespace getVariable [_stateVariable, (_tree getVariable [_stateVariable, []])]);

if (_expanded) then {
    if !(_displayPath in _expandedTextPaths) then {
        _expandedTextPaths pushBack _displayPath;
    };
} else {
    _expandedTextPaths = _expandedTextPaths select {
        (_x isNotEqualTo _displayPath) &&
        {((count _x) < (count _displayPath)) || {(_x select [0, count _displayPath]) isNotEqualTo _displayPath}}
    };
};

_tree setVariable [_stateVariable, _expandedTextPaths];
missionNamespace setVariable [_stateVariable, _expandedTextPaths];
