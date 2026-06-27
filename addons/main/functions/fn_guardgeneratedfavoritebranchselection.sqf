#include "..\script_component.hpp"

// Select a generated Favorites folder without letting it become a ZEN placement/config selection.
params ["_tree", ["_path", []]];

if (isNull _tree || {_path isEqualTo []}) exitWith {false};
if !([_tree, _path] call zen_favorites_main_fnc_isgeneratedfavoritesbranch) exitWith {false};

private _displayPath = [_tree, _path] call zen_favorites_main_fnc_gettreepathtexts;
private _treeContext = [ctrlIDC _tree] call zen_favorites_main_fnc_getcreatetreecontextbyidc;
_treeContext params ["_mode", "_side"];
private _ignoreVariables = [];

switch (true) do {
    case ((ctrlIDC _tree) == ZEN_FAVORITES_IDC_CREATE_UNITS_EMPTY): {
        _ignoreVariables = [
            "zen_favorites_main_ignoreEmptyUnitsExpandEvents",
            "zen_favorites_main_ignoreEmptyUnitsProxySelection"
        ];
    };
    case ((ctrlIDC _tree) == ZEN_FAVORITES_IDC_CREATE_GROUPS_EMPTY): {
        _ignoreVariables = [
            "zen_favorites_main_ignoreEmptyGroupsExpandEvents",
            "zen_favorites_main_ignoreEmptyGroupsProxySelection"
        ];
    };
    case ((ctrlIDC _tree) == ZEN_FAVORITES_IDC_CREATE_MODULES): {
        _ignoreVariables = [
            "zen_favorites_main_ignoreModuleExpandEvents",
            "zen_favorites_main_ignoreModuleProxySelection"
        ];
    };
    case (_mode in ["units", "groups"] && {_side != "empty"}): {
        _ignoreVariables = [
            "zen_favorites_main_ignoreFactionLeafExpandEvents",
            "zen_favorites_main_ignoreFactionLeafProxySelection",
            "zen_favorites_main_ignoreFactionExpandEvents"
        ];
    };
};

[_tree, "zen_favorites_main_activeEmptyUnitsFavoritePath"] call zen_favorites_main_fnc_clearactivefavoriteproxy;
[_tree, "zen_favorites_main_activeEmptyGroupsFavoritePath"] call zen_favorites_main_fnc_clearactivefavoriteproxy;
[_tree, "zen_favorites_main_activeModuleFavoritePath"] call zen_favorites_main_fnc_clearactivefavoriteproxy;
[_tree, "zen_favorites_main_activeFactionLeafFavoritePath"] call zen_favorites_main_fnc_clearactivefavoriteproxy;

{
    _tree setVariable [_x, true];
} forEach _ignoreVariables;

_tree setVariable ["zen_favorites_main_ignoreGeneratedBranchSelectionGuard", true];
_tree tvSetCurSel _path;

[{
    params ["_tree", "_ignoreVariables"];

    if (isNull _tree) exitWith {};

    {
        _tree setVariable [_x, false];
    } forEach _ignoreVariables;

    _tree setVariable ["zen_favorites_main_ignoreGeneratedBranchSelectionGuard", false];
}, [_tree, _ignoreVariables]] call CBA_fnc_execNextFrame;

[ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
    "selected generated Favorites branch inertly path=%1 displayPath=%2",
    _path,
    _displayPath
]] call zen_favorites_main_fnc_log;

true
