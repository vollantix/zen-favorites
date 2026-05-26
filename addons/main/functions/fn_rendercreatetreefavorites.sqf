#include "..\script_component.hpp"

params ["_display"];

private _activeTree = [_display] call zen_favorites_main_fnc_getactivecreatetree;
_activeTree params ["_tree", "_idc", "_mode", "_side"];

if (isNull _tree) exitWith {};
if !(_mode in ["units", "groups", "modules"]) exitWith {};

private _favoriteColor = [1, 0.82, 0.25, 1];
private _normalColor = [1, 1, 1, 0.35];
private _searchText = ctrlText (_display displayCtrl 283);

[_tree] call zen_favorites_main_fnc_registercreatetreehandlers;

if (_mode == "modules") exitWith {
    [_tree, _idc, _searchText, _favoriteColor, _normalColor] call zen_favorites_main_fnc_rendermodulefavoriteview;
};

if (_side == "empty") exitWith {
    [_tree, _idc, _mode, _searchText, _favoriteColor, _normalColor] call zen_favorites_main_fnc_renderemptyfavoriteview;
};

[_display, _tree, _idc, _mode, _side, _searchText, _favoriteColor, _normalColor] call zen_favorites_main_fnc_renderfactionrootfavorites;
