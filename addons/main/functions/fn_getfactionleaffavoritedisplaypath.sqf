#include "..\script_component.hpp"

// Return the visible path shown under the generated faction leaf Favorites branch.
params [
    ["_sourceDisplayPath", []],
    ["_mode", ""],
    ["_tree", controlNull],
    ["_candidateSourceDisplayPaths", []]
];

private _favoriteLayout = [_mode] call zen_favorites_main_fnc_getfavoritelayout;
private _getRelativePath = {
    params ["_displayPath"];

    private _relativePath = +_displayPath;

    if (
        _mode == "groups" &&
        {!isNull _tree} &&
        {(_tree tvCount []) > 0} &&
        {(count _relativePath) > 1} &&
        {(_relativePath select 0) == (_tree tvText [0])}
    ) then {
        _relativePath deleteAt 0;
    };

    _relativePath
};
private _relativeDisplayPath = [_sourceDisplayPath] call _getRelativePath;
private _relativeCandidatePaths = _candidateSourceDisplayPaths apply {[_x] call _getRelativePath};

if (_favoriteLayout == ZEN_FAVORITES_LAYOUT_FLAT) exitWith {
    [[_relativeDisplayPath, _relativeCandidatePaths] call zen_favorites_main_fnc_getshortestuniquefavoritelabel]
};

if (_mode == "groups") exitWith {
    // Grouped faction Groups use one safe root per faction with qualified leaves.
    if ((count _relativeDisplayPath) > 1) then {
        private _factionText = _relativeDisplayPath select 0;
        private _leafPath = _relativeDisplayPath select [1];
        private _candidateLeafPaths = (_relativeCandidatePaths select {
            _x isNotEqualTo [] &&
            {(_x select 0) == _factionText}
        }) apply {_x select [1]};
        private _leafText = [_leafPath, _candidateLeafPaths] call zen_favorites_main_fnc_getshortestuniquefavoritelabel;

        _relativeDisplayPath = [_factionText, _leafText];
    };

    _relativeDisplayPath
};

if ((count _relativeDisplayPath) > 2) then {
    private _leafText = _relativeDisplayPath select -1;
    private _categoryText = (_relativeDisplayPath select [0, ((count _relativeDisplayPath) - 1) max 0]) joinString " / ";

    _relativeDisplayPath = [_categoryText, _leafText];
};

_relativeDisplayPath
