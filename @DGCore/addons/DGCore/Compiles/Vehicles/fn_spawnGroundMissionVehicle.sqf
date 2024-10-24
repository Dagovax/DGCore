/*

	DGCore_fnc_spawnGroundMissionVehicle

	Purpose: Spawns a ground vehicle that will patrol a mission (_targetPos)

	Parameters:
		_targetPos: 	Position.		Final target position
		_vehicleClass: 	String.			Vehicle class to spawn
		_spawnDistance: Integer.		Minimum distance away from the target to spawn the vehicle. Default = 0 (at target position)
		_difficulty:	String.			Mission difficulty. Choose between [low | medium | high | veteran]

	Returns: Array in format: [_vicGroup, _vehicle]

	Copyright 2024 by Dagovax
*/

private["_targetPos", "_vehicleClass", "_spawnDistance", "_difficulty"];
params["_targetPos", "_vehicleClass", ["_spawnDistance", 0], ["_difficulty", "normal"]];
if(isNil "_targetPos" || _targetPos isEqualTo []) exitWith
{
	[format["Not enough valid params to spawn mission ground vehicle: _targetPos = null"], "DGCore_fnc_spawnGroundMissionVehicle", "error"] call DGCore_fnc_log;
};
if(isNil "_vehicleClass" || _vehicleClass isEqualTo "") exitWith
{
	[format["Not enough valid params to spawn mission ground vehicle: _vehicleClass = null"], "DGCore_fnc_spawnGroundMissionVehicle", "error"] call DGCore_fnc_log;
};

private["_vicGroup", "_vehicle", "_spawnPos"];

private _randomDir = random 360;
private _radius = [_difficulty] call DGCore_fnc_getWaypointRadiusByLevel;
private _spawnRadius = _radius * 2;
private _spawnAttempts = 25;
private _foundValidPos = false;

for "_try" from 1 to _spawnAttempts do
{
	private _randomPos = [(_targetPos select 0) - (sin _randomDir) * _spawnDistance, (_targetPos select 1) - (cos _randomDir) * _spawnDistance, _targetPos select 2];
	_spawnPos = [_randomPos, 0, _spawnRadius, 2, 0, 20, 0, [], [[-1,-1,-1],[-1,-1,-1]]] call BIS_fnc_findSafePos; // Find a safe spawn pos for ground vehicle
	if !(_spawnPos isEqualTo [-1,-1,-1]) then
	{
		private _nearbyPlayers = [_spawnPos, DGCore_MinPlayerDistance] call DGCore_fnc_getNearbyPlayers;
		
		if (count _nearbyPlayers < 1) then 
		{
			_foundValidPos = true; // Mark that we found a valid position
			break; // Exit loop once we find a valid position
		};
	};
	
	_randomDir = random 360;
};

// Check if a valid spawn position was found
if (!_foundValidPos) exitWith 
{
    [format["Failed to find a valid spawn position after %1 attempts.", _spawnAttempts], "DGCore_fnc_spawnGroundMissionVehicle", "warning"] call DGCore_fnc_log;
    [grpNull, objNull]
};

private _skillList = [_difficulty] call DGCore_fnc_getUnitSkillByLevel;
private _vehicleCrewPercentage = _skillList select 5; // should be a valid int
if(isNil "_vehicleCrewPercentage" || typeName _vehicleCrewPercentage != "SCALAR") exitWith
{
	[format["Failed to retrieve vehicle crew percentage for difficulty= %1 ! Please check the corresponding DGCore_config entry for crew percentage!", _difficulty], "DGCore_fnc_spawnGroundMissionVehicle", "error"] call DGCore_fnc_log;
    [grpNull, objNull]
};

_vehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "CAN_COLLIDE"];
private _vehicleName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");

private _fullCrewCount = count(fullCrew [_vehicle, "", true]);
private _crewCount = round ((_fullCrewCount * _vehicleCrewPercentage) / 100); // Round the crew count to an integer

// Ensure at least 2 crew members
if (_crewCount < 2) then {
    _crewCount = 2; // At least 2 units on this vehicle (one driver, one gunner/commander)
};

_vicGroup = [DGCore_Side, _spawnPos, _crewCount, nil, _difficulty] call DGCore_fnc_spawnGroup;

[_vehicle, _vicGroup, _spawnPos, _targetPos] spawn
{
	params["_vehicle", "_vicGroup", "_spawnPos", "_targetPos"];
	{ _x allowDamage false; } forEach units _vicGroup;
	[_vicGroup, _vehicle, false, true, true] call DGCore_fnc_moveGroupInVehicle;
	uiSleep 5; // Give moveGroupInVehicle some time to execute
	{ _x allowDamage true; } forEach units _vicGroup;
	
	_vehicle disableAI "LIGHTS"; // override AI
	_vehicle action ["LightOn", _vehicle];
	
	[_vehicle, true, true, true] call DGCore_fnc_addRepairRefuelMonitor;
	
	private _idleVariable = [_vehicle, false, false, true, _targetPos] call DGCore_fnc_addIdleMonitor;
	private _endPositionVariable = [_vehicle, _targetPos, 125, false, false, false] call DGCore_fnc_vehicleDoMove;
	if(isNil "_idleVariable") exitWith
	{
		["Failed to add idle monitor. Check the logs for DGCore_fnc_addIdleMonitor exception messages!", "DGCore_fnc_spawnGroundMissionVehicle", "error"] call DGCore_fnc_log;
	};
	if(isNil "_endPositionVariable") exitWith
	{
		["Failed to add do move monitor. Check the logs for DGCore_fnc_vehicleDoMove exception messages!", "DGCore_fnc_spawnGroundMissionVehicle", "error"] call DGCore_fnc_log;
	};
	waitUntil {uiSleep 1; !(isNil "_idleVariable") && !(isNil "_endPositionVariable")}; // Wait until value retrieved
	
	private ["_vehicleIsIdle", "_vehicleReachedTarget"];
	while {!isNull _vehicle && alive _vehicle} do
	{
		_vehicleIsIdle = _vehicle getVariable [_idleVariable, false];
		_vehicleReachedTarget = _vehicle getVariable [_endPositionVariable, false];
		
		if(_vehicleReachedTarget) exitWith
		{
			[format["Received positive _vehicleReachedTarget variable! Vehicle %1 reached its target...", _vehicle], "DGCore_fnc_spawnGroundMissionVehicle", "debug"] call DGCore_fnc_log;
		}; // Vehicle reached the end waypoint. 
		
		if(_vehicleIsIdle) exitWith
		{
			[format["Received positive _vehicleIsIdle variable! Vehicle %1 is not moving anymore...", _vehicle], "DGCore_fnc_spawnGroundMissionVehicle", "debug"] call DGCore_fnc_log;
		}; // Vehicle is idle and should be removed

		uiSleep 2;
	};
	
	if(_vehicleIsIdle) exitWith
	{
		[_vehicle, 0] call DGCore_fnc_addDeletionMonitor; // Kill vehicle
	};
	
	if(_vehicleReachedTarget) then // Vehicle reached mission site
	{
		[_vicGroup, _targetPos] call DGCore_fnc_addGroupWaypoints;
	};
};

[format ["Spawned a %1 (%2) at position %3", _vehicleName, _vehicleClass, _spawnPos], "DGCore_fnc_spawnGroundMissionVehicle", "debug"] call DGCore_fnc_log;

[_vicGroup, _vehicle]


