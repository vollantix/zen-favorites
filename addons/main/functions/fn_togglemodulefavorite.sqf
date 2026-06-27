#include "..\script_component.hpp"

// Add or remove a selected Module leaf from profile-backed module favorites.
params ["_tree", "_path"];

if ((count _path) == 0) exitWith {
    [ZEN_FAVORITES_LOG_LEVEL_WARN, "cannot toggle Module favorite: no selected tree row"] call zen_favorites_main_fnc_log;
};

if ((_tree tvCount _path) > 0) exitWith {
    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "Module favorite skipped for non-leaf path=%1 text=%2",
        _path,
        _tree tvText _path
    ]] call zen_favorites_main_fnc_log;
};

private _className = _tree tvData _path;
private _displayPath = [_tree, _path] call zen_favorites_main_fnc_gettreepathtexts;
private _isGeneratedFavoritePath = ("Favorites" in _displayPath);
private _sourceDisplayPath = [_displayPath] call zen_favorites_main_fnc_removefavoritepathmarker;
private _favoriteId = str _sourceDisplayPath;
private _favoriteEntry = [
    _sourceDisplayPath,
    _className,
    _favoriteId,
    _tree tvValue _path,
    _tree tvText _path,
    [_tree, _path] call zen_favorites_main_fnc_gettreeoriginalpicture
];
private _favorites = +(missionNamespace getVariable ["zen_favorites_main_moduleFavorites", []]);
private _existingIndex = _favorites findIf {
    (_x isEqualType []) &&
    {count _x >= 3} &&
    {(_x select 2) == _favoriteId}
};

if (_existingIndex == -1) then {
    if (_isGeneratedFavoritePath) exitWith {
        [ZEN_FAVORITES_LOG_LEVEL_WARN, format [
            "skipped adding generated Module favorite path=%1 sourcePath=%2 id=%3",
            _displayPath,
            _sourceDisplayPath,
            _favoriteId
        ]] call zen_favorites_main_fnc_log;
    };

    _favorites pushBack _favoriteEntry;

    // New favorites expand their own generated branch once, then user state takes over.
    private _pendingBranchTextPaths = [];

    if ((count _sourceDisplayPath) > 1) then {
        private _relativeBranchPath = [];

        for "_index" from 0 to ((count _sourceDisplayPath) - 2) do {
            _relativeBranchPath pushBack (_sourceDisplayPath select _index);

            private _favoriteBranchTextPath = ["Favorites"] + _relativeBranchPath;

            if !(_favoriteBranchTextPath in _pendingBranchTextPaths) then {
                _pendingBranchTextPaths pushBack _favoriteBranchTextPath;
            };
        };
    };

    if (_pendingBranchTextPaths isNotEqualTo []) then {
        private _pendingExpandTextPaths = +(_tree getVariable ["zen_favorites_main_modulePendingExpandTextPaths", []]);

        if !(["Favorites"] in _pendingExpandTextPaths) then {
            _pendingExpandTextPaths pushBack ["Favorites"];
        };

        {
            if !(_x in _pendingExpandTextPaths) then {
                _pendingExpandTextPaths pushBack _x;
            };
        } forEach _pendingBranchTextPaths;

        _tree setVariable ["zen_favorites_main_modulePendingExpandTextPaths", _pendingExpandTextPaths];
    };

    [format ["Added Module favorite: %1", _sourceDisplayPath select -1]] call zen_favorites_main_fnc_showactionhint;

    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "added Module favorite class=%1 id=%2 displayPath=%3 entry=%4",
        _className,
        _favoriteId,
        _sourceDisplayPath,
        _favoriteEntry
    ]] call zen_favorites_main_fnc_log;
} else {
    private _removed = _favorites deleteAt _existingIndex;

    [format ["Removed Module favorite: %1", (_removed select 0) select -1]] call zen_favorites_main_fnc_showactionhint;

    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "removed Module favorite class=%1 displayPath=%2 entry=%3",
        _className,
        _removed select 0,
        _removed
    ]] call zen_favorites_main_fnc_log;
};

missionNamespace setVariable ["zen_favorites_main_moduleFavorites", _favorites];
profileNamespace setVariable ["zen_favorites_main_moduleFavorites", _favorites];
saveProfileNamespace;

_tree setVariable ["zen_favorites_main_moduleFavoritesSignature", ""];
_tree setVariable ["zen_favorites_main_lastModuleRenderSignature", ""];

if (ctrlText ((ctrlParent _tree) displayCtrl 283) == "") then {
    [_tree] call zen_favorites_main_fnc_rendermodulefavoritescategory;
};

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "Module favorites count=%1 values=%2",
    count _favorites,
    _favorites
]] call zen_favorites_main_fnc_log;
