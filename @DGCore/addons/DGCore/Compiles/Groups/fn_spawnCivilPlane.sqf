/*

	DGCore_fnc_spawnCivilPlane

	Purpose: spawns a civilian plane at a random available airport, and let it fly to another available airport

	Parameters:
		_class: class name of the aircraft - Optional
		_allowDamage: plane can be shot down - Optional | Default false
		_side: Side that the AI will be on
		_initialWaitTime: Initial wait time in seconds the plane will wait before taking off. Default 0 (instant take off)

	Example: [] call DGCore_fnc_spawnCivilPlane;

	Returns: [Group, start ilsPosition, end ilsPosition]

	Copyright 2023 by Dagovax
*/
params[["_class", ""], ["_allowDamage", false], ["_side", DGCore_CivilSide], ["_initialWaitTime", 0], ["_setCaptive", true]];
if(_class isEqualTo "") then
{
	_class = selectRandom DGCore_CivilianPlanes;
};
private ["_plane", "_allAirportsInfo", "_takeOffAirportInfo", "_landAirportInfo", "_landOnTakeOfAirport" ,"_spawnPos", "_civilianGroup"];

if(count allAirports < 1) exitWith
{
	[format["Tried to execute this function when there are not enough airports on this map [%1]. Must be at least 1!", count allAirports], "DGCore_fnc_spawnCivilPlane", "error"] call DGCore_fnc_log;
};

if(count allAirports == 1) then
{
	_landOnTakeOfAirport = true; // Only 1 Airport on the map, so it needs to land at the same airport
} else
{
	_landOnTakeOfAirport = false;
};

_allAirportsInfo = [];
_firstIlsPos = getArray (configfile >> "CfgWorlds" >> worldname >> "ilsPosition");
private _first = 
[
	_firstIlsPos,
	getArray (configfile >> "CfgWorlds" >> worldname >> "ilsDirection"),
	getArray (configfile >> "CfgWorlds" >> worldname >> "ilsTaxiIn"),
	getArray (configfile >> "CfgWorlds" >> worldname >> "ilsTaxiOff"),
	[_firstIlsPos] call DGCore_fnc_nearestAirportId
];
_allAirportsInfo pushBack _first;
_sec = (configfile >> "CfgWorlds" >> worldname >> "SecondaryAirports");
for "_i" from 0 to (count _sec - 1) do
{
	_ilsPos = getarray ((_sec select _i) >> "ilsPosition");
	_allAirportsInfo pushBackUnique 
	[
		_ilsPos,
		getarray ((_sec select _i) >> "ilsDirection"),
		getarray ((_sec select _i) >> "ilsTaxiIn"),
		getarray ((_sec select _i) >> "ilsTaxiOff"),
		[_ilsPos] call DGCore_fnc_nearestAirportId
	];
};

// Also load dynamic airport
if(DGCore_UseDynamicAirports) then
{
	_dynamicAirports = allAirports select 1;
	if(_dynamicAirports isEqualTo []) exitWith{}; // There are no dynamic airports on this map
	{
		if(!isNull _x) then
		{
			_dynamicAirportInfo = [_x] call DGCore_fnc_getDynamicAirportInfo;
			if(!(_dynamicAirportInfo isEqualTo [])) then
			{
				_dynamicAirportInfo pushBack _x; // Add object it self for landAt command
				_allAirportsInfo pushBack _dynamicAirportInfo;
				[format["Added dynamic airport '%1' with information %2!", typeOf _x, _dynamicAirportInfo], "DGCore_fnc_spawnCivilPlane", "debug"] call DGCore_fnc_log;
			};
		};
	} forEach _dynamicAirports;
};

// Now we have all airport information
if(count _allAirportsInfo < 1) exitWith
{
	[format["Error retrieving airport information. Count is equals [%1]. Must be at least 1!", count _allAirportsInfo], "DGCore_fnc_spawnCivilPlane", "error"] call DGCore_fnc_log;
};

_takeOffAirportInfo = selectRandom _allAirportsInfo;
_allAirportsInfo deleteAt(_allAirportsInfo find _takeOffAirportInfo);
_landAirportInfo = [];
if(_landOnTakeOfAirport) then
{
	_landAirportInfo = _takeOffAirportInfo;
} else
{
	_landAirportInfo = selectRandom _allAirportsInfo;
};
[format["_takeOffAirportInfo = %1", _takeOffAirportInfo]] call DGCore_fnc_log;
_ilsTaxiIn = _takeOffAirportInfo select 2; // ilsTakeIn waypoints
_spawnLocations = [];
for "_i" from 0 to (count _ilsTaxiIn - 1) step 2 do
{
	_x = _ilsTaxiIn select _i;
	_y = _ilsTaxiIn select _i + 1;
	_z = 0;
	_spawnLocations pushBack [_x, _y, _z];
};

