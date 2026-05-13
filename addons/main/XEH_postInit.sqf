#include "script_component.hpp"

[ZEN_FILTER_LOG_LEVEL_INFO, "postInit ran"] call zen_filter_main_fnc_log;

[{
    private _display = findDisplay 312;
    private _buttonExists = !isNull _display && {{ctrlIDC _x == ZEN_FILTER_BUTTON_IDC} count allControls _display > 0};

    if (isNull _display || _buttonExists) exitWith {};

    [_display] call zen_filter_main_fnc_onzeusdisplayopened;
}] call CBA_fnc_addPerFrameHandler;
