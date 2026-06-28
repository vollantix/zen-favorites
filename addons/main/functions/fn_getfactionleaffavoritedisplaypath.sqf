#include "..\script_component.hpp"

// Return the visible path shown under the generated faction leaf Favorites branch.
params [
    ["_sourceDisplayPath", []],
    ["_mode", ""],
    ["_tree", controlNull]
];

private _relativeDisplayPath = +_sourceDisplayPath;
private _favoriteLayout = [_mode] call zen_favorites_main_fnc_getfavoritelayout;

if (
    _mode == "groups" &&
    {!isNull _tree} &&
    {(_tree tvCount []) > 0} &&
    {(count _relativeDisplayPath) > 1} &&
    {(_relativeDisplayPath select 0) == (_tree tvText [0])}
) then {
    _relativeDisplayPath deleteAt 0;
};

if (_favoriteLayout == ZEN_FAVORITES_LAYOUT_FLAT) exitWith {
    if ((count _relativeDisplayPath) > 1) then {
        [_relativeDisplayPath joinString " / "]
    } else {
        _relativeDisplayPath
    }
};

if (_mode == "groups") exitWith {
    // Grouped faction Groups use one safe root per faction with qualified leaves.
    if ((count _relativeDisplayPath) > 1) then {
        private _factionText = _relativeDisplayPath select 0;
        private _leafText = (_relativeDisplayPath select [1]) joinString " / ";

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
