#include "..\script_component.hpp"

params [["_displayPath", []]];

private _sourceDisplayPath = +_displayPath;
private _favoritesIndex = _sourceDisplayPath find "Favorites";

if (_favoritesIndex >= 0) then {
    _sourceDisplayPath deleteAt _favoritesIndex;
};

_sourceDisplayPath
