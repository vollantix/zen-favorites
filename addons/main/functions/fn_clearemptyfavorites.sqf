#include "..\script_component.hpp"

profileNamespace setVariable ["zen_favorites_main_emptyFavorites_units", []];
saveProfileNamespace;

missionNamespace setVariable ["zen_favorites_main_emptyFavorites_units", []];
missionNamespace setVariable ["zen_favorites_main_emptyUnitsExpandedTextPaths", []];

private _display = findDisplay 312;

if (!isNull _display) then {
    private _activeTree = [_display] call zen_favorites_main_fnc_getactivecreatetree;
    _activeTree params ["_tree", "_idc", "_mode", "_side"];

    if (!isNull _tree && {_side == "empty"} && {_mode == "units"}) then {
        for "_index" from ((_tree tvCount []) - 1) to 0 step -1 do {
            if ((_tree tvText [_index]) == "Favorites") then {
                _tree tvDelete [_index];
            };
        };

        _tree setVariable ["zen_favorites_main_lastEmptyRenderSignature", ""];
        _tree setVariable ["zen_favorites_main_emptyFavoritesSignature", ""];
        _tree setVariable ["zen_favorites_main_emptyUnitsFavoriteBranchTextPaths", []];
        _tree setVariable ["zen_favorites_main_emptyUnitsExpandedTextPaths", []];
        _tree setVariable ["zen_favorites_main_emptyUnitsPendingExpandTextPaths", []];
    };
};

["ZEN Favorites: Empty Unit favorites cleared"] call zen_favorites_main_fnc_showactionhint;

[ZEN_FAVORITES_LOG_LEVEL_INFO, "cleared Empty Unit favorites from profile"] call zen_favorites_main_fnc_log;
