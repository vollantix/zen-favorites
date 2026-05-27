#include "..\script_component.hpp"

// Convert a favorite store HashMap into profileNamespace-safe array entries.
params [["_store", createHashMap]];

private _entries = [];

if !(_store isEqualType createHashMap) exitWith {_entries};

{
    if (_x isEqualType "" && {_y isEqualType []}) then {
        _entries pushBack [_x, +_y];
    };
} forEach _store;

_entries
