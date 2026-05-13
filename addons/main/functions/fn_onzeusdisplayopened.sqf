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
private _searchPosition = ctrlPosition _search;

[ZEN_FILTER_LOG_LEVEL_DEBUG, format [
    "search position=%1",
    _searchPosition
]] call zen_filter_main_fnc_log;

private _button = _display ctrlCreate ["RscButton", _buttonIdc];
private _createPaneWidth = 0.33;
private _buttonWidth = 0.06;
private _buttonHeight = 0.035;
private _buttonGap = 0.01;
private _buttonX = safeZoneX + safeZoneW - _createPaneWidth - _buttonWidth - _buttonGap;
private _buttonY = safeZoneY + 0.12;

_button ctrlSetText "ZF";
_button ctrlSetPosition [
    _buttonX,
    _buttonY,
    _buttonWidth,
    _buttonHeight
];

_button ctrlCommit 0;
_button ctrlAddEventHandler ["ButtonClick", {
    params ["_button"];

    private _display = ctrlParent _button;

    hint "ZEN Filter inspected Create tree";
    [ZEN_FILTER_LOG_LEVEL_INFO, "button clicked"] call zen_filter_main_fnc_log;
    [_display] call zen_filter_main_fnc_inspectcreatetree;
    [_display] call zen_filter_main_fnc_toggleselectedrootfavorite;
}];

[ZEN_FILTER_LOG_LEVEL_INFO, format [
    "button created position=%1 paneWidth=%2",
    ctrlPosition _button,
    _createPaneWidth
]] call zen_filter_main_fnc_log;
