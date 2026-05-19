#include "..\script_component.hpp"

params [
    ["_objectType", ""],
    ["_updateZenPreview", true]
];

if (_objectType == "") exitWith {
    [_updateZenPreview, "set empty object type"] call zen_filter_main_fnc_clearemptyfavoritepreview;
};

if (_updateZenPreview) then {
    [_objectType] call zen_placement_fnc_setupPreview;
};

missionNamespace setVariable ["zen_filter_main_emptyFavoritePreviewActive", true];
missionNamespace setVariable ["zen_filter_main_emptyFavoritePreviewType", _objectType];
