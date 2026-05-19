#include "..\script_component.hpp"

params ["_display"];

[ZEN_FILTER_LOG_LEVEL_INFO, "Zeus display 312 opened"] call zen_filter_main_fnc_log;

if ((missionNamespace getVariable ["zen_filter_main_logLevel", ZEN_FILTER_LOG_LEVEL_INFO]) >= ZEN_FILTER_LOG_LEVEL_DEBUG) then {
    systemChat "ZEN Filter detected Zeus display 312";
};

if !(_display getVariable ["zen_filter_main_displayMouseHandlerAdded", false]) then {
    _display setVariable ["zen_filter_main_displayMouseHandlerAdded", true];

    _display displayAddEventHandler ["MouseButtonDown", {
        params ["_display", "_button", "_xPos", "_yPos"];

        if (_button != 1) exitWith {};

        _display setVariable ["zen_filter_main_rightMouseDown", [_xPos, _yPos]];
    }];

    _display displayAddEventHandler ["MouseButtonUp", {
        params ["_display", "_button", "_xPos", "_yPos"];

        if (_button != 1) exitWith {};
        if !(missionNamespace getVariable ["zen_filter_main_emptyFavoritePreviewActive", false]) exitWith {};

        private _mouseDown = _display getVariable ["zen_filter_main_rightMouseDown", []];

        if (_mouseDown isEqualTo []) exitWith {};

        _mouseDown params ["_downX", "_downY"];

        private _dragDistance = sqrt (((_xPos - _downX) ^ 2) + ((_yPos - _downY) ^ 2));

        if (_dragDistance > 0.01) exitWith {
            [ZEN_FILTER_LOG_LEVEL_DEBUG, format [
                "ignored right-click preview cancel because it looked like camera drag distance=%1",
                _dragDistance
            ]] call zen_filter_main_fnc_log;
        };

        [] call zen_placement_fnc_setupPreview;
        missionNamespace setVariable ["zen_filter_main_emptyFavoritePreviewActive", false];
        missionNamespace setVariable ["zen_filter_main_emptyFavoritePreviewType", ""];

        [ZEN_FILTER_LOG_LEVEL_INFO, format [
            "cleared Empty favorite placement preview from display right click distance=%1",
            _dragDistance
        ]] call zen_filter_main_fnc_log;
    }];
};

[_display] call zen_filter_main_fnc_inspectcreatetree;
