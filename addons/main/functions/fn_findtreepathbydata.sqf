#include "..\script_component.hpp"

params [
    "_tree",
    ["_parentPath", []],
    ["_data", ""],
    ["_skipText", "Favorites"]
];

private _result = [];

for "_index" from 0 to ((_tree tvCount _parentPath) - 1) do {
    private _childPath = +_parentPath;
    _childPath pushBack _index;

    if (_skipText != "" && {(_tree tvText _childPath) == _skipText}) then {
        continue;
    };

    if ((_tree tvData _childPath) == _data) exitWith {
        _result = _childPath;
    };

    private _nestedResult = [_tree, _childPath, _data, _skipText] call zen_favorites_main_fnc_findtreepathbydata;

    if (_nestedResult isNotEqualTo []) exitWith {
        _result = _nestedResult;
    };
};

_result
