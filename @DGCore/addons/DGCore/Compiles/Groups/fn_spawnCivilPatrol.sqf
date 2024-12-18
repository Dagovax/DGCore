/*

	DGCore_fnc_spawnCivilPatrol

	Purpose: spawns a civilian vehicle (at given coordinates)

	Parameters:
		_class: class name of the unit
		_pos: position to spawn this unit
		_side: side the AI will be on

	Example: ["C_man_1", [10400,10400,0], INDEPENDENT] call DGCore_fnc_spawnCivilPatrol;

	Returns: Civilian Group

	Copyright 2023 by Dagovax
*/
params[["_class", ""], ["_pos", [-1,-1,-1]], ["_side", DGCore_CivilSide]];
if(_class isEqualTo "") then
{
	_class = selectRandom DGCore_CivilianVehicles;
};
private ["_vehicle", "_pos", "_patrolLocations", "_spawnPos", "_civilianGroup"];
_patrolLocations = [];
{
	_patrolLocations pushBack _x;
} forEach DG_patrolLocations;
if(_pos isEqualTo [-1,-1,-1]) then
{
	_spawnLocation = selectRandom(_patrolLocations);
	_patrolLocations deleteAt(_patrolLocations find _spawnLocation);
	_locationPos = locationPosition _spawnLocation;
	_pos = [_locationPos, 0, 100, 2, 0, 20] call BIS_fnc_findSafePos;
	[format["No _pos parameter given for vehicle patrol. Selecting random position [%1] @ %2", name _spawnLocation, _pos], "DGCore_fnc_spawnCivilPatrol", "debug"] call DGCore_fnc_log;
};
if(count _patrolLocations < 1) exitWith
{
	[format["_patrolLocations was lower than 1. (%1), canceling civil patrol!", count _patrolLocations], "DGCore_fnc_spawnCivilPatrol", "warning"] call DGCore_fnc_log;
};

_allRoads = _pos nearRoads 250; // Get all roads near the pos
if(count _allRoads > 0) then
{
	_spawnPos = getPos (selectRandom _allRoads);
} else
{
	_spawnPos = _pos;
};

_vehicle = createVehicle [_class, _spawnPos, [], 0, "CAN_COLLIDE"];
_vicName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
_vehicle setVariable ["ExileIsPersistent", false];
if(isNull _vehicle || !alive _vehicle) exitWith
{
	[format["Failed to spawn the %1 @ %2 (did it EXPLODE)?", _class, _pos], "DGCore_fnc_spawnCivilPatrol", "warning"] call DGCore_fnc_log;
};

_civilianDriver = [_pos, "", _side, true, _vehicle] call DGCore_fnc_spawnCivilian;
if(isNil "_civilianDriver") exitWith{}; 
if(isNull _civilianDriver) exitWith{};
_civilianGroup = group _civilianDriver;

_vehicle setVehicleLock "LOCKED"; // Locked

[_vehicle, _vicName, _civilianDriver, _patrolLocations] spawn
{
	params[["_vehicle", objNull], ["_vicName", ""], ["_civilianDriver", objNull], ["_patrolLocations", []]];
	if(isNull _vehicle || isNull _civilianDriver || _patrolLocations isEqualTo []) exitWith
	{
		[format["Not enough valid params to add monitors! -> _vehicle = %1 | _civilianDriver = %2 | _patrolLocations = %3", _vehicle, _civilianDriver, _patrolLocations], "DGCore_fnc_spawnCivilPatrol", "warning"] call DGCore_fnc_log;
	};
	
	_endLocation = selectRandom(_patrolLocations);
	_endPos = locationPosition _endLocation;
	_endRoads = _endPos nearRoads 250; // Get all roads near the pos
	if(count _endRoads > 0) then
	{
		_endPos = getPos (selectRandom _endRoads);
	};
	
	_nearestBuilding = [_endPos] call DGCore_fnc_nearestBuilding;
	waitUntil {uiSleep 1; !(isNil "_nearestBuilding")}; // Wait until value retrieved
	_randomPos = _endPos;
	if(!isNull _nearestBuilding) then
	{
		_allBuildingPositions = [_nearestBuilding] call BIS_fnc_buildingPositions;
		_randomPos = selectRandom _allBuildingPositions;
		_endPos = [_randomPos, 0, 10, 0, 0, 20,0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
		if(_endPos isEqualTo [0,0,0]) then
		{
			_endPos = _randomPos;
		};
	};
	[format["%1 inside the %2 is now driving to their house @ %3 in %4", group _civilianDriver, _vicName, _endPos, name _endLocation], "DGCore_fnc_spawnCivilPatrol", "information"] call DGCore_fnc_log;
	_idleVariable = [_vehicle] call DGCore_fnc_addIdleMonitor;
	_endPositionVariable = [_vehicle, _endPos, 50, true, true, true] call DGCore_fnc_vehicleDoMove;
	if(isNil "_idleVariable") exitWith
	{
		["Failed to add idle monitor. Check the logs for DGCore_fnc_addIdleMonitor exception messages!", "DGCore_fnc_spawnCivilPatrol", "error"] call DGCore_fnc_log;
	};
	if(isNil "_endPositionVariable") exitWith
	{
		["Failed to add do move monitor. Check the logs for DGCore_fnc_vehicleDoMove exception messages!", "DGCore_fnc_spawnCivilPatrol", "error"] call DGCore_fnc_log;
	};
	waitUntil {uiSleep 1; !(isNil "_idleVariable") && !(isNil "_endPositionVariable")}; // Wait until value retrieved
	while {!isNull _vehicle && alive _vehicle} do
	{
		_vehicleIsIdle = _vehicle getVariable [_idleVariable, false];
		_vehicleReachedEnd = _vehicle getVariable [_endPositionVariable, false];
		if(_vehicleIsIdle && !_vehicleReachedEnd) exitWith // Vehicle was idle for too long. Remove it
		{
			_civilianGroup = group _civilianDriver;
			{deleteVehicle _x;} forEach units _civilianGroup;
			deleteGroup _civilianGroup;
			deleteVehicleCrew _vehicle;
			deleteVehicle _vehicle;
			[format["Removed the %1 after it was being idle for too long!", _vicName], "DGCore_fnc_spawnCivilPatrol", "debug"] call DGCore_fnc_log;
		};
		if(_vehicleReachedEnd) exitWith // Vehicle reached the end waypoint. 
		{
			waitUntil { unitReady _vehicle };
			_civilianGroup = group _civilianDriver;
			_civilianGroup leaveVehicle _vehicle;
			{[_x] orderGetin false;} forEach units _civilianGroup;
			[format["Civilian group %1 reached the end waypoint @ %2, moving out the vehicle %3 now!", _civilianGroup, _endPos, _vicName], "DGCore_fnc_spawnCivilPatrol", "debug"] call DGCore_fnc_log;
			_vehicle setVehicleLock "UNLOCKED"; // Unlocked
		};
		uiSleep 2;
	};

	_civilianGroup = group _civilianDriver;
	_civilianGroup setVariable ["DGCore_unitReady", true];
	[_civilianDriver, _randomPos] spawn DGCore_fnc_civilianDoFinalMove;
	[_vehicle] spawn DGCore_fnc_addDeletionMonitor;
};

_civilianGroup
