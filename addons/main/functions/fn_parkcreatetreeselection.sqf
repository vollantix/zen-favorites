#include "..\script_component.hpp"

// Preserve viewport/selection, then move native selection away from rows that will be rebuilt.
params ["_tree", ["_parentPath", []]];

private _selectionState = [_tree] call zen_favorites_main_fnc_getcreatetreeselectionstate;

if (isNull _tree) exitWith {[_selectionState, []]};

private _scrollValues = ctrlScrollValues _tree;

private _candidatePath = [];

if (_parentPath isEqualTo []) then {
    for "_index" from 1 to ((_tree tvCount []) - 1) do {
        private _path = [_index];

        if ((_tree tvText _path) != "Favorites") exitWith {
            _candidatePath = _path;
        };
    };
} else {
    _candidatePath = +_parentPath;
};

if (_candidatePath isNotEqualTo [] && {!([_tree, _candidatePath] call zen_favorites_main_fnc_isgeneratedfavoritesbranch)}) then {
    _tree tvSetCurSel _candidatePath;
};

[_selectionState, _scrollValues]
