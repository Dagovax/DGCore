/*
    DGCore_fnc_isNearWater

    Purpose: Check if the specified position is near water within a given radius.

    Parameters:
        _pos: The position to check for proximity to water.                | Optional -> Defaults to [-1, -1, -1].
        _radius: The radius within which to check for water.               | Optional -> Defaults to DGCore_MinWaterNearDistance.

    Example:
        _isNearWater = [_pos, 100] call DGCore_fnc_isNearWater;

    Returns: Boolean (true if near water, false if not).

    Copyright 2024 by Dagovax
*/

private ["_pos", "_radius"];
params [["_pos", [-1,-1,-1]], ["_radius", DGCore_MinWaterNearDistance]];

if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	false
};

private _result	= false;

try
{
	if (surfaceIsWater _pos) then
	{
		throw true;
	};

	for "_i" from 0 to 359 step 45 do
	{
		if (surfaceIsWater (_pos getPos [_radius,_i])) then
		{
			throw true;
		};
	};
}
catch
{
	_result = true;
};

_result
