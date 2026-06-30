#include "..\script_component.hpp"

// Register user-facing CBA settings for debugging and maintenance actions.
private _refreshOpenZeusTree = {
    private _display = findDisplay ZEN_FAVORITES_IDD_ZEUS_DISPLAY;

    if (!isNull _display) then {
        private _activeTree = [_display] call zen_favorites_main_fnc_getactivecreatetree;
        _activeTree params ["_tree"];

        if (!isNull _tree) then {
            _tree setVariable ["zen_favorites_main_emptyFavoritesSignature", ""];
            _tree setVariable ["zen_favorites_main_factionLeafFavoritesSignature", ""];
            _tree setVariable ["zen_favorites_main_moduleFavoritesSignature", ""];
            _tree setVariable ["zen_favorites_main_lastEmptyRenderSignature", ""];
            _tree setVariable ["zen_favorites_main_lastEmptyGroupsRenderSignature", ""];
            _tree setVariable ["zen_favorites_main_lastFactionLeafRenderSignature", ""];
            _tree setVariable ["zen_favorites_main_lastModuleRenderSignature", ""];

            [_display] call zen_favorites_main_fnc_rendercreatetreefavorites;
        };
    };
};

[
    "zen_favorites_main_logLevel",
    "LIST",
    ["Log level", "Choose how much information ZEN Favorites writes to Arma's log file. Keep this on Error for normal play. Use a more detailed level only when troubleshooting."],
    ["ZEN Favorites", "Debugging"],
    [
        [
            ZEN_FAVORITES_LOG_LEVEL_ERROR,
            ZEN_FAVORITES_LOG_LEVEL_WARN,
            ZEN_FAVORITES_LOG_LEVEL_INFO,
            ZEN_FAVORITES_LOG_LEVEL_DEBUG,
            ZEN_FAVORITES_LOG_LEVEL_TRACE
        ],
        [
            "Error",
            "Warning",
            "Info",
            "Debug",
            "Trace"
        ],
        ZEN_FAVORITES_LOG_LEVEL_ERROR
    ],
    0
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_unitFavoritesLayout",
    "LIST",
    ["Unit favorites layout", "Grouped keeps Unit favorites in category folders. Flat shows them in one list. This applies to faction Units and Empty Units. Default: Grouped."],
    ["ZEN Favorites", "Interface"],
    [
        [
            ZEN_FAVORITES_LAYOUT_GROUPED,
            ZEN_FAVORITES_LAYOUT_FLAT
        ],
        [
            "Grouped",
            "Flat"
        ],
        ZEN_FAVORITES_LAYOUT_GROUPED
    ],
    0,
    _refreshOpenZeusTree
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_groupFavoritesLayout",
    "LIST",
    ["Group favorites layout", "Grouped keeps Group favorites under faction and category folders. Flat shows them in one list. This also applies to Empty Groups. Default: Grouped."],
    ["ZEN Favorites", "Interface"],
    [
        [
            ZEN_FAVORITES_LAYOUT_GROUPED,
            ZEN_FAVORITES_LAYOUT_FLAT
        ],
        [
            "Grouped",
            "Flat"
        ],
        ZEN_FAVORITES_LAYOUT_GROUPED
    ],
    0,
    _refreshOpenZeusTree
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_moduleFavoritesLayout",
    "LIST",
    ["Module favorites layout", "Grouped keeps the original module categories. Flat shows all Module favorites in one list and avoids a possible one-time Arma warning when opening a Grouped category. Default: Flat."],
    ["ZEN Favorites", "Interface"],
    [
        [
            ZEN_FAVORITES_LAYOUT_GROUPED,
            ZEN_FAVORITES_LAYOUT_FLAT
        ],
        [
            "Grouped",
            "Flat"
        ],
        ZEN_FAVORITES_LAYOUT_FLAT
    ],
    0,
    _refreshOpenZeusTree
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_starAlignment",
    "LIST",
    ["Favorite star side", "Choose which side of each Zeus Create row shows the favorite star. Left is recommended because it stays clear of the scrollbar. Default: Left."],
    ["ZEN Favorites", "Interface"],
    [
        [
            ZEN_FAVORITES_STAR_ALIGNMENT_LEFT,
            ZEN_FAVORITES_STAR_ALIGNMENT_RIGHT
        ],
        [
            "Left",
            "Right"
        ],
        ZEN_FAVORITES_STAR_ALIGNMENT_LEFT
    ],
    0,
    {
        private _display = findDisplay ZEN_FAVORITES_IDD_ZEUS_DISPLAY;

        if (!isNull _display) then {
            private _activeTree = [_display] call zen_favorites_main_fnc_getactivecreatetree;
            _activeTree params ["_tree"];

            if (!isNull _tree) then {
                _tree setVariable ["zen_favorites_main_starRows", createHashMap];
                _tree setVariable ["zen_favorites_main_starRowColors", createHashMap];
                _tree setVariable ["zen_favorites_main_lastFactionRenderSignature", ""];
                _tree setVariable ["zen_favorites_main_lastFactionLeafRenderSignature", ""];
                _tree setVariable ["zen_favorites_main_lastEmptyRenderSignature", ""];
                _tree setVariable ["zen_favorites_main_lastEmptyGroupsRenderSignature", ""];
                _tree setVariable ["zen_favorites_main_lastModuleRenderSignature", ""];

                [_display] call zen_favorites_main_fnc_rendercreatetreefavorites;
            };
        };
    }
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_persistUnitFavorites",
    "CHECKBOX",
    ["Save Unit favorites", "On: save Unit factions and favorites for future missions. Off: delete the saved copy but keep current favorites for this mission. Default: On."],
    ["ZEN Favorites", "Persistence"],
    true,
    0,
    {
        params ["_value"];

        ["units", _value] call zen_favorites_main_fnc_syncfavoritepersistence;
    }
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_persistGroupFavorites",
    "CHECKBOX",
    ["Save Group favorites", "On: save Group factions and favorites for future missions. Off: delete the saved copy but keep current favorites for this mission. Default: On."],
    ["ZEN Favorites", "Persistence"],
    true,
    0,
    {
        params ["_value"];

        ["groups", _value] call zen_favorites_main_fnc_syncfavoritepersistence;
    }
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_persistModuleFavorites",
    "CHECKBOX",
    ["Save Module favorites", "On: save Module favorites for future missions. Off: delete the saved copy but keep current favorites for this mission. Default: On."],
    ["ZEN Favorites", "Persistence"],
    true,
    0,
    {
        params ["_value"];

        ["modules", _value] call zen_favorites_main_fnc_syncfavoritepersistence;
    }
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_persistEmptyFavorites",
    "CHECKBOX",
    ["Save Empty favorites", "On: save favorites from both Empty Units and Empty Groups for future missions. Off: delete the saved copies but keep current favorites for this mission. Default: On."],
    ["ZEN Favorites", "Persistence"],
    true,
    0,
    {
        params ["_value"];

        ["empty", _value] call zen_favorites_main_fnc_syncfavoritepersistence;
    }
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_clearEmptyGroupFavorites",
    "CHECKBOX",
    ["Clear Empty Group favorites", "Clear all Empty Group favorites now, including the saved copy. This switch turns itself off after clearing."],
    ["ZEN Favorites", "Maintenance"],
    false,
    0
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_clearFactionFavorites",
    "CHECKBOX",
    ["Clear faction favorites", "Clear favorited faction rows from both Units and Groups, including saved copies. Individual unit and group favorites are not cleared. This switch turns itself off after clearing."],
    ["ZEN Favorites", "Maintenance"],
    false,
    0
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_clearFactionLeafFavorites",
    "CHECKBOX",
    ["Clear faction unit/group favorites", "Clear all individual faction Unit and Group favorites, including saved copies. Favorited faction rows are not cleared. This switch turns itself off after clearing."],
    ["ZEN Favorites", "Maintenance"],
    false,
    0
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_clearModuleFavorites",
    "CHECKBOX",
    ["Clear Module favorites", "Clear all Module favorites now, including the saved copy. This switch turns itself off after clearing."],
    ["ZEN Favorites", "Maintenance"],
    false,
    0
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_clearEmptyFavorites",
    "CHECKBOX",
    ["Clear Empty Unit favorites", "Clear all Empty Unit favorites now, including the saved copy. This switch turns itself off after clearing."],
    ["ZEN Favorites", "Maintenance"],
    false,
    0
] call CBA_fnc_addSetting;
