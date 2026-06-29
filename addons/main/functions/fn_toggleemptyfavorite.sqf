#include "..\script_component.hpp"

// Add or remove a selected Empty Units/Groups leaf from its profile-backed favorites.
params ["_tree", "_path", "_mode"];

if ((count _path) == 0) exitWith {
    [ZEN_FAVORITES_LOG_LEVEL_WARN, "cannot toggle Empty favorite: no selected tree row"] call zen_favorites_main_fnc_log;
};

if ((_tree tvCount _path) > 0) exitWith {
    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "Empty favorite skipped for non-leaf path=%1 text=%2",
        _path,
        _tree tvText _path
    ]] call zen_favorites_main_fnc_log;
};

private _className = _tree tvData _path;

if (_className == "" && {_mode != "groups"}) exitWith {
    [ZEN_FAVORITES_LOG_LEVEL_WARN, format [
        "cannot toggle Empty favorite: selected leaf has no tvData path=%1 text=%2",
        _path,
        _tree tvText _path
    ]] call zen_favorites_main_fnc_log;
};

private _displayPath = [_tree, _path] call zen_favorites_main_fnc_gettreepathtexts;
private _isGeneratedFavoritePath = [_displayPath] call zen_favorites_main_fnc_isfavoritepath;
private _sourceDisplayPath = [_displayPath] call zen_favorites_main_fnc_removefavoritepathmarker;

if (_mode == "groups" && {_isGeneratedFavoritePath}) then {
    private _favoriteSourcePathMap = _tree getVariable ["zen_favorites_main_emptyGroupsFavoriteSourcePaths", createHashMap];

    // Empty Groups display paths are compacted under Favorites, so use the stored source path.
    _sourceDisplayPath = _favoriteSourcePathMap getOrDefault [str _displayPath, _sourceDisplayPath];
};

private _storeKey = format ["zen_favorites_main_emptyFavorites_%1", _mode];
private _favorites = +(missionNamespace getVariable [_storeKey, []]);

if (_mode == "groups") then {
    _favorites = _favorites select {
        (_x isEqualType []) &&
        {count _x >= 6} &&
        {(_x select 0) isEqualType []} &&
        {(_x select 2) isEqualType ""} &&
        {(_x select 2) == str (_x select 0)}
    };
};

private _favoriteId = [_className, str _sourceDisplayPath] select (_mode == "groups");
private _favoriteEntry = if (_mode == "groups") then {
    [
        _sourceDisplayPath,
        _className,
        _favoriteId,
        _tree tvValue _path,
        _tree tvText _path,
        [_tree, _path] call zen_favorites_main_fnc_gettreeoriginalpicture
    ]
} else {
    [_sourceDisplayPath, _className, _favoriteId]
};
private _existingIndex = _favorites findIf {
    private _storedId = if ((count _x) > 2) then {_x select 2} else {_x select 1};

    _storedId == _favoriteId
};
private _addedFavorite = false;

