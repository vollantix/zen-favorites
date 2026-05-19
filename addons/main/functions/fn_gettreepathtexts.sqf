#include "..\script_component.hpp"

params ["_tree", ["_path", []]];

private _displayPath = [];
private _ancestorPath = [];

{
    _ancestorPath pushBack _x;
    _displayPath pushBack (_tree tvText _ancestorPath);
} forEach _path;

_displayPath
