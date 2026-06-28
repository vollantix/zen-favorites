#include "..\script_component.hpp"

// Restore the original source icon and clear any favorite star from either side.
params ["_tree", ["_path", []]];

if (isNull _tree || {_path isEqualTo []}) exitWith {};

private _pictureKey = [_tree, _path] call zen_favorites_main_fnc_gettreepicturekey;
private _originalPictures = _tree getVariable ["zen_favorites_main_originalPictures", createHashMap];
private _starRows = _tree getVariable ["zen_favorites_main_starRows", createHashMap];
private _starRowColors = _tree getVariable ["zen_favorites_main_starRowColors", createHashMap];
private _originalPicture = _originalPictures getOrDefault [_pictureKey, objNull];

if (_originalPicture isEqualTo objNull) then {
    _originalPicture = _tree tvPicture _path;
};

if ([_originalPicture] call zen_favorites_main_fnc_isfavoritestartexture) then {
    _originalPicture = "";
};

_tree tvSetPictureRight [_path, ""];
_tree tvSetPicture [_path, _originalPicture];
private _originalPictureColor = [[1, 1, 1, 0], [1, 1, 1, 1]] select (_originalPicture != "");

_tree tvSetPictureColor [_path, _originalPictureColor];
_tree tvSetPictureColorSelected [_path, _originalPictureColor];
_tree tvSetPictureRightColor [_path, [1, 1, 1, 0]];
_tree tvSetPictureRightColorSelected [_path, [1, 1, 1, 0]];

_starRows deleteAt _pictureKey;
_tree setVariable ["zen_favorites_main_starRows", _starRows];
_starRowColors deleteAt _pictureKey;
_tree setVariable ["zen_favorites_main_starRowColors", _starRowColors];
