#include "..\script_component.hpp"

params ["_tree", "_idc", "_searchText", "_favoriteColor", "_normalColor"];

private _moduleFavorites = (missionNamespace getVariable ["zen_favorites_main_moduleFavorites", []]) select {
    (_x isEqualType []) &&
    {count _x >= 6} &&
    {(_x select 0) isEqualType []} &&
    {(_x select 2) isEqualType ""}
};
private _rootCount = _tree tvCount [];
private _renderSignature = str [
    _idc,
    _searchText,
    _rootCount,
    _moduleFavorites
];

if ((_tree getVariable ["zen_favorites_main_lastModuleRenderSignature", ""]) == _renderSignature) exitWith {};

_tree setVariable ["zen_favorites_main_lastModuleRenderSignature", _renderSignature];

if (_searchText == "") then {
    [_tree] call zen_favorites_main_fnc_rendermodulefavoritescategory;
} else {
    for "_index" from ((_tree tvCount []) - 1) to 0 step -1 do {
        if ((_tree tvText [_index]) == "Favorites") then {
            _tree tvDelete [_index];
        };
    };

    _tree setVariable ["zen_favorites_main_moduleFavoritesSignature", ""];
};

private _moduleFavoriteIds = _moduleFavorites apply {_x select 2};
private _renderModulePath = {
    params ["_path"];

    private _childCount = _tree tvCount _path;

    if (_childCount == 0) then {
        private _displayPath = [_tree, _path] call zen_favorites_main_fnc_gettreepathtexts;
        private _sourceDisplayPath = [_displayPath] call zen_favorites_main_fnc_removefavoritepathmarker;
        private _favoriteId = str _sourceDisplayPath;
        private _color = [_normalColor, _favoriteColor] select (_favoriteId in _moduleFavoriteIds);

        _tree tvSetPictureRight [_path, ZEN_FAVORITES_STAR_TEXTURE];
        _tree tvSetPictureRightColor [_path, _color];
        _tree tvSetPictureRightColorSelected [_path, _color];
    } else {
        for "_index" from 0 to (_childCount - 1) do {
            private _childPath = +_path;
            _childPath pushBack _index;
            [_childPath] call _renderModulePath;
        };
    };
};

for "_index" from 0 to ((_tree tvCount []) - 1) do {
    if ((_tree tvText [_index]) != "Favorites") then {
        [[_index]] call _renderModulePath;
    };
};
