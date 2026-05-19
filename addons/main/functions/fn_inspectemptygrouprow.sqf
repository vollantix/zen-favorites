#include "..\script_component.hpp"

params ["_tree", "_path"];

if ((missionNamespace getVariable ["zen_favorites_main_logLevel", ZEN_FAVORITES_LOG_LEVEL_INFO]) < ZEN_FAVORITES_LOG_LEVEL_DEBUG) exitWith {};
if ((ctrlIDC _tree) != ZEN_FAVORITES_IDC_CREATE_GROUPS_EMPTY) exitWith {};
if (_path isEqualTo []) exitWith {};

private _displayPath = [];
private _ancestorPath = [];

{
    _ancestorPath pushBack _x;
    _displayPath pushBack (_tree tvText _ancestorPath);
} forEach _path;

private _childCount = _tree tvCount _path;
private _data = _tree tvData _path;
private _value = _tree tvValue _path;
private _text = _tree tvText _path;
private _picture = _tree tvPicture _path;
private _pictureRight = _tree tvPictureRight _path;
private _tooltip = _tree tvTooltip _path;
private _selectedCompositionType = "nil";
private _selectedCompositionCount = -1;

if !(isNil "zen_compositions_selected") then {
    _selectedCompositionType = typeName zen_compositions_selected;

    if (zen_compositions_selected isEqualType []) then {
        _selectedCompositionCount = count zen_compositions_selected;
    };
};

[ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
    "Empty Groups row selected path=%1 displayPath=%2 text=%3 data=%4 value=%5 children=%6 picture=%7 pictureRight=%8 tooltip=%9 selectedCompositionType=%10 selectedCompositionCount=%11",
    _path,
    _displayPath,
    _text,
    _data,
    _value,
    _childCount,
    _picture,
    _pictureRight,
    _tooltip,
    _selectedCompositionType,
    _selectedCompositionCount
]] call zen_favorites_main_fnc_log;

[
    {
        params ["_path", "_displayPath", "_text", "_data"];

        private _selectedCompositionType = "nil";
        private _selectedCompositionCount = -1;

        if !(isNil "zen_compositions_selected") then {
            _selectedCompositionType = typeName zen_compositions_selected;

            if (zen_compositions_selected isEqualType []) then {
                _selectedCompositionCount = count zen_compositions_selected;
            };
        };

        [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
            "Empty Groups row next-frame composition state path=%1 displayPath=%2 text=%3 data=%4 selectedCompositionType=%5 selectedCompositionCount=%6",
            _path,
            _displayPath,
            _text,
            _data,
            _selectedCompositionType,
            _selectedCompositionCount
        ]] call zen_favorites_main_fnc_log;
    },
    [_path, _displayPath, _text, _data]
] call CBA_fnc_execNextFrame;

if (_childCount > 0) then {
    private _sampleChildren = [];

    for "_index" from 0 to ((_childCount - 1) min 10) do {
        private _childPath = +_path;
        _childPath pushBack _index;

        _sampleChildren pushBack [
            _index,
            _tree tvText _childPath,
            _tree tvData _childPath,
            _tree tvValue _childPath,
            _tree tvCount _childPath
        ];
    };

    [ZEN_FAVORITES_LOG_LEVEL_DEBUG, format [
        "Empty Groups row child sample path=%1 children=%2",
        _path,
        _sampleChildren
    ]] call zen_favorites_main_fnc_log;
};
