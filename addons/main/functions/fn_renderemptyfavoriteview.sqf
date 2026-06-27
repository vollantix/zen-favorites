#include "..\script_component.hpp"

// Refresh Empty tree favorite branches and star colors for Units or Groups.
params ["_tree", "_idc", "_mode", "_searchText", "_favoriteColor", "_normalColor"];

if (_mode == "groups") exitWith {
    private _emptyStoreKey = format ["zen_favorites_main_emptyFavorites_%1", _mode];
    private _emptyFavorites = (missionNamespace getVariable [_emptyStoreKey, []]) select {
        (_x isEqualType []) &&
        {count _x >= 3} &&
        {(_x select 2) isEqualType ""}
    };
    private _rootCount = _tree tvCount [];
    private _starAlignment = missionNamespace getVariable ["zen_favorites_main_starAlignment", ZEN_FAVORITES_STAR_ALIGNMENT_LEFT];
    // Include root count so delayed ZEN tree population triggers a fresh render.
    private _renderSignature = str [
        _idc,
        _mode,
        _searchText,
        _starAlignment,
        _rootCount,
        _emptyFavorites
    ];

    if ((_tree getVariable ["zen_favorites_main_lastEmptyGroupsRenderSignature", ""]) == _renderSignature) exitWith {};

    _tree setVariable ["zen_favorites_main_lastEmptyGroupsRenderSignature", _renderSignature];

    if (_searchText == "") then {
        [_tree, _mode] call zen_favorites_main_fnc_renderemptyfavoritescategory;
    } else {
        // Search results are transient; hide generated Favorites branches while searching.
        for "_index" from ((_tree tvCount []) - 1) to 0 step -1 do {
            if ((_tree tvText [_index]) == "Favorites") then {
                _tree tvDelete [_index];
            };
        };

        _tree setVariable ["zen_favorites_main_emptyFavoritesSignature", ""];
    };

    private _emptyFavoriteIds = _emptyFavorites apply {_x select 2};
    private _renderEmptyGroupPath = {
        params ["_path"];

        private _childCount = _tree tvCount _path;

        if (_childCount == 0) then {
            private _displayPath = [_tree, _path] call zen_favorites_main_fnc_gettreepathtexts;

            private _favoriteId = str _displayPath;
            private _color = [_normalColor, _favoriteColor] select (_favoriteId in _emptyFavoriteIds);

            if ("Favorites" in _displayPath) then {
                _color = _favoriteColor;
            };

            [_tree, _path, _color] call zen_favorites_main_fnc_setfavoritestar;
        } else {
            for "_index" from 0 to (_childCount - 1) do {
                private _childPath = +_path;
                _childPath pushBack _index;
                [_childPath] call _renderEmptyGroupPath;
            };
        };
    };

    for "_index" from 0 to (_rootCount - 1) do {
        if ((_tree tvText [_index]) != "Favorites") then {
            [[_index]] call _renderEmptyGroupPath;
        };
    };
};

private _emptyStoreKey = format ["zen_favorites_main_emptyFavorites_%1", _mode];
private _emptyFavorites = (missionNamespace getVariable [_emptyStoreKey, []]) select {
    (_x isEqualType []) &&
    {count _x >= 2} &&
    {(_x select 1) isEqualType ""} &&
    {(_x select 1) != ""}
};
private _rootCount = _tree tvCount [];
private _starAlignment = missionNamespace getVariable ["zen_favorites_main_starAlignment", ZEN_FAVORITES_STAR_ALIGNMENT_LEFT];
// Include root count so delayed ZEN tree population triggers a fresh render.
private _renderSignature = str [
    _idc,
    _mode,
    _searchText,
    _starAlignment,
    _rootCount,
    _emptyFavorites
];

if ((_tree getVariable ["zen_favorites_main_lastEmptyRenderSignature", ""]) == _renderSignature) exitWith {};

_tree setVariable ["zen_favorites_main_lastEmptyRenderSignature", _renderSignature];

if (_searchText == "") then {
    [_tree, _mode] call zen_favorites_main_fnc_renderemptyfavoritescategory;
} else {
    // Search results are transient; hide generated Favorites branches while searching.
    for "_index" from ((_tree tvCount []) - 1) to 0 step -1 do {
        if ((_tree tvText [_index]) == "Favorites") then {
            _tree tvDelete [_index];
        };
    };

    _tree setVariable ["zen_favorites_main_emptyFavoritesSignature", ""];
};

private _emptyFavoriteIds = _emptyFavorites apply {
    if ((count _x) > 2) then {_x select 2} else {_x select 1}
};
private _renderEmptyPath = {
    params ["_path"];

    private _childCount = _tree tvCount _path;

    if (_childCount == 0) then {
        private _className = _tree tvData _path;

        if (_className != "") then {
            private _displayPath = [_tree, _path] call zen_favorites_main_fnc_gettreepathtexts;
            private _sourceDisplayPath = [_displayPath] call zen_favorites_main_fnc_removefavoritepathmarker;

            private _favoriteId = [_className, str _sourceDisplayPath] select (_mode == "groups" && {_className == "zen_compositions_composition"});
            private _color = [_normalColor, _favoriteColor] select (_favoriteId in _emptyFavoriteIds);

            if ("Favorites" in _displayPath) then {
                _color = _favoriteColor;
            };

            [_tree, _path, _color] call zen_favorites_main_fnc_setfavoritestar;
        };
    } else {
        for "_index" from 0 to (_childCount - 1) do {
            private _childPath = +_path;
            _childPath pushBack _index;
            [_childPath] call _renderEmptyPath;
        };
    };
};

for "_index" from 0 to (_rootCount - 1) do {
    [[_index]] call _renderEmptyPath;
};
