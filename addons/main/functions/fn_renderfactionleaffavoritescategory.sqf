#include "..\script_component.hpp"

// Build the generated Favorites branch for non-empty Units or Groups leaf favorites.
params ["_tree", "_mode", "_side"];

private _favoriteKey = format ["%1:%2", _mode, _side];
private _favoriteStore = missionNamespace getVariable ["zen_favorites_main_factionLeafFavorites", createHashMap];
private _favorites = (_favoriteStore getOrDefault [_favoriteKey, []]) select {
    (_x isEqualType []) &&
    {count _x >= 6} &&
    {(_x select 0) isEqualType []} &&
    {(_x select 2) isEqualType ""}
};
private _favoritesParentPath = [];

if (_mode == "groups") then {
    if ((_tree tvCount []) == 0) exitWith {};

    // Keep the existing side root at [0]; group faction code depends on that index.
    _favoritesParentPath = [0];
};

private _starAlignment = missionNamespace getVariable ["zen_favorites_main_starAlignment", ZEN_FAVORITES_STAR_ALIGNMENT_LEFT];
private _signature = str [_favoriteKey, _favorites, _starAlignment, _tree tvCount _favoritesParentPath];
private _hasFavoritesRoot = false;

for "_index" from 0 to ((_tree tvCount _favoritesParentPath) - 1) do {
    private _path = +_favoritesParentPath;
    _path pushBack _index;

    if ((_tree tvText _path) == "Favorites") exitWith {
        _hasFavoritesRoot = true;
    };
};

if (
    (_tree getVariable ["zen_favorites_main_factionLeafFavoritesSignature", ""] == _signature) &&
    {!(_favorites isEqualTo [] && {_hasFavoritesRoot})}
) exitWith {};

private _selectionState = [_tree, _favoritesParentPath] call zen_favorites_main_fnc_parkcreatetreeselection;
private _expandedStateVariable = format ["zen_favorites_main_factionLeafExpandedTextPaths_%1_%2", _mode, _side];
private _pendingStateVariable = format ["zen_favorites_main_factionLeafPendingExpandTextPaths_%1_%2", _mode, _side];
private _rootFavoriteStore = missionNamespace getVariable ["zen_favorites_main_factionFavorites", createHashMap];
private _rootFavorites = _rootFavoriteStore getOrDefault [_favoriteKey, []];
private _rootOrderStore = missionNamespace getVariable ["zen_favorites_main_factionOriginalOrders", createHashMap];
private _originalOrder = _rootOrderStore getOrDefault [_favoriteKey, []];
private _expandedTextPaths = +(missionNamespace getVariable [_expandedStateVariable, (_tree getVariable [_expandedStateVariable, []])]);
private _pendingExpandTextPaths = +(_tree getVariable [_pendingStateVariable, []]);

if (_originalOrder isEqualTo []) then {
    for "_index" from 0 to ((_tree tvCount _favoritesParentPath) - 1) do {
        private _path = +_favoritesParentPath;
        _path pushBack _index;
        private _rowText = _tree tvText _path;

        if (_rowText != "Favorites") then {
            _originalOrder pushBack _rowText;
        };
    };

    _rootOrderStore set [_favoriteKey, _originalOrder];
    missionNamespace setVariable ["zen_favorites_main_factionOriginalOrders", _rootOrderStore];
};

_tree setVariable ["zen_favorites_main_ignoreFactionLeafExpandEvents", true];

for "_index" from ((_tree tvCount _favoritesParentPath) - 1) to 0 step -1 do {
    private _path = +_favoritesParentPath;
    _path pushBack _index;

    if ((_tree tvText _path) == "Favorites") then {
        _tree tvDelete _path;
    };
};

