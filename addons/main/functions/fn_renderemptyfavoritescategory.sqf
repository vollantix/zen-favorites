#include "..\script_component.hpp"

params ["_tree", "_mode"];

private _storeKey = format ["zen_filter_main_emptyFavorites_%1", _mode];
private _favorites = (missionNamespace getVariable [_storeKey, []]) select {
    (_x isEqualType []) &&
    {count _x >= 2} &&
    {(_x select 1) isEqualType ""} &&
    {(_x select 1) != ""}
};
private _signature = str _favorites;

if (_tree getVariable ["zen_filter_main_emptyFavoritesSignature", ""] == _signature) exitWith {};

private _rootCount = _tree tvCount [];
private _favoritesParentPath = [];
private _originalRootOrder = _tree getVariable ["zen_filter_main_emptyOriginalRootOrder", []];

if (_originalRootOrder isEqualTo []) then {
    for "_index" from 0 to (_rootCount - 1) do {
        private _rootText = _tree tvText [_index];

        if (_rootText != "Favorites") then {
            _originalRootOrder pushBack _rootText;
        };
    };

    _tree setVariable ["zen_filter_main_emptyOriginalRootOrder", _originalRootOrder];
};

for "_index" from (_rootCount - 1) to 0 step -1 do {
    if ((_tree tvText [_index]) == "Favorites") then {
        _tree tvDelete [_index];
    };
};

if (_favoritesParentPath isNotEqualTo []) then {
    for "_index" from ((_tree tvCount _favoritesParentPath) - 1) to 0 step -1 do {
        private _path = +_favoritesParentPath;
        _path pushBack _index;

        if ((_tree tvText _path) == "Favorites") then {
            _tree tvDelete _path;
        };
    };
};

if (_favorites isEqualTo []) exitWith {
    _tree setVariable ["zen_filter_main_emptyFavoritesSignature", _signature];
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

private _favoritesRootIndex = _tree tvAdd [_favoritesParentPath, "Favorites"];
private _favoritesRootPath = +_favoritesParentPath;
_favoritesRootPath pushBack _favoritesRootIndex;
private _favoriteBranchTextPaths = [];

_tree tvSetValue [_favoritesRootPath, -1000];

{
    private _displayPath = _x select 0;
    private _className = _x select 1;
    private _originalPath = if (_mode == "groups") then {
        [_tree, _displayPath] call zen_filter_main_fnc_findtreepathbytexts
    } else {
        [_tree, [], _className] call zen_filter_main_fnc_findtreepathbydata
    };
    private _relativeDisplayPath = +_displayPath;

    if (_originalPath isEqualTo []) then {
        [ZEN_FILTER_LOG_LEVEL_DEBUG, format [
            "skipped missing Empty favorite class=%1 displayPath=%2",
            _className,
            _displayPath
        ]] call zen_filter_main_fnc_log;
        continue;
    };

    if (_mode == "units") then {
        private _leafText = _relativeDisplayPath param [(count _relativeDisplayPath) - 1, ""];
        private _categoryParts = _relativeDisplayPath select [0, ((count _relativeDisplayPath) - 1) max 0];
        private _categoryText = if (_categoryParts isEqualTo []) then {"Favorites"} else {_categoryParts joinString " / "};

        _relativeDisplayPath = [_categoryText, _leafText];
    };

    private _pathOffset = (count _displayPath) - (count _relativeDisplayPath);
    private _originalSortValue = [_originalPath] call _getOriginalSortValue;
    private _parentPath = +_favoritesRootPath;
    private _relativeBranchPath = [];

    {
        private _segment = _x;
        private _existingIndex = -1;
        private _childCount = _tree tvCount _parentPath;
        private _originalSegmentPath = _originalPath select [0, ((count _originalPath) - 1) min (_forEachIndex + 1 + _pathOffset)];

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

        _tree tvSetData [_parentPath, ""];
        _tree tvSetValue [_parentPath, _originalSortValue + _forEachIndex];
        _tree tvSetTooltip [_parentPath, _tree tvTooltip _originalSegmentPath];
        _tree tvSetPicture [_parentPath, _tree tvPicture _originalSegmentPath];

        if (_forEachIndex < ((count _relativeDisplayPath) - 1)) then {
            _tree tvExpand _parentPath;
            _favoriteBranchTextPaths pushBack +_relativeBranchPath;
        };
    } forEach _relativeDisplayPath;

    _tree tvSetData [_parentPath, _className];
    _tree tvSetValue [_parentPath, _originalSortValue];
    _tree tvSetTooltip [_parentPath, _tree tvTooltip _originalPath];
    _tree tvSetPicture [_parentPath, _tree tvPicture _originalPath];
    _tree tvSetPictureRight [_parentPath, ZEN_FILTER_STAR_TEXTURE];
    _tree tvSetPictureRightColor [_parentPath, [1, 0.82, 0.25, 1]];
    _tree tvSetPictureRightColorSelected [_parentPath, [1, 0.82, 0.25, 1]];
} forEach _favorites;

if (_favoritesParentPath isEqualTo []) then {
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
} else {
    private _childCount = _tree tvCount _favoritesParentPath;

    for "_index" from 0 to (_childCount - 1) do {
        private _path = +_favoritesParentPath;
        _path pushBack _index;

        if ((_tree tvText _path) == "Favorites") then {
            _tree tvSetValue [_path, -1000];
        };
    };

    _tree tvSortByValue [_favoritesParentPath, true];
};

_tree tvExpand _favoritesRootPath;
private _sortFavoritesPath = +_favoritesRootPath;

while {true} do {
    _tree tvSortByValue [_sortFavoritesPath, true];

    if ((_tree tvCount _sortFavoritesPath) == 0) exitWith {};

    _sortFavoritesPath pushBack 0;
};

{
    private _pathToExpand = +_favoritesRootPath;
    private _found = true;

    {
        private _segment = _x;
        private _foundChildPath = [];

        for "_index" from 0 to ((_tree tvCount _pathToExpand) - 1) do {
            private _candidatePath = +_pathToExpand;
            _candidatePath pushBack _index;

            if ((_tree tvText _candidatePath) == _segment) exitWith {
                _foundChildPath = _candidatePath;
            };
        };

        if (_foundChildPath isEqualTo []) exitWith {
            _found = false;
        };

        _pathToExpand = _foundChildPath;
    } forEach _x;

    if (_found) then {
        _tree tvExpand _pathToExpand;
    };
} forEach _favoriteBranchTextPaths;

_tree setVariable ["zen_filter_main_emptyFavoritesSignature", _signature];

[ZEN_FILTER_LOG_LEVEL_INFO, format [
    "rendered Empty Favorites category count=%1",
    count _favorites
]] call zen_filter_main_fnc_log;
