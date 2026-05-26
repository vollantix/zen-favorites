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
            class clearemptyfavoritepreview {};
            class clearleftoveremptyfavoritepreview {};
            class findtreepathbydata {};
            class findtreepathbytexts {};
            class getactivecreatetree {};
            class gettreepathtexts {};
            class inspectemptygrouprow {};
            class inspectcreatetree {};
            class log {};
            class onzeusdisplayopened {};
            class removefavoritepathmarker {};
            class clearemptyfavorites {};
            class registersettings {};
            class renderemptyfavoritescategory {};
            class renderfactionstars {};
            class setemptyfavoritepreview {};
            class setfactionrowexpanded {};
            class showactionhint {};
            class syncemptyfavoriterow {};
            class toggleemptyfavorite {};
            class toggleselectedrootfavorite {};
        };
    };
};