if(isNil "_spawnLocations") exitWith
{
	["Selected airport for take off does not have ilsTakeIn waypoints. Can not spawn a plane there!", "DGCore_fnc_spawnCivilPlane", "error"] call DGCore_fnc_log;
};
if(count _spawnLocations < 1) exitWith
{
	["Selected airport for take off does not have ilsTakeIn waypoints. Can not spawn a plane there!", "DGCore_fnc_spawnCivilPlane", "error"] call DGCore_fnc_log;
};
_rdnPos = selectRandom _spawnLocations;
_spawnPos = [_rdnPos, 0, 25, 2, 0, 1.0,0,[],[_rdnPos,_rdnPos]] call BIS_fnc_findSafePos;
if(isNil "_spawnPos") exitWith
{
	[format["Failed to find a valid spawn position. Not random item from _spawnLocations = %1?", _spawnLocations], "DGCore_fnc_spawnCivilPlane", "error"] call DGCore_fnc_log;
};
[1,2,3,4]; 
_spawnAngle = 0; // default
{
	if(_x isEqualTo _rdnPos) exitWith
	{
		if((count _spawnLocations - 1) > _forEachIndex) then // There is another spawn location
		{
			_nextPos = (_spawnLocations select (_forEachIndex + 1));
			_spawnAngle = [_spawnPos,_nextPos] call BIS_fnc_dirTo; // Get direction to next position
		} else // Last element
		{
			_spawnAngle = [_spawnPos,_takeOffAirportInfo select 0] call BIS_fnc_dirTo; // Get direction to ILSPos, take off point
		};
	};
} forEach _spawnLocations;
_plane = createVehicle [_class, _spawnPos, [], 0, "CAN_COLLIDE"];
_plane setPosATL [getPosATL _plane select 0, getPosATL _plane select 1, (getPosATL _plane select 2) + 2];
_plane allowDamage _allowDamage;
_plane setDir _spawnAngle;
_flyHeight = (DGCore_FlyHeightRange call BIS_fnc_randomInt);
_plane flyInHeight _flyHeight; // Make sure this plane flies at a random height
_planeName = getText (configFile >> "CfgVehicles" >> (typeOf _plane) >> "displayName");
_plane setVariable ["ExileIsPersistent", false];
if(isNull _plane || !alive _plane) exitWith
{
	[format["Failed to spawn the %1 @ %2 (did it EXPLODE)?", _class, _spawnPos], "DGCore_fnc_spawnCivilPlane", "warning"] call DGCore_fnc_log;
};

_civilianPilot = [_spawnPos, DGCore_civilianPilot, _side, _setCaptive, _plane] call DGCore_fnc_spawnCivilian;
if(isNil "_civilianPilot") exitWith{}; 
if(isNull _civilianPilot) exitWith{};
_civilianGroup = group _civilianPilot;

