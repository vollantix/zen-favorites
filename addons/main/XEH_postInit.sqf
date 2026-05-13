diag_log "[ZEN Filter] postInit ran";

[{
    private _display = findDisplay 312;
    private _buttonExists = !isNull _display && {{ctrlIDC _x == 712300} count allControls _display > 0};

    if (isNull _display || _buttonExists) exitWith {};

    [_display] call zen_filter_main_fnc_onzeusdisplayopened;
}] call CBA_fnc_addPerFrameHandler;
