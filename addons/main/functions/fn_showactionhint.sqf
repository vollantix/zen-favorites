#include "..\script_component.hpp"

// Show a short Zeus-display toast for favorite add/remove and clear actions.
params [["_message", ""], ["_duration", 1.6]];

private _display = findDisplay 312;

if (_message == "") exitWith {
    if (!isNull _display) then {
        private _ctrl = _display getVariable ["zen_favorites_main_actionHintControl", controlNull];

        if (!isNull _ctrl) then {
            ctrlDelete _ctrl;
            _display setVariable ["zen_favorites_main_actionHintControl", controlNull];
        };
    };

    hintSilent "";
};

private _token = [diag_tickTime, random 1, _message];
missionNamespace setVariable ["zen_favorites_main_actionHintToken", _token];

if (isNull _display) exitWith {
    hintSilent _message;

    [{
        params ["_token"];

        if ((missionNamespace getVariable ["zen_favorites_main_actionHintToken", []]) isEqualTo _token) then {
            hintSilent "";
            missionNamespace setVariable ["zen_favorites_main_actionHintToken", []];
        };
    }, [_token], _duration] call CBA_fnc_waitAndExecute;
};

private _ctrl = _display getVariable ["zen_favorites_main_actionHintControl", controlNull];

if (isNull _ctrl) then {
    _ctrl = _display ctrlCreate ["RscText", -1];
    _display setVariable ["zen_favorites_main_actionHintControl", _ctrl];
};

private _width = 0.28;
private _height = 0.035;
private _margin = 0.008;
private _toastX = safeZoneX + safeZoneW - _width - _margin;
private _toastY = safeZoneY + _margin;

_toastX = (_toastX max (safeZoneX + _margin)) min (safeZoneX + safeZoneW - _width - _margin);
_toastY = (_toastY max (safeZoneY + _margin)) min (safeZoneY + safeZoneH - _height - _margin);

_ctrl ctrlSetPosition [_toastX, _toastY, _width, _height];
_ctrl ctrlSetText _message;
_ctrl ctrlSetTextColor [1, 1, 1, 1];
_ctrl ctrlSetFontHeight 0.031;
_ctrl ctrlSetBackgroundColor [0, 0, 0, 0.78];
_ctrl ctrlSetFade 0;
_ctrl ctrlCommit 0;

[{
    params ["_token"];

    if ((missionNamespace getVariable ["zen_favorites_main_actionHintToken", []]) isEqualTo _token) then {
        private _display = findDisplay 312;

        if (!isNull _display) then {
            private _ctrl = _display getVariable ["zen_favorites_main_actionHintControl", controlNull];

            if (!isNull _ctrl) then {
                _ctrl ctrlSetFade 1;
                _ctrl ctrlCommit 0.15;

                [{
                    params ["_ctrl", "_token"];

                    if ((missionNamespace getVariable ["zen_favorites_main_actionHintToken", []]) isEqualTo _token) then {
                        ctrlDelete _ctrl;

                        private _display = findDisplay 312;

                        if (!isNull _display) then {
                            _display setVariable ["zen_favorites_main_actionHintControl", controlNull];
                        };
                    };
                }, [_ctrl, _token], 0.2] call CBA_fnc_waitAndExecute;
            };
        } else {
            hintSilent "";
        };

        missionNamespace setVariable ["zen_favorites_main_actionHintToken", []];
    };
}, [_token], _duration] call CBA_fnc_waitAndExecute;
