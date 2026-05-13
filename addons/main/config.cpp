class CfgPatches {
    class zen_filter_main {
        name = "ZEN Filter";
        author = "vollantix";
        requiredVersion = 2.18;
        requiredAddons[] = {
            "cba_main",
            "cba_xeh",
            "zen_main"
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
            class getactivecreatetree {};
            class inspectcreatetree {};
            class log {};
            class onzeusdisplayopened {};
            class renderfactionstars {};
            class toggleemptyfavorite {};
            class toggleselectedrootfavorite {};
        };
    };
};
