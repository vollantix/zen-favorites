#include "..\script_component.hpp"

// Return the configured generated Favorites layout for a Create tree type.
params [["_mode", "", [""]]];

private _settingName = switch (_mode) do {
    case "units": {"zen_favorites_main_unitFavoritesLayout"};
    case "groups": {"zen_favorites_main_groupFavoritesLayout"};
    case "modules": {"zen_favorites_main_moduleFavoritesLayout"};
    default {""};
};

if (_settingName == "") exitWith {ZEN_FAVORITES_LAYOUT_GROUPED};

private _defaultLayout = parseNumber (_mode == "modules");

missionNamespace getVariable [_settingName, _defaultLayout]
