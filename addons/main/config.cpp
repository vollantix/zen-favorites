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
            class clearfavoritestar {};
            class clearemptygroupfavorites {};
            class clearfactionfavorites {};
            class clearfactionleaffavorites {};
            class clearmodulefavorites {};
            class favoritehashmapfromarray {};
            class favoritehashmaptoarray {};
            class findtreepathbydata {};
            class findtreepathbytexts {};
            class getactivecreatetree {};
            class getcreatetreeselectionstate {};
            class getcreatetreecontextbyidc {};
            class getfavoritelayout {};
            class getfactionleaffavoritedisplaypath {};
            class getfavoritestarbounds {};
            class gettreeoriginalpicture {};
            class gettreepicturekey {};
            class gettreepathtexts {};
            class guardgeneratedfavoritebranchselection {};
            class isfavoritestartexture {};
            class isfavoritepath {};
            class isgeneratedfavoritesbranch {};
            class log {};
            class onzeusdisplayopened {};
            class parkcreatetreeselection {};
            class removefavoritepathmarker {};
            class clearemptyfavorites {};
            class registersettings {};
            class registercreatetreehandlers {};
            class rendercreatetreefavorites {};
            class renderemptyfavoriteview {};
            class renderemptyfavoritescategory {};
            class renderfactionleaffavoriteview {};
            class renderfactionleaffavoritescategory {};
            class renderfactionrootfavorites {};
            class rendermodulefavoriteview {};
            class rendermodulefavoritescategory {};
            class restorecreatetreeselection {};
            class restorefavoritetreeexpanded {};
            class setfactionrowexpanded {};
            class setfavoritestar {};
            class setfavoritetreeexpanded {};
            class selectfactionleaffavoriteproxy {};
            class selectfavoriteproxy {};
            class showactionhint {};
            class syncfactionfavoritepersistence {};
            class toggleemptyfavorite {};
            class togglefactionleaffavorite {};
            class togglegeneratedfavoritebranch {};
            class togglemodulefavorite {};
            class toggleselectedrootfavorite {};
        };
    };
};