[_plane, _planeName, _civilianPilot, _spawnPos, _landAirportInfo, _initialWaitTime] spawn
{
	params["_plane", "_planeName", "_civilianPilot", "_spawnPos", "_landAirportInfo", "_initialWaitTime"];
	// First wait until initial wait time;
	waitUntil{sleep _initialWaitTime; true };
	
	// Add the move command
	_inversePos = [_spawnPos] call DGCore_fnc_getInversePos;
	_movePos = [_landAirportInfo select 0, 1000, 3000, 0, 1, 20, 0, [], [_inversePos, _inversePos]] call BIS_fnc_findSafePos; // Random range around the target airport
	
	_idleVariable = [_plane] call DGCore_fnc_addIdleMonitor;
	_endPositionVariable = [_plane, _movePos, 100, true, true, true] call DGCore_fnc_vehicleDoMove;
	if(isNil "_idleVariable") exitWith
	{
		["Failed to add idle monitor. Check the logs for DGCore_fnc_addIdleMonitor exception messages!", "DGCore_fnc_spawnCivilPlane", "error"] call DGCore_fnc_log;
	};
	if(isNil "_endPositionVariable") exitWith
	{
		["Failed to add do move monitor. Check the logs for DGCore_fnc_vehicleDoMove exception messages!", "DGCore_fnc_spawnCivilPlane", "error"] call DGCore_fnc_log;
	};
	waitUntil {uiSleep 1; !(isNil "_idleVariable") && !(isNil "_endPositionVariable")}; // Wait until value retrieved
	while {!isNull _plane && alive _plane} do
	{
		_vehicleIsIdle = _plane getVariable [_idleVariable, false];
		_vehicleReachedEnd = _plane getVariable [_endPositionVariable, false];
		if(_vehicleIsIdle && !_vehicleReachedEnd) exitWith // Vehicle was idle for too long. Remove it
		{
			_civilianGroup = group _civilianPilot;
			{deleteVehicle _x;} forEach units _civilianGroup;
			deleteGroup _civilianGroup;
			[_plane, 0] call DGCore_fnc_addDeletionMonitor;
			[format["Removed the %1 after it was being idle for too long!", _planeName], "DGCore_fnc_spawnCivilPlane", "information"] call DGCore_fnc_log;
		};
		if(_vehicleReachedEnd) exitWith{}; // Vehicle reached the waypoint. 
		uiSleep 2;
	};

	if(isNull _plane) exitWith{}; // Plane is null

	// Add the landAt command.
	_landAirportId = _landAirportInfo select 4; // Id or dynamic object
	if(isNil "_landAirportId") exitWith{
		deleteVehicle _civilianPilot;
		[_plane, 0] call DGCore_fnc_addDeletionMonitor;
	};
	if(!alive _plane || !alive _civilianPilot) exitWith
	{
		deleteVehicle _civilianPilot;
		[_plane] call DGCore_fnc_addDeletionMonitor;
	};
	
	_landAtVariable = [_plane, _landAirportId, _landAirportInfo select 0] call DGCore_fnc_planeDoLand;
	waitUntil {uiSleep 1; !(isNil "_landAtVariable")}; // Wait until value retrieved
	
	// This forces the script to wait until plane landed
	while {!isNull _plane && alive _plane} do
	{
		_planeLanded = _plane getVariable [_landAtVariable, false];
		if(_planeLanded) exitWith{};
		uiSleep 2;
		// [format["The script for %1 is in a loop, waiting until it landed!", _planeName], "DGCore_fnc_spawnCivilPlane", "debug"] call DGCore_fnc_log;
	};
	
	if(!alive _plane || !alive _civilianPilot) exitWith
	{
		deleteVehicle _civilianPilot;
		[_plane] call DGCore_fnc_addDeletionMonitor;
	};
	
	_plane setVehicleLock "UNLOCKED"; // Unlocked
	_plane allowDamage true;
	_civilianGroup = group _civilianPilot;
	if(isNull _civilianGroup || isNull _civilianPilot) exitWith{};
	_civilianGroup setVariable ["DGCore_unitReady", true];
	_pilotPos = getPos _civilianPilot;
	_nearestBuilding = [_pilotPos, 1000] call DGCore_fnc_nearestBuilding;
	waitUntil {uiSleep 1; !(isNil "_nearestBuilding")}; // Wait until value retrieved
	[format["The %1 of group %2 landed at the airportID %3.", _planeName,  _civilianGroup, _landAirportId], "DGCore_fnc_spawnCivilPlane", "information"] call DGCore_fnc_log;
	if(!isNull _nearestBuilding) then
	{
		uiSleep 5;
		_allBuildingPositions = [_nearestBuilding] call BIS_fnc_buildingPositions;
		private _randomPos = selectRandom _allBuildingPositions;
		if(!isNil "_randomPos") then
		{
			[_civilianPilot, _randomPos, 10] call DGCore_fnc_civilianDoFinalMove;
		} else
		{
			[_civilianPilot, getPos _nearestBuilding, 10] call DGCore_fnc_civilianDoFinalMove;
		};
	} else
	{
		{deleteVehicle _x;} forEach units _civilianGroup;
		deleteGroup _group;
	};
	_playersInVehicle = [_plane] call DGCore_fnc_getPlayersInVehicle; // Eject players!
	waitUntil {uiSleep 1; !(isNil "_playersInVehicle")}; // Wait until value retrieved
	if(count _playersInVehicle > 0) then
	{
		{
			[format["Ejected %1 from the %2!", name _x, _planeName], "DGCore_fnc_spawnCivilPlane", "information"] call DGCore_fnc_log;
			_x moveOut _plane;
		} forEach _playersInVehicle; // Eject players!
	};

	[_plane, 120] call DGCore_fnc_addDeletionMonitor; // This will kill the plane when no player enters it after 120 seconds!
};

[_civilianGroup, _takeOffAirportInfo select 0, _landAirportInfo select 0]
