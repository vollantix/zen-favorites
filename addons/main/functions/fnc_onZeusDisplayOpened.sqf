params ["_display"];

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

private _search = _display displayCtrl 283;
private _searchGroup = ctrlParentControlsGroup _search;
private _searchPosition = ctrlPosition _search;

diag_log format [
    "[ZEN Filter] search position=%1 parentGroupNull=%2",
    _searchPosition,
    isNull _searchGroup
];

private _button = if (isNull _searchGroup) then {
    _display ctrlCreate ["RscButton", -1]
} else {
    _display ctrlCreate ["RscButton", -1, _searchGroup]
};

_button ctrlSetText "ZF";

if (isNull _searchGroup) then {
    _button ctrlSetPosition [
        safeZoneX + safeZoneW - 0.16,
        safeZoneY + 0.18,
        0.06,
        0.035
    ];
} else {
    _button ctrlSetPosition [
        _searchPosition select 0,
        (_searchPosition select 1) + (_searchPosition select 3) + 0.005,
        0.06,
        0.035
    ];
};

_button ctrlCommit 0;
_button ctrlAddEventHandler ["ButtonClick", {
    hint "ZEN Filter button clicked";
    diag_log "[ZEN Filter] button clicked";
}];

diag_log "[ZEN Filter] button created";
