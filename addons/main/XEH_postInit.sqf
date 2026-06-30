#include "script_component.hpp"

// Load profile-backed favorites and start the lightweight Zeus display render loop.
[ZEN_FAVORITES_LOG_LEVEL_INFO, "postInit ran"] call zen_favorites_main_fnc_log;

private _persistUnits = missionNamespace getVariable ["zen_favorites_main_persistUnitFavorites", true];
private _persistGroups = missionNamespace getVariable ["zen_favorites_main_persistGroupFavorites", true];
private _persistModules = missionNamespace getVariable ["zen_favorites_main_persistModuleFavorites", true];
private _persistEmpty = missionNamespace getVariable ["zen_favorites_main_persistEmptyFavorites", true];
private _rawEmptyUnitFavorites = profileNamespace getVariable ["zen_favorites_main_emptyFavorites_units", []];
private _rawEmptyGroupFavorites = profileNamespace getVariable ["zen_favorites_main_emptyFavorites_groups", []];
private _rawModuleFavorites = profileNamespace getVariable ["zen_favorites_main_moduleFavorites", []];
private _emptyUnitFavorites = [[], _rawEmptyUnitFavorites] select _persistEmpty;
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
private _profileChanged = false;

if (!_persistEmpty) then {
    _emptyGroupFavorites = [];

    if (_rawEmptyUnitFavorites isNotEqualTo [] || {_rawEmptyGroupFavorites isNotEqualTo []}) then {
        profileNamespace setVariable ["zen_favorites_main_emptyFavorites_units", []];
        profileNamespace setVariable ["zen_favorites_main_emptyFavorites_groups", []];
        _profileChanged = true;
    };
};

if (!_persistModules) then {
    _moduleFavorites = [];

    if (_rawModuleFavorites isNotEqualTo []) then {
        profileNamespace setVariable ["zen_favorites_main_moduleFavorites", []];
        _profileChanged = true;
    };
};

private _loadFactionStore = {
    params ["_storeVariable"];

    private _rawEntries = profileNamespace getVariable [_storeVariable, []];
    private _profileStore = [_rawEntries] call zen_favorites_main_fnc_favoritehashmapfromarray;
    private _currentStore = createHashMap;
    private _removedSavedCategory = false;

    {
        private _key = _x;
        private _loadEntry = (
            (_persistUnits && {(_key find "units:") == 0}) ||
            (_persistGroups && {(_key find "groups:") == 0})
        );

        if (_loadEntry) then {
            _currentStore set [_key, +(_profileStore get _key)];
        } else {
            _profileStore deleteAt _key;
            _removedSavedCategory = true;
        };
    } forEach (keys _profileStore);

    private _filteredEntries = [_profileStore] call zen_favorites_main_fnc_favoritehashmaptoarray;

    if (_removedSavedCategory || {(count _rawEntries) != (count _filteredEntries)}) then {
        profileNamespace setVariable [_storeVariable, _filteredEntries];
        _profileChanged = true;
    };

    _currentStore
};

private _factionFavorites = ["zen_favorites_main_factionFavorites"] call _loadFactionStore;
private _factionLeafFavorites = ["zen_favorites_main_factionLeafFavorites"] call _loadFactionStore;

missionNamespace setVariable ["zen_favorites_main_emptyFavorites_units", _emptyUnitFavorites];
missionNamespace setVariable ["zen_favorites_main_emptyFavorites_groups", _emptyGroupFavorites];
missionNamespace setVariable ["zen_favorites_main_moduleFavorites", _moduleFavorites];
missionNamespace setVariable ["zen_favorites_main_factionFavorites", _factionFavorites];
missionNamespace setVariable ["zen_favorites_main_factionLeafFavorites", _factionLeafFavorites];
zen_favorites_main_favoritesInitialized = true;

