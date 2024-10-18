/*

	DGCore_fnc_addConvoyMonitor

	Purpose: spawns a civilian vehicle (at given coordinates)

	Parameters:
		_class: class name of the unit
		_pos: position to spawn this unit
		_side: side the AI will be on

	Example: ["C_man_1", [10400,10400,0], INDEPENDENT] call DGCore_fnc_spawnCivilPatrol;

	Returns: Nothing

	Copyright 2024 by Dagovax
*/
params [["_vehicle", objNull], ["_endWaypoint", [-1,-1,-1]], ["_completionRadius", 150], ["_speedLimit", -1], ["_refuel", false], ["_repair", false]];
if(isNull _vehicle || _endWaypoint isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to add convoy monitor vehicle! -> _vehicle = %1 | _endWaypoint = %2", _vehicle, _endWaypoint], "DGCore_fnc_addConvoyMonitor", "error"] call DGCore_fnc_log;
};

[_vehicle, _endWaypoint, _completionRadius, _speedLimit, _refuel, _repair] spawn
{
	params["_vehicle", "_endWaypoint", "_completionRadius", "_speedLimit", "_refuel", "_repair"];
	
	if(isNull _vehicle || !alive _vehicle) exitWith{}; // Vehicle already destroyed or removed...
	
	_vehicle setVariable ["DGCore_IsConvoyActive", true];
	
	[_vehicle, true, true, true] call DGCore_fnc_addRepairRefuelMonitor;
	
	private _idleVariable = [_vehicle, false, false, true, _endWaypoint] call DGCore_fnc_addIdleMonitor;
	private _endPositionVariable = [_vehicle, _endWaypoint, _completionRadius, false, false, false, _speedLimit] call DGCore_fnc_vehicleDoMove;
	if(isNil "_idleVariable") exitWith
	{
		["Failed to add idle monitor. Check the logs for DGCore_fnc_addIdleMonitor exception messages!", "DGCore_fnc_addConvoyMonitor", "error"] call DGCore_fnc_log;
	};
	if(isNil "_endPositionVariable") exitWith
	{
		["Failed to add do move monitor. Check the logs for DGCore_fnc_vehicleDoMove exception messages!", "DGCore_fnc_addConvoyMonitor", "error"] call DGCore_fnc_log;
	};
	waitUntil {uiSleep 1; !(isNil "_idleVariable") && !(isNil "_endPositionVariable")}; // Wait until value retrieved
	
	while {!isNull _vehicle && alive _vehicle} do
	{
		_vehicleIsIdle = _vehicle getVariable [_idleVariable, false];
		_vehicleReachedEnd = _vehicle getVariable [_endPositionVariable, false];
		
		if(_vehicleReachedEnd) exitWith
		{
			[format["Received positive _vehicleReachedEnd variable! Vehicle %1 reached its end...", _vehicle], "DGCore_fnc_addConvoyMonitor", "debug"] call DGCore_fnc_log;
		}; // Vehicle reached the end waypoint. 
		
		if(_vehicleIsIdle) exitWith
		{
			[format["Received positive _vehicleIsIdle variable! Vehicle %1 is not moving anymore...", _vehicle], "DGCore_fnc_addConvoyMonitor", "debug"] call DGCore_fnc_log;
		}; // Vehicle is idle and should be removed

		uiSleep 2;
	};

	_vehicle setVariable ["DGCore_IsConvoyActive", false];

	_nearbyPlayers = [getPos _vehicle, 100] call DGCore_fnc_getNearbyPlayers;

	if(count _nearbyPlayers > 0) then
	{
		[format["There are players nearby! (%1), not cleaning this vehicle -> %2", _nearbyPlayers, _vehicle], "DGCore_fnc_addConvoyMonitor", "debug"] call DGCore_fnc_log;
		_group = group _vehicle;
		{
			unassignVehicle _x;
			[_x] orderGetIn false;
			_x setUnitCombatMode "RED";
			_x setCombatBehaviour "COMBAT";
		} forEach crew _vehicle;
		uiSleep 10;
		_group setCombatMode "RED";
		_group setBehaviour "COMBAT";
		uiSleep 20;
		[_group, getPos _vehicle, 3000] call BIS_fnc_taskPatrol;
		[format["Started patrol task for group %1, ending this convoy monitor..", _group], "DGCore_fnc_addConvoyMonitor", "debug"] call DGCore_fnc_log;
	}
	else
	{
		[_vehicle, 0] call DGCore_fnc_addDeletionMonitor; // Cleanup vehicle properly. Instantly explode if possible after reaching way point!
	};
};