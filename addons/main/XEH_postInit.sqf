diag_log "[ZEN Filter] postInit ran";

zen_filter_main_zeusDisplaySeen = false;

[{
    private _display = findDisplay 312;

    if (isNull _display || {zen_filter_main_zeusDisplaySeen}) exitWith {};

    zen_filter_main_zeusDisplaySeen = true;
    [_display] call compile preprocessFileLineNumbers "z\zen_filter\addons\main\functions\fnc_onZeusDisplayOpened.sqf";
}] call CBA_fnc_addPerFrameHandler;
