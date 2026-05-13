#include "..\script_component.hpp"

params ["_display"];

private _activeTree = [_display] call zen_filter_main_fnc_getactivecreatetree;
_activeTree params ["_tree", "_idc", "_mode", "_side"];

if (isNull _tree) exitWith {};
if !(_mode in ["units", "groups"]) exitWith {};

private _favoriteColor = [1, 0.82, 0.25, 1];
private _normalColor = [1, 1, 1, 0.35];
private _searchText = ctrlText (_display displayCtrl 283);

if !(_tree getVariable ["zen_filter_main_treeHandlersAdded", false]) then {
    _tree setVariable ["zen_filter_main_treeHandlersAdded", true];

    _tree ctrlAddEventHandler ["MouseButtonUp", {
        params ["_tree", "_button", "_xPos", "_yPos"];

        private _treePosition = ctrlPosition _tree;
        private _treeRight = (_treePosition select 0) + (_treePosition select 2);
        private _starClickX = _treeRight - 0.041;
        private _display = ctrlParent _tree;
        private _searchText = ctrlText (_display displayCtrl 283);
        private _isStarClick = _button == 0 && {_xPos >= _starClickX};
        private _hoverPath = _tree getVariable ["zen_filter_main_mousePath", []];
        private _selectedPath = tvCurSel _tree;

        if (missionNamespace getVariable ["zen_filter_main_logNextTreeMouseUp", false]) then {
            missionNamespace setVariable ["zen_filter_main_logNextTreeMouseUp", false];

            [ZEN_FILTER_LOG_LEVEL_INFO, format [
                "tree mouse-up coordinate sample idc=%1 button=%2 x=%3 y=%4 treePosition=%5 treeRight=%6 currentStarClickX=%7 distanceFromRight=%8 isStarClick=%9 hoverPath=%10 hoverText=%11 selectedPath=%12 selectedText=%13 search=%14",
                ctrlIDC _tree,
                _button,
                _xPos,
                _yPos,
                _treePosition,
                _treeRight,
                _starClickX,
                _treeRight - _xPos,
                _isStarClick,
                _hoverPath,
                _tree tvText _hoverPath,
                _selectedPath,
                _tree tvText _selectedPath,
                _searchText
            ]] call zen_filter_main_fnc_log;
        };

        if (_button == 1) then {
            if (missionNamespace getVariable ["zen_filter_main_emptyFavoritePreviewActive", false]) then {
                _tree setVariable ["zen_filter_main_previewSuppressedPath", _hoverPath];
                [] call zen_placement_fnc_setupPreview;
                missionNamespace setVariable ["zen_filter_main_emptyFavoritePreviewActive", false];

                [ZEN_FILTER_LOG_LEVEL_INFO, "cleared Empty favorite placement preview from right click"] call zen_filter_main_fnc_log;
            };

            if ((ctrlIDC _tree) == 274 && {_hoverPath isNotEqualTo []}) then {
                private _displayPath = [];
                private _ancestorPath = [];

                {
                    _ancestorPath pushBack _x;
                    _displayPath pushBack (_tree tvText _ancestorPath);
                } forEach _hoverPath;

                if ("Favorites" in _displayPath) then {
                    private _className = _tree tvData _hoverPath;

                    if (_className != "") then {
                        private _findOriginalPath = {
                            params ["_parentPath", "_className"];

                            private _result = [];

                            for "_index" from 0 to ((_tree tvCount _parentPath) - 1) do {
                                private _childPath = +_parentPath;
                                _childPath pushBack _index;

                                if ((_tree tvText _childPath) == "Favorites") then {
                                    continue;
                                };

                                if ((_tree tvData _childPath) == _className) exitWith {
                                    _result = _childPath;
                                };

                                private _nestedResult = [_childPath, _className] call _findOriginalPath;

                                if (_nestedResult isNotEqualTo []) exitWith {
                                    _result = _nestedResult;
                                };
                            };

                            _result
                        };

                        private _originalPath = [[], _className] call _findOriginalPath;

                        if (_originalPath isNotEqualTo []) then {
                            for "_depth" from 1 to (count _originalPath) do {
                                _tree tvExpand (_originalPath select [0, _depth]);
                            };

                            _tree tvSetCurSel _originalPath;

                            [ZEN_FILTER_LOG_LEVEL_INFO, format [
                                "right-click jumped Empty favorite to original path favoritePath=%1 originalPath=%2 class=%3",
                                _hoverPath,
                                _originalPath,
                                _className
                            ]] call zen_filter_main_fnc_log;
                        };
                    };
                };
            };
        };

        if (_isStarClick && {_hoverPath isNotEqualTo []}) then {
            [ZEN_FILTER_LOG_LEVEL_DEBUG, format [
                "star click detected idc=%1 hoverPath=%2 hoverText=%3 selectedPath=%4 search=%5",
                ctrlIDC _tree,
                _hoverPath,
                _tree tvText _hoverPath,
                _selectedPath,
                _searchText
            ]] call zen_filter_main_fnc_log;

            [ctrlParent _tree, _hoverPath] call zen_filter_main_fnc_toggleselectedrootfavorite;
        } else {
            if (_isStarClick) then {
                [ZEN_FILTER_LOG_LEVEL_INFO, format [
                    "star click skipped: no hovered tree row idc=%1 selectedPath=%2 search=%3",
                    ctrlIDC _tree,
                    _selectedPath,
                    _searchText
                ]] call zen_filter_main_fnc_log;
            };
        };
    }];

    _tree ctrlAddEventHandler ["TreeMouseMove", {
        params ["_tree", ["_path", []]];

        _tree setVariable ["zen_filter_main_mousePath", _path];
    }];

    _tree ctrlAddEventHandler ["TreeMouseHold", {
        params ["_tree", ["_path", []]];

        _tree setVariable ["zen_filter_main_mousePath", _path];
    }];

    _tree ctrlAddEventHandler ["TreeSelChanged", {
        params ["_tree", "_path"];

        if ((ctrlIDC _tree) != 274) exitWith {};
        if ((count _path) < 2) exitWith {};
        if ((_tree tvText [_path select 0]) != "Favorites") exitWith {};

        if ((_tree getVariable ["zen_filter_main_previewSuppressedPath", []]) isEqualTo _path) exitWith {
            [] call zen_placement_fnc_setupPreview;
            missionNamespace setVariable ["zen_filter_main_emptyFavoritePreviewActive", false];
        };

        private _className = "";

        if ((_tree tvCount _path) == 0) then {
            _className = _tree tvData _path;
        };

        private _objectType = ["", _className] select (
            isClass (configFile >> "CfgVehicles" >> _className) &&
            {!(_className isKindOf "Logic")}
        );

        [_objectType] call zen_placement_fnc_setupPreview;
        missionNamespace setVariable ["zen_filter_main_emptyFavoritePreviewActive", _objectType != ""];

        [ZEN_FILTER_LOG_LEVEL_INFO, format [
            "updated ZEN placement preview from Empty favorite path=%1 class=%2 objectType=%3",
            _path,
            _className,
            _objectType
        ]] call zen_filter_main_fnc_log;
    }];

    _tree ctrlAddEventHandler ["TreeSelChanged", {
        params ["_tree", "_path"];

        if ((ctrlIDC _tree) != 279) exitWith {};
        if ((count _path) < 2) exitWith {};

        private _displayPath = [];
        private _ancestorPath = [];

        {
            _ancestorPath pushBack _x;
            _displayPath pushBack (_tree tvText _ancestorPath);
        } forEach _path;

        if !("Favorites" in _displayPath) exitWith {};

        private _className = _tree tvData _path;
        private _sourceDisplayPath = +_displayPath;
        private _favoritesIndex = _sourceDisplayPath find "Favorites";

        if (_favoritesIndex >= 0) then {
            _sourceDisplayPath deleteAt _favoritesIndex;
        };

        private _isComposition = _className == "zen_compositions_composition";
        private _composition = [];

        if (_isComposition) then {
            private _categoryPath = _path select [0, count _path - 1];
            private _category = _tree tvText _categoryPath;
            private _name = _tree tvText _path;
            private _compositions = profileNamespace getVariable ["zen_compositions_data", createHashMap];
            private _categoryHash = _compositions getOrDefault [_category, createHashMap];

            _composition = _categoryHash getOrDefault [_name, []];

            if (_composition isEqualTo [] && {"Favorites" in _displayPath}) then {
                private _favoritesIndex = _displayPath find "Favorites";
                private _sourceDisplayPath = +_displayPath;

                _sourceDisplayPath deleteAt _favoritesIndex;

                if ((count _sourceDisplayPath) >= 3) then {
                    _category = _sourceDisplayPath select -2;
                    _name = _sourceDisplayPath select -1;
                    _categoryHash = _compositions getOrDefault [_category, createHashMap];
                    _composition = _categoryHash getOrDefault [_name, []];
                };
            };
        };

        zen_compositions_selected = _composition;

        [ZEN_FILTER_LOG_LEVEL_INFO, format [
            "updated ZEN composition selection from Empty favorite path=%1 isComposition=%2 dataCount=%3",
            _path,
            _isComposition,
            count _composition
        ]] call zen_filter_main_fnc_log;
    }];

    [ZEN_FILTER_LOG_LEVEL_DEBUG, format [
        "tree handlers added idc=%1",
        ctrlIDC _tree
    ]] call zen_filter_main_fnc_log;
};

