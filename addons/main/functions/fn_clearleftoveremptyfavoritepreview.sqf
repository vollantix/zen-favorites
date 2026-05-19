#include "..\script_component.hpp"

params [
    ["_expectedType", ""],
    ["_reason", ""]
];

if (_expectedType == "") exitWith {false};
if (isNil "zen_placement_object") exitWith {false};
if (isNull zen_placement_object) exitWith {false};
if (typeOf zen_placement_object != _expectedType) exitWith {false};

[] call zen_placement_fnc_setupPreview;

[ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
    "cleared leftover Empty favorite preview expectedType=%1 reason=%2",
    _expectedType,
    _reason
]] call zen_favorites_main_fnc_log;

true
