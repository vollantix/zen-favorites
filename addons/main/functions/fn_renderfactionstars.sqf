#include "..\script_component.hpp"

// Compatibility wrapper for the older render entry point name.
params ["_display"];

[_display] call zen_favorites_main_fnc_rendercreatetreefavorites;
