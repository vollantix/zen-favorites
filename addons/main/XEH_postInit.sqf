#include "script_component.hpp"

[ZEN_FAVORITES_LOG_LEVEL_INFO, "postInit ran"] call zen_favorites_main_fnc_log;

private _emptyUnitFavorites = profileNamespace getVariable ["zen_favorites_main_emptyFavorites_units", []];
private _rawEmptyGroupFavorites = profileNamespace getVariable ["zen_favorites_main_emptyFavorites_groups", []];
private _rawModuleFavorites = profileNamespace getVariable ["zen_favorites_main_moduleFavorites", []];
private _emptyGroupFavorites = _rawEmptyGroupFavorites select {
    (_x isEqualType []) &&
    {count _x >= 6} &&
    {(_x select 0) isEqualType []} &&
    {(_x select 2) isEqualType ""} &&
    {(_x select 2) == str (_x select 0)}
};
private _moduleFavorites = _rawModuleFavorites select {
    (_x isEqualType []) &&
    {count _x >= 6} &&
    {(_x select 0) isEqualType []} &&
    {(_x select 2) isEqualType ""}
};

missionNamespace setVariable ["zen_favorites_main_emptyFavorites_units", _emptyUnitFavorites];
missionNamespace setVariable ["zen_favorites_main_emptyFavorites_groups", _emptyGroupFavorites];
missionNamespace setVariable ["zen_favorites_main_moduleFavorites", _moduleFavorites];

if ((count _emptyGroupFavorites) != (count _rawEmptyGroupFavorites)) then {
    profileNamespace setVariable ["zen_favorites_main_emptyFavorites_groups", _emptyGroupFavorites];
    saveProfileNamespace;

    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "normalized Empty Groups favorites removedLegacy=%1 kept=%2",
        (count _rawEmptyGroupFavorites) - (count _emptyGroupFavorites),
        count _emptyGroupFavorites
    ]] call zen_favorites_main_fnc_log;
};

if ((count _moduleFavorites) != (count _rawModuleFavorites)) then {
    profileNamespace setVariable ["zen_favorites_main_moduleFavorites", _moduleFavorites];
    saveProfileNamespace;

    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "normalized Module favorites removedInvalid=%1 kept=%2",
        (count _rawModuleFavorites) - (count _moduleFavorites),
        count _moduleFavorites
    ]] call zen_favorites_main_fnc_log;
};

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "loaded favorites from profile emptyUnits=%1 emptyGroups=%2 modules=%3",
    count _emptyUnitFavorites,
    count _emptyGroupFavorites,
    count _moduleFavorites
]] call zen_favorites_main_fnc_log;

zen_favorites_main_clearEmptyFavorites = false;
zen_favorites_main_clearEmptyGroupFavorites = false;
zen_favorites_main_clearModuleFavorites = false;
["zen_favorites_main_clearEmptyFavorites", false, nil, "client"] call CBA_settings_fnc_set;
["zen_favorites_main_clearEmptyFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
["zen_favorites_main_clearEmptyFavorites", false, nil, "server"] call CBA_settings_fnc_set;
["zen_favorites_main_clearEmptyGroupFavorites", false, nil, "client"] call CBA_settings_fnc_set;
["zen_favorites_main_clearEmptyGroupFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
["zen_favorites_main_clearEmptyGroupFavorites", false, nil, "server"] call CBA_settings_fnc_set;
["zen_favorites_main_clearModuleFavorites", false, nil, "client"] call CBA_settings_fnc_set;
["zen_favorites_main_clearModuleFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
["zen_favorites_main_clearModuleFavorites", false, nil, "server"] call CBA_settings_fnc_set;

[{
    private _display = findDisplay 312;

    if (missionNamespace getVariable ["zen_favorites_main_clearEmptyFavorites", false]) then {
        [] call zen_favorites_main_fnc_clearemptyfavorites;

        zen_favorites_main_clearEmptyFavorites = false;
        ["zen_favorites_main_clearEmptyFavorites", false, nil, "client"] call CBA_settings_fnc_set;
        ["zen_favorites_main_clearEmptyFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
        ["zen_favorites_main_clearEmptyFavorites", false, nil, "server"] call CBA_settings_fnc_set;
    };

    if (missionNamespace getVariable ["zen_favorites_main_clearEmptyGroupFavorites", false]) then {
        [] call zen_favorites_main_fnc_clearemptygroupfavorites;

        zen_favorites_main_clearEmptyGroupFavorites = false;
        ["zen_favorites_main_clearEmptyGroupFavorites", false, nil, "client"] call CBA_settings_fnc_set;
        ["zen_favorites_main_clearEmptyGroupFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
        ["zen_favorites_main_clearEmptyGroupFavorites", false, nil, "server"] call CBA_settings_fnc_set;
    };

    if (missionNamespace getVariable ["zen_favorites_main_clearModuleFavorites", false]) then {
        [] call zen_favorites_main_fnc_clearmodulefavorites;

        zen_favorites_main_clearModuleFavorites = false;
        ["zen_favorites_main_clearModuleFavorites", false, nil, "client"] call CBA_settings_fnc_set;
        ["zen_favorites_main_clearModuleFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
        ["zen_favorites_main_clearModuleFavorites", false, nil, "server"] call CBA_settings_fnc_set;
    };

    if (isNull _display) exitWith {};

    if !(_display getVariable ["zen_favorites_main_displayOpenedHandled", false]) then {
        _display setVariable ["zen_favorites_main_displayOpenedHandled", true];
        [_display] call zen_favorites_main_fnc_onzeusdisplayopened;
    };

    [_display] call zen_favorites_main_fnc_rendercreatetreefavorites;
}, 0.2] call CBA_fnc_addPerFrameHandler;
