#include "..\script_component.hpp"

params ["_display"];

private _activeTree = [_display] call zen_favorites_main_fnc_getactivecreatetree;
_activeTree params ["_tree", "_idc", "_mode", "_side"];

if (isNull _tree) exitWith {};
if !(_mode in ["units", "groups"]) exitWith {};

if !(_mode == "units" && {_side == "empty"}) then {
    [false, "left Empty units tree"] call zen_favorites_main_fnc_clearemptyfavoritepreview;
};

private _favoriteColor = [1, 0.82, 0.25, 1];
private _normalColor = [1, 1, 1, 0.35];
private _searchText = ctrlText (_display displayCtrl 283);

if !(_tree getVariable ["zen_favorites_main_treeHandlersAdded", false]) then {
    _tree setVariable ["zen_favorites_main_treeHandlersAdded", true];

    _tree ctrlAddEventHandler ["MouseButtonUp", {
        params ["_tree", "_button", "_xPos", "_yPos"];

        private _treePosition = ctrlPosition _tree;
        private _treeRight = (_treePosition select 0) + (_treePosition select 2);
        private _starClickX = _treeRight - 0.041;
        private _display = ctrlParent _tree;
        private _searchText = ctrlText (_display displayCtrl 283);
        private _isStarClick = _button == 0 && {_xPos >= _starClickX};
        private _hoverPath = _tree getVariable ["zen_favorites_main_mousePath", []];
        private _selectedPath = tvCurSel _tree;

        if (_button == 1) then {
            if (missionNamespace getVariable ["zen_favorites_main_emptyFavoritePreviewActive", false]) then {
                _tree setVariable ["zen_favorites_main_previewSuppressedPath", _hoverPath];
                [true, "tree right click"] call zen_favorites_main_fnc_clearemptyfavoritepreview;

                [ZEN_FAVORITES_LOG_LEVEL_INFO, "cleared Empty favorite placement preview from right click"] call zen_favorites_main_fnc_log;
            };

            if ((ctrlIDC _tree) == 274 && {_hoverPath isNotEqualTo []}) then {
                private _displayPath = [_tree, _hoverPath] call zen_favorites_main_fnc_gettreepathtexts;

                if ("Favorites" in _displayPath) then {
                    private _className = _tree tvData _hoverPath;

                    if (_className != "") then {
                        private _originalPath = [_tree, [], _className] call zen_favorites_main_fnc_findtreepathbydata;

                        if (_originalPath isNotEqualTo []) then {
                            for "_depth" from 1 to (count _originalPath) do {
                                _tree tvExpand (_originalPath select [0, _depth]);
                            };

                            _tree tvSetCurSel _originalPath;

                            [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
                                "right-click jumped Empty favorite to original path favoritePath=%1 originalPath=%2 class=%3",
                                _hoverPath,
                                _originalPath,
                                _className
                            ]] call zen_favorites_main_fnc_log;
                        };
                    };
                };
            };
        };

        if (_isStarClick && {_hoverPath isNotEqualTo []}) then {
            [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
                "star click detected idc=%1 hoverPath=%2 hoverText=%3 selectedPath=%4 search=%5",
                ctrlIDC _tree,
                _hoverPath,
                _tree tvText _hoverPath,
                _selectedPath,
                _searchText
            ]] call zen_favorites_main_fnc_log;

            [ctrlParent _tree, _hoverPath] call zen_favorites_main_fnc_toggleselectedrootfavorite;
        } else {
            if (_isStarClick) then {
                [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
                    "star click skipped: no hovered tree row idc=%1 selectedPath=%2 search=%3",
                    ctrlIDC _tree,
                    _selectedPath,
                    _searchText
                ]] call zen_favorites_main_fnc_log;
            };
        };
    }];

    _tree ctrlAddEventHandler ["TreeMouseMove", {
        params ["_tree", ["_path", []]];

        _tree setVariable ["zen_favorites_main_mousePath", _path];
    }];

    _tree ctrlAddEventHandler ["TreeMouseHold", {
        params ["_tree", ["_path", []]];

        _tree setVariable ["zen_favorites_main_mousePath", _path];
    }];

    _tree ctrlAddEventHandler ["TreeSelChanged", {
        params ["_tree", "_path"];

        if ((ctrlIDC _tree) != 274) exitWith {};
        if ((count _path) < 2) exitWith {};

        if ((_tree tvText [_path select 0]) != "Favorites") exitWith {
            private _activeBefore = missionNamespace getVariable ["zen_favorites_main_emptyFavoritePreviewActive", false];
            private _expectedType = missionNamespace getVariable ["zen_favorites_main_emptyFavoritePreviewType", ""];

            [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
                "leaving Empty favorite selection path=%1 text=%2 data=%3 activeBefore=%4 expectedType=%5",
                _path,
                _tree tvText _path,
                _tree tvData _path,
                _activeBefore,
                _expectedType
            ]] call zen_favorites_main_fnc_log;

            [false, "selected normal Empty unit row"] call zen_favorites_main_fnc_clearemptyfavoritepreview;

            if (_activeBefore && {_expectedType != ""}) then {
                [{
                    params ["_expectedType"];

                    private _cleared = [_expectedType, "normal tree selection"] call zen_favorites_main_fnc_clearleftoveremptyfavoritepreview;

                    if (_cleared) then {
                        [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
                            "cleared leftover Empty favorite preview after normal tree selection expectedType=%1",
                            _expectedType
                        ]] call zen_favorites_main_fnc_log;
                    };
                }, _expectedType] call CBA_fnc_execNextFrame;
            };
        };

        if ((_tree getVariable ["zen_favorites_main_previewSuppressedPath", []]) isEqualTo _path) exitWith {
            [true, "suppressed preview path selected"] call zen_favorites_main_fnc_clearemptyfavoritepreview;
        };

        if ((_tree tvCount _path) > 0) exitWith {
            [true, "Empty favorite folder selected"] call zen_favorites_main_fnc_clearemptyfavoritepreview;

            [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
                "ignored Empty favorite folder selection path=%1 text=%2",
                _path,
                _tree tvText _path
            ]] call zen_favorites_main_fnc_log;
        };

        private _className = _tree tvData _path;

        private _objectType = ["", _className] select (
            isClass (configFile >> "CfgVehicles" >> _className) &&
            {!(_className isKindOf "Logic")}
        );

        if (_objectType == "") exitWith {
            [true, "invalid Empty favorite leaf"] call zen_favorites_main_fnc_clearemptyfavoritepreview;

            [ZEN_FAVORITES_LOG_LEVEL_WARN, format [
                "ignored Empty favorite leaf with invalid CfgVehicles class path=%1 class=%2",
                _path,
                _className
            ]] call zen_favorites_main_fnc_log;
        };

        [_objectType, true] call zen_favorites_main_fnc_setemptyfavoritepreview;

        [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
            "updated ZEN placement preview from Empty favorite path=%1 class=%2 objectType=%3",
            _path,
            _className,
            _objectType
        ]] call zen_favorites_main_fnc_log;
    }];

    _tree ctrlAddEventHandler ["TreeSelChanged", {
        params ["_tree", "_path"];

        if ((ctrlIDC _tree) != 279) exitWith {};

        [_tree, _path] call zen_favorites_main_fnc_inspectemptygrouprow;

        if ((count _path) < 2) exitWith {};

        private _displayPath = [_tree, _path] call zen_favorites_main_fnc_gettreepathtexts;

        if !("Favorites" in _displayPath) exitWith {};
        if ((_tree tvCount _path) > 0) exitWith {};

        private _sourceDisplayPath = [_displayPath] call zen_favorites_main_fnc_removefavoritepathmarker;
        private _originalPath = [_tree, _sourceDisplayPath] call zen_favorites_main_fnc_findtreepathbytexts;

        if (_originalPath isEqualTo []) exitWith {
            [ZEN_FAVORITES_LOG_LEVEL_WARN, format [
                "could not resolve Empty Groups favorite shortcut favoritePath=%1 sourceDisplayPath=%2",
                _path,
                _sourceDisplayPath
            ]] call zen_favorites_main_fnc_log;
        };

        for "_depth" from 1 to (count _originalPath) do {
            _tree tvExpand (_originalPath select [0, _depth]);
        };

        _tree tvSetCurSel _originalPath;

        [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
            "selected original Empty Groups row from favorite shortcut favoritePath=%1 originalPath=%2 sourceDisplayPath=%3",
            _path,
            _originalPath,
            _sourceDisplayPath
        ]] call zen_favorites_main_fnc_log;
    }];

    [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
        "tree handlers added idc=%1",
        ctrlIDC _tree
    ]] call zen_favorites_main_fnc_log;
};

