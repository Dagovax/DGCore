/*
    DGCore_fnc_setVectorUp

    Purpose: Adjust the object's vector up based on terrain slope or a predefined mode.

    Parameters:
        _obj: The object whose vector up is being set.
        
    DGCore_RotBuildingMode:
        - "slope": Align object with the terrain slope.
        - "up": Align object upwards (flat).
        - "auto": Automatically choose between slope and flat based on the steepness of the terrain.

    Copyright 2024 by Dagovax
*/

private ["_obj", "_mode", "_angle"];
params [["_obj", objNull], ["_mode", DGCore_RotBuildingMode], ["_angle", DGCore_RotBuildingAngle]]; 
if(isNull _obj) exitWith
{
	[format["Not enough valid params to set vector up! -> _obj == null"], "DGCore_fnc_setVectorUp", "error"] call DGCore_fnc_log;
};

// Define threshold for "too steep" slope (in radius)
private _slopeThreshold = _angle;  // If terrain slope is steeper than 20 rad, use the slope alignment
if(_slopeThreshold < 0) then
{
	_slopeThreshold = _slopeThreshold * -1;
};

// Get the surface normal at the object's position
private _surfaceNormal = surfaceNormal getPosASL _obj;

// Calculate the slope angle in radians
private _radGrad = [getPos _obj, getDir _obj] call BIS_fnc_terrainGradAngle;

switch (toLowerANSI _mode) do
{
	case "slope":
	{
		_obj setVectorUp _surfaceNormal;
	};
	case "up":
	{
		_obj setVectorUp [0,0,1];
	};
	case "auto":
	{
        // If the slope is either too steep or too flat, align the object flat
        if (_radGrad < (-1 * _slopeThreshold) || _radGrad > _slopeThreshold) then {
            _obj setVectorUp [0, 0, 1];  // Flat alignment
        } else {
            _obj setVectorUp surfaceNormal getPosASL _obj;  // Align with terrain slope
        };
	};
	default
	{
		_obj setVectorUp [0,0,1];
	};
};