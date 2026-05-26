#include "..\script_component.hpp"

// Convert a tree path such as [0, 2, 1] into its visible text segments.
params ["_tree", ["_path", []]];

private _displayPath = [];
private _ancestorPath = [];

{
    _ancestorPath pushBack _x;
    _displayPath pushBack (_tree tvText _ancestorPath);
} forEach _path;

_displayPath