if (_side == "empty") exitWith {
    if (_mode == "groups") exitWith {
        private _emptyStoreKey = format ["zen_favorites_main_emptyFavorites_%1", _mode];
        private _emptyFavorites = (missionNamespace getVariable [_emptyStoreKey, []]) select {
            (_x isEqualType []) &&
            {count _x >= 3} &&
            {(_x select 2) isEqualType ""}
        };
        private _rootCount = _tree tvCount [];
        private _renderSignature = str [
            _idc,
            _mode,
            _searchText,
            _rootCount,
            _emptyFavorites
        ];

        if ((_tree getVariable ["zen_favorites_main_lastEmptyGroupsRenderSignature", ""]) == _renderSignature) exitWith {};

        _tree setVariable ["zen_favorites_main_lastEmptyGroupsRenderSignature", _renderSignature];

        if (_searchText == "") then {
            [_tree, _mode] call zen_favorites_main_fnc_renderemptyfavoritescategory;
        } else {
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

                _tree tvSetPictureRight [_path, ZEN_FAVORITES_STAR_TEXTURE];
                _tree tvSetPictureRightColor [_path, _color];
                _tree tvSetPictureRightColorSelected [_path, _color];
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
    private _renderSignature = str [
        _idc,
        _mode,
        _searchText,
        _rootCount,
        _emptyFavorites
    ];

    if ((_tree getVariable ["zen_favorites_main_lastEmptyRenderSignature", ""]) == _renderSignature) exitWith {};

    _tree setVariable ["zen_favorites_main_lastEmptyRenderSignature", _renderSignature];

    if (_searchText == "") then {
        [_tree, _mode] call zen_favorites_main_fnc_renderemptyfavoritescategory;
    } else {
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

                _tree tvSetPictureRight [_path, ZEN_FAVORITES_STAR_TEXTURE];
                _tree tvSetPictureRightColor [_path, _color];
                _tree tvSetPictureRightColorSelected [_path, _color];
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
};

private _favoriteKey = format ["%1:%2", _mode, _side];
private _favoriteStore = missionNamespace getVariable ["zen_favorites_main_factionFavorites", createHashMap];
private _favorites = _favoriteStore getOrDefault [_favoriteKey, []];
private _lastSearchText = _tree getVariable ["zen_favorites_main_lastSearchText", ""];
private _justClearedSearch = _searchText == "" && {_lastSearchText != ""};
private _renderSignature = str [
    _idc,
    _mode,
    _side,
    _searchText,
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

    for "_index" from 0 to ((_rootCount - 1) min 20) do {
        private _path = [_index];
        private _factionName = _tree tvText _path;
        private _color = [_normalColor, _favoriteColor] select (_factionName in _favorites);

        _tree tvSetPictureRight [_path, ZEN_FAVORITES_STAR_TEXTURE];
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

        _tree tvSetPictureRight [_path, ZEN_FAVORITES_STAR_TEXTURE];
        _tree tvSetPictureRightColor [_path, _color];
        _tree tvSetPictureRightColorSelected [_path, _color];
    };
};