if (_existingIndex == -1) then {
    if (_isGeneratedFavoritePath) exitWith {
        [ZEN_FAVORITES_LOG_LEVEL_WARN, format [
            "skipped adding generated Empty favorite path=%1 sourcePath=%2 id=%3",
            _displayPath,
            _sourceDisplayPath,
            _favoriteId
        ]] call zen_favorites_main_fnc_log;
    };

    _favorites pushBack _favoriteEntry;
    _addedFavorite = true;

    if (_mode in ["units", "groups"]) then {
        // New favorites expand their own generated branch once, then user state takes over.
        private _pendingBranchTextPaths = [];
        private _favoriteDisplayPath = +_sourceDisplayPath;
        private _pendingStateVariable = [
            "zen_favorites_main_emptyUnitsPendingExpandTextPaths",
            "zen_favorites_main_emptyGroupsPendingExpandTextPaths"
        ] select (_mode == "groups");
        private _favoriteLayout = [_mode] call zen_favorites_main_fnc_getfavoritelayout;

        if (_favoriteLayout == ZEN_FAVORITES_LAYOUT_FLAT) then {
            _favoriteDisplayPath = [_favoriteDisplayPath joinString " / "];
        } else {
            if ((count _favoriteDisplayPath) > 1) then {
                private _leafText = _favoriteDisplayPath param [(count _favoriteDisplayPath) - 1, ""];
                private _categoryParts = _favoriteDisplayPath select [0, ((count _favoriteDisplayPath) - 1) max 0];

                if (_mode == "groups" && {(count _categoryParts) > 1}) then {
                    private _rootCategoryText = _categoryParts select 0;
                    private _subCategoryText = (_categoryParts select [1]) joinString " / ";

                    _favoriteDisplayPath = [_rootCategoryText, _subCategoryText, _leafText];
                } else {
                    private _categoryText = if (_categoryParts isEqualTo []) then {"Favorites"} else {_categoryParts joinString " / "};

                    _favoriteDisplayPath = [_categoryText, _leafText];
                };
            };
        };

        if ((count _favoriteDisplayPath) > 1) then {
            private _relativeBranchPath = [];

            for "_index" from 0 to ((count _favoriteDisplayPath) - 2) do {
                _relativeBranchPath pushBack (_favoriteDisplayPath select _index);

                private _favoriteBranchTextPath = ["Favorites"] + _relativeBranchPath;

                if !(_favoriteBranchTextPath in _pendingBranchTextPaths) then {
                    _pendingBranchTextPaths pushBack _favoriteBranchTextPath;
                };
            };
        };

        private _pendingExpandTextPaths = +(_tree getVariable [_pendingStateVariable, []]);

        if !(["Favorites"] in _pendingExpandTextPaths) then {
            _pendingExpandTextPaths pushBack ["Favorites"];
        };

        {
            if !(_x in _pendingExpandTextPaths) then {
                _pendingExpandTextPaths pushBack _x;
            };
        } forEach _pendingBranchTextPaths;

        _tree setVariable [_pendingStateVariable, _pendingExpandTextPaths];
    };

    [format ["Added Empty favorite: %1", _sourceDisplayPath select -1]] call zen_favorites_main_fnc_showactionhint;

    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "added Empty favorite mode=%1 data=%2 id=%3 displayPath=%4 entry=%5",
        _mode,
        _className,
        _favoriteId,
        _sourceDisplayPath,
        _favoriteEntry
    ]] call zen_favorites_main_fnc_log;
} else {
    private _removed = _favorites deleteAt _existingIndex;

    [format ["Removed Empty favorite: %1", (_removed select 0) select -1]] call zen_favorites_main_fnc_showactionhint;

    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "removed Empty favorite mode=%1 data=%2 displayPath=%3 entry=%4",
        _mode,
        _className,
        _removed select 0,
        _removed
    ]] call zen_favorites_main_fnc_log;
};

// Batch source-row additions so several nearby leaves can be starred before Favorites moves the tree.
// Batch source-row additions so several nearby leaves can be starred before Favorites moves the tree.
private _deferRender = _addedFavorite && {!_isGeneratedFavoritePath};

_tree setVariable [
    "zen_favorites_main_leafFavoriteRenderDeferredUntil",
    [0, diag_tickTime + ZEN_FAVORITES_LEAF_RENDER_DELAY] select _deferRender
];

missionNamespace setVariable [_storeKey, _favorites];
profileNamespace setVariable [_storeKey, _favorites];
saveProfileNamespace;
_tree setVariable ["zen_favorites_main_emptyFavoritesSignature", str _favorites];
_tree setVariable ["zen_favorites_main_lastEmptyRenderSignature", ""];
_tree setVariable ["zen_favorites_main_lastEmptyGroupsRenderSignature", ""];

if (_mode in ["units", "groups"]) then {
    _tree setVariable ["zen_favorites_main_emptyFavoritesSignature", ""];

    if (!_deferRender && {ctrlText ((ctrlParent _tree) displayCtrl 283) == ""}) then {
        [_tree, _mode] call zen_favorites_main_fnc_renderemptyfavoritescategory;
    };
};

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "Empty favorites mode=%1 count=%2 values=%3",
    _mode,
    count _favorites,
    _favorites
]] call zen_favorites_main_fnc_log;
