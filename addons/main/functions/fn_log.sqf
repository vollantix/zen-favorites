#include "..\script_component.hpp"

params [
    ["_level", ZEN_FILTER_LOG_LEVEL_INFO, [0]],
    ["_message", "", [""]]
];

private _currentLevel = missionNamespace getVariable [
    "zen_filter_main_logLevel",
    ZEN_FILTER_LOG_LEVEL_INFO
];

if (_level > _currentLevel) exitWith {};

private _levelNames = ["ERROR", "WARN", "INFO", "DEBUG", "TRACE"];
private _levelName = _levelNames param [_level, "INFO"];

diag_log format ["[ZEN Filter] [%1] %2", _levelName, _message];
