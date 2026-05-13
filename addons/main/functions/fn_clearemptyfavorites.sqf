#include "..\script_component.hpp"

profileNamespace setVariable ["zen_filter_main_emptyFavorites_units", []];
saveProfileNamespace;

missionNamespace setVariable ["zen_filter_main_emptyFavorites_units", []];

private _display = findDisplay 312;

if (!isNull _display) then {
    private _activeTree = [_display] call zen_filter_main_fnc_getactivecreatetree;
    _activeTree params ["_tree", "_idc", "_mode", "_side"];

    if (!isNull _tree && {_side == "empty"} && {_mode == "units"}) then {
        for "_index" from ((_tree tvCount []) - 1) to 0 step -1 do {
            if ((_tree tvText [_index]) == "Favorites") then {
                _tree tvDelete [_index];
            };
        };

        _tree setVariable ["zen_filter_main_lastEmptyRenderSignature", ""];
        _tree setVariable ["zen_filter_main_emptyFavoritesSignature", ""];
    };
};

hint "ZEN Filter: Empty Unit favorites cleared";

[ZEN_FILTER_LOG_LEVEL_INFO, "cleared Empty Unit favorites from profile"] call zen_filter_main_fnc_log;
