#include "..\script_component.hpp"

// Build the generated Favorites branch for the Modules tree.
params ["_tree"];

private _favorites = (missionNamespace getVariable ["zen_favorites_main_moduleFavorites", []]) select {
    (_x isEqualType []) &&
    {count _x >= 6} &&
    {(_x select 0) isEqualType []} &&
    {(_x select 2) isEqualType ""}
};
private _rootCount = _tree tvCount [];
private _hasFavoritesRoot = false;
private _sourceTreeSignature = [];

// If an old empty Favorites root is still visible, force one cleanup pass.
for "_index" from 0 to (_rootCount - 1) do {
    private _path = [_index];
    private _rootText = _tree tvText _path;

    if (_rootText == "Favorites") then {
        _hasFavoritesRoot = true;
    } else {
        _sourceTreeSignature pushBack [_rootText, _tree tvCount _path];
    };
};

private _starAlignment = missionNamespace getVariable ["zen_favorites_main_starAlignment", ZEN_FAVORITES_STAR_ALIGNMENT_LEFT];
private _favoriteLayout = ["modules"] call zen_favorites_main_fnc_getfavoritelayout;
private _isFlatLayout = _favoriteLayout == ZEN_FAVORITES_LAYOUT_FLAT;
private _signature = str [_favorites, _starAlignment, _favoriteLayout, _sourceTreeSignature];

if (
    (_tree getVariable ["zen_favorites_main_moduleFavoritesSignature", ""] == _signature) &&
    {!(_favorites isEqualTo [] && {_hasFavoritesRoot})}
) exitWith {};

private _selectionState = [_tree, []] call zen_favorites_main_fnc_parkcreatetreeselection;
private _storedOriginalRootOrder = _tree getVariable ["zen_favorites_main_moduleOriginalRootOrder", []];
private _originalRootOrder = +_storedOriginalRootOrder;
private _sessionExpandedTextPaths = +(missionNamespace getVariable ["zen_favorites_main_moduleExpandedTextPaths", []]);
private _expandedTextPaths = +(_tree getVariable ["zen_favorites_main_moduleExpandedTextPaths", _sessionExpandedTextPaths]);
private _pendingExpandTextPaths = +(_tree getVariable ["zen_favorites_main_modulePendingExpandTextPaths", []]);

for "_index" from 0 to (_rootCount - 1) do {
    private _rootText = _tree tvText [_index];

    if (_rootText != "Favorites" && {!(_rootText in _originalRootOrder)}) then {
        _originalRootOrder pushBack _rootText;
    };
};

if (_originalRootOrder isNotEqualTo _storedOriginalRootOrder) then {
    _tree setVariable ["zen_favorites_main_moduleOriginalRootOrder", _originalRootOrder];
};

// Rendering deletes and rebuilds rows; ignore those synthetic expand/collapse events.
_tree setVariable ["zen_favorites_main_ignoreModuleExpandEvents", true];

for "_index" from (_rootCount - 1) to 0 step -1 do {
    if ((_tree tvText [_index]) == "Favorites") then {
        _tree tvDelete [_index];
    };
};

