#include "..\script_component.hpp"

params ["_display"];

private _candidates = [
    [ZEN_FAVORITES_IDC_CREATE_UNITS_WEST, "units", "west"],
    [ZEN_FAVORITES_IDC_CREATE_UNITS_EAST, "units", "east"],
    [ZEN_FAVORITES_IDC_CREATE_UNITS_GUER, "units", "guer"],
    [ZEN_FAVORITES_IDC_CREATE_UNITS_CIV, "units", "civ"],
    [ZEN_FAVORITES_IDC_CREATE_UNITS_EMPTY, "units", "empty"],
    [ZEN_FAVORITES_IDC_CREATE_GROUPS_WEST, "groups", "west"],
    [ZEN_FAVORITES_IDC_CREATE_GROUPS_EAST, "groups", "east"],
    [ZEN_FAVORITES_IDC_CREATE_GROUPS_GUER, "groups", "guer"],
    [ZEN_FAVORITES_IDC_CREATE_GROUPS_EMPTY, "groups", "empty"],
    [ZEN_FAVORITES_IDC_CREATE_MODULES, "modules", "logic"]
];

private _result = [controlNull, -1, "", ""];

{
    _x params ["_idc", "_mode", "_side"];

    private _tree = _display displayCtrl _idc;

    if (!isNull _tree && {ctrlShown _tree}) exitWith {
        _result = [_tree, _idc, _mode, _side];
    };
} forEach _candidates;

_result
