#include "..\script_component.hpp"

params ["_display"];

[ZEN_FILTER_LOG_LEVEL_INFO, "Zeus display 312 opened"] call zen_filter_main_fnc_log;

if ((missionNamespace getVariable ["zen_filter_main_logLevel", ZEN_FILTER_LOG_LEVEL_INFO]) >= ZEN_FILTER_LOG_LEVEL_DEBUG) then {
    systemChat "ZEN Filter detected Zeus display 312";
};

if !(_display getVariable ["zen_filter_main_displayMouseHandlerAdded", false]) then {
    _display setVariable ["zen_filter_main_displayMouseHandlerAdded", true];

    _display displayAddEventHandler ["MouseButtonUp", {
        params ["_display", "_button"];

        if (_button != 1) exitWith {};
        if !(missionNamespace getVariable ["zen_filter_main_emptyFavoritePreviewActive", false]) exitWith {};

        [] call zen_placement_fnc_setupPreview;
        missionNamespace setVariable ["zen_filter_main_emptyFavoritePreviewActive", false];

        [ZEN_FILTER_LOG_LEVEL_INFO, "cleared Empty favorite placement preview from display right click"] call zen_filter_main_fnc_log;
    }];
};

[_display] call zen_filter_main_fnc_inspectcreatetree;
