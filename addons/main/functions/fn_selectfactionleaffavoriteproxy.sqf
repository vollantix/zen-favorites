#include "..\script_component.hpp"

// Resolve a generated faction leaf favorite to its original ZEN row and proxy-select it.
params ["_tree", ["_favoritePath", []]];

if (isNull _tree || {_favoritePath isEqualTo []}) exitWith {false};
if ((_tree tvCount _favoritePath) > 0) exitWith {false};

private _treeContext = [ctrlIDC _tree] call zen_favorites_main_fnc_getcreatetreecontextbyidc;
_treeContext params ["_mode", "_side"];

if !(_mode in ["units", "groups"] && {_side != "empty"}) exitWith {false};

private _displayPath = [_tree, _favoritePath] call zen_favorites_main_fnc_gettreepathtexts;

if !("Favorites" in _displayPath) exitWith {false};

private _favoriteSourcePathMap = _tree getVariable ["zen_favorites_main_factionLeafFavoriteSourcePaths", createHashMap];
private _sourceDisplayPath = _favoriteSourcePathMap getOrDefault [
    str _displayPath,
    [_displayPath] call zen_favorites_main_fnc_removefavoritepathmarker
];
private _data = _tree tvData _favoritePath;
private _originalPath = [_tree, _sourceDisplayPath] call zen_favorites_main_fnc_findtreepathbytexts;

if (_originalPath isEqualTo [] && {_data != ""}) then {
    _originalPath = [_tree, [], _data] call zen_favorites_main_fnc_findtreepathbydata;
};

if (_originalPath isEqualTo []) exitWith {
    [_tree, "zen_favorites_main_activeFactionLeafFavoritePath"] call zen_favorites_main_fnc_clearactivefavoriteproxy;

    [ZEN_FAVORITES_LOG_LEVEL_WARN, format [
        "could not resolve faction leaf favorite proxy selection favoritePath=%1 sourceDisplayPath=%2 data=%3",
        _favoritePath,
        _sourceDisplayPath,
        _data
    ]] call zen_favorites_main_fnc_log;

    false
};

private _proxySelectionArgs = [
    _tree,
    +_favoritePath,
    +_originalPath,
    format ["zen_favorites_main_factionLeafExpandedTextPaths_%1_%2", _mode, _side],
    "zen_favorites_main_ignoreFactionLeafExpandEvents",
    "zen_favorites_main_ignoreFactionLeafProxySelection",
    "zen_favorites_main_activeFactionLeafFavoritePath",
    [1, 0.93, 0.58, 1],
    [1, 1, 1, 1],
    "zen_favorites_main_ignoreFactionExpandEvents"
];

// TreeSelChanged is still unwinding; move the real selection to a clean frame.
[{
    params ["_proxySelectionArgs"];

    _proxySelectionArgs call zen_favorites_main_fnc_selectfavoriteproxy;
}, [_proxySelectionArgs]] call CBA_fnc_execNextFrame;

[ZEN_FAVORITES_LOG_LEVEL_INFO, format [
    "selected original faction leaf row from favorite proxy favoritePath=%1 originalPath=%2 sourceDisplayPath=%3 data=%4",
    _favoritePath,
    _originalPath,
    _sourceDisplayPath,
    _data
]] call zen_favorites_main_fnc_log;

true
