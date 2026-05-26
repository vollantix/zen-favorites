#include "..\script_component.hpp"

// Register user-facing CBA settings for debugging and maintenance actions.
[
    "zen_favorites_main_logLevel",
    "LIST",
    ["Log level", "Controls how much ZEN Favorites writes to the Arma RPT."],
    ["ZEN Favorites", "Debugging"],
    [
        [
            ZEN_FAVORITES_LOG_LEVEL_ERROR,
            ZEN_FAVORITES_LOG_LEVEL_WARN,
            ZEN_FAVORITES_LOG_LEVEL_INFO,
            ZEN_FAVORITES_LOG_LEVEL_DEBUG,
            ZEN_FAVORITES_LOG_LEVEL_TRACE
        ],
        [
            "Error",
            "Warning",
            "Info",
            "Debug",
            "Trace"
        ],
        ZEN_FAVORITES_LOG_LEVEL_INFO
    ],
    0
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_clearEmptyGroupFavorites",
    "CHECKBOX",
    ["Clear Empty Group favorites", "Turn this on to clear the Empty Groups favorites saved in this Arma profile. The checkbox resets itself after clearing."],
    ["ZEN Favorites", "Maintenance"],
    false,
    0
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_clearModuleFavorites",
    "CHECKBOX",
    ["Clear Module favorites", "Turn this on to clear the Module favorites saved in this Arma profile. The checkbox resets itself after clearing."],
    ["ZEN Favorites", "Maintenance"],
    false,
    0
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_clearEmptyFavorites",
    "CHECKBOX",
    ["Clear Empty Unit favorites", "Turn this on to clear the Empty Units favorites saved in this Arma profile. The checkbox resets itself after clearing."],
    ["ZEN Favorites", "Maintenance"],
    false,
    0
] call CBA_fnc_addSetting;
