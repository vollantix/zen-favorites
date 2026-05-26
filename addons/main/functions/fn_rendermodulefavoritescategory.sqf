#include "..\script_component.hpp"

params ["_tree"];

private _favorites = (missionNamespace getVariable ["zen_favorites_main_moduleFavorites", []]) select {
    (_x isEqualType []) &&
    {count _x >= 6} &&
    {(_x select 0) isEqualType []} &&
    {(_x select 2) isEqualType ""}
};
private _signature = str _favorites;
private _rootCount = _tree tvCount [];
private _hasFavoritesRoot = false;

for "_index" from 0 to (_rootCount - 1) do {
    if ((_tree tvText [_index]) == "Favorites") exitWith {
        _hasFavoritesRoot = true;
    };
};

if (
    (_tree getVariable ["zen_favorites_main_moduleFavoritesSignature", ""] == _signature) &&
    {!(_favorites isEqualTo [] && {_hasFavoritesRoot})}
) exitWith {};

private _originalRootOrder = _tree getVariable ["zen_favorites_main_moduleOriginalRootOrder", []];
private _sessionExpandedTextPaths = +(missionNamespace getVariable ["zen_favorites_main_moduleExpandedTextPaths", []]);
private _expandedTextPaths = +(_tree getVariable ["zen_favorites_main_moduleExpandedTextPaths", _sessionExpandedTextPaths]);
private _pendingExpandTextPaths = +(_tree getVariable ["zen_favorites_main_modulePendingExpandTextPaths", []]);

if (_originalRootOrder isEqualTo []) then {
    for "_index" from 0 to (_rootCount - 1) do {
        private _rootText = _tree tvText [_index];

        if (_rootText != "Favorites") then {
            _originalRootOrder pushBack _rootText;
        };
    };

    _tree setVariable ["zen_favorites_main_moduleOriginalRootOrder", _originalRootOrder];
};

_tree setVariable ["zen_favorites_main_ignoreModuleExpandEvents", true];

for "_index" from (_rootCount - 1) to 0 step -1 do {
    if ((_tree tvText [_index]) == "Favorites") then {
        _tree tvDelete [_index];
    };
};

if (_favorites isEqualTo []) exitWith {
    _tree setVariable ["zen_favorites_main_moduleFavoritesSignature", _signature];
    _tree setVariable ["zen_favorites_main_moduleFavoriteBranchTextPaths", []];
    _tree setVariable ["zen_favorites_main_moduleExpandedTextPaths", []];
    _tree setVariable ["zen_favorites_main_modulePendingExpandTextPaths", []];
    missionNamespace setVariable ["zen_favorites_main_moduleExpandedTextPaths", []];
    _tree setVariable ["zen_favorites_main_ignoreModuleExpandEvents", false];
};

private _getOriginalSortValue = {
    params ["_path"];

    private _value = 0;
    private _multiplier = 1;

    {
        _value = _value + (_x * _multiplier);
        _multiplier = _multiplier * 1000;
    } forEach _path;

    _value
};

private _favoritesRootIndex = _tree tvAdd [[], "Favorites"];
private _favoritesRootPath = [_favoritesRootIndex];
private _favoriteBranchTextPaths = [];

_tree tvSetData [_favoritesRootPath, "Logic"];
_tree tvSetValue [_favoritesRootPath, -1000];