if (_favorites isEqualTo []) exitWith {
    _tree setVariable ["zen_favorites_main_factionLeafFavoritesSignature", _signature];
    _tree setVariable ["zen_favorites_main_factionLeafFavoriteBranchTextPaths", []];
    _tree setVariable ["zen_favorites_main_factionLeafFavoriteSourcePaths", createHashMap];
    _tree setVariable [_expandedStateVariable, []];
    _tree setVariable [_pendingStateVariable, []];
    missionNamespace setVariable [_expandedStateVariable, []];
    _tree setVariable ["zen_favorites_main_ignoreFactionLeafExpandEvents", false];
    [_tree, _selectionState] call zen_favorites_main_fnc_restorecreatetreeselection;
};

private _getOriginalSortValue = {
    params ["_path"];

    private _value = 0;
    private _multiplier = 1;

    {
        _value = _value + (_x * _multiplier);
        _multiplier = _multiplier * 1000;
    } forEach _path;

    _value
};

private _sortBranch = {
    params ["_path"];

    _tree tvSortByValue [_path, true];

    for "_index" from 0 to ((_tree tvCount _path) - 1) do {
        private _childPath = +_path;
        _childPath pushBack _index;

        if ((_tree tvCount _childPath) > 0) then {
            [_childPath] call _sortBranch;
        };
    };
};

private _favoritesRootIndex = _tree tvAdd [_favoritesParentPath, "Favorites"];
private _favoritesRootPath = +_favoritesParentPath;
_favoritesRootPath pushBack _favoritesRootIndex;
private _favoriteBranchTextPaths = [];
private _favoriteSourcePathMap = createHashMap;

// The synthetic root is a UI folder only; it must not become a placeable object.
_tree tvSetData [_favoritesRootPath, ""];
_tree tvSetValue [_favoritesRootPath, -1000];

{
    private _sourceDisplayPath = _x select 0;
    private _data = _x select 1;
    private _originalPath = [_tree, _sourceDisplayPath] call zen_favorites_main_fnc_findtreepathbytexts;

    if (_originalPath isEqualTo [] && {_data != ""}) then {
        _originalPath = [_tree, [], _data] call zen_favorites_main_fnc_findtreepathbydata;
    };

    if (_originalPath isEqualTo []) then {
        [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
            "skipped missing faction leaf favorite key=%1 data=%2 sourceDisplayPath=%3",
            _favoriteKey,
            _data,
            _sourceDisplayPath
        ]] call zen_favorites_main_fnc_log;
        continue;
    };

    private _relativeDisplayPath = [_sourceDisplayPath, _mode, _tree] call zen_favorites_main_fnc_getfactionleaffavoritedisplaypath;

    if (_relativeDisplayPath isEqualTo []) then {
        continue;
    };

    private _originalSortValue = [_originalPath] call _getOriginalSortValue;
    private _parentPath = +_favoritesRootPath;

    {
        private _segment = _x;
        private _existingIndex = -1;
        private _childCount = _tree tvCount _parentPath;
        private _originalSegmentPath = _originalPath select [0, ((count _originalPath) - 1) min (_forEachIndex + 1)];

        for "_childIndex" from 0 to (_childCount - 1) do {
            private _candidatePath = +_parentPath;
            _candidatePath pushBack _childIndex;

            if ((_tree tvText _candidatePath) == _segment) exitWith {
                _existingIndex = _childIndex;
            };
        };

        if (_existingIndex == -1) then {
            _existingIndex = _tree tvAdd [_parentPath, _segment];
        };

        _parentPath pushBack _existingIndex;

        // Generated folder rows are UI only; only leaves carry placeable source data.
        _tree tvSetData [_parentPath, ""];
        _tree tvSetValue [_parentPath, _originalSortValue + _forEachIndex];
        _tree tvSetTooltip [_parentPath, _tree tvTooltip _originalSegmentPath];
        _tree tvSetPicture [_parentPath, [_tree, _originalSegmentPath] call zen_favorites_main_fnc_gettreeoriginalpicture];

        if (_forEachIndex < ((count _relativeDisplayPath) - 1)) then {
            private _favoriteBranchTextPath = [_tree, _parentPath] call zen_favorites_main_fnc_gettreepathtexts;

            if !(_favoriteBranchTextPath in _favoriteBranchTextPaths) then {
                _favoriteBranchTextPaths pushBack _favoriteBranchTextPath;
            };
        };
    } forEach _relativeDisplayPath;

    _tree tvSetData [_parentPath, _data];
    _tree tvSetValue [_parentPath, _x select 3];
    _tree tvSetTooltip [_parentPath, _tree tvTooltip _originalPath];
    _tree tvSetPicture [_parentPath, [_tree, _originalPath] call zen_favorites_main_fnc_gettreeoriginalpicture];
    [_tree, _parentPath, [1, 0.82, 0.25, 1]] call zen_favorites_main_fnc_setfavoritestar;

    _favoriteSourcePathMap set [str ([_tree, _parentPath] call zen_favorites_main_fnc_gettreepathtexts), _sourceDisplayPath];
} forEach _favorites;

