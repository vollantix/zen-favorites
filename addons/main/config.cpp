class CfgPatches {
    class zen_filter_main {
        name = "ZEN Filter";
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
    class zen_filter_main {
        init = "call compile preprocessFileLineNumbers 'z\zen_filter\addons\main\XEH_preInit.sqf'";
    };
};

class Extended_PostInit_EventHandlers {
    class zen_filter_main {
        init = "call compile preprocessFileLineNumbers 'z\zen_filter\addons\main\XEH_postInit.sqf'";
    };
};

class CfgFunctions {
    class zen_filter_main {
        class main {
            file = "z\zen_filter\addons\main\functions";

            class applyfactionfavoriteorder {};
            class clearemptyfavoritepreview {};
            class clearleftoveremptyfavoritepreview {};
            class getactivecreatetree {};
            class inspectemptygrouprow {};
            class inspectcreatetree {};
            class log {};
            class onzeusdisplayopened {};
            class clearemptyfavorites {};
            class registersettings {};
            class renderemptyfavoritescategory {};
            class renderfactionstars {};
            class setemptyfavoritepreview {};
            class syncemptyfavoriterow {};
            class toggleemptyfavorite {};
            class toggleselectedrootfavorite {};
        };
    };
};
