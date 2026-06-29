#include "..\script_component.hpp"

// Refresh non-empty Units/Groups leaf favorite branches and leaf star colors.
params ["_tree", "_idc", "_mode", "_side", "_searchText", "_favoriteColor", "_normalColor"];

private _isLeafFavoriteRenderDeferred = diag_tickTime < (_tree getVariable [
    "zen_favorites_main_leafFavoriteRenderDeferredUntil",
    0
]);
private _favoriteKey = format ["%1:%2", _mode, _side];
private _favoriteStore = missionNamespace getVariable ["zen_favorites_main_factionLeafFavorites", createHashMap];
private _favorites = (_favoriteStore getOrDefault [_favoriteKey, []]) select {
    (_x isEqualType []) &&
    {count _x >= 6} &&
    {(_x select 0) isEqualType []} &&
    {(_x select 2) isEqualType ""}
};
private _rootCount = _tree tvCount [];
private _childCount = if (_mode == "groups" && {_rootCount > 0}) then {_tree tvCount [0]} else {0};
private _starAlignment = missionNamespace getVariable ["zen_favorites_main_starAlignment", ZEN_FAVORITES_STAR_ALIGNMENT_LEFT];
private _favoriteLayout = [_mode] call zen_favorites_main_fnc_getfavoritelayout;
private _renderSignature = str [
    _idc,
    _mode,
    _side,
    _searchText,
    _starAlignment,
    _favoriteLayout,
    _rootCount,
    _childCount,
    _favorites,
    _isLeafFavoriteRenderDeferred
];

if ((_tree getVariable ["zen_favorites_main_lastFactionLeafRenderSignature", ""]) == _renderSignature) exitWith {};

_tree setVariable ["zen_favorites_main_lastFactionLeafRenderSignature", _renderSignature];

if (_searchText == "") then {
    if (!_isLeafFavoriteRenderDeferred) then {
        [_tree, _mode, _side] call zen_favorites_main_fnc_renderfactionleaffavoritescategory;
    };
} else {
    // Search results are transient; hide generated Favorites branches while searching.
    private _favoritesParentPath = [];

    if (_mode == "groups") then {
        if (_rootCount == 0) exitWith {};
        _favoritesParentPath = [0];
    };

    for "_index" from ((_tree tvCount _favoritesParentPath) - 1) to 0 step -1 do {
        private _path = +_favoritesParentPath;
        _path pushBack _index;

        if ([_tree tvText _path] call zen_favorites_main_fnc_isfavoritepath) then {
            _tree tvDelete _path;
        };
    };

    _tree setVariable ["zen_favorites_main_factionLeafFavoritesSignature", ""];
};

private _favoriteIds = _favorites apply {_x select 2};
private _renderPath = {
    params ["_path"];

    private _childCount = _tree tvCount _path;

    if (_childCount == 0) then {
        private _displayPath = [_tree, _path] call zen_favorites_main_fnc_gettreepathtexts;
        private _sourceDisplayPath = [_displayPath] call zen_favorites_main_fnc_removefavoritepathmarker;
        private _favoriteSourcePathMap = _tree getVariable ["zen_favorites_main_factionLeafFavoriteSourcePaths", createHashMap];

        if ([_displayPath] call zen_favorites_main_fnc_isfavoritepath) then {
            _sourceDisplayPath = _favoriteSourcePathMap getOrDefault [str _displayPath, _sourceDisplayPath];
        };

        private _favoriteId = str _sourceDisplayPath;
        private _color = [_normalColor, _favoriteColor] select (_favoriteId in _favoriteIds);

        if ([_displayPath] call zen_favorites_main_fnc_isfavoritepath) then {
            _color = _favoriteColor;
        };

        [_tree, _path, _color] call zen_favorites_main_fnc_setfavoritestar;
    } else {
        for "_index" from 0 to (_childCount - 1) do {
            private _childPath = +_path;
            _childPath pushBack _index;

            [_childPath] call _renderPath;
        };
    };
};

if (_mode == "units") then {
    for "_index" from 0 to (_rootCount - 1) do {
        if !([_tree tvText [_index]] call zen_favorites_main_fnc_isfavoritepath) then {
            [[_index]] call _renderPath;
        };
    };
};

if (_mode == "groups" && {_rootCount > 0}) then {
    for "_index" from 0 to ((_tree tvCount [0]) - 1) do {
        private _path = [0, _index];

        if !([_tree tvText _path] call zen_favorites_main_fnc_isfavoritepath) then {
            [_path] call _renderPath;
        };
    };
};
