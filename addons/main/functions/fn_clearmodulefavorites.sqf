#include "..\script_component.hpp"

// Clear saved Module favorites and remove the live Favorites branch if it is visible.
profileNamespace setVariable ["zen_favorites_main_moduleFavorites", []];
saveProfileNamespace;

missionNamespace setVariable ["zen_favorites_main_moduleFavorites", []];

private _display = findDisplay 312;

if (!isNull _display) then {
    private _activeTree = [_display] call zen_favorites_main_fnc_getactivecreatetree;
    _activeTree params ["_tree", "_idc", "_mode"];

    if (!isNull _tree && {_mode == "modules"}) then {
        for "_index" from ((_tree tvCount []) - 1) to 0 step -1 do {
            if ((_tree tvText [_index]) == "Favorites") then {
                _tree tvDelete [_index];
            };
        };

        _tree setVariable ["zen_favorites_main_lastModuleRenderSignature", ""];
        _tree setVariable ["zen_favorites_main_moduleFavoritesSignature", ""];
    };
};

["ZEN Favorites: Module favorites cleared"] call zen_favorites_main_fnc_showactionhint;

[ZEN_FAVORITES_LOG_LEVEL_INFO, "cleared Module favorites from profile"] call zen_favorites_main_fnc_log;