if (_persistEmpty && {(count _emptyGroupFavorites) != (count _rawEmptyGroupFavorites)}) then {
    profileNamespace setVariable ["zen_favorites_main_emptyFavorites_groups", _emptyGroupFavorites];
    _profileChanged = true;

    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "normalized Empty Groups favorites removedLegacy=%1 kept=%2",
        (count _rawEmptyGroupFavorites) - (count _emptyGroupFavorites),
        count _emptyGroupFavorites
    ]] call zen_favorites_main_fnc_log;
};

if (_persistModules && {(count _moduleFavorites) != (count _rawModuleFavorites)}) then {
    profileNamespace setVariable ["zen_favorites_main_moduleFavorites", _moduleFavorites];
    _profileChanged = true;

    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "normalized Module favorites removedInvalid=%1 kept=%2",
        (count _rawModuleFavorites) - (count _moduleFavorites),
        count _moduleFavorites
    ]] call zen_favorites_main_fnc_log;
};

if (_profileChanged) then {
    saveProfileNamespace;
};

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "loaded favorites from profile emptyUnits=%1 emptyGroups=%2 modules=%3 persistUnits=%4 persistGroups=%5 persistModules=%6 persistEmpty=%7",
    count _emptyUnitFavorites,
    count _emptyGroupFavorites,
    count _moduleFavorites,
    _persistUnits,
    _persistGroups,
    _persistModules,
    _persistEmpty
]] call zen_favorites_main_fnc_log;

zen_favorites_main_clearEmptyFavorites = false;
zen_favorites_main_clearEmptyGroupFavorites = false;
zen_favorites_main_clearFactionFavorites = false;
zen_favorites_main_clearFactionLeafFavorites = false;
zen_favorites_main_clearModuleFavorites = false;
["zen_favorites_main_clearEmptyFavorites", false, nil, "client"] call CBA_settings_fnc_set;
["zen_favorites_main_clearEmptyFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
["zen_favorites_main_clearEmptyFavorites", false, nil, "server"] call CBA_settings_fnc_set;
["zen_favorites_main_clearEmptyGroupFavorites", false, nil, "client"] call CBA_settings_fnc_set;
["zen_favorites_main_clearEmptyGroupFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
["zen_favorites_main_clearEmptyGroupFavorites", false, nil, "server"] call CBA_settings_fnc_set;
["zen_favorites_main_clearFactionFavorites", false, nil, "client"] call CBA_settings_fnc_set;
["zen_favorites_main_clearFactionFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
["zen_favorites_main_clearFactionFavorites", false, nil, "server"] call CBA_settings_fnc_set;
["zen_favorites_main_clearFactionLeafFavorites", false, nil, "client"] call CBA_settings_fnc_set;
["zen_favorites_main_clearFactionLeafFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
["zen_favorites_main_clearFactionLeafFavorites", false, nil, "server"] call CBA_settings_fnc_set;
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

    if (missionNamespace getVariable ["zen_favorites_main_clearFactionFavorites", false]) then {
        [] call zen_favorites_main_fnc_clearfactionfavorites;

        zen_favorites_main_clearFactionFavorites = false;
        ["zen_favorites_main_clearFactionFavorites", false, nil, "client"] call CBA_settings_fnc_set;
        ["zen_favorites_main_clearFactionFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
        ["zen_favorites_main_clearFactionFavorites", false, nil, "server"] call CBA_settings_fnc_set;
    };

    if (missionNamespace getVariable ["zen_favorites_main_clearFactionLeafFavorites", false]) then {
        [] call zen_favorites_main_fnc_clearfactionleaffavorites;

        zen_favorites_main_clearFactionLeafFavorites = false;
        ["zen_favorites_main_clearFactionLeafFavorites", false, nil, "client"] call CBA_settings_fnc_set;
        ["zen_favorites_main_clearFactionLeafFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
        ["zen_favorites_main_clearFactionLeafFavorites", false, nil, "server"] call CBA_settings_fnc_set;
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
