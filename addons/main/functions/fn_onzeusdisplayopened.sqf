#include "..\script_component.hpp"

// Mark that a Zeus display was seen; heavier work runs through the render loop.
params ["_display"];

[ZEN_FAVORITES_LOG_LEVEL_DEBUG, "Zeus display opened"] call zen_favorites_main_fnc_log;
