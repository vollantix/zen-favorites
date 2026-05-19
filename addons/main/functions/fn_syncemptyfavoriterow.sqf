#include "..\script_component.hpp"

params ["_tree", "_mode", "_favorite", ["_remove", false]];

_favorite params ["_displayPath", "_className"];

private _rootCount = _tree tvCount [];
private _favoritesParentPath = [];
private _relativeDisplayPath = +_displayPath;
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

if (_mode == "units") then {
    private _leafText = _relativeDisplayPath param [(count _relativeDisplayPath) - 1, ""];
    private _categoryParts = _relativeDisplayPath select [0, ((count _relativeDisplayPath) - 1) max 0];
    private _categoryText = if (_categoryParts isEqualTo []) then {"Favorites"} else {_categoryParts joinString " / "};

    _relativeDisplayPath = [_categoryText, _leafText];
};

if (_mode == "groups" && {_relativeDisplayPath isNotEqualTo []} && {_rootCount > 0} && {(_relativeDisplayPath select 0) == (_tree tvText [0])}) then {
    _relativeDisplayPath deleteAt 0;
};

private _findChildByText = {
    params ["_parentPath", "_text"];

    private _result = -1;

    for "_index" from 0 to ((_tree tvCount _parentPath) - 1) do {
        private _candidatePath = +_parentPath;
        _candidatePath pushBack _index;

        if ((_tree tvText _candidatePath) == _text) exitWith {
            _result = _index;
        };
    };

    _result
};

private _favoritesIndex = [_favoritesParentPath, "Favorites"] call _findChildByText;

if (_favoritesIndex == -1) then {
    if (_remove) exitWith {};

    _favoritesIndex = _tree tvAdd [_favoritesParentPath, "Favorites"];

    private _favoritesRootPath = +_favoritesParentPath;
    _favoritesRootPath pushBack _favoritesIndex;

    _tree tvSetValue [_favoritesRootPath, -1000];

    if (_favoritesParentPath isEqualTo []) then {
        _tree tvSortByValue [[], true];
    } else {
        _tree tvSortByValue [_favoritesParentPath, true];
    };

    _favoritesIndex = [_favoritesParentPath, "Favorites"] call _findChildByText;
};

private _favoritesRootPath = +_favoritesParentPath;
_favoritesRootPath pushBack _favoritesIndex;

_tree tvSetValue [_favoritesRootPath, -1000];

private _parentPath = +_favoritesRootPath;
private _pathToFavorite = [];
private _originalPath = [_tree, [], _className] call zen_filter_main_fnc_findtreepathbydata;
private _originalSortValue = if (_originalPath isEqualTo []) then {0} else {[_originalPath] call _getOriginalSortValue};

{
    private _segment = _x;
    private _index = [_parentPath, _segment] call _findChildByText;

    if (_index == -1) then {
        if (_remove) exitWith {
            _pathToFavorite = [];
        };

        _index = _tree tvAdd [_parentPath, _segment];
    };

    _parentPath pushBack _index;
    _pathToFavorite = +_parentPath;

    _tree tvSetData [_pathToFavorite, ""];
    _tree tvSetValue [_pathToFavorite, _originalSortValue + _forEachIndex];
} forEach _relativeDisplayPath;

if (_pathToFavorite isEqualTo []) exitWith {};

if (_remove) exitWith {
    _tree tvDelete _pathToFavorite;

    private _prunePath = +_pathToFavorite;
    _prunePath deleteAt ((count _prunePath) - 1);

    while {count _prunePath > count _favoritesRootPath} do {
        if ((_tree tvCount _prunePath) > 0) exitWith {};

        private _parent = _prunePath select [0, (count _prunePath) - 1];
        _tree tvDelete _prunePath;
        _prunePath = _parent;
    };

    if ((_tree tvCount _favoritesRootPath) == 0) then {
        _tree tvDelete _favoritesRootPath;
    };
};

_tree tvSetData [_pathToFavorite, _className];
_tree tvSetValue [_pathToFavorite, _originalSortValue];

if (_originalPath isNotEqualTo []) then {
    _tree tvSetTooltip [_pathToFavorite, _tree tvTooltip _originalPath];
    _tree tvSetPicture [_pathToFavorite, _tree tvPicture _originalPath];
};

_tree tvSetPictureRight [_pathToFavorite, ZEN_FILTER_STAR_TEXTURE];
_tree tvSetPictureRightColor [_pathToFavorite, [1, 0.82, 0.25, 1]];
_tree tvSetPictureRightColorSelected [_pathToFavorite, [1, 0.82, 0.25, 1]];

private _sortPath = +_favoritesRootPath;

{
    _tree tvSortByValue [_sortPath, true];

    private _nextIndex = [_sortPath, _x] call _findChildByText;

    if (_nextIndex == -1) exitWith {};

    _sortPath pushBack _nextIndex;
} forEach _relativeDisplayPath;
