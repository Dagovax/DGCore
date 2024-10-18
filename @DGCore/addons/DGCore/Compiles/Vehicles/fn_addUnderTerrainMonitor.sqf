/*
    DGCore_fnc_addUnderTerrainMonitor

    Purpose: Monitor an object's height to detect if it falls under terrain and remove it if necessary.

    Parameters:
        _object: The object to monitor. If objNull, exits immediately.

    Example:
        [_object] call DGCore_fnc_addUnderTerrainMonitor;

    Returns: None

    Copyright 2024 by Dagovax
*/

private ["_object"];
params [["_object", objNull]];

if (isNull _object) exitWith {
    [format["Not enough valid params to add 'falling under terrain' check! -> _object == undefined"], "DGCore_fnc_addUnderTerrainMonitor", "error"] call DGCore_fnc_log;
};

[_object] spawn
{
    private ["_object", "_currentHeight", "_needDeletion"];
    params[["_object", objNull]];
    if (isNull _object) exitWith{};

    private _retries = 0;
    private _position = getPosATL _object;
    private _previousHeight = _position select 2;
    _needDeletion = false;

    while {true} do
    {
        if (isNull _object || _needDeletion) exitWith{};

        uiSleep 5;  // Adjust delay as needed
        _position = getPosATL _object;
        _currentHeight = _position select 2;

        // Exit if retries exceed a certain limit (failsafe)
        if (_retries >= 5) exitWith {
            _needDeletion = true;
        };

        // Check if the object has fallen under the terrain
        if (_currentHeight <= -1) then {
            _needDeletion = true;  // Object is under terrain
        };

        // Check if the object is not falling anymore (if the height difference is small)
        if (abs(_currentHeight - _previousHeight) <= 1) exitWith {
            _needDeletion = false;  // Object is stable, not falling
        };

        // Update the previous height for the next comparison
        _previousHeight = _currentHeight;

        // Prevent the object from falling further (set velocity to zero)
        _object setVelocity [0, 0, 0];

        // Increment retry counter
        _retries = _retries + 1;
    };

    // After exiting loop, check if deletion is needed
    if (_needDeletion) then {
		[format["Deleting the '%1', because it was falling under terrain for too long!", _object], "DGCore_fnc_addUnderTerrainMonitor", "debug"] call DGCore_fnc_log;
        deleteVehicle _object;
    };
};