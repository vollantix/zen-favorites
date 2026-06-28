#include "..\script_component.hpp"

// Build the generated Favorites branch for Empty Units or Empty Groups.
params ["_tree", "_mode"];

private _storeKey = format ["zen_favorites_main_emptyFavorites_%1", _mode];
private _favorites = (missionNamespace getVariable [_storeKey, []]) select {
    (_x isEqualType []) &&
    {count _x >= 2} &&
    {(_x select 1) isEqualType ""} &&
    {(_x select 1) != ""}
};
private _starAlignment = missionNamespace getVariable ["zen_favorites_main_starAlignment", ZEN_FAVORITES_STAR_ALIGNMENT_LEFT];
private _favoriteLayout = [_mode] call zen_favorites_main_fnc_getfavoritelayout;
private _isFlatLayout = _favoriteLayout == ZEN_FAVORITES_LAYOUT_FLAT;
private _signature = str [_favorites, _starAlignment, _favoriteLayout];
private _rootCount = _tree tvCount [];
private _hasFavoritesRoot = false;

// If an old empty Favorites root is still visible, force one cleanup pass.
for "_index" from 0 to (_rootCount - 1) do {
    if ((_tree tvText [_index]) == "Favorites") exitWith {
        _hasFavoritesRoot = true;
    };
};

if (
    (_tree getVariable ["zen_favorites_main_emptyFavoritesSignature", ""] == _signature) &&
    {!(_favorites isEqualTo [] && {_hasFavoritesRoot})}
) exitWith {};

private _selectionState = [_tree, []] call zen_favorites_main_fnc_parkcreatetreeselection;
private _originalRootOrder = _tree getVariable ["zen_favorites_main_emptyOriginalRootOrder", []];
private _isEmptyUnits = _mode == "units";
private _isEmptyGroups = _mode == "groups";
private _expandedStateVariable = [
    "zen_favorites_main_emptyUnitsExpandedTextPaths",
    "zen_favorites_main_emptyGroupsExpandedTextPaths"
] select _isEmptyGroups;
private _pendingStateVariable = [
    "zen_favorites_main_emptyUnitsPendingExpandTextPaths",
    "zen_favorites_main_emptyGroupsPendingExpandTextPaths"
] select _isEmptyGroups;
private _ignoreExpandVariable = [
    "zen_favorites_main_ignoreEmptyUnitsExpandEvents",
    "zen_favorites_main_ignoreEmptyGroupsExpandEvents"
] select _isEmptyGroups;
private _expandedTextPaths = +(missionNamespace getVariable [_expandedStateVariable, (_tree getVariable [_expandedStateVariable, []])]);
private _pendingExpandTextPaths = +(_tree getVariable [_pendingStateVariable, []]);

if (_originalRootOrder isEqualTo []) then {
    for "_index" from 0 to (_rootCount - 1) do {
        private _rootText = _tree tvText [_index];

        if (_rootText != "Favorites") then {
            _originalRootOrder pushBack _rootText;
        };
    };

    _tree setVariable ["zen_favorites_main_emptyOriginalRootOrder", _originalRootOrder];
};

// Rendering deletes and rebuilds rows; ignore those synthetic expand/collapse events.
_tree setVariable [_ignoreExpandVariable, true];

for "_index" from (_rootCount - 1) to 0 step -1 do {
    if ((_tree tvText [_index]) == "Favorites") then {
        _tree tvDelete [_index];
    };
};

if (_favorites isEqualTo []) exitWith {
    _tree setVariable ["zen_favorites_main_emptyFavoritesSignature", _signature];

    if (_isEmptyGroups) then {
        _tree setVariable ["zen_favorites_main_emptyGroupsFavoriteBranchTextPaths", []];
        _tree setVariable ["zen_favorites_main_emptyGroupsFavoriteSourcePaths", createHashMap];
    } else {
        _tree setVariable ["zen_favorites_main_emptyUnitsFavoriteBranchTextPaths", []];
    };

    _tree setVariable [_expandedStateVariable, []];
    _tree setVariable [_pendingStateVariable, []];
    missionNamespace setVariable [_expandedStateVariable, []];
    _tree setVariable [_ignoreExpandVariable, false];
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
private _favoriteBranchTextPaths = [];
private _favoriteSourcePathMap = createHashMap;

// The synthetic root is a UI folder only; it must not become a placeable object.
_tree tvSetData [_favoritesRootPath, ""];
_tree tvSetValue [_favoritesRootPath, -1000];

{
    private _displayPath = _x select 0;
    private _className = _x select 1;
    private _originalPath = if (_mode == "groups") then {
        [_tree, _displayPath] call zen_favorites_main_fnc_findtreepathbytexts
    } else {
        [_tree, [], _className] call zen_favorites_main_fnc_findtreepathbydata
    };
    private _relativeDisplayPath = +_displayPath;

    if (_originalPath isEqualTo []) then {
        [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
            "skipped missing Empty favorite class=%1 displayPath=%2",
            _className,
            _displayPath
        ]] call zen_favorites_main_fnc_log;
        continue;
    };

    if (_isFlatLayout) then {
        _relativeDisplayPath = [_relativeDisplayPath joinString " / "];
    } else {
        if (_isEmptyUnits) then {
            // Empty Units can have deep source paths, so present a compact two-level branch.
            private _leafText = _relativeDisplayPath param [(count _relativeDisplayPath) - 1, ""];
            private _categoryParts = _relativeDisplayPath select [0, ((count _relativeDisplayPath) - 1) max 0];
            private _categoryText = if (_categoryParts isEqualTo []) then {"Favorites"} else {_categoryParts joinString " / "};

            _relativeDisplayPath = [_categoryText, _leafText];
        };

        if (_isEmptyGroups && {count _relativeDisplayPath > 1}) then {
            // Empty Groups keep one extra category level for readable composition grouping.
            private _leafText = _relativeDisplayPath param [(count _relativeDisplayPath) - 1, ""];
            private _categoryParts = _relativeDisplayPath select [0, ((count _relativeDisplayPath) - 1) max 0];

            if ((count _categoryParts) > 1) then {
                private _rootCategoryText = _categoryParts select 0;
                private _subCategoryText = (_categoryParts select [1]) joinString " / ";

                _relativeDisplayPath = [_rootCategoryText, _subCategoryText, _leafText];
            } else {
                _relativeDisplayPath = [_categoryParts param [0, "Favorites"], _leafText];
            };
        };
    };

    private _pathOffset = (count _displayPath) - (count _relativeDisplayPath);
    private _originalSortValue = [_originalPath] call _getOriginalSortValue;
    private _parentPath = +_favoritesRootPath;

    {
        private _segment = _x;
        private _existingIndex = -1;
        private _childCount = _tree tvCount _parentPath;
        private _originalSegmentPath = _originalPath select [0, ((count _originalPath) - 1) min (_forEachIndex + 1 + _pathOffset)];

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

            _favoriteBranchTextPaths pushBack _favoriteBranchTextPath;
        };
    } forEach _relativeDisplayPath;

    _tree tvSetData [_parentPath, _className];
    _tree tvSetValue [_parentPath, _originalSortValue];
    _tree tvSetTooltip [_parentPath, _tree tvTooltip _originalPath];
    _tree tvSetPicture [_parentPath, [_tree, _originalPath] call zen_favorites_main_fnc_gettreeoriginalpicture];
    [_tree, _parentPath, [1, 0.82, 0.25, 1]] call zen_favorites_main_fnc_setfavoritestar;

    if (_isEmptyGroups) then {
        // Compacted display paths need a reverse map to find the original ZEN row again.
        _favoriteSourcePathMap set [str (["Favorites"] + _relativeDisplayPath), _displayPath];
    };
} forEach _favorites;

if ((_tree tvCount _favoritesRootPath) == 0) exitWith {
    // Stored favorites can become unavailable when mods/compositions are missing.
    _tree tvDelete _favoritesRootPath;
    _tree setVariable ["zen_favorites_main_emptyFavoritesSignature", _signature];

    if (_isEmptyGroups) then {
        _tree setVariable ["zen_favorites_main_emptyGroupsFavoriteBranchTextPaths", []];
        _tree setVariable ["zen_favorites_main_emptyGroupsFavoriteSourcePaths", createHashMap];
    } else {
        _tree setVariable ["zen_favorites_main_emptyUnitsFavoriteBranchTextPaths", []];
    };

    _tree setVariable [_expandedStateVariable, []];
    _tree setVariable [_pendingStateVariable, []];
    missionNamespace setVariable [_expandedStateVariable, []];
    _tree setVariable [_ignoreExpandVariable, false];
    [_tree, _selectionState] call zen_favorites_main_fnc_restorecreatetreeselection;

    [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
        "removed Empty Favorites category because no favorites rendered mode=%1 storedCount=%2",
        _mode,
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

private _sortFavoritesPath = +_favoritesRootPath;

while {true} do {
    _tree tvSortByValue [_sortFavoritesPath, true];

    if ((_tree tvCount _sortFavoritesPath) == 0) exitWith {};

    _sortFavoritesPath pushBack 0;
};

private _restoreExpandedTextPaths = +_expandedTextPaths;

{
    if !(_x in _restoreExpandedTextPaths) then {
        _restoreExpandedTextPaths pushBack _x;
    };
} forEach _pendingExpandTextPaths;

private _expandedTextPathsAfterRender = [_tree, _restoreExpandedTextPaths, _expandedStateVariable] call zen_favorites_main_fnc_restorefavoritetreeexpanded;

if (_isEmptyGroups) then {
    _tree setVariable ["zen_favorites_main_emptyGroupsFavoriteBranchTextPaths", _favoriteBranchTextPaths];
    _tree setVariable ["zen_favorites_main_emptyGroupsFavoriteSourcePaths", _favoriteSourcePathMap];
} else {
    _tree setVariable ["zen_favorites_main_emptyUnitsFavoriteBranchTextPaths", _favoriteBranchTextPaths];
};

_tree setVariable [_expandedStateVariable, _expandedTextPathsAfterRender];
_tree setVariable [_pendingStateVariable, []];
_tree setVariable [_ignoreExpandVariable, false];

_tree setVariable ["zen_favorites_main_emptyFavoritesSignature", _signature];
[_tree, _selectionState] call zen_favorites_main_fnc_restorecreatetreeselection;

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "rendered Empty Favorites category count=%1",
    count _favorites
]] call zen_favorites_main_fnc_log;
