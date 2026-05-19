#include "..\script_component.hpp"

params ["_tree", "_path", "_mode"];

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

if (_className == "" && {_mode != "groups"}) exitWith {
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

private _isGeneratedFavoritePath = ("Favorites" in _displayPath);
private _sourceDisplayPath = +_displayPath;

if (_isGeneratedFavoritePath) then {
    private _favoritesIndex = _sourceDisplayPath find "Favorites";

    if (_favoritesIndex >= 0) then {
        _sourceDisplayPath deleteAt _favoritesIndex;
    };
};

private _storeKey = format ["zen_filter_main_emptyFavorites_%1", _mode];
private _favorites = +(missionNamespace getVariable [_storeKey, []]);

if (_mode == "groups") then {
    _favorites = _favorites select {
        (_x isEqualType []) &&
        {count _x >= 6} &&
        {(_x select 0) isEqualType []} &&
        {(_x select 2) isEqualType ""} &&
        {(_x select 2) == str (_x select 0)}
    };
};

private _favoriteId = [_className, str _sourceDisplayPath] select (_mode == "groups");
private _favoriteEntry = if (_mode == "groups") then {
    [
        _sourceDisplayPath,
        _className,
        _favoriteId,
        _tree tvValue _path,
        _tree tvText _path,
        _tree tvPicture _path
    ]
} else {
    [_sourceDisplayPath, _className, _favoriteId]
};
private _existingIndex = _favorites findIf {
    private _storedId = if ((count _x) > 2) then {_x select 2} else {_x select 1};

    _storedId == _favoriteId
};

if (_existingIndex == -1) then {
    if (_isGeneratedFavoritePath) exitWith {
        [ZEN_FILTER_LOG_LEVEL_WARN, format [
            "skipped adding generated Empty favorite path=%1 sourcePath=%2 id=%3",
            _displayPath,
            _sourceDisplayPath,
            _favoriteId
        ]] call zen_filter_main_fnc_log;
    };

    _favorites pushBack _favoriteEntry;

    if (_mode == "units") then {
        [_tree, _mode, _favoriteEntry, false] call zen_filter_main_fnc_syncemptyfavoriterow;
    };

    hint format ["Added Empty favorite: %1", _sourceDisplayPath select -1];

    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "added Empty favorite mode=%1 data=%2 id=%3 displayPath=%4 entry=%5",
        _mode,
        _className,
        _favoriteId,
        _sourceDisplayPath,
        _favoriteEntry
    ]] call zen_filter_main_fnc_log;
} else {
    private _removed = _favorites deleteAt _existingIndex;

    if (_mode == "units") then {
        [_tree, _mode, _removed, true] call zen_filter_main_fnc_syncemptyfavoriterow;
    };

    hint format ["Removed Empty favorite: %1", (_removed select 0) select -1];

    if (_mode == "units") then {
        [true, "removed Empty unit favorite"] call zen_filter_main_fnc_clearemptyfavoritepreview;
    };

    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "removed Empty favorite mode=%1 data=%2 displayPath=%3 entry=%4",
        _mode,
        _className,
        _removed select 0,
        _removed
    ]] call zen_filter_main_fnc_log;
};

missionNamespace setVariable [_storeKey, _favorites];
profileNamespace setVariable [_storeKey, _favorites];
saveProfileNamespace;
_tree setVariable ["zen_filter_main_emptyFavoritesSignature", str _favorites];
_tree setVariable ["zen_filter_main_lastEmptyRenderSignature", ""];
_tree setVariable ["zen_filter_main_lastEmptyGroupsRenderSignature", ""];

if (_mode == "groups") then {
    _tree setVariable ["zen_filter_main_emptyFavoritesSignature", ""];

    if (ctrlText ((ctrlParent _tree) displayCtrl 283) == "") then {
        [_tree, _mode] call zen_filter_main_fnc_renderemptyfavoritescategory;
    };
};

[ZEN_FILTER_LOG_LEVEL_INFO, format [
    "Empty favorites mode=%1 count=%2 values=%3",
    _mode,
    count _favorites,
    _favorites
]] call zen_filter_main_fnc_log;
