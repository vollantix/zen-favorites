#include "..\script_component.hpp"

params [
    ["_level", ZEN_FAVORITES_LOG_LEVEL_INFO, [0]],
    ["_message", "", [""]]
];

private _currentLevel = missionNamespace getVariable [
    "zen_favorites_main_logLevel",
    ZEN_FAVORITES_LOG_LEVEL_INFO
];

if (_level > _currentLevel) exitWith {};

private _levelNames = ["ERROR", "WARN", "INFO", "DEBUG", "TRACE"];
private _levelName = _levelNames param [_level, "INFO"];

diag_log format ["[ZEN Favorites] [%1] %2", _levelName, _message];
