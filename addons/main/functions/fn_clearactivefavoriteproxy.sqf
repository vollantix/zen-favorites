#include "..\script_component.hpp"

// Clear the gold active styling from a generated favorite proxy row.
params [
    "_tree",
    "_activePathVariable",
    ["_normalColor", [1, 1, 1, 1]]
];

private _activeFavoritePath = _tree getVariable [_activePathVariable, []];

if (_activeFavoritePath isNotEqualTo []) then {
    private _displayPath = [_tree, _activeFavoritePath] call zen_favorites_main_fnc_gettreepathtexts;

    if ([_displayPath] call zen_favorites_main_fnc_isfavoritepath) then {
        _tree tvSetColor [_activeFavoritePath, _normalColor];
    };
};

_tree setVariable [_activePathVariable, []];
