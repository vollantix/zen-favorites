#include "..\script_component.hpp"

params ["_display"];

private _activeTree = [_display] call zen_filter_main_fnc_getactivecreatetree;
_activeTree params ["_tree", "_idc", "_mode", "_side"];

if (isNull _tree) exitWith {
    [ZEN_FILTER_LOG_LEVEL_WARN, "cannot toggle favorite: no active Create tree"] call zen_filter_main_fnc_log;
};

if !(_mode in ["units", "groups"]) exitWith {
    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "favorite toggle skipped for unsupported mode=%1 side=%2",
        _mode,
        _side
    ]] call zen_filter_main_fnc_log;
};

if (_side == "empty") exitWith {
    [ZEN_FILTER_LOG_LEVEL_INFO, "favorite toggle skipped for Empty tree"] call zen_filter_main_fnc_log;
};

private _path = tvCurSel _tree;

if ((count _path) == 0) exitWith {
    [ZEN_FILTER_LOG_LEVEL_WARN, "cannot toggle favorite: no selected tree row"] call zen_filter_main_fnc_log;
};

private _favoritePath = _path;

if (_mode == "units" && {(count _path) > 1}) exitWith {
    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "unit favorite toggle skipped for non-root path=%1",
        _path
    ]] call zen_filter_main_fnc_log;
};

if (_mode == "groups" && {(count _path) != 2}) exitWith {
    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "group favorite toggle skipped: select a faction below the side root path=%1",
        _path
    ]] call zen_filter_main_fnc_log;
};

private _favoriteKey = format ["%1:%2", _mode, _side];
private _favoriteStore = missionNamespace getVariable ["zen_filter_main_factionFavorites", createHashMap];
private _favorites = +(_favoriteStore getOrDefault [_favoriteKey, []]);
private _factionName = _tree tvText _favoritePath;

if (_factionName in _favorites) then {
    _favorites deleteAt (_favorites find _factionName);
    hint format ["Removed favorite: %1", _factionName];

    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "removed favorite faction=%1 key=%2 path=%3",
        _factionName,
        _favoriteKey,
        _favoritePath
    ]] call zen_filter_main_fnc_log;
} else {
    _favorites pushBack _factionName;
    _favorites sort true;
    hint format ["Added favorite: %1", _factionName];

    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "added favorite faction=%1 key=%2 path=%3",
        _factionName,
        _favoriteKey,
        _favoritePath
    ]] call zen_filter_main_fnc_log;
};

_favoriteStore set [_favoriteKey, _favorites];
missionNamespace setVariable ["zen_filter_main_factionFavorites", _favoriteStore];

[ZEN_FILTER_LOG_LEVEL_INFO, format [
    "favorites key=%1 values=%2",
    _favoriteKey,
    _favorites
]] call zen_filter_main_fnc_log;
