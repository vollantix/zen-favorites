#include "..\script_component.hpp"

// Return x-axis bounds for the configured favorite star side of the hovered tree row.
params ["_tree", ["_path", []]];

if (isNull _tree || {_path isEqualTo []}) exitWith {[]};

private _treePosition = ctrlPosition _tree;
private _treeLeft = _treePosition select 0;
private _treeWidth = _treePosition select 2;
private _alignment = missionNamespace getVariable ["zen_favorites_main_starAlignment", ZEN_FAVORITES_STAR_ALIGNMENT_LEFT];

if (_alignment isEqualType "") then {
    _alignment = parseNumber (_alignment == "right");
};

if (_alignment == ZEN_FAVORITES_STAR_ALIGNMENT_RIGHT) exitWith {
    private _treeRight = _treeLeft + _treeWidth;

    [_treeRight - 0.041, _treeRight]
};

private _depth = ((count _path) - 1) max 0;

// Arma does not expose per-row icon rectangles. These control-relative ratios
// track the tree indent and icon slot so the hotspot scales with UI resolution.
private _indentWidth = _treeWidth * 0.075;
private _iconLeftPadding = _treeWidth * 0.090;
private _iconWidth = _treeWidth * 0.080;
private _iconLeft = _treeLeft + _iconLeftPadding + (_depth * _indentWidth);

[_iconLeft, _iconLeft + _iconWidth]