if (_favorites isEqualTo []) exitWith {
    _tree setVariable ["zen_favorites_main_moduleFavoritesSignature", _signature];
    _tree setVariable ["zen_favorites_main_moduleFavoriteSourcePaths", createHashMap];
    _tree setVariable ["zen_favorites_main_moduleExpandedTextPaths", []];
    _tree setVariable ["zen_favorites_main_modulePendingExpandTextPaths", []];
    missionNamespace setVariable ["zen_favorites_main_moduleExpandedTextPaths", []];
    _tree setVariable ["zen_favorites_main_ignoreModuleExpandEvents", false];
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

private _favoritesRootIndex = _tree tvAdd [[], "Favorites"];
private _favoritesRootPath = [_favoritesRootIndex];
private _favoriteSourcePathMap = createHashMap;

// The synthetic root is a UI folder only; it must not become a placeable object.
_tree tvSetData [_favoritesRootPath, ""];
_tree tvSetValue [_favoritesRootPath, -1000];

{
    private _displayPath = _x select 0;
    private _originalPath = [_tree, _displayPath] call zen_favorites_main_fnc_findtreepathbytexts;

    if (_originalPath isEqualTo []) then {
        [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
            "skipped missing Module favorite class=%1 displayPath=%2",
            _x select 1,
            _displayPath
        ]] call zen_favorites_main_fnc_log;
        continue;
    };

    private _className = _tree tvData _originalPath;
    private _relativeDisplayPath = if (_isFlatLayout) then {
        [_displayPath joinString " / "]
    } else {
        +_displayPath
    };
    private _pathOffset = (count _displayPath) - (count _relativeDisplayPath);
    private _originalSortValue = [_originalPath] call _getOriginalSortValue;
    private _favoritePath = +_favoritesRootPath;

    {
        private _segment = _x;
        private _existingIndex = -1;
        private _childCount = _tree tvCount _favoritePath;
        private _sourceDepth = ((count _originalPath) - 1) min (_forEachIndex + 1 + _pathOffset);
        private _originalSegmentPath = _originalPath select [0, _sourceDepth];

        for "_childIndex" from 0 to (_childCount - 1) do {
            private _candidatePath = +_favoritePath;
            _candidatePath pushBack _childIndex;

            if ((_tree tvText _candidatePath) == _segment) exitWith {
                _existingIndex = _childIndex;
            };
        };

        if (_existingIndex == -1) then {
            _existingIndex = _tree tvAdd [_favoritePath, _segment];
        };

        _favoritePath pushBack _existingIndex;

        // Generated folders are inert UI rows; only the final leaf gets source data.
        _tree tvSetData [_favoritePath, ""];
        _tree tvSetValue [_favoritePath, _originalSortValue + _forEachIndex];
        _tree tvSetTooltip [_favoritePath, _tree tvTooltip _originalSegmentPath];
        _tree tvSetPicture [_favoritePath, [_tree, _originalSegmentPath] call zen_favorites_main_fnc_gettreeoriginalpicture];
    } forEach _relativeDisplayPath;

    _tree tvSetData [_favoritePath, _className];
    _tree tvSetValue [_favoritePath, _tree tvValue _originalPath];
    _tree tvSetTooltip [_favoritePath, _tree tvTooltip _originalPath];
    _tree tvSetPicture [_favoritePath, [_tree, _originalPath] call zen_favorites_main_fnc_gettreeoriginalpicture];
    [_tree, _favoritePath, [1, 0.82, 0.25, 1]] call zen_favorites_main_fnc_setfavoritestar;

    _favoriteSourcePathMap set [str ([_tree, _favoritePath] call zen_favorites_main_fnc_gettreepathtexts), _displayPath];
} forEach _favorites;

if ((_tree tvCount _favoritesRootPath) == 0) exitWith {
    // Stored favorites can become unavailable when a module-providing mod is missing.
    _tree tvDelete _favoritesRootPath;
    _tree setVariable ["zen_favorites_main_moduleFavoritesSignature", _signature];
    _tree setVariable ["zen_favorites_main_moduleFavoriteSourcePaths", createHashMap];
    _tree setVariable ["zen_favorites_main_moduleExpandedTextPaths", []];
    _tree setVariable ["zen_favorites_main_modulePendingExpandTextPaths", []];
    missionNamespace setVariable ["zen_favorites_main_moduleExpandedTextPaths", []];
    _tree setVariable ["zen_favorites_main_ignoreModuleExpandEvents", false];
    [_tree, _selectionState] call zen_favorites_main_fnc_restorecreatetreeselection;

    [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
        "removed Module Favorites category because no favorites rendered storedCount=%1",
        count _favorites
    ]] call zen_favorites_main_fnc_log;
};

private _newRootCount = _tree tvCount [];

for "_index" from 0 to (_newRootCount - 1) do {
    private _path = [_index];
    private _rootText = _tree tvText _path;
    private _originalIndex = _originalRootOrder find _rootText;
    private _sortValue = if (_rootText == "Favorites") then {
        -1000
    } else {
        1000 + ([_newRootCount, _originalIndex] select (_originalIndex >= 0))
    };

    _tree tvSetValue [_path, _sortValue];
};

_tree tvSortByValue [[], true];

private _restoreExpandedTextPaths = +_expandedTextPaths;

{
    if !(_x in _restoreExpandedTextPaths) then {
        _restoreExpandedTextPaths pushBack _x;
    };
} forEach _pendingExpandTextPaths;

private _expandedTextPathsAfterRender = [_tree, _restoreExpandedTextPaths, "zen_favorites_main_moduleExpandedTextPaths"] call zen_favorites_main_fnc_restorefavoritetreeexpanded;

_tree setVariable ["zen_favorites_main_moduleFavoritesSignature", _signature];
_tree setVariable ["zen_favorites_main_moduleFavoriteSourcePaths", _favoriteSourcePathMap];
_tree setVariable ["zen_favorites_main_moduleExpandedTextPaths", _expandedTextPathsAfterRender];
_tree setVariable ["zen_favorites_main_modulePendingExpandTextPaths", []];
_tree setVariable ["zen_favorites_main_ignoreModuleExpandEvents", false];
[_tree, _selectionState] call zen_favorites_main_fnc_restorecreatetreeselection;

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "rendered Module Favorites category count=%1",
    count _favorites
]] call zen_favorites_main_fnc_log;
