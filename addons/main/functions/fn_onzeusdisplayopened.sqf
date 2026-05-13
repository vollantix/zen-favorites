#include "..\script_component.hpp"

params ["_display"];

private _buttonIdc = ZEN_FILTER_BUTTON_IDC;
private _existingButtons = allControls _display select {ctrlIDC _x == _buttonIdc};

if (_existingButtons isNotEqualTo []) exitWith {
    [ZEN_FILTER_LOG_LEVEL_TRACE, "button already exists"] call zen_filter_main_fnc_log;
};

[ZEN_FILTER_LOG_LEVEL_INFO, "Zeus display 312 opened"] call zen_filter_main_fnc_log;
systemChat "ZEN Filter detected Zeus display 312";

private _search = _display displayCtrl 283;
private _searchGroup = ctrlParentControlsGroup _search;
private _searchPosition = ctrlPosition _search;

[ZEN_FILTER_LOG_LEVEL_DEBUG, format [
    "search position=%1 parentGroupNull=%2",
    _searchPosition,
    isNull _searchGroup
]] call zen_filter_main_fnc_log;

private _button = if (isNull _searchGroup) then {
    _display ctrlCreate ["RscButton", _buttonIdc]
} else {
    _display ctrlCreate ["RscButton", _buttonIdc, _searchGroup]
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
    params ["_button"];

    private _display = ctrlParent _button;

    hint "ZEN Filter inspected Create tree";
    [ZEN_FILTER_LOG_LEVEL_INFO, "button clicked"] call zen_filter_main_fnc_log;
    [_display] call zen_filter_main_fnc_inspectcreatetree;
}];

[ZEN_FILTER_LOG_LEVEL_INFO, "button created"] call zen_filter_main_fnc_log;
