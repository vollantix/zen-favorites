#include "..\script_component.hpp"

params ["_display", ["_pathOverride", []]];

private _activeTree = [_display] call zen_favorites_main_fnc_getactivecreatetree;
_activeTree params ["_tree", "_idc", "_mode", "_side"];

if (isNull _tree) exitWith {
    [ZEN_FAVORITES_LOG_LEVEL_WARN, "cannot toggle favorite: no active Create tree"] call zen_favorites_main_fnc_log;
};

if !(_mode in ["units", "groups"]) exitWith {
    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "favorite toggle skipped for unsupported mode=%1 side=%2",
        _mode,
        _side
    ]] call zen_favorites_main_fnc_log;
};

private _path = if (_pathOverride isEqualTo []) then {tvCurSel _tree} else {_pathOverride};
private _searchText = ctrlText (_display displayCtrl 283);
private _isSearching = _searchText != "";

if ((count _path) == 0) exitWith {
    [ZEN_FAVORITES_LOG_LEVEL_WARN, "cannot toggle favorite: no selected tree row"] call zen_favorites_main_fnc_log;
};

if (_side == "empty") exitWith {
    [_tree, _path, _mode] call zen_favorites_main_fnc_toggleemptyfavorite;
};

private _favoritePath = _path;

if (_isSearching && {_side != "empty"}) then {
    if (_mode == "units" && {(count _path) > 1}) then {
        _favoritePath = [_path select 0];
    };

    if (_mode == "groups" && {(count _path) > 2}) then {
        _favoritePath = [_path select 0, _path select 1];
    };
};

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "favorite toggle target mode=%1 side=%2 idc=%3 path=%4 text=%5 override=%6 search=%7 sourcePath=%8",
    _mode,
    _side,
    _idc,
    _favoritePath,
    _tree tvText _favoritePath,
    _pathOverride isNotEqualTo [],
    _isSearching,
    _path
]] call zen_favorites_main_fnc_log;

if (_mode == "units" && {(count _favoritePath) > 1}) exitWith {
    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "unit favorite toggle skipped for non-root path=%1",
        _favoritePath
    ]] call zen_favorites_main_fnc_log;
};

if (_mode == "groups" && {(count _favoritePath) != 2}) exitWith {
    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "group favorite toggle skipped: select a faction below the side root path=%1",
        _favoritePath
    ]] call zen_favorites_main_fnc_log;
};

private _favoriteKey = format ["%1:%2", _mode, _side];
private _favoriteStore = missionNamespace getVariable ["zen_favorites_main_factionFavorites", createHashMap];
private _favorites = +(_favoriteStore getOrDefault [_favoriteKey, []]);
private _factionName = _tree tvText _favoritePath;
private _addedFavorite = false;

if (_factionName in _favorites) then {
    _favorites deleteAt (_favorites find _factionName);
    _tree tvCollapse _favoritePath;
    [_tree, _favoritePath, false, true] call zen_favorites_main_fnc_setfactionrowexpanded;
    [format ["Removed favorite: %1", _factionName]] call zen_favorites_main_fnc_showactionhint;

    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "removed favorite faction=%1 key=%2 path=%3",
        _factionName,
        _favoriteKey,
        _favoritePath
    ]] call zen_favorites_main_fnc_log;
} else {
    _favorites pushBack _factionName;
    _favorites sort true;
    _addedFavorite = true;
    [format ["Added favorite: %1", _factionName]] call zen_favorites_main_fnc_showactionhint;

    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "added favorite faction=%1 key=%2 path=%3",
        _factionName,
        _favoriteKey,
        _favoritePath
    ]] call zen_favorites_main_fnc_log;
};

_favoriteStore set [_favoriteKey, _favorites];
missionNamespace setVariable ["zen_favorites_main_factionFavorites", _favoriteStore];

if (!_isSearching) then {
    [_display, true] call zen_favorites_main_fnc_applyfactionfavoriteorder;

    if (_addedFavorite) then {
        private _favoriteRootPath = [];

        if (_mode == "units") then {
            for "_index" from 0 to ((_tree tvCount []) - 1) do {
                if ((_tree tvText [_index]) == _factionName) exitWith {
                    _favoriteRootPath = [_index];
                };
            };
        };

        if (_mode == "groups") then {
            for "_index" from 0 to ((_tree tvCount [0]) - 1) do {
                if ((_tree tvText [0, _index]) == _factionName) exitWith {
                    _favoriteRootPath = [0, _index];
                };
            };
        };

        if (_favoriteRootPath isNotEqualTo []) then {
            _tree tvExpand _favoriteRootPath;
            [_tree, _favoriteRootPath, true, true] call zen_favorites_main_fnc_setfactionrowexpanded;
        };
    };
} else {
    _tree setVariable ["zen_favorites_main_lastFavoriteOrderSignature", ""];
};

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "favorites key=%1 values=%2",
    _favoriteKey,
    _favorites
]] call zen_favorites_main_fnc_log;
