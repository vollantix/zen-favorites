#include "..\script_component.hpp"

// Display the favorite star on the configured side while remembering the source icon.
params ["_tree", ["_path", []], ["_color", [1, 1, 1, 1]]];

if (isNull _tree || {_path isEqualTo []}) exitWith {};

private _pictureKey = [_tree, _path] call zen_favorites_main_fnc_gettreepicturekey;
private _legacyKey = str [_path, _tree tvText _path, _tree tvData _path];
private _originalPictures = _tree getVariable ["zen_favorites_main_originalPictures", createHashMap];
private _starRows = _tree getVariable ["zen_favorites_main_starRows", createHashMap];
private _starRowColors = _tree getVariable ["zen_favorites_main_starRowColors", createHashMap];
private _cachedOriginalPicture = _originalPictures getOrDefault [_pictureKey, objNull];
private _originalPicture = _cachedOriginalPicture;
private _legacyOriginalPicture = _originalPictures getOrDefault [_legacyKey, objNull];
private _visiblePicture = _tree tvPicture _path;
private _alignment = missionNamespace getVariable ["zen_favorites_main_starAlignment", ZEN_FAVORITES_STAR_ALIGNMENT_LEFT];

if (_alignment isEqualType "") then {
    _alignment = parseNumber (_alignment == "right");
};

if (_originalPicture isEqualTo objNull) then {
    _originalPicture = _legacyOriginalPicture;
};

if (_originalPicture isEqualTo objNull) then {
    _originalPicture = _visiblePicture;
};

if ([_originalPicture] call zen_favorites_main_fnc_isfavoritestartexture) then {
    _originalPicture = "";
};

private _shouldCachePicture = _cachedOriginalPicture isEqualTo objNull;

if (!_shouldCachePicture) then {
    _shouldCachePicture = [_cachedOriginalPicture] call zen_favorites_main_fnc_isfavoritestartexture;
};

if (_shouldCachePicture) then {
    private _pictureToCache = _visiblePicture;

    if ([_pictureToCache] call zen_favorites_main_fnc_isfavoritestartexture) then {
        _pictureToCache = _originalPicture;
    };

    _originalPictures set [_pictureKey, _pictureToCache];
    _tree setVariable ["zen_favorites_main_originalPictures", _originalPictures];
};

// Stable text/data keys survive generated branch sorting after the star is rendered.
_starRows set [_pictureKey, true];
_tree setVariable ["zen_favorites_main_starRows", _starRows];
_starRowColors set [_pictureKey, _color];
_tree setVariable ["zen_favorites_main_starRowColors", _starRowColors];

if (_alignment == ZEN_FAVORITES_STAR_ALIGNMENT_RIGHT) exitWith {
    _tree tvSetPicture [_path, _originalPicture];
    private _originalPictureColor = [[1, 1, 1, 0], [1, 1, 1, 1]] select (_originalPicture != "");

    // Arma can retain the previous texture when an empty picture is assigned.
    // Hiding that icon slot prevents an old left star remaining on iconless folders.
    _tree tvSetPictureColor [_path, _originalPictureColor];
    _tree tvSetPictureColorSelected [_path, _originalPictureColor];
    _tree tvSetPictureRight [_path, ZEN_FAVORITES_STAR_TEXTURE];
    _tree tvSetPictureRightColor [_path, _color];
    _tree tvSetPictureRightColorSelected [_path, _color];
};

_tree tvSetPictureRight [_path, ""];
_tree tvSetPictureRightColor [_path, [1, 1, 1, 0]];
_tree tvSetPictureRightColorSelected [_path, [1, 1, 1, 0]];
_tree tvSetPicture [_path, ZEN_FAVORITES_STAR_TEXTURE];
_tree tvSetPictureColor [_path, _color];
_tree tvSetPictureColorSelected [_path, _color];
