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
    "zen_filter_main_clearEmptyFavoritesButton",
    "BUTTON",
    ["Clear Empty Unit favorites", "Clears the Empty Units favorites saved in this Arma profile."],
    ["ZEN Filter", "Maintenance"],
    [
        "Clear favorites",
        {
            [] call zen_filter_main_fnc_clearemptyfavorites;
        }
    ],
    0
] call CBA_fnc_addSetting;
