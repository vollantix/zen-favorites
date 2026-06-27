#include "..\script_component.hpp"

// Compare texture paths in the same loose format Arma returns from tree controls.
params [["_texture", ""]];

private _normalize = {
    params [["_value", ""]];

    _value = toLower _value;

    if ((_value select [0, 1]) == "\") then {
        _value = _value select [1];
    };

    _value
};

([_texture] call _normalize) == ([ZEN_FAVORITES_STAR_TEXTURE] call _normalize)
