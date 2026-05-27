class CfgPatches {
    class zen_favorites_main {
        name = "ZEN Favorites";
        author = "vollantix";
        requiredVersion = 2.18;
        requiredAddons[] = {
            "cba_main",
            "cba_settings",
            "cba_xeh",
            "zen_main",
            "zen_compositions",
            "zen_placement"
        };
        units[] = {};
        weapons[] = {};
    };
};

class Extended_PreInit_EventHandlers {
    class zen_favorites_main {
        init = "call compile preprocessFileLineNumbers 'z\zen_favorites\addons\main\XEH_preInit.sqf'";
    };
};

class Extended_PostInit_EventHandlers {
    class zen_favorites_main {
        init = "call compile preprocessFileLineNumbers 'z\zen_favorites\addons\main\XEH_postInit.sqf'";
    };
};

class CfgFunctions {
    class zen_favorites_main {
        class main {
            file = "z\zen_favorites\addons\main\functions";

            class applyfactionfavoriteorder {};
            class clearactivefavoriteproxy {};
            class clearemptygroupfavorites {};
            class clearmodulefavorites {};
            class favoritehashmapfromarray {};
            class favoritehashmaptoarray {};
            class findtreepathbydata {};
            class findtreepathbytexts {};
            class getactivecreatetree {};
            class getcreatetreecontextbyidc {};
            class getfactionleaffavoritedisplaypath {};
            class gettreepathtexts {};
            class log {};
            class onzeusdisplayopened {};
            class removefavoritepathmarker {};
            class clearemptyfavorites {};
            class registersettings {};
            class registercreatetreehandlers {};
            class rendercreatetreefavorites {};
            class renderemptyfavoriteview {};
            class renderemptyfavoritescategory {};
            class renderfactionstars {};
            class renderfactionleaffavoriteview {};
            class renderfactionleaffavoritescategory {};
            class renderfactionrootfavorites {};
            class rendermodulefavoriteview {};
            class rendermodulefavoritescategory {};
            class restorefavoritetreeexpanded {};
            class setfactionrowexpanded {};
            class setfavoritetreeexpanded {};
            class selectfavoriteproxy {};
            class showactionhint {};
            class toggleemptyfavorite {};
            class togglefactionleaffavorite {};
            class togglemodulefavorite {};
            class toggleselectedrootfavorite {};
        };
    };
};