{
    private _displayPath = _x select 0;
    private _className = _x select 1;
    private _originalPath = [_tree, _displayPath] call zen_favorites_main_fnc_findtreepathbytexts;

    if (_originalPath isEqualTo [] && {_className != ""}) then {
        _originalPath = [_tree, [], _className] call zen_favorites_main_fnc_findtreepathbydata;
    };

    if (_originalPath isEqualTo []) then {
        [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
            "skipped missing Module favorite class=%1 displayPath=%2",
            _className,
            _displayPath
        ]] call zen_favorites_main_fnc_log;
        continue;
    };

    private _originalSortValue = [_originalPath] call _getOriginalSortValue;
    private _parentPath = +_favoritesRootPath;
    private _relativeBranchPath = [];

    {
        private _segment = _x;
        private _existingIndex = -1;
        private _childCount = _tree tvCount _parentPath;
        private _originalSegmentPath = _originalPath select [0, ((count _originalPath) - 1) min (_forEachIndex + 1)];

        for "_childIndex" from 0 to (_childCount - 1) do {
            private _candidatePath = +_parentPath;
            _candidatePath pushBack _childIndex;

            if ((_tree tvText _candidatePath) == _segment) exitWith {
                _existingIndex = _childIndex;
            };
        };

        if (_existingIndex == -1) then {
            _existingIndex = _tree tvAdd [_parentPath, _segment];
        };

        _parentPath pushBack _existingIndex;
        _relativeBranchPath pushBack _segment;

        _tree tvSetData [_parentPath, "Logic"];
        _tree tvSetValue [_parentPath, _tree tvValue _originalSegmentPath];
        _tree tvSetTooltip [_parentPath, _tree tvTooltip _originalSegmentPath];
        _tree tvSetPicture [_parentPath, _tree tvPicture _originalSegmentPath];

        if (_forEachIndex < ((count _displayPath) - 1)) then {
            private _favoriteBranchTextPath = ["Favorites"] + _relativeBranchPath;

            _favoriteBranchTextPaths pushBack _favoriteBranchTextPath;
        };
    } forEach _displayPath;

    _tree tvSetData [_parentPath, _className];
    _tree tvSetValue [_parentPath, _x select 3];
    _tree tvSetTooltip [_parentPath, _tree tvTooltip _originalPath];
    _tree tvSetPicture [_parentPath, _tree tvPicture _originalPath];
    _tree tvSetPictureRight [_parentPath, ZEN_FAVORITES_STAR_TEXTURE];
    _tree tvSetPictureRightColor [_parentPath, [1, 0.82, 0.25, 1]];
    _tree tvSetPictureRightColorSelected [_parentPath, [1, 0.82, 0.25, 1]];
} forEach _favorites;

if ((_tree tvCount _favoritesRootPath) == 0) exitWith {
    _tree tvDelete _favoritesRootPath;
    _tree setVariable ["zen_favorites_main_moduleFavoritesSignature", _signature];
    _tree setVariable ["zen_favorites_main_moduleFavoriteBranchTextPaths", []];
    _tree setVariable ["zen_favorites_main_moduleExpandedTextPaths", []];
    _tree setVariable ["zen_favorites_main_modulePendingExpandTextPaths", []];
    missionNamespace setVariable ["zen_favorites_main_moduleExpandedTextPaths", []];
    _tree setVariable ["zen_favorites_main_ignoreModuleExpandEvents", false];

    [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
        "removed Module Favorites category because no favorites rendered storedCount=%1",
        count _favorites
    ]] call zen_favorites_main_fnc_log;
};

private _newRootCount = _tree tvCount [];

for "_index" from 0 to (_newRootCount - 1) do {
    private _path = [_index];
    private _rootText = _tree tvText _path;
    private _originalIndex = _originalRootOrder find _rootText;
    private _sortValue = if (_rootText == "Favorites") then {
        -1000
    } else {
        1000 + ([_newRootCount, _originalIndex] select (_originalIndex >= 0))
    };

    _tree tvSetValue [_path, _sortValue];
};

_tree tvSortByValue [[], true];

private _restoreExpandedTextPaths = +_expandedTextPaths;

{
    if !(_x in _restoreExpandedTextPaths) then {
        _restoreExpandedTextPaths pushBack _x;
    };
} forEach _pendingExpandTextPaths;

private _expandedTextPathsAfterRender = [_tree, _restoreExpandedTextPaths, "zen_favorites_main_moduleExpandedTextPaths"] call zen_favorites_main_fnc_restorefavoritetreeexpanded;

_tree setVariable ["zen_favorites_main_moduleFavoritesSignature", _signature];
_tree setVariable ["zen_favorites_main_moduleFavoriteBranchTextPaths", _favoriteBranchTextPaths];
_tree setVariable ["zen_favorites_main_moduleExpandedTextPaths", _expandedTextPathsAfterRender];
_tree setVariable ["zen_favorites_main_modulePendingExpandTextPaths", []];
_tree setVariable ["zen_favorites_main_ignoreModuleExpandEvents", false];

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "rendered Module Favorites category count=%1",
    count _favorites
]] call zen_favorites_main_fnc_log;
