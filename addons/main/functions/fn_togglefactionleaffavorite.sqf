#include "..\script_component.hpp"

// Add or remove a non-empty Units/Groups leaf from the session faction leaf favorites.
params ["_tree", "_path", "_mode", "_side"];

if ((count _path) == 0) exitWith {
    [ZEN_FAVORITES_LOG_LEVEL_WARN, "cannot toggle faction leaf favorite: no selected tree row"] call zen_favorites_main_fnc_log;
};

if ((_tree tvCount _path) > 0) exitWith {
    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "faction leaf favorite skipped for non-leaf path=%1 text=%2",
        _path,
        _tree tvText _path
    ]] call zen_favorites_main_fnc_log;
};

private _displayPath = [_tree, _path] call zen_favorites_main_fnc_gettreepathtexts;
private _isGeneratedFavoritePath = "Favorites" in _displayPath;
private _favoriteSourcePathMap = _tree getVariable ["zen_favorites_main_factionLeafFavoriteSourcePaths", createHashMap];
private _sourceDisplayPath = [_displayPath] call zen_favorites_main_fnc_removefavoritepathmarker;

if (_isGeneratedFavoritePath) then {
    _sourceDisplayPath = _favoriteSourcePathMap getOrDefault [str _displayPath, _sourceDisplayPath];
};

private _favoriteId = str _sourceDisplayPath;
private _favoriteKey = format ["%1:%2", _mode, _side];
private _favoriteStore = missionNamespace getVariable ["zen_favorites_main_factionLeafFavorites", createHashMap];
private _favorites = +((_favoriteStore getOrDefault [_favoriteKey, []]) select {
    (_x isEqualType []) &&
    {count _x >= 6} &&
    {(_x select 0) isEqualType []} &&
    {(_x select 2) isEqualType ""}
});
private _existingIndex = _favorites findIf {(_x select 2) == _favoriteId};

if (_existingIndex == -1) then {
    if (_isGeneratedFavoritePath) exitWith {
        [ZEN_FAVORITES_LOG_LEVEL_WARN, format [
            "skipped adding generated faction leaf favorite path=%1 sourcePath=%2 id=%3",
            _displayPath,
            _sourceDisplayPath,
            _favoriteId
        ]] call zen_favorites_main_fnc_log;
    };

    private _favoriteEntry = [
        _sourceDisplayPath,
        _tree tvData _path,
        _favoriteId,
        _tree tvValue _path,
        _tree tvText _path,
        [_tree, _path] call zen_favorites_main_fnc_gettreeoriginalpicture
    ];

    _favorites pushBack _favoriteEntry;

    // New favorites expand their generated branch once, then manual state is remembered.
    private _relativeDisplayPath = [_sourceDisplayPath, _mode, _tree] call zen_favorites_main_fnc_getfactionleaffavoritedisplaypath;
    private _pendingExpandTextPaths = +(_tree getVariable [format ["zen_favorites_main_factionLeafPendingExpandTextPaths_%1_%2", _mode, _side], []]);
    private _favoriteRootTextPath = if (_mode == "groups") then {
        [_tree tvText [0], "Favorites"]
    } else {
        ["Favorites"]
    };

    if !(_favoriteRootTextPath in _pendingExpandTextPaths) then {
        _pendingExpandTextPaths pushBack _favoriteRootTextPath;
    };

    if ((count _relativeDisplayPath) > 1) then {
        private _relativeBranchPath = [];

        for "_index" from 0 to ((count _relativeDisplayPath) - 2) do {
            _relativeBranchPath pushBack (_relativeDisplayPath select _index);

            private _favoriteBranchTextPath = _favoriteRootTextPath + _relativeBranchPath;

            if !(_favoriteBranchTextPath in _pendingExpandTextPaths) then {
                _pendingExpandTextPaths pushBack _favoriteBranchTextPath;
            };
        };
    };

    _tree setVariable [format ["zen_favorites_main_factionLeafPendingExpandTextPaths_%1_%2", _mode, _side], _pendingExpandTextPaths];

    [format ["Added favorite: %1", _sourceDisplayPath select -1]] call zen_favorites_main_fnc_showactionhint;

    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "added faction leaf favorite key=%1 id=%2 displayPath=%3 entry=%4",
        _favoriteKey,
        _favoriteId,
        _sourceDisplayPath,
        _favoriteEntry
    ]] call zen_favorites_main_fnc_log;
} else {
    private _removed = _favorites deleteAt _existingIndex;

    [format ["Removed favorite: %1", (_removed select 0) select -1]] call zen_favorites_main_fnc_showactionhint;

    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "removed faction leaf favorite key=%1 id=%2 displayPath=%3 entry=%4",
        _favoriteKey,
        _favoriteId,
        _removed select 0,
        _removed
    ]] call zen_favorites_main_fnc_log;
};

_favoriteStore set [_favoriteKey, _favorites];
missionNamespace setVariable ["zen_favorites_main_factionLeafFavorites", _favoriteStore];

if (missionNamespace getVariable ["zen_favorites_main_persistFactionLeafFavorites", false]) then {
    profileNamespace setVariable [
        "zen_favorites_main_factionLeafFavorites",
        [_favoriteStore] call zen_favorites_main_fnc_favoritehashmaptoarray
    ];
    saveProfileNamespace;
};

_tree setVariable ["zen_favorites_main_factionLeafFavoritesSignature", ""];
_tree setVariable ["zen_favorites_main_lastFactionLeafRenderSignature", ""];

if (ctrlText ((ctrlParent _tree) displayCtrl 283) == "") then {
    [_tree, _mode, _side] call zen_favorites_main_fnc_renderfactionleaffavoritescategory;
};

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "faction leaf favorites key=%1 count=%2 values=%3",
    _favoriteKey,
    count _favorites,
    _favorites
]] call zen_favorites_main_fnc_log;
