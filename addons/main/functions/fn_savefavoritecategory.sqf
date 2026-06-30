#include "..\script_component.hpp"

// Save the live favorites for one Zeus category without changing other categories.
params [
    ["_category", ""],
    ["_force", false]
];

private _persistenceConfig = switch (_category) do {
    case "units": {["zen_favorites_main_persistUnitFavorites", true]};
    case "groups": {["zen_favorites_main_persistGroupFavorites", true]};
    case "modules": {["zen_favorites_main_persistModuleFavorites", true]};
    case "empty": {["zen_favorites_main_persistEmptyFavorites", true]};
    default {[]};
};

if (_persistenceConfig isEqualTo []) exitWith {false};

_persistenceConfig params ["_settingVariable", "_defaultValue"];

if (!_force && {!(missionNamespace getVariable [_settingVariable, _defaultValue])}) exitWith {false};

switch (_category) do {
    case "units";
    case "groups": {
        private _keyPrefix = format ["%1:", _category];

        {
            private _storeVariable = _x;
            private _currentStore = missionNamespace getVariable [_storeVariable, createHashMap];
            private _profileStore = [profileNamespace getVariable [_storeVariable, []]] call zen_favorites_main_fnc_favoritehashmapfromarray;

            {
                if ((_x find _keyPrefix) == 0) then {
                    _profileStore deleteAt _x;
                };
            } forEach (keys _profileStore);

            if (_currentStore isEqualType createHashMap) then {
                {
                    if ((_x find _keyPrefix) == 0) then {
                        _profileStore set [_x, +_y];
                    };
                } forEach _currentStore;
            };

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
        profileNamespace setVariable [
            "zen_favorites_main_moduleFavorites",
            +(missionNamespace getVariable ["zen_favorites_main_moduleFavorites", []])
        ];
    };
    case "empty": {
        {
            profileNamespace setVariable [
                _x,
                +(missionNamespace getVariable [_x, []])
            ];
        } forEach [
            "zen_favorites_main_emptyFavorites_units",
            "zen_favorites_main_emptyFavorites_groups"
        ];
    };
};

saveProfileNamespace;

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "saved favorite category=%1",
    _category
]] call zen_favorites_main_fnc_log;

true
