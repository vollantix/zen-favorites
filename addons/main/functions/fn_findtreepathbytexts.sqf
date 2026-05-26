#include "..\script_component.hpp"

// Resolve a visible text path back to a tree path, optionally skipping a generated branch.
params [
    "_tree",
    ["_displayPath", []],
    ["_parentPath", []],
    ["_skipText", "Favorites"]
];

private _currentPath = +_parentPath;
private _result = [];
private _failed = false;

{
    private _segment = _x;
    private _foundIndex = -1;

    for "_index" from 0 to ((_tree tvCount _currentPath) - 1) do {
        private _candidatePath = +_currentPath;
        _candidatePath pushBack _index;

        if (_skipText != "" && {(_tree tvText _candidatePath) == _skipText}) then {
            continue;
        };

        if ((_tree tvText _candidatePath) == _segment) exitWith {
            _foundIndex = _index;
        };
    };

    if (_foundIndex == -1) exitWith {
        _failed = true;
    };

    _currentPath pushBack _foundIndex;
    _result = +_currentPath;
} forEach _displayPath;

if (_failed) exitWith {[]};

_result
