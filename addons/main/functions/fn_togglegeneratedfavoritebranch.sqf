#include "..\script_component.hpp"

// Toggle a generated Favorites folder using the same remembered expansion state as normal clicks.
params ["_tree", ["_path", []]];

if (isNull _tree || {_path isEqualTo []}) exitWith {false};
if ((_tree tvCount _path) == 0) exitWith {false};
if !([_tree, _path] call zen_favorites_main_fnc_isgeneratedfavoritesbranch) exitWith {false};

private _treeContext = [ctrlIDC _tree] call zen_favorites_main_fnc_getcreatetreecontextbyidc;
_treeContext params ["_mode", "_side"];
private _stateVariable = "";

switch (true) do {
    case ((ctrlIDC _tree) == ZEN_FAVORITES_IDC_CREATE_UNITS_EMPTY): {
        _stateVariable = "zen_favorites_main_emptyUnitsExpandedTextPaths";
    };
    case ((ctrlIDC _tree) == ZEN_FAVORITES_IDC_CREATE_GROUPS_EMPTY): {
        _stateVariable = "zen_favorites_main_emptyGroupsExpandedTextPaths";
    };
    case ((ctrlIDC _tree) == ZEN_FAVORITES_IDC_CREATE_MODULES): {
        _stateVariable = "zen_favorites_main_moduleExpandedTextPaths";
    };
    case (_mode in ["units", "groups"] && {_side != "empty"}): {
        _stateVariable = format ["zen_favorites_main_factionLeafExpandedTextPaths_%1_%2", _mode, _side];
    };
};

if (_stateVariable == "") exitWith {false};

private _displayPath = [_tree, _path] call zen_favorites_main_fnc_gettreepathtexts;
private _expandedTextPaths = +(missionNamespace getVariable [_stateVariable, (_tree getVariable [_stateVariable, []])]);
private _isExpanded = _displayPath in _expandedTextPaths;

if (_isExpanded) then {
    _tree tvCollapse _path;
    [_tree, _path, false, _stateVariable] call zen_favorites_main_fnc_setfavoritetreeexpanded;
} else {
    _tree tvExpand _path;
    [_tree, _path, true, _stateVariable] call zen_favorites_main_fnc_setfavoritetreeexpanded;
};

[ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
    "toggled generated Favorites branch path=%1 displayPath=%2 expanded=%3",
    _path,
    _displayPath,
    !_isExpanded
]] call zen_favorites_main_fnc_log;

true
