#include "..\script_component.hpp"

// Return the visible path shown under the generated faction leaf Favorites branch.
params [
    ["_sourceDisplayPath", []],
    ["_mode", ""],
    ["_tree", controlNull]
];

private _relativeDisplayPath = +_sourceDisplayPath;

if (
    _mode == "groups" &&
    {!isNull _tree} &&
    {(_tree tvCount []) > 0} &&
    {(count _relativeDisplayPath) > 1} &&
    {(_relativeDisplayPath select 0) == (_tree tvText [0])}
) then {
    _relativeDisplayPath deleteAt 0;
};

if ((count _relativeDisplayPath) > 3) then {
    private _leafText = _relativeDisplayPath select -1;
    private _categoryText = (_relativeDisplayPath select [1, ((count _relativeDisplayPath) - 2) max 0]) joinString " / ";

    _relativeDisplayPath = [_relativeDisplayPath select 0, _categoryText, _leafText];
};

_relativeDisplayPath
