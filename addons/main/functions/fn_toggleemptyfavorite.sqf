#include "..\script_component.hpp"

params ["_tree", "_path"];

if ((count _path) == 0) exitWith {
    [ZEN_FILTER_LOG_LEVEL_WARN, "cannot toggle Empty favorite: no selected tree row"] call zen_filter_main_fnc_log;
};

if ((_tree tvCount _path) > 0) exitWith {
    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "Empty favorite skipped for non-leaf path=%1 text=%2",
        _path,
        _tree tvText _path
    ]] call zen_filter_main_fnc_log;
};

private _className = _tree tvData _path;

if (_className == "") exitWith {
    [ZEN_FILTER_LOG_LEVEL_WARN, format [
        "cannot toggle Empty favorite: selected leaf has no tvData path=%1 text=%2",
        _path,
        _tree tvText _path
    ]] call zen_filter_main_fnc_log;
};

private _displayPath = [];
private _ancestorPath = [];

{
    _ancestorPath pushBack _x;
    _displayPath pushBack (_tree tvText _ancestorPath);
} forEach _path;

private _favorites = +(missionNamespace getVariable ["zen_filter_main_emptyFavorites", []]);
private _existingIndex = _favorites findIf {(_x select 1) == _className};

if (_existingIndex == -1) then {
    _favorites pushBack [_displayPath, _className];
    hint format ["Added Empty favorite: %1", _displayPath select -1];

    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "added Empty favorite class=%1 displayPath=%2",
        _className,
        _displayPath
    ]] call zen_filter_main_fnc_log;
} else {
    private _removed = _favorites deleteAt _existingIndex;
    hint format ["Removed Empty favorite: %1", (_removed select 0) select -1];

    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "removed Empty favorite class=%1 displayPath=%2",
        _className,
        _removed select 0
    ]] call zen_filter_main_fnc_log;
};

missionNamespace setVariable ["zen_filter_main_emptyFavorites", _favorites];

[ZEN_FILTER_LOG_LEVEL_INFO, format [
    "Empty favorites count=%1 values=%2",
    count _favorites,
    _favorites
]] call zen_filter_main_fnc_log;
