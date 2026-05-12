diag_log "[ZEN Filter] postInit ran";

zen_filter_main_zeusDisplaySeen = false;

[{
    private _display = findDisplay 312;

    if (isNull _display || {zen_filter_main_zeusDisplaySeen}) exitWith {};

    zen_filter_main_zeusDisplaySeen = true;
    diag_log "[ZEN Filter] Zeus display 312 opened";
    systemChat "ZEN Filter detected Zeus display 312";

    {
        if (_forEachIndex < 30) then {
            diag_log format [
                "[ZEN Filter] control %1: idc=%2 class=%3 text=%4",
                _forEachIndex,
                ctrlIDC _x,
                ctrlClassName _x,
                ctrlText _x
            ];
        };
    } forEach allControls _display;
}] call CBA_fnc_addPerFrameHandler;
