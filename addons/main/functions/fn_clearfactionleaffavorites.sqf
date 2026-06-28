#include "..\script_component.hpp"

// Clear faction unit/group leaf favorites from the live session and profile.
profileNamespace setVariable ["zen_favorites_main_factionLeafFavorites", []];
saveProfileNamespace;

missionNamespace setVariable ["zen_favorites_main_factionLeafFavorites", createHashMap];

private _display = findDisplay 312;

if (!isNull _display) then {
    {
        private _tree = _display displayCtrl _x;

        if (!isNull _tree) then {
            private _rootPaths = [[]];

            if (_x in [
                ZEN_FAVORITES_IDC_CREATE_GROUPS_WEST,
                ZEN_FAVORITES_IDC_CREATE_GROUPS_EAST,
                ZEN_FAVORITES_IDC_CREATE_GROUPS_GUER
            ]) then {
                _rootPaths = [[0]];
            };

            {
                private _parentPath = _x;

                for "_index" from ((_tree tvCount _parentPath) - 1) to 0 step -1 do {
                    private _path = +_parentPath;
                    _path pushBack _index;

                    if ([_tree tvText _path] call zen_favorites_main_fnc_isfavoritepath) then {
                        _tree tvDelete _path;
                    };
                };
            } forEach _rootPaths;

            _tree setVariable ["zen_favorites_main_lastFactionLeafRenderSignature", ""];
            _tree setVariable ["zen_favorites_main_factionLeafFavoritesSignature", ""];
            _tree setVariable ["zen_favorites_main_factionLeafFavoriteBranchTextPaths", []];
            _tree setVariable ["zen_favorites_main_factionLeafFavoriteSourcePaths", createHashMap];
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

    [_display] call zen_favorites_main_fnc_rendercreatetreefavorites;
};

["ZEN Favorites: Faction unit/group favorites cleared"] call zen_favorites_main_fnc_showactionhint;

[ZEN_FAVORITES_LOG_LEVEL_INFO, "cleared faction unit/group favorites from profile"] call zen_favorites_main_fnc_log;
