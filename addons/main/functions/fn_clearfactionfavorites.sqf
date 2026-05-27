#include "..\script_component.hpp"

// Clear top-level faction favorites from the live session and profile.
profileNamespace setVariable ["zen_favorites_main_factionFavorites", []];
saveProfileNamespace;

missionNamespace setVariable ["zen_favorites_main_factionFavorites", createHashMap];

private _display = findDisplay 312;

if (!isNull _display) then {
    {
        private _tree = _display displayCtrl _x;

        if (!isNull _tree) then {
            _tree setVariable ["zen_favorites_main_lastFavoriteOrderSignature", ""];
            _tree setVariable ["zen_favorites_main_lastFactionRenderSignature", ""];
        };
    } forEach [
        ZEN_FAVORITES_IDC_CREATE_UNITS_WEST,
        ZEN_FAVORITES_IDC_CREATE_UNITS_EAST,
        ZEN_FAVORITES_IDC_CREATE_UNITS_GUER,
        ZEN_FAVORITES_IDC_CREATE_UNITS_CIV,
        ZEN_FAVORITES_IDC_CREATE_GROUPS_WEST,
        ZEN_FAVORITES_IDC_CREATE_GROUPS_EAST,
        ZEN_FAVORITES_IDC_CREATE_GROUPS_GUER
    ];

    [_display, true] call zen_favorites_main_fnc_applyfactionfavoriteorder;
    [_display] call zen_favorites_main_fnc_rendercreatetreefavorites;
};

["ZEN Favorites: Faction favorites cleared"] call zen_favorites_main_fnc_showactionhint;

[ZEN_FAVORITES_LOG_LEVEL_INFO, "cleared top-level faction favorites from profile"] call zen_favorites_main_fnc_log;
