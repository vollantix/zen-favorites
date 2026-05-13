#include "..\script_component.hpp"

params ["_display", ["_force", false]];

private _activeTree = [_display] call zen_filter_main_fnc_getactivecreatetree;
_activeTree params ["_tree", "_idc", "_mode", "_side"];

if (isNull _tree) exitWith {};
if !(_mode in ["units", "groups"]) exitWith {};
if (_side == "empty") exitWith {};

private _favoriteKey = format ["%1:%2", _mode, _side];
private _favoriteStore = missionNamespace getVariable ["zen_filter_main_factionFavorites", createHashMap];
private _favorites = _favoriteStore getOrDefault [_favoriteKey, []];
private _originalOrderStore = missionNamespace getVariable ["zen_filter_main_factionOriginalOrders", createHashMap];
private _originalOrder = _originalOrderStore getOrDefault [_favoriteKey, []];
private _signature = str [_favoriteKey, _favorites];

if (!_force && {_tree getVariable ["zen_filter_main_lastFavoriteOrderSignature", ""] == _signature}) exitWith {};

private _orderAfterSort = [];

if (_mode == "units") then {
    private _rootCount = _tree tvCount [];

    if (_originalOrder isEqualTo []) then {
        for "_index" from 0 to (_rootCount - 1) do {
            _originalOrder pushBack (_tree tvText [_index]);
        };

        _originalOrderStore set [_favoriteKey, _originalOrder];
        missionNamespace setVariable ["zen_filter_main_factionOriginalOrders", _originalOrderStore];
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

        if (_factionName in _favorites) then {
            _tree tvExpand _path;
        };
    };
};

if (_mode == "groups") then {
    private _factionCount = _tree tvCount [0];

    if (_originalOrder isEqualTo []) then {
        for "_index" from 0 to (_factionCount - 1) do {
            _originalOrder pushBack (_tree tvText [0, _index]);
        };

        _originalOrderStore set [_favoriteKey, _originalOrder];
        missionNamespace setVariable ["zen_filter_main_factionOriginalOrders", _originalOrderStore];
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

        if (_factionName in _favorites) then {
            _tree tvExpand _path;
        };
    };
};

[ZEN_FILTER_LOG_LEVEL_DEBUG, format [
    "applied favorite order key=%1 favorites=%2 originalOrder=%3 orderAfterSort=%4",
    _favoriteKey,
    _favorites,
    _originalOrder,
    _orderAfterSort
]] call zen_filter_main_fnc_log;

_tree setVariable ["zen_filter_main_lastFavoriteOrderSignature", _signature];
