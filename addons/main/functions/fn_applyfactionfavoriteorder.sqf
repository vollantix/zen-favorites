#include "..\script_component.hpp"

// Move favorited top-level factions above normal factions while preserving expansion state.
params ["_display", ["_force", false]];

private _activeTree = [_display] call zen_favorites_main_fnc_getactivecreatetree;
_activeTree params ["_tree", "_idc", "_mode", "_side"];

if (isNull _tree) exitWith {};
if !(_mode in ["units", "groups"]) exitWith {};
if (_side == "empty") exitWith {};

private _favoriteKey = format ["%1:%2", _mode, _side];
private _favoriteStore = missionNamespace getVariable ["zen_favorites_main_factionFavorites", createHashMap];
private _favorites = _favoriteStore getOrDefault [_favoriteKey, []];
private _originalOrderStore = missionNamespace getVariable ["zen_favorites_main_factionOriginalOrders", createHashMap];
private _originalOrder = _originalOrderStore getOrDefault [_favoriteKey, []];
private _expandedStore = missionNamespace getVariable ["zen_favorites_main_factionExpandedRows", createHashMap];
private _expandedRows = +(_expandedStore getOrDefault [_favoriteKey, []]);
private _signature = str [_favoriteKey, _favorites];

// Reordering is frequent in Zeus; skip when favorites have not changed.
if (!_force && {_tree getVariable ["zen_favorites_main_lastFavoriteOrderSignature", ""] == _signature}) exitWith {};

private _orderAfterSort = [];
private _restoreExpandedRows = {
    params ["_tree", "_mode", "_expandedRows"];

    if (isNull _tree) exitWith {};

    _tree setVariable ["zen_favorites_main_ignoreFactionExpandEvents", true];

    if (_mode == "units") then {
        for "_index" from 0 to ((_tree tvCount []) - 1) do {
            private _path = [_index];

            if ((_tree tvText _path) in _expandedRows) then {
                _tree tvExpand _path;
            };
        };
    };

    if (_mode == "groups") then {
        if (("__root__" in _expandedRows) || {(_expandedRows - ["__root__"]) isNotEqualTo []}) then {
            _tree tvExpand [0];
        };

        for "_index" from 0 to ((_tree tvCount [0]) - 1) do {
            private _path = [0, _index];

            if ((_tree tvText _path) in _expandedRows) then {
                _tree tvExpand _path;
            };
        };
    };

    _tree setVariable ["zen_favorites_main_ignoreFactionExpandEvents", false];
};

// Sorting emits expansion events, so suppress them while values are rewritten.
_tree setVariable ["zen_favorites_main_ignoreFactionExpandEvents", true];

if (_mode == "units") then {
    private _rootCount = _tree tvCount [];

    if (_originalOrder isEqualTo []) then {
        for "_index" from 0 to (_rootCount - 1) do {
            _originalOrder pushBack (_tree tvText [_index]);
        };

        _originalOrderStore set [_favoriteKey, _originalOrder];
        missionNamespace setVariable ["zen_favorites_main_factionOriginalOrders", _originalOrderStore];
    };

    for "_index" from 0 to (_rootCount - 1) do {
        private _path = [_index];
        private _factionName = _tree tvText _path;
        private _favoriteIndex = _favorites find _factionName;
        private _originalIndex = _originalOrder find _factionName;
        private _sortValue = if (_favoriteIndex == -1) then {1000 + _originalIndex} else {_favoriteIndex};

        _tree tvSetValue [_path, _sortValue];
    };

    _tree tvSortByValue [[], true];

    for "_index" from 0 to (_rootCount - 1) do {
        private _path = [_index];
        private _factionName = _tree tvText _path;

        _orderAfterSort pushBack _factionName;
    };
};

if (_mode == "groups") then {
    private _factionCount = _tree tvCount [0];

    if (_originalOrder isEqualTo []) then {
        for "_index" from 0 to (_factionCount - 1) do {
            _originalOrder pushBack (_tree tvText [0, _index]);
        };

        _originalOrderStore set [_favoriteKey, _originalOrder];
        missionNamespace setVariable ["zen_favorites_main_factionOriginalOrders", _originalOrderStore];
    };

    for "_index" from 0 to (_factionCount - 1) do {
        private _path = [0, _index];
        private _factionName = _tree tvText _path;
        private _favoriteIndex = _favorites find _factionName;
        private _originalIndex = _originalOrder find _factionName;
        private _sortValue = if (_favoriteIndex == -1) then {1000 + _originalIndex} else {_favoriteIndex};

        _tree tvSetValue [_path, _sortValue];
    };

    _tree tvSortByValue [[0], true];

    for "_index" from 0 to (_factionCount - 1) do {
        private _path = [0, _index];
        private _factionName = _tree tvText _path;

        _orderAfterSort pushBack _factionName;
    };
};

_tree setVariable ["zen_favorites_main_ignoreFactionExpandEvents", false];

[_tree, _mode, _expandedRows] call _restoreExpandedRows;

// ZEN may adjust tree state shortly after sorting; restore once more after that settles.
[{
    params ["_tree", "_mode", "_expandedRows", "_restoreExpandedRows"];

    [_tree, _mode, _expandedRows] call _restoreExpandedRows;
}, [_tree, _mode, _expandedRows, _restoreExpandedRows], 0.1] call CBA_fnc_waitAndExecute;

[ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
    "applied favorite order key=%1 favorites=%2 originalOrder=%3 orderAfterSort=%4 expandedRows=%5",
    _favoriteKey,
    _favorites,
    _originalOrder,
    _orderAfterSort,
    _expandedRows
]] call zen_favorites_main_fnc_log;

_tree setVariable ["zen_favorites_main_lastFavoriteOrderSignature", _signature];
