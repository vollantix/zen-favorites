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
    ["Log level", "Controls how much ZEN Favorites writes to the Arma RPT log. Error is recommended for normal play; use Info, Debug, or Trace only while troubleshooting."],
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
    ["Unit favorites layout", "Choose whether generated Unit Favorites use compact category branches or flat, fully qualified rows. Applies to faction and Empty Units tabs. Grouped is the default."],
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
    ["Group favorites layout", "Choose whether generated Group Favorites are grouped into faction-specific sections or shown as flat, fully qualified rows. Also controls grouped or flat presentation in Empty Groups. Grouped is the default."],
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
    ["Module favorites layout", "Choose whether generated Module Favorites follow their original category branches or use flat, fully qualified rows. Flat is the default because Arma can show a one-time CfgVehicles popup when a generated Grouped category is first selected."],
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
    ["Favorite star side", "Choose where favorite stars appear in the Zeus Create tree. Left avoids the scrollbar; Right restores the original right-edge layout."],
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
    "zen_favorites_main_persistFactionRootFavorites",
    "CHECKBOX",
    ["Save faction favorites", "When enabled, current top-level faction favorites are saved immediately and then loaded from your Arma profile when the addon starts. Default is off. Turning this off keeps live and saved favorites, but stops loading and saving them."],
    ["ZEN Favorites", "Persistence"],
    false,
    0,
    {
        params ["_value"];

        ["zen_favorites_main_factionFavorites", _value, "top-level faction favorites"] call zen_favorites_main_fnc_syncfactionfavoritepersistence;
    }
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_persistFactionLeafFavorites",
    "CHECKBOX",
    ["Save faction unit/group favorites", "When enabled, current faction unit and group favorites are saved immediately and then loaded from your Arma profile when the addon starts. Default is off. Turning this off keeps live and saved favorites, but stops loading and saving them."],
    ["ZEN Favorites", "Persistence"],
    false,
    0,
    {
        params ["_value"];

        ["zen_favorites_main_factionLeafFavorites", _value, "faction unit/group favorites"] call zen_favorites_main_fnc_syncfactionfavoritepersistence;
    }
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_clearEmptyGroupFavorites",
    "CHECKBOX",
    ["Clear Empty Group favorites", "Turn this on to permanently clear only the Empty Groups favorites saved in this Arma profile. The checkbox resets itself after clearing."],
    ["ZEN Favorites", "Maintenance"],
    false,
    0
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_clearFactionFavorites",
    "CHECKBOX",
    ["Clear faction favorites", "Turn this on to permanently clear top-level faction favorites from this session and this Arma profile. The checkbox resets itself after clearing."],
    ["ZEN Favorites", "Maintenance"],
    false,
    0
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_clearFactionLeafFavorites",
    "CHECKBOX",
    ["Clear faction unit/group favorites", "Turn this on to permanently clear faction unit and group favorites from this session and this Arma profile. The checkbox resets itself after clearing."],
    ["ZEN Favorites", "Maintenance"],
    false,
    0
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_clearModuleFavorites",
    "CHECKBOX",
    ["Clear Module favorites", "Turn this on to permanently clear only the Module favorites saved in this Arma profile. The checkbox resets itself after clearing."],
    ["ZEN Favorites", "Maintenance"],
    false,
    0
] call CBA_fnc_addSetting;

[
    "zen_favorites_main_clearEmptyFavorites",
    "CHECKBOX",
    ["Clear Empty Unit favorites", "Turn this on to permanently clear only the Empty Units favorites saved in this Arma profile. The checkbox resets itself after clearing."],
    ["ZEN Favorites", "Maintenance"],
    false,
    0
] call CBA_fnc_addSetting;
