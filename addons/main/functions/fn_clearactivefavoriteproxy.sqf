#include "..\script_component.hpp"

params [
    "_tree",
    "_activePathVariable",
    ["_normalColor", [1, 1, 1, 1]]
];

private _activeFavoritePath = _tree getVariable [_activePathVariable, []];

if (_activeFavoritePath isNotEqualTo [] && {(_tree tvText [_activeFavoritePath select 0]) == "Favorites"}) then {
    _tree tvSetColor [_activeFavoritePath, _normalColor];
};

_tree setVariable [_activePathVariable, []];
