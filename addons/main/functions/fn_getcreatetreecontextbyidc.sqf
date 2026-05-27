#include "..\script_component.hpp"

// Return [mode, side] for a known Zeus Create tree control IDC.
params [["_idc", -1]];

private _context = ["", ""];

switch (_idc) do {
    case ZEN_FAVORITES_IDC_CREATE_UNITS_WEST: {_context = ["units", "west"]};
    case ZEN_FAVORITES_IDC_CREATE_UNITS_EAST: {_context = ["units", "east"]};
    case ZEN_FAVORITES_IDC_CREATE_UNITS_GUER: {_context = ["units", "guer"]};
    case ZEN_FAVORITES_IDC_CREATE_UNITS_CIV: {_context = ["units", "civ"]};
    case ZEN_FAVORITES_IDC_CREATE_UNITS_EMPTY: {_context = ["units", "empty"]};
    case ZEN_FAVORITES_IDC_CREATE_GROUPS_WEST: {_context = ["groups", "west"]};
    case ZEN_FAVORITES_IDC_CREATE_GROUPS_EAST: {_context = ["groups", "east"]};
    case ZEN_FAVORITES_IDC_CREATE_GROUPS_GUER: {_context = ["groups", "guer"]};
    case ZEN_FAVORITES_IDC_CREATE_GROUPS_EMPTY: {_context = ["groups", "empty"]};
    case ZEN_FAVORITES_IDC_CREATE_MODULES: {_context = ["modules", "logic"]};
};

_context
