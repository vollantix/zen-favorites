#include "..\script_component.hpp"

// Return true when a text or visible tree path contains a generated Favorites marker.
params [["_value", [], [[], ""]]];

private _isMarker = {
    params ["_text"];

    _text == "Favorites" || {(_text find "Favorites: ") == 0}
};

if (_value isEqualType "") exitWith {
    [_value] call _isMarker
};

(_value findIf {[_x] call _isMarker}) >= 0
