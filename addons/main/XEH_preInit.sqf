#include "script_component.hpp"

// Register CBA settings before the addon starts interacting with Zeus UI.
[] call zen_favorites_main_fnc_registersettings;

[ZEN_FAVORITES_LOG_LEVEL_INFO, "preInit ran"] call zen_favorites_main_fnc_log;
