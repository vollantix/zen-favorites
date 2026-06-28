#include "..\script_component.hpp"

// Strip generated Favorites path segments to recover a source display path.
params [["_displayPath", []]];

private _sourceDisplayPath = +_displayPath;
private _favoritesIndex = _sourceDisplayPath findIf {
    [_x] call zen_favorites_main_fnc_isfavoritepath
};

if (_favoritesIndex >= 0) then {
    _sourceDisplayPath deleteAt _favoritesIndex;
};

_sourceDisplayPath
