#include "..\script_component.hpp"

// Apply a faction persistence setting change without clearing live or saved favorites.
params [
    ["_storeVariable", ""],
    ["_enabled", false],
    ["_label", "faction favorites"]
];

if (_storeVariable == "") exitWith {};

private _currentStore = missionNamespace getVariable [_storeVariable, createHashMap];

if !(_currentStore isEqualType createHashMap) then {
    _currentStore = createHashMap;
};

private _currentEntries = [_currentStore] call zen_favorites_main_fnc_favoritehashmaptoarray;
private _profileStore = [profileNamespace getVariable [_storeVariable, []]] call zen_favorites_main_fnc_favoritehashmapfromarray;
private _profileEntries = [_profileStore] call zen_favorites_main_fnc_favoritehashmaptoarray;

if (_enabled) then {
    if (_currentEntries isNotEqualTo []) then {
        profileNamespace setVariable [_storeVariable, _currentEntries];
        saveProfileNamespace;

        [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
            "enabled persistence and saved current %1 count=%2",
            _label,
            count _currentEntries
        ]] call zen_favorites_main_fnc_log;
    } else {
        missionNamespace setVariable [_storeVariable, _profileStore];

        [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
            "enabled persistence and loaded saved %1 count=%2",
            _label,
            count _profileEntries
        ]] call zen_favorites_main_fnc_log;
    };
} else {
    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "disabled persistence for %1; live and saved favorites kept currentCount=%2 savedCount=%3",
        _label,
        count _currentEntries,
        count _profileEntries
    ]] call zen_favorites_main_fnc_log;
};

private _display = findDisplay 312;

if (isNull _display) exitWith {};

{
    private _tree = _display displayCtrl _x;

    if (!isNull _tree) then {
        _tree setVariable ["zen_favorites_main_lastFavoriteOrderSignature", ""];
        _tree setVariable ["zen_favorites_main_lastFactionRenderSignature", ""];
        _tree setVariable ["zen_favorites_main_lastFactionLeafRenderSignature", ""];
        _tree setVariable ["zen_favorites_main_factionLeafFavoritesSignature", ""];
    };
} forEach [
    ZEN_FAVORITES_IDC_CREATE_UNITS_WEST,
    ZEN_FAVORITES_IDC_CREATE_UNITS_EAST,
    ZEN_FAVORITES_IDC_CREATE_UNITS_GUER,
    ZEN_FAVORITES_IDC_CREATE_UNITS_CIV,
    ZEN_FAVORITES_IDC_CREATE_GROUPS_WEST,
    ZEN_FAVORITES_IDC_CREATE_GROUPS_EAST,
    ZEN_FAVORITES_IDC_CREATE_GROUPS_GUER
];

[_display, true] call zen_favorites_main_fnc_applyfactionfavoriteorder;
[_display] call zen_favorites_main_fnc_rendercreatetreefavorites;
