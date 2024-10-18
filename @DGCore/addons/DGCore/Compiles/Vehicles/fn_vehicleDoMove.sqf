/*

	DGCore_fnc_vehicleDoMove

	Purpose: checks if a vehicle is moving to a certain position.

	Parameters:
		_vehicle: vehicle object to add monitor to.
		_pos: position the vehicle has to move to.
		_completionRadius: radius around the end position the waypoint is complete. Defaults to 25
		_refuel: automatically refuel the vehicle until it reaches the end
		_repair: automatically repairs the vehicle until it reaches the end
		_ensureOffroad: ensure that after the vehicle reaches the end, it is moving off the road (to prevent vehicle stack).

	Example: _variableToCheck = [_vehicle, [10400,10400,0], 50, false, true, true] call DGCore_fnc_vehicleDoMove;

	Returns: Variable added to this vehicle. Will be set to 'true' when the vehicle has reached the waypoint, 'false' otherwise

	Copyright 2023 by Dagovax
*/
params [["_vehicle", objNull], ["_pos", [-1,-1,-1]], ["_completionRadius", 25], ["_refuel", false], ["_repair", false], ["_ensureOffroad", false], ["_limitSpeed", -1]];
if(isNull _vehicle || _pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to add waypoint domove checker to vehicle! -> _vehicle = %1 | _pos = %2", _vehicle, _pos], "DGCore_fnc_vehicleDoMove", "error"] call DGCore_fnc_log;
};
private ["_vehicle", "_refuel", "_repair"];
private _variable = "DGCore_doMoveVariable";
private _endPosVar = "DGCore_doMoveEndPos";
_vehicle setVariable [_variable, false];
_vehicle setVariable [_endPosVar, _pos];
if(!alive _vehicle) exitWith
{
	[format["Tried to add idle check monitor to destroyed vehicle!"], "DGCore_fnc_vehicleDoMove", "warning"] call DGCore_fnc_log;
	_vehicle setVariable [_variable, true];
};

_vicName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
[_variable, _vehicle, _pos, _completionRadius, _vicName, _refuel, _repair, _ensureOffroad, _limitSpeed] spawn
{
	params[["_variable", ""],["_vehicle", objNull], "_pos", "_completionRadius", ["_vicName", ""], ["_refuel", false], ["_repair", false], ["_ensureOffroad", false], ["_limitSpeed", -1]];
	if(isNull _vehicle) exitWith
	{
		[format["Not enough valid params to add waypoint domove checker to vehicle! -> _vehicle = %1", _vehicle], "DGCore_fnc_vehicleDoMove", "error"] call DGCore_fnc_log;
	};
	
	[format["Main loop for vehicle [%1] waypoint checker", _vicName], "DGCore_fnc_vehicleDoMove", "debug"] call DGCore_fnc_log;

	if(_ensureOffroad) then
	{
		_roads = _pos nearRoads 5; // Get all roads near the pos
		if(count _roads > 0) then
		{
			_newPos = [_pos, 0, 50, 3, 0, 20,0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
			if(_newPos isEqualTo [0,0,0]) then // Search a bit further away
			{
				_newPos = [_pos, 0, 100, 3, 0, 20,0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;	
				if(_newPos isEqualTo [0,0,0]) then
				{
					_newPos = _pos; // Never mind then
				};
			};
			_pos = _newPos;
		};
	};

	while {!isNull _vehicle && alive _vehicle} do
	{
		_playersInVehicle = [_vehicle] call DGCore_fnc_getPlayersInVehicle;
		if(count _playersInVehicle > 0) exitWith
		{
			[format["Player(s) %1 entered the %2. Stopping this monitor!", _playersInVehicle, _vehicle], "DGCore_fnc_vehicleDoMove", "debug"] call DGCore_fnc_log;
		}; // Stop any repair/refuel command if a player enters this vehicle!
		
		_currentPos = getPos _vehicle;
		_notOnRoad = false;
		
		_isRepairing = _vehicle getVariable ["DGCore_vehicleIsRepairing", false];
		if(_isRepairing) then
		{
			waitUntil 
			{
				uiSleep 1; !(_vehicle getVariable ["DGCore_vehicleIsRepairing", false])
			}; // Wait until repair is false
			_vehicle move _pos;
		};
		
		if(isNull _vehicle && !alive _vehicle) exitWith {};
		
		//if(count (crew _vehicle) < 1) exitWith {};
		
		_roads = _currentPos nearRoads 2; // Get all roads near the pos
		if(count _roads == 0 && _ensureOffroad && (_currentPos distance2D _pos) <= _completionRadius) exitWith
		{
			_vehicle setVariable [_variable, true];
		};
		if (!_ensureOffroad && (_currentPos distance2D _pos) <= _completionRadius) exitWith
		{
			_vehicle setVariable [_variable, true];
		};
		
		if(_limitSpeed > -1) then
		{
			_vehicle limitSpeed _limitSpeed;
		};
		
		if(unitReady _vehicle) then
		{
			_vehicle move _pos;
		};
		
		if(_refuel) then
		{
			_vehicle setFuel 1;
		};
		if(_repair) then
		{
			_vehicle setDamage 0; // repair
		};
		_vehicle setVariable [_variable, false];
		uiSleep 5;
	};
};

_variable 