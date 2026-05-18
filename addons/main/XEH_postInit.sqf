#include "script_component.hpp"

[ZEN_FILTER_LOG_LEVEL_INFO, "postInit ran"] call zen_filter_main_fnc_log;

private _legacyEmptyFavorites = profileNamespace getVariable ["zen_filter_main_emptyFavorites", []];
private _emptyUnitFavorites = profileNamespace getVariable ["zen_filter_main_emptyFavorites_units", _legacyEmptyFavorites];
private _rawEmptyGroupFavorites = profileNamespace getVariable ["zen_filter_main_emptyFavorites_groups", []];
private _emptyGroupFavorites = _rawEmptyGroupFavorites select {
    (_x isEqualType []) &&
    {count _x >= 6} &&
    {(_x select 0) isEqualType []} &&
    {(_x select 2) isEqualType ""} &&
    {(_x select 2) == str (_x select 0)}
};

missionNamespace setVariable ["zen_filter_main_emptyFavorites_units", _emptyUnitFavorites];
missionNamespace setVariable ["zen_filter_main_emptyFavorites_groups", _emptyGroupFavorites];

if ((count _emptyGroupFavorites) != (count _rawEmptyGroupFavorites)) then {
    profileNamespace setVariable ["zen_filter_main_emptyFavorites_groups", _emptyGroupFavorites];
    saveProfileNamespace;

    [ZEN_FILTER_LOG_LEVEL_INFO, format [
        "normalized Empty Groups favorites removedLegacy=%1 kept=%2",
        (count _rawEmptyGroupFavorites) - (count _emptyGroupFavorites),
        count _emptyGroupFavorites
    ]] call zen_filter_main_fnc_log;
};

[ZEN_FILTER_LOG_LEVEL_INFO, format [
    "loaded Empty favorites from profile units=%1 groups=%2",
    count _emptyUnitFavorites,
    count _emptyGroupFavorites
]] call zen_filter_main_fnc_log;

zen_filter_main_clearEmptyFavorites = false;
["zen_filter_main_clearEmptyFavorites", false, nil, "client"] call CBA_settings_fnc_set;
["zen_filter_main_clearEmptyFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
["zen_filter_main_clearEmptyFavorites", false, nil, "server"] call CBA_settings_fnc_set;

["ModuleCurator_F", "Init", {
    params ["_logic"];

    _logic addEventHandler ["CuratorObjectPlaced", {
        params ["", "_object"];

        if !(missionNamespace getVariable ["zen_filter_main_emptyFavoritePreviewActive", false]) exitWith {};

        private _previewType = "<nil>";
        private _typeMatches = false;
        private _helperNull = true;
        private _helperDir = -1;
        private _helperVectorDir = [];
        private _helperVectorUp = [];

        if !(isNil "zen_placement_object") then {
            if !(isNull zen_placement_object) then {
                _previewType = typeOf zen_placement_object;
                _typeMatches = typeOf _object == _previewType;
            };
        };

        if !(isNil "zen_placement_helper") then {
            _helperNull = isNull zen_placement_helper;

            if (!_helperNull) then {
                _helperDir = getDir zen_placement_helper;
                _helperVectorDir = vectorDir zen_placement_helper;
                _helperVectorUp = vectorUp zen_placement_helper;
            };
        };

        [ZEN_FILTER_LOG_LEVEL_INFO, format [
            "Empty favorite object placed pre-cleanup placedType=%1 placedDir=%2 previewType=%3 typeMatches=%4 helperNull=%5 helperDir=%6 helperVectorDir=%7 helperVectorUp=%8 objectVectorDir=%9 objectVectorUp=%10",
            typeOf _object,
            getDir _object,
            _previewType,
            _typeMatches,
            _helperNull,
            _helperDir,
            _helperVectorDir,
            _helperVectorUp,
            vectorDir _object,
            vectorUp _object
        ]] call zen_filter_main_fnc_log;

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

            private _previewType = "<nil>";
            private _helperNull = true;

            if !(isNil "zen_placement_object") then {
                if !(isNull zen_placement_object) then {
                    _previewType = typeOf zen_placement_object;
                };
            };

            if !(isNil "zen_placement_helper") then {
                _helperNull = isNull zen_placement_helper;
            };

            [ZEN_FILTER_LOG_LEVEL_INFO, format [
                "Empty favorite object placed next-frame applied transform placedType=%1 placedDir=%2 placedVectorDir=%3 placedVectorUp=%4 previewType=%5 helperNull=%6",
                typeOf _object,
                getDir _object,
                vectorDir _object,
                vectorUp _object,
                _previewType,
                _helperNull
            ]] call zen_filter_main_fnc_log;

            [{
                [] call zen_placement_fnc_setupPreview;
                missionNamespace setVariable ["zen_filter_main_emptyFavoritePreviewActive", false];

                [ZEN_FILTER_LOG_LEVEL_INFO, "cleared Empty favorite placement preview after object placement"] call zen_filter_main_fnc_log;
            }, []] call CBA_fnc_execNextFrame;
        }, [_object, _helperPosition, _helperDirAndUp]] call CBA_fnc_execNextFrame;
    }];
}, true, [], true] call CBA_fnc_addClassEventHandler;

[{
    private _display = findDisplay 312;

    if (missionNamespace getVariable ["zen_filter_main_clearEmptyFavorites", false]) then {
        [] call zen_filter_main_fnc_clearemptyfavorites;

        zen_filter_main_clearEmptyFavorites = false;
        ["zen_filter_main_clearEmptyFavorites", false, nil, "client"] call CBA_settings_fnc_set;
        ["zen_filter_main_clearEmptyFavorites", false, nil, "mission"] call CBA_settings_fnc_set;
        ["zen_filter_main_clearEmptyFavorites", false, nil, "server"] call CBA_settings_fnc_set;
    };

    if (isNull _display) exitWith {};

    if !(_display getVariable ["zen_filter_main_displayOpenedHandled", false]) then {
        _display setVariable ["zen_filter_main_displayOpenedHandled", true];
        [_display] call zen_filter_main_fnc_onzeusdisplayopened;
    };

    [_display] call zen_filter_main_fnc_renderfactionstars;
}, 0.2] call CBA_fnc_addPerFrameHandler;
