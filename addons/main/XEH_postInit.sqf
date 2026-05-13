#include "script_component.hpp"

[ZEN_FILTER_LOG_LEVEL_INFO, "postInit ran"] call zen_filter_main_fnc_log;

private _legacyEmptyFavorites = profileNamespace getVariable ["zen_filter_main_emptyFavorites", []];
private _emptyUnitFavorites = profileNamespace getVariable ["zen_filter_main_emptyFavorites_units", _legacyEmptyFavorites];
private _emptyGroupFavorites = profileNamespace getVariable ["zen_filter_main_emptyFavorites_groups", []];

missionNamespace setVariable ["zen_filter_main_emptyFavorites_units", _emptyUnitFavorites];
missionNamespace setVariable ["zen_filter_main_emptyFavorites_groups", _emptyGroupFavorites];

[ZEN_FILTER_LOG_LEVEL_INFO, format [
    "loaded Empty favorites from profile units=%1 groups=%2",
    count _emptyUnitFavorites,
    count _emptyGroupFavorites
]] call zen_filter_main_fnc_log;

["ModuleCurator_F", "Init", {
    params ["_logic"];

    _logic addEventHandler ["CuratorObjectPlaced", {
        if !(missionNamespace getVariable ["zen_filter_main_emptyFavoritePreviewActive", false]) exitWith {};

        [{
            [] call zen_placement_fnc_setupPreview;
            missionNamespace setVariable ["zen_filter_main_emptyFavoritePreviewActive", false];

            [ZEN_FILTER_LOG_LEVEL_INFO, "cleared Empty favorite placement preview after object placement"] call zen_filter_main_fnc_log;
        }, []] call CBA_fnc_execNextFrame;
    }];
}, true, [], true] call CBA_fnc_addClassEventHandler;

[{
    private _display = findDisplay 312;
    private _buttonExists = !isNull _display && {{ctrlIDC _x == ZEN_FILTER_BUTTON_IDC} count allControls _display > 0};

    if (isNull _display) exitWith {};

    if (!_buttonExists) then {
        [_display] call zen_filter_main_fnc_onzeusdisplayopened;
    };

    [_display] call zen_filter_main_fnc_renderfactionstars;
}, 0.2] call CBA_fnc_addPerFrameHandler;
