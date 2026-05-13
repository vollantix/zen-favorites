#include "..\script_component.hpp"

[
    "zen_filter_main_logLevel",
    "LIST",
    ["Log level", "Controls how much ZEN Filter writes to the Arma RPT."],
    ["ZEN Filter", "Debugging"],
    [
        [
            ZEN_FILTER_LOG_LEVEL_ERROR,
            ZEN_FILTER_LOG_LEVEL_WARN,
            ZEN_FILTER_LOG_LEVEL_INFO,
            ZEN_FILTER_LOG_LEVEL_DEBUG,
            ZEN_FILTER_LOG_LEVEL_TRACE
        ],
        [
            "Error",
            "Warning",
            "Info",
            "Debug",
            "Trace"
        ],
        ZEN_FILTER_LOG_LEVEL_INFO
    ],
    0
] call CBA_fnc_addSetting;

[
    "zen_filter_main_clearEmptyFavorites",
    "CHECKBOX",
    ["Clear Empty Unit favorites", "Turn this on to clear the Empty Units favorites saved in this Arma profile. The checkbox resets itself after clearing."],
    ["ZEN Filter", "Maintenance"],
    false,
    0,
    {
        params ["_value"];

        if (!_value) exitWith {};

        [] call zen_filter_main_fnc_clearemptyfavorites;

        [{
            zen_filter_main_clearEmptyFavorites = false;

            ["zen_filter_main_clearEmptyFavorites", false, nil, "client"] call CBA_settings_fnc_set;
            ["zen_filter_main_clearEmptyFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
            ["zen_filter_main_clearEmptyFavorites", false, nil, "server"] call CBA_settings_fnc_set;
        }, [], 0.25] call CBA_fnc_waitAndExecute;
    }
] call CBA_fnc_addSetting;
