/*
    DGCore_fnc_findPosition

    Purpose: Find a safe position within the given constraints using BIS_fnc_findSafePos.

    Parameters:
        _pos: Starting position for the search. Optional, defaults to DG_mapCenter.
        _minDistance: Minimum distance from the starting position. Default: 0.
        _maxDistance: Maximum distance from the starting position. Default: DG_mapRange.
        _distanceFromObjects: Minimum distance from objects. Default: 50.
        _waterMode: Mode to handle water proximity (0: ignore, 1: avoid water, 2: on water). Default: 0.
        _minGrad: Minimum terrain gradient allowed. Default: DGCore_MinSurfaceNormal.
        _shoreMode: Mode for shore proximity (0: ignore, 1: avoid shore, 2: near shore). Default: 0.

    Example: 
		_pos = [] call DGCore_fnc_findPosition;
		_pos = [getPos player, 10, 500, 60] call DGCore_fnc_findPosition;

    Returns: The safe position found or [-1,-1,-1] if no valid position could be found.

    Copyright 2024 by Dagovax
*/

private ["_pos", "_minDistance", "_maxDistance", "_distanceFromObjects", "_waterMode", "_minGrad", "_shoreMode"];
params [["_pos", []], ["_minDistance", 0], ["_maxDistance", DG_mapRange], ["_distanceFromObjects", DGCore_MinObjectDistance], ["_waterMode", 0], ["_minGrad", DGCore_MinSurfaceNormal], ["_shoreMode", 0]];

if(_pos isEqualTo []) then
{
	_pos = DG_mapCenter;
};

private _validSpot 	= false;
private _currGrad 	= 1.0;
private _position 	= [-1,-1,-1];

[format["Searching for a valid position until while loop ends or valid position returns..."], "DGCore_fnc_findPosition", "debug"] call DGCore_fnc_log;
while {!_validSpot && (_currGrad >= _minGrad)} do
{
	if(canSuspend) then
	{
		sleep 1;
	};
	
	// the 'maxGrad' parameter in BIS_fnc_findSafePos is actually bate! 1.0 means flat, while 0.0 means very steep!!!!
	if(DGCore_RetriesPerSurfaceNormalLevel > 1) then
	{
		for "_i" from 1 to DGCore_RetriesPerSurfaceNormalLevel do 
		{ 
			_position = [_pos, _minDistance, _maxDistance, _distanceFromObjects, _waterMode, _currGrad, _shoreMode, [], [[-1,-1,-1],[-1,-1,-1]]] call BIS_fnc_findSafePos;
			_validSpot = [_position] call DGCore_fnc_isValidPos;
			if(_validSpot) exitWith{}; // Exit for loop
		};
	} else
	{
		_position = [_pos, _minDistance, _maxDistance, _distanceFromObjects, _waterMode, _currGrad, _shoreMode, [], [[-1,-1,-1],[-1,-1,-1]]] call BIS_fnc_findSafePos;
		_validSpot = [_position] call DGCore_fnc_isValidPos;	
	};
	
	if(!_validSpot) then
	{
		_currGrad = _currGrad - 0.05; // Next loop the grad will be a bit lower
		_position 	= [-1,-1,-1]; // Reset position if spot is not valid
	};
};	

if !(_position isEqualTo [-1,-1,-1]) then
{
	[format["Found safe position @ %1 with grad %2", _position, _currGrad], "DGCore_fnc_findPosition", "debug"] call DGCore_fnc_log;
};

_position 