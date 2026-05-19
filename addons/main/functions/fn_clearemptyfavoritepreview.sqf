#include "..\script_component.hpp"

params [
    ["_clearZenPreview", false],
    ["_reason", ""]
];

if (_clearZenPreview) then {
    [] call zen_placement_fnc_setupPreview;
};

missionNamespace setVariable ["zen_filter_main_emptyFavoritePreviewActive", false];
missionNamespace setVariable ["zen_filter_main_emptyFavoritePreviewType", ""];

if (_reason != "") then {
    [ZEN_FILTER_LOG_LEVEL_DEBUG, format [
        "cleared Empty favorite preview state clearZenPreview=%1 reason=%2",
        _clearZenPreview,
        _reason
    ]] call zen_filter_main_fnc_log;
};
