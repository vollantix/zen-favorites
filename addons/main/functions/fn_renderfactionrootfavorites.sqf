#include "..\script_component.hpp"

// Refresh top-level faction favorite order and star colors for Units or Groups.
params ["_display", "_tree", "_idc", "_mode", "_side", "_searchText", "_favoriteColor", "_normalColor"];

private _favoriteKey = format ["%1:%2", _mode, _side];
private _favoriteStore = missionNamespace getVariable ["zen_favorites_main_factionFavorites", createHashMap];
private _favorites = _favoriteStore getOrDefault [_favoriteKey, []];
private _starAlignment = missionNamespace getVariable ["zen_favorites_main_starAlignment", ZEN_FAVORITES_STAR_ALIGNMENT_LEFT];
private _lastSearchText = _tree getVariable ["zen_favorites_main_lastSearchText", ""];
private _justClearedSearch = _searchText == "" && {_lastSearchText != ""};
// Include search text so stars are refreshed after ZEN swaps normal and search rows.
private _renderSignature = str [
    _idc,
    _mode,
    _side,
    _searchText,
    _starAlignment,
    _tree tvCount [],
    _favorites
];

if (_searchText == "") then {
    [_display, _justClearedSearch] call zen_favorites_main_fnc_applyfactionfavoriteorder;
};

_tree setVariable ["zen_favorites_main_lastSearchText", _searchText];

if (!_justClearedSearch && {(_tree getVariable ["zen_favorites_main_lastFactionRenderSignature", ""]) == _renderSignature}) exitWith {};

_tree setVariable ["zen_favorites_main_lastFactionRenderSignature", _renderSignature];

if (_mode == "units") then {
    private _rootCount = _tree tvCount [];

    for "_index" from 0 to (_rootCount - 1) do {
        private _path = [_index];
        private _factionName = _tree tvText _path;

        if (_factionName == "Favorites") then {
            [_tree, _path] call zen_favorites_main_fnc_clearfavoritestar;
            continue;
        };

        private _color = [_normalColor, _favoriteColor] select (_factionName in _favorites);

        [_tree, _path, _color] call zen_favorites_main_fnc_setfavoritestar;
    };
};

if (_mode == "groups") then {
    private _factionCount = _tree tvCount [0];

    for "_index" from 0 to (_factionCount - 1) do {
        private _path = [0, _index];
        private _factionName = _tree tvText _path;

        if (_factionName == "Favorites") then {
            [_tree, _path] call zen_favorites_main_fnc_clearfavoritestar;
            continue;
        };

        private _color = [_normalColor, _favoriteColor] select (_factionName in _favorites);

        [_tree, _path, _color] call zen_favorites_main_fnc_setfavoritestar;
    };
};
