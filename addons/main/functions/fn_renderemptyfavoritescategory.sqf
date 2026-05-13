#include "..\script_component.hpp"

params ["_tree"];

private _favorites = missionNamespace getVariable ["zen_filter_main_emptyFavorites", []];
private _signature = str _favorites;

if (_tree getVariable ["zen_filter_main_emptyFavoritesSignature", ""] == _signature) exitWith {};

private _rootCount = _tree tvCount [];

for "_index" from (_rootCount - 1) to 0 step -1 do {
    if ((_tree tvText [_index]) == "Favorites") then {
        _tree tvDelete [_index];
    };
};

if (_favorites isEqualTo []) exitWith {
    _tree setVariable ["zen_filter_main_emptyFavoritesSignature", _signature];
};

private _favoritesRootIndex = _tree tvAdd [[], "Favorites"];
private _favoritesRootPath = [_favoritesRootIndex];

_tree tvSetValue [_favoritesRootPath, -1000];

{
    private _displayPath = _x select 0;
    private _className = _x select 1;
    private _parentPath = +_favoritesRootPath;

    {
        private _segment = _x;
        private _existingIndex = -1;
        private _childCount = _tree tvCount _parentPath;

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
    } forEach _displayPath;

    _tree tvSetData [_parentPath, _className];
    _tree tvSetPictureRight [_parentPath, ZEN_FILTER_STAR_TEXTURE];
    _tree tvSetPictureRightColor [_parentPath, [1, 0.82, 0.25, 1]];
    _tree tvSetPictureRightColorSelected [_parentPath, [1, 0.82, 0.25, 1]];
} forEach _favorites;

_tree tvExpand _favoritesRootPath;
_tree tvSortByValue [[], true];
_tree setVariable ["zen_filter_main_emptyFavoritesSignature", _signature];

[ZEN_FILTER_LOG_LEVEL_INFO, format [
    "rendered Empty Favorites category count=%1",
    count _favorites
]] call zen_filter_main_fnc_log;
