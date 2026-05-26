#include "..\script_component.hpp"

// Strip generated Favorites path segments to recover a source display path.
params [["_displayPath", []]];

private _sourceDisplayPath = +_displayPath;
private _favoritesIndex = _sourceDisplayPath find "Favorites";

if (_favoritesIndex >= 0) then {
    _sourceDisplayPath deleteAt _favoritesIndex;
};

_sourceDisplayPath
