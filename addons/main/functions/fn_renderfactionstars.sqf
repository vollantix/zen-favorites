#include "..\script_component.hpp"

params ["_display"];

private _activeTree = [_display] call zen_filter_main_fnc_getactivecreatetree;
_activeTree params ["_tree", "_idc", "_mode", "_side"];

if (isNull _tree) exitWith {};
if !(_mode in ["units", "groups"]) exitWith {};
if (_side == "empty") exitWith {};

private _favoriteKey = format ["%1:%2", _mode, _side];
private _favoriteStore = missionNamespace getVariable ["zen_filter_main_factionFavorites", createHashMap];
private _favorites = _favoriteStore getOrDefault [_favoriteKey, []];
private _favoriteColor = [1, 0.82, 0.25, 1];
private _normalColor = [1, 1, 1, 0.35];

if !(_tree getVariable ["zen_filter_main_treeHandlersAdded", false]) then {
    _tree setVariable ["zen_filter_main_treeHandlersAdded", true];

    _tree ctrlAddEventHandler ["TreeSelChanged", {
        params ["_tree", "_path"];

        [ZEN_FILTER_LOG_LEVEL_INFO, format [
            "tree event TreeSelChanged idc=%1 path=%2 text=%3",
            ctrlIDC _tree,
            _path,
            _tree tvText _path
        ]] call zen_filter_main_fnc_log;
    }];

    _tree ctrlAddEventHandler ["TreeDblClick", {
        params ["_tree", "_path"];

        [ZEN_FILTER_LOG_LEVEL_INFO, format [
            "tree event TreeDblClick idc=%1 path=%2 text=%3",
            ctrlIDC _tree,
            _path,
            _tree tvText _path
        ]] call zen_filter_main_fnc_log;
    }];

    _tree ctrlAddEventHandler ["MouseButtonUp", {
        params ["_tree", "_button", "_xPos", "_yPos"];

        private _path = tvCurSel _tree;
        private _treePosition = ctrlPosition _tree;
        private _treeRight = (_treePosition select 0) + (_treePosition select 2);
        private _starClickX = _treeRight - 0.05;
        private _isStarClick = _button == 0 && {_xPos >= _starClickX};

        [ZEN_FILTER_LOG_LEVEL_INFO, format [
            "tree event MouseButtonUp idc=%1 button=%2 mouse=[%3,%4] starClick=%5 treePosition=%6 selectedPath=%7 selectedText=%8",
            ctrlIDC _tree,
            _button,
            _xPos,
            _yPos,
            _isStarClick,
            _treePosition,
            _path,
            _tree tvText _path
        ]] call zen_filter_main_fnc_log;

        if (_isStarClick) then {
            [ZEN_FILTER_LOG_LEVEL_INFO, format [
                "star click detected idc=%1 path=%2 text=%3",
                ctrlIDC _tree,
                _path,
                _tree tvText _path
            ]] call zen_filter_main_fnc_log;

            [ctrlParent _tree] call zen_filter_main_fnc_toggleselectedrootfavorite;
        };
    }];

    [ZEN_FILTER_LOG_LEVEL_DEBUG, format [
        "tree handlers added idc=%1",
        ctrlIDC _tree
    ]] call zen_filter_main_fnc_log;
};

if (_mode == "units") then {
    private _rootCount = _tree tvCount [];

    for "_index" from 0 to ((_rootCount - 1) min 20) do {
        private _path = [_index];
        private _factionName = _tree tvText _path;
        private _color = [_normalColor, _favoriteColor] select (_factionName in _favorites);

        _tree tvSetPictureRight [_path, ZEN_FILTER_STAR_TEXTURE];
        _tree tvSetPictureRightColor [_path, _color];
        _tree tvSetPictureRightColorSelected [_path, _color];
    };
};

if (_mode == "groups") then {
    private _factionCount = _tree tvCount [0];

    for "_index" from 0 to ((_factionCount - 1) min 20) do {
        private _path = [0, _index];
        private _factionName = _tree tvText _path;
        private _color = [_normalColor, _favoriteColor] select (_factionName in _favorites);

        _tree tvSetPictureRight [_path, ZEN_FILTER_STAR_TEXTURE];
        _tree tvSetPictureRightColor [_path, _color];
        _tree tvSetPictureRightColorSelected [_path, _color];
    };
};
