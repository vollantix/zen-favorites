#include "..\script_component.hpp"

// Return a leaf-first label with only enough parent context to distinguish it.
params [
    ["_sourcePath", []],
    ["_candidatePaths", []]
];

if (_sourcePath isEqualTo []) exitWith {""};

private _leafText = _sourcePath select -1;
private _matchingPaths = _candidatePaths select {
    (_x isEqualType []) &&
    {_x isNotEqualTo []} &&
    {(_x select -1) == _leafText}
};

if ((count _matchingPaths) <= 1) exitWith {_leafText};

private _parentCount = (count _sourcePath) - 1;
private _label = _leafText;

for "_contextDepth" from 1 to _parentCount do {
    private _contextPath = _sourcePath select [_parentCount - _contextDepth, _contextDepth];
    private _matchingContextCount = {
        private _candidateParentCount = (count _x) - 1;
        private _candidateContextDepth = _contextDepth min _candidateParentCount;
        private _candidateContextPath = _x select [
            _candidateParentCount - _candidateContextDepth,
            _candidateContextDepth
        ];

        _candidateContextPath isEqualTo _contextPath
    } count _matchingPaths;

    if (_matchingContextCount == 1) exitWith {
        _label = format ["%1 (%2)", _leafText, _contextPath joinString " / "];
    };
};

_label
