#include "..\script_component.hpp"

// Return the source row icon, even when the visible row icon is the favorite star.
params ["_tree", ["_path", []]];

if (isNull _tree || {_path isEqualTo []}) exitWith {""};

private _pictureKey = [_tree, _path] call zen_favorites_main_fnc_gettreepicturekey;
private _originalPictures = _tree getVariable ["zen_favorites_main_originalPictures", createHashMap];
private _originalPicture = _originalPictures getOrDefault [_pictureKey, objNull];

if (_originalPicture isEqualTo objNull) then {
    _originalPicture = _tree tvPicture _path;
};

if ([_originalPicture] call zen_favorites_main_fnc_isfavoritestartexture) exitWith {""};

_originalPicture