if (_side == "empty") exitWith {
    if (_mode == "groups") exitWith {
        for "_index" from ((_tree tvCount []) - 1) to 0 step -1 do {
            if ((_tree tvText [_index]) == "Favorites") then {
                _tree tvDelete [_index];
            };
        };

        _tree setVariable ["zen_filter_main_emptyFavoritesSignature", ""];
        _tree setVariable ["zen_filter_main_lastEmptyRenderSignature", ""];
    };

    private _emptyStoreKey = format ["zen_filter_main_emptyFavorites_%1", _mode];
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

    if ((_tree getVariable ["zen_filter_main_lastEmptyRenderSignature", ""]) == _renderSignature) exitWith {};

    _tree setVariable ["zen_filter_main_lastEmptyRenderSignature", _renderSignature];

    if (_searchText == "") then {
        [_tree, _mode] call zen_filter_main_fnc_renderemptyfavoritescategory;
    } else {
        for "_index" from ((_tree tvCount []) - 1) to 0 step -1 do {
            if ((_tree tvText [_index]) == "Favorites") then {
                _tree tvDelete [_index];
            };
        };

        _tree setVariable ["zen_filter_main_emptyFavoritesSignature", ""];
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
                private _displayPath = [];
                private _ancestorPath = [];

                {
                    _ancestorPath pushBack _x;
                    _displayPath pushBack (_tree tvText _ancestorPath);
                } forEach _path;

                private _sourceDisplayPath = +_displayPath;
                private _favoritesIndex = _sourceDisplayPath find "Favorites";

                if (_favoritesIndex >= 0) then {
                    _sourceDisplayPath deleteAt _favoritesIndex;
                };

                private _favoriteId = [_className, str _sourceDisplayPath] select (_mode == "groups" && {_className == "zen_compositions_composition"});
                private _color = [_normalColor, _favoriteColor] select (_favoriteId in _emptyFavoriteIds);

                _tree tvSetPictureRight [_path, ZEN_FILTER_STAR_TEXTURE];
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
private _favoriteStore = missionNamespace getVariable ["zen_filter_main_factionFavorites", createHashMap];
private _favorites = _favoriteStore getOrDefault [_favoriteKey, []];
private _lastSearchText = _tree getVariable ["zen_filter_main_lastSearchText", ""];
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
    [_display, _justClearedSearch] call zen_filter_main_fnc_applyfactionfavoriteorder;
};

_tree setVariable ["zen_filter_main_lastSearchText", _searchText];

if (!_justClearedSearch && {(_tree getVariable ["zen_filter_main_lastFactionRenderSignature", ""]) == _renderSignature}) exitWith {};

_tree setVariable ["zen_filter_main_lastFactionRenderSignature", _renderSignature];

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
