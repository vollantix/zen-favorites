#include "..\script_component.hpp"

// Restore source selection and the viewport after generated Favorites rows were rebuilt.
params ["_tree", ["_restoreState", []]];

if (isNull _tree) exitWith {false};

private _selectionState = _restoreState param [0, []];
private _scrollValues = _restoreState param [1, []];
private _restoredSelection = false;

if (_selectionState isNotEqualTo [] && {!([_selectionState] call zen_favorites_main_fnc_isfavoritepath)}) then {
    private _restorePath = [_tree, _selectionState] call zen_favorites_main_fnc_findtreepathbytexts;

    if (_restorePath isNotEqualTo []) then {
        if ((tvCurSel _tree) isNotEqualTo _restorePath) then {
            _tree tvSetCurSel _restorePath;
        };

        _restoredSelection = true;
    };
};

if ((count _scrollValues) >= 2) then {
    // tvSetCurSel can scroll again after this frame, so enforce the captured viewport once more.
    _tree ctrlSetScrollValues _scrollValues;

    [{
        params ["_tree", "_scrollValues"];

        if (!isNull _tree) then {
            _tree ctrlSetScrollValues _scrollValues;
        };
    }, [_tree, _scrollValues]] call CBA_fnc_execNextFrame;
};

_restoredSelection
