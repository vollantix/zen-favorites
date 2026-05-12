diag_log "[ZEN Filter] postInit ran";

zen_filter_main_zeusDisplaySeen = false;

[{
    private _display = findDisplay 312;

    if (isNull _display || {zen_filter_main_zeusDisplaySeen}) exitWith {};

    zen_filter_main_zeusDisplaySeen = true;
    diag_log "[ZEN Filter] Zeus display 312 opened";
    systemChat "ZEN Filter detected Zeus display 312";
}] call CBA_fnc_addPerFrameHandler;
