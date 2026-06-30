#include "..\script_component.hpp"

// Apply a category persistence setting while leaving live session favorites untouched.
params [
    ["_category", ""],
    ["_enabled", false]
];

if !(_category in ["units", "groups", "modules", "empty"]) exitWith {};
if !(missionNamespace getVariable ["zen_favorites_main_favoritesInitialized", false]) exitWith {};

if (_enabled) exitWith {
    [_category, true] call zen_favorites_main_fnc_savefavoritecategory;

    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "enabled favorite persistence category=%1",
        _category
    ]] call zen_favorites_main_fnc_log;
};

switch (_category) do {
    case "units";
    case "groups": {
        private _keyPrefix = format ["%1:", _category];

        {
            private _storeVariable = _x;
            private _profileStore = [profileNamespace getVariable [_storeVariable, []]] call zen_favorites_main_fnc_favoritehashmapfromarray;

            {
                if ((_x find _keyPrefix) == 0) then {
                    _profileStore deleteAt _x;
                };
            } forEach (keys _profileStore);

            profileNamespace setVariable [
                _storeVariable,
                [_profileStore] call zen_favorites_main_fnc_favoritehashmaptoarray
            ];
        } forEach [
            "zen_favorites_main_factionFavorites",
            "zen_favorites_main_factionLeafFavorites"
        ];
    };
    case "modules": {
        profileNamespace setVariable ["zen_favorites_main_moduleFavorites", []];
    };
    case "empty": {
        profileNamespace setVariable ["zen_favorites_main_emptyFavorites_units", []];
        profileNamespace setVariable ["zen_favorites_main_emptyFavorites_groups", []];
    };
};

saveProfileNamespace;

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "disabled favorite persistence and removed saved copy category=%1",
    _category
]] call zen_favorites_main_fnc_log;
