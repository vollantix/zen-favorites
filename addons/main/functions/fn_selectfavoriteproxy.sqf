#include "..\script_component.hpp"

params [
    "_tree",
    "_favoritePath",
    "_originalPath",
    "_expandedStateVariable",
    "_ignoreExpandVariable",
    "_ignoreSelectionVariable",
    "_activePathVariable",
    ["_activeColor", [1, 0.93, 0.58, 1]],
    ["_normalColor", [1, 1, 1, 1]]
];

if (isNull _tree) exitWith {false};
if (_favoritePath isEqualTo [] || {_originalPath isEqualTo []}) exitWith {false};

[_tree, _activePathVariable, _normalColor] call zen_favorites_main_fnc_clearactivefavoriteproxy;

_tree tvSetColor [_favoritePath, _activeColor];
_tree setVariable [_activePathVariable, +_favoritePath];

private _expandedTextPaths = +(_tree getVariable [_expandedStateVariable, []]);
private _collapseCandidates = [];

for "_depth" from ((count _originalPath) - 1) to 1 step -1 do {
    _collapseCandidates pushBack (_originalPath select [0, _depth]);
};

_tree setVariable [_ignoreExpandVariable, true];

for "_depth" from 1 to ((count _originalPath) - 1) do {
    _tree tvExpand (_originalPath select [0, _depth]);
};

_tree setVariable [_ignoreSelectionVariable, true];
_tree tvSetCurSel _originalPath;

[{
    params [
        "_tree",
        "_expandedTextPaths",
        "_collapseCandidates",
        "_favoritePath",
        "_expandedStateVariable",
        "_ignoreExpandVariable",
        "_ignoreSelectionVariable",
        "_activeColor"
    ];

    if (isNull _tree) exitWith {};

    _tree setVariable [_ignoreExpandVariable, true];

    {
        private _displayPath = [_tree, _x] call zen_favorites_main_fnc_gettreepathtexts;

        if !(_displayPath in _expandedTextPaths) then {
            _tree tvCollapse _x;
        };
    } forEach _collapseCandidates;

    [_tree, _expandedTextPaths, _expandedStateVariable] call zen_favorites_main_fnc_restorefavoritetreeexpanded;

    for "_depth" from 1 to ((count _favoritePath) - 1) do {
        _tree tvExpand (_favoritePath select [0, _depth]);
    };

    _tree tvSetColor [_favoritePath, _activeColor];
    _tree setVariable [_ignoreExpandVariable, false];
    _tree setVariable [_ignoreSelectionVariable, false];
}, [
    _tree,
    _expandedTextPaths,
    _collapseCandidates,
    +_favoritePath,
    _expandedStateVariable,
    _ignoreExpandVariable,
    _ignoreSelectionVariable,
    _activeColor
]] call CBA_fnc_execNextFrame;

true