if ((_tree tvCount _favoritesRootPath) == 0) exitWith {
    // Stored favorites can become unavailable when the source addon is missing.
    _tree tvDelete _favoritesRootPath;
    _tree setVariable ["zen_favorites_main_factionLeafFavoritesSignature", _signature];
    _tree setVariable ["zen_favorites_main_factionLeafFavoriteBranchTextPaths", []];
    _tree setVariable ["zen_favorites_main_factionLeafFavoriteSourcePaths", createHashMap];
    _tree setVariable [_expandedStateVariable, []];
    _tree setVariable [_pendingStateVariable, []];
    missionNamespace setVariable [_expandedStateVariable, []];
    _tree setVariable ["zen_favorites_main_ignoreFactionLeafExpandEvents", false];
    [_tree, _selectionState] call zen_favorites_main_fnc_restorecreatetreeselection;

    [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
        "removed faction leaf Favorites category because no favorites rendered key=%1 storedCount=%2",
        _favoriteKey,
        count _favorites
    ]] call zen_favorites_main_fnc_log;
};

for "_index" from 0 to ((_tree tvCount _favoritesParentPath) - 1) do {
    private _path = +_favoritesParentPath;
    _path pushBack _index;
    private _rowText = _tree tvText _path;
    private _favoriteIndex = _rootFavorites find _rowText;
    private _originalIndex = _originalOrder find _rowText;
    private _sortValue = if (_rowText == "Favorites") then {
        -1000
    } else {
        if (_favoriteIndex == -1) then {
            1000 + ([(_tree tvCount _favoritesParentPath), _originalIndex] select (_originalIndex >= 0))
        } else {
            _favoriteIndex
        }
    };

    _tree tvSetValue [_path, _sortValue];
};

_tree tvSortByValue [_favoritesParentPath, true];

[_favoritesRootPath] call _sortBranch;

private _restoreExpandedTextPaths = +_expandedTextPaths;

{
    if !(_x in _restoreExpandedTextPaths) then {
        _restoreExpandedTextPaths pushBack _x;
    };
} forEach _pendingExpandTextPaths;

private _expandedTextPathsAfterRender = [_tree, _restoreExpandedTextPaths, _expandedStateVariable] call zen_favorites_main_fnc_restorefavoritetreeexpanded;

_tree setVariable ["zen_favorites_main_factionLeafFavoritesSignature", _signature];
_tree setVariable ["zen_favorites_main_factionLeafFavoriteBranchTextPaths", _favoriteBranchTextPaths];
_tree setVariable ["zen_favorites_main_factionLeafFavoriteSourcePaths", _favoriteSourcePathMap];
_tree setVariable [_expandedStateVariable, _expandedTextPathsAfterRender];
_tree setVariable [_pendingStateVariable, []];
_tree setVariable ["zen_favorites_main_ignoreFactionLeafExpandEvents", false];
[_tree, _selectionState] call zen_favorites_main_fnc_restorecreatetreeselection;

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "rendered faction leaf Favorites category key=%1 count=%2",
    _favoriteKey,
    count _favorites
]] call zen_favorites_main_fnc_log;
