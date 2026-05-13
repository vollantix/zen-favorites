#include "..\script_component.hpp"

params ["_display"];

[ZEN_FILTER_LOG_LEVEL_INFO, "inspecting Zeus Create tree"] call zen_filter_main_fnc_log;

private _pictureControls = allControls _display select {
    ctrlShown _x && {".paa" in toLower ctrlText _x}
};

[ZEN_FILTER_LOG_LEVEL_INFO, format [
    "visible picture controls with textures=%1",
    count _pictureControls
]] call zen_filter_main_fnc_log;

{
    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "picture control idc=%1 class=%2 text=%3 position=%4",
        ctrlIDC _x,
        ctrlClassName _x,
        ctrlText _x,
        ctrlPosition _x
    ]] call zen_filter_main_fnc_log;
} forEach (_pictureControls select [0, 30]);

private _activeTree = [_display] call zen_filter_main_fnc_getactivecreatetree;
_activeTree params ["_tree", "_idc", "_mode", "_side"];

if (isNull _tree) exitWith {
    [ZEN_FILTER_LOG_LEVEL_WARN, "no active Create tree found"] call zen_filter_main_fnc_log;
};

private _rootCount = _tree tvCount [];
private _position = ctrlPosition _tree;

[ZEN_FILTER_LOG_LEVEL_INFO, format [
    "active tree idc=%1 class=%2 mode=%3 side=%4 position=%5 rootCount=%6",
    _idc,
    ctrlClassName _tree,
    _mode,
    _side,
    _position,
    _rootCount
]] call zen_filter_main_fnc_log;

for "_index" from 0 to ((_rootCount - 1) min 20) do {
    private _path = [_index];

    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "active tree row %1 text=%2 data=%3 children=%4",
        _index,
        _tree tvText _path,
        _tree tvData _path,
        _tree tvCount _path
    ]] call zen_filter_main_fnc_log;
};

private _selectedPath = tvCurSel _tree;

if (_selectedPath isEqualTo []) exitWith {
    [ZEN_FILTER_LOG_LEVEL_INFO, "active tree has no selected row"] call zen_filter_main_fnc_log;
};

[ZEN_FILTER_LOG_LEVEL_INFO, format [
    "selected row path=%1 text=%2 data=%3 children=%4",
    _selectedPath,
    _tree tvText _selectedPath,
    _tree tvData _selectedPath,
    _tree tvCount _selectedPath
]] call zen_filter_main_fnc_log;

private _ancestorPath = [];

{
    _ancestorPath pushBack _x;

    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "selected ancestor path=%1 text=%2 data=%3 children=%4",
        _ancestorPath,
        _tree tvText _ancestorPath,
        _tree tvData _ancestorPath,
        _tree tvCount _ancestorPath
    ]] call zen_filter_main_fnc_log;
} forEach _selectedPath;

private _childCount = _tree tvCount _selectedPath;

for "_index" from 0 to ((_childCount - 1) min 20) do {
    private _childPath = +_selectedPath;
    _childPath pushBack _index;

    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "selected child %1 path=%2 text=%3 data=%4 children=%5",
        _index,
        _childPath,
        _tree tvText _childPath,
        _tree tvData _childPath,
        _tree tvCount _childPath
    ]] call zen_filter_main_fnc_log;
};
