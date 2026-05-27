#include "..\script_component.hpp"

// Rebuild a favorite store HashMap from profileNamespace-safe array entries.
params [["_entries", []]];

private _store = createHashMap;

if !(_entries isEqualType []) exitWith {_store};

{
    if (
        (_x isEqualType []) &&
        {count _x >= 2} &&
        {(_x select 0) isEqualType ""} &&
        {(_x select 1) isEqualType []}
    ) then {
        _store set [_x select 0, +(_x select 1)];
    };
} forEach _entries;

_store
