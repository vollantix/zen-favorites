#include "..\script_component.hpp"

// Track expansion state for top-level faction rows across reorder operations.
params ["_tree", ["_path", []], ["_expanded", false], ["_force", false]];

if (isNull _tree) exitWith {};
if (_tree getVariable ["zen_favorites_main_ignoreFactionExpandEvents", false]) exitWith {};

if (!_force) then {
    private _lastUserTreeClick = _tree getVariable ["zen_favorites_main_lastUserTreeClick", -1000];
    private _lastUserTreeClickPath = _tree getVariable ["zen_favorites_main_lastUserTreeClickPath", []];

    if ((diag_tickTime - _lastUserTreeClick) > 0.75) exitWith {
        [ZEN_FAVORITES_LOG_LEVEL_TRACE, format [
            "ignored non-user faction expand state idc=%1 path=%2 expanded=%3 lastClickPath=%4 age=%5",
            ctrlIDC _tree,
            _path,
            _expanded,
            _lastUserTreeClickPath,
            diag_tickTime - _lastUserTreeClick
        ]] call zen_favorites_main_fnc_log;
    };

    _tree setVariable ["zen_favorites_main_lastUserTreeClick", -1000];
    _tree setVariable ["zen_favorites_main_lastUserTreeClickPath", []];

    if (_lastUserTreeClickPath isNotEqualTo _path) exitWith {
        [ZEN_FAVORITES_LOG_LEVEL_TRACE, format [
            "ignored mismatched faction expand state idc=%1 path=%2 expanded=%3 lastClickPath=%4",
            ctrlIDC _tree,
            _path,
            _expanded,
            _lastUserTreeClickPath
        ]] call zen_favorites_main_fnc_log;
    };
};

private _mode = "";
private _side = "";

switch (ctrlIDC _tree) do {
    case ZEN_FAVORITES_IDC_CREATE_UNITS_WEST: {
        _mode = "units";
        _side = "west";
    };
    case ZEN_FAVORITES_IDC_CREATE_UNITS_EAST: {
        _mode = "units";
        _side = "east";
    };
    case ZEN_FAVORITES_IDC_CREATE_UNITS_GUER: {
        _mode = "units";
        _side = "guer";
    };
    case ZEN_FAVORITES_IDC_CREATE_UNITS_CIV: {
        _mode = "units";
        _side = "civ";
    };
    case ZEN_FAVORITES_IDC_CREATE_GROUPS_WEST: {
        _mode = "groups";
        _side = "west";
    };
    case ZEN_FAVORITES_IDC_CREATE_GROUPS_EAST: {
        _mode = "groups";
        _side = "east";
    };
    case ZEN_FAVORITES_IDC_CREATE_GROUPS_GUER: {
        _mode = "groups";
        _side = "guer";
    };
};

if (_mode == "" || {_side == ""}) exitWith {};

private _rowId = "";

if (_mode == "units" && {count _path == 1}) then {
    _rowId = _tree tvText _path;
};

if (_mode == "groups") then {
    if (_path isEqualTo [0]) then {
        _rowId = "__root__";
    };

    if (count _path == 2 && {(_path select 0) == 0}) then {
        _rowId = _tree tvText _path;
    };
};

if (_rowId == "") exitWith {};

private _stateKey = format ["%1:%2", _mode, _side];
private _expandedStore = missionNamespace getVariable ["zen_favorites_main_factionExpandedRows", createHashMap];
private _expandedRows = +(_expandedStore getOrDefault [_stateKey, []]);
private _existingIndex = _expandedRows find _rowId;

if (_expanded) then {
    if (_existingIndex == -1) then {
        _expandedRows pushBack _rowId;
    };
} else {
    if (_existingIndex != -1) then {
        _expandedRows deleteAt _existingIndex;
    };
};

_expandedStore set [_stateKey, _expandedRows];
missionNamespace setVariable ["zen_favorites_main_factionExpandedRows", _expandedStore];

[ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
    "stored faction row expanded state key=%1 row=%2 expanded=%3 values=%4",
    _stateKey,
    _rowId,
    _expanded,
    _expandedRows
]] call zen_favorites_main_fnc_log;
