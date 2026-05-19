#include "script_component.hpp"

[ZEN_FAVORITES_LOG_LEVEL_INFO, "postInit ran"] call zen_favorites_main_fnc_log;

private _emptyUnitFavorites = profileNamespace getVariable ["zen_favorites_main_emptyFavorites_units", []];
private _rawEmptyGroupFavorites = profileNamespace getVariable ["zen_favorites_main_emptyFavorites_groups", []];
private _emptyGroupFavorites = _rawEmptyGroupFavorites select {
    (_x isEqualType []) &&
    {count _x >= 6} &&
    {(_x select 0) isEqualType []} &&
    {(_x select 2) isEqualType ""} &&
    {(_x select 2) == str (_x select 0)}
};

missionNamespace setVariable ["zen_favorites_main_emptyFavorites_units", _emptyUnitFavorites];
missionNamespace setVariable ["zen_favorites_main_emptyFavorites_groups", _emptyGroupFavorites];

if ((count _emptyGroupFavorites) != (count _rawEmptyGroupFavorites)) then {
    profileNamespace setVariable ["zen_favorites_main_emptyFavorites_groups", _emptyGroupFavorites];
    saveProfileNamespace;

    [ZEN_FAVORITES_LOG_LEVEL_INFO, format [
        "normalized Empty Groups favorites removedLegacy=%1 kept=%2",
        (count _rawEmptyGroupFavorites) - (count _emptyGroupFavorites),
        count _emptyGroupFavorites
    ]] call zen_favorites_main_fnc_log;
};

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "loaded Empty favorites from profile units=%1 groups=%2",
    count _emptyUnitFavorites,
    count _emptyGroupFavorites
]] call zen_favorites_main_fnc_log;

zen_favorites_main_clearEmptyFavorites = false;
["zen_favorites_main_clearEmptyFavorites", false, nil, "client"] call CBA_settings_fnc_set;
["zen_favorites_main_clearEmptyFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
["zen_favorites_main_clearEmptyFavorites", false, nil, "server"] call CBA_settings_fnc_set;

["ModuleCurator_F", "Init", {
    params ["_logic"];

    _logic addEventHandler ["CuratorObjectPlaced", {
        params ["", "_object"];

        if !(missionNamespace getVariable ["zen_favorites_main_emptyFavoritePreviewActive", false]) exitWith {};

        private _expectedType = missionNamespace getVariable ["zen_favorites_main_emptyFavoritePreviewType", ""];

        [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
            "favorite preview placement event placedType=%1 expectedType=%2 active=%3",
            typeOf _object,
            _expectedType,
            missionNamespace getVariable ["zen_favorites_main_emptyFavoritePreviewActive", false]
        ]] call zen_favorites_main_fnc_log;

        if (_expectedType == "" || {typeOf _object != _expectedType}) exitWith {
            [false, "ignored non-favorite placement"] call zen_favorites_main_fnc_clearemptyfavoritepreview;

            [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
                "ignored non-favorite placement while favorite preview state was active placedType=%1 expectedType=%2",
                typeOf _object,
                _expectedType
            ]] call zen_favorites_main_fnc_log;
        };

        private _helperNull = true;

        if !(isNil "zen_placement_helper") then {
            _helperNull = isNull zen_placement_helper;
        };

        private _helperPosition = if (!_helperNull) then {getPosASL zen_placement_helper} else {getPosASL _object};
        private _helperDirAndUp = if (!_helperNull) then {
            [vectorDir zen_placement_helper, vectorUp zen_placement_helper]
        } else {
            [vectorDir _object, vectorUp _object]
        };

        [{
            params ["_object", "_helperPosition", "_helperDirAndUp"];

            if (!isNull _object) then {
                _object setPosASL _helperPosition;
                _object setVectorDirAndUp _helperDirAndUp;
                _object setVelocity [0, 0, 0];
            };

            [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
                "applied Empty favorite placement transform placedType=%1 placedDir=%2",
                typeOf _object,
                getDir _object
            ]] call zen_favorites_main_fnc_log;

            [{
                [true, "object placed"] call zen_favorites_main_fnc_clearemptyfavoritepreview;

                [ZEN_FAVORITES_LOG_LEVEL_DEBUG, "cleared Empty favorite placement preview after object placement"] call zen_favorites_main_fnc_log;
            }, []] call CBA_fnc_execNextFrame;
        }, [_object, _helperPosition, _helperDirAndUp]] call CBA_fnc_execNextFrame;
    }];
}, true, [], true] call CBA_fnc_addClassEventHandler;

[{
    private _display = findDisplay 312;

    if (missionNamespace getVariable ["zen_favorites_main_clearEmptyFavorites", false]) then {
        [] call zen_favorites_main_fnc_clearemptyfavorites;

        zen_favorites_main_clearEmptyFavorites = false;
        ["zen_favorites_main_clearEmptyFavorites", false, nil, "client"] call CBA_settings_fnc_set;
        ["zen_favorites_main_clearEmptyFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
        ["zen_favorites_main_clearEmptyFavorites", false, nil, "server"] call CBA_settings_fnc_set;
    };

    if (isNull _display) exitWith {};

    if !(_display getVariable ["zen_favorites_main_displayOpenedHandled", false]) then {
        _display setVariable ["zen_favorites_main_displayOpenedHandled", true];
        [_display] call zen_favorites_main_fnc_onzeusdisplayopened;
    };

    [_display] call zen_favorites_main_fnc_renderfactionstars;
}, 0.2] call CBA_fnc_addPerFrameHandler;
