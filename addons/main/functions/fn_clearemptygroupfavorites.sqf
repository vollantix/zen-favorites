#include "..\script_component.hpp"

profileNamespace setVariable ["zen_favorites_main_emptyFavorites_groups", []];
saveProfileNamespace;

missionNamespace setVariable ["zen_favorites_main_emptyFavorites_groups", []];
missionNamespace setVariable ["zen_favorites_main_emptyGroupsExpandedTextPaths", []];

private _display = findDisplay 312;

if (!isNull _display) then {
    private _activeTree = [_display] call zen_favorites_main_fnc_getactivecreatetree;
    _activeTree params ["_tree", "_idc", "_mode", "_side"];

    if (!isNull _tree && {_side == "empty"} && {_mode == "groups"}) then {
        for "_index" from ((_tree tvCount []) - 1) to 0 step -1 do {
            if ((_tree tvText [_index]) == "Favorites") then {
                _tree tvDelete [_index];
            };
        };

        _tree setVariable ["zen_favorites_main_lastEmptyGroupsRenderSignature", ""];
        _tree setVariable ["zen_favorites_main_emptyFavoritesSignature", ""];
        _tree setVariable ["zen_favorites_main_emptyGroupsFavoriteBranchTextPaths", []];
        _tree setVariable ["zen_favorites_main_emptyGroupsFavoriteSourcePaths", createHashMap];
        _tree setVariable ["zen_favorites_main_emptyGroupsExpandedTextPaths", []];
        _tree setVariable ["zen_favorites_main_emptyGroupsPendingExpandTextPaths", []];
    };
};

["ZEN Favorites: Empty Group favorites cleared"] call zen_favorites_main_fnc_showactionhint;

[ZEN_FAVORITES_LOG_LEVEL_INFO, "cleared Empty Group favorites from profile"] call zen_favorites_main_fnc_log;
