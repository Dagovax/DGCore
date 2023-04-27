/*

	DGCore_fnc_spawnCivilPlane

	Purpose: spawns a civilian plane at a random available airport, and let it fly to another available airport

	Parametsrs:
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
private _first = 
[
	getArray (configfile >> "CfgWorlds" >> worldname >> "ilsPosition"),
	getArray (configfile >> "CfgWorlds" >> worldname >> "ilsDirection"),
	getArray (configfile >> "CfgWorlds" >> worldname >> "ilsTaxiIn"),
	getArray (configfile >> "CfgWorlds" >> worldname >> "ilsTaxiOff")
];
_allAirportsInfo pushBack _first;
_sec = (configfile >> "CfgWorlds" >> worldname >> "SecondaryAirports");
for "_i" from 0 to (count _sec - 1) do
{
	_allAirportsInfo pushBackUnique 
	[
		getarray ((_sec select _i) >> "ilsPosition"),
		getarray ((_sec select _i) >> "ilsDirection"),
		getarray ((_sec select _i) >> "ilsTaxiIn"),
		getarray ((_sec select _i) >> "ilsTaxiOff")
	];
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

_plane = createVehicle [_class, _spawnPos, [], 0, "CAN_COLLIDE"];
_plane allowDamage _allowDamage;
_flyHeight = (DGCore_FlyHeightRange call BIS_fnc_randomInt);
_plane flyInHeight _flyHeight; // Make sure this plane flies at a random height
_planeName = getText (configFile >> "CfgVehicles" >> (typeOf _plane) >> "displayName");
_plane setVariable ["ExileIsPersistent", false];
if(isNull _plane || !alive _plane) exitWith
{
	[format["Failed to spawn the %1 @ %2 (did it EXPLODE)?", _class, _spawnPos], "DGCore_fnc_spawnCivilPlane", "warning"] call DGCore_fnc_log;
};

_civilianPilot = [_spawnPos, "", _side, _setCaptive, _plane] call DGCore_fnc_spawnCivilian;
if(isNil "_civilianPilot") exitWith{}; 
if(isNull _civilianPilot) exitWith{};
_civilianGroup = group _civilianPilot;

[_plane, _planeName, _civilianPilot, _spawnPos, _landAirportInfo, _initialWaitTime] spawn
{
	params["_plane", "_planeName", "_civilianPilot", "_spawnPos", "_landAirportInfo", "_initialWaitTime"];
	// First wait until initial wait time;
	waitUntil{sleep _initialWaitTime; true };
	
	// Add the move command
	_movePos = [_spawnPos] call DGCore_fnc_getInversePos;
	
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
			deleteVehicleCrew _plane;
			deleteVehicle _plane;
			[format["Removed the %1 after it was being idle for too long!", _planeName], "DGCore_fnc_spawnCivilPatrol", "information"] call DGCore_fnc_log;
		};
		if(_vehicleReachedEnd) exitWith{}; // Vehicle reached the waypoint. 
		uiSleep 2;
	};

	// Add the landAt command.
	_landAirportId = [_landAirportInfo select 0] call DGCore_fnc_nearestAirportId;
	if(_landAirportId isEqualTo -1) exitWith{
		deleteVehicle _civilianPilot;
		deleteVehicleCrew _plane;
		deleteVehicle _plane;
	};
	if(!alive _plane || !alive _civilianPilot) exitWith
	{
		deleteVehicle _civilianPilot;
		deleteVehicleCrew _plane;
		deleteVehicle _plane;
	};
	
	_landAtVariable = [_plane, _landAirportId, _landAirportInfo select 0] call DGCore_fnc_planeDoLand;
	waitUntil {uiSleep 1; !(isNil "_landAtVariable")}; // Wait until value retrieved
	while {!isNull _plane && alive _plane} do
	{
		_planeLanded = _plane getVariable [_landAtVariable, false];
		if(_planeLanded) exitWith{};
		uiSleep 2;
	};
	
	if(!alive _plane || !alive _civilianPilot) exitWith
	{
		deleteVehicle _civilianPilot;
		deleteVehicleCrew _plane;
		deleteVehicle _plane;
	};
	
	_civilianGroup = group _civilianPilot;
	_civilianGroup leaveVehicle _plane;
	{[_x] orderGetin false;} forEach units _civilianGroup;
	[format["Civilian group %1 landed at the airportID %2, moving out the plane %3 now!", _civilianGroup, _landAirportId, _planeName], "DGCore_fnc_spawnCivilPlane", "information"] call DGCore_fnc_log;
	_plane setVehicleLock "UNLOCKED"; // Unlocked
	_plane allowDamage true;
	_civilianGroup setVariable ["DGCore_civilReady", true];
	uiSleep 2;
	
	[_plane, 0, 120] call DGCore_fnc_addDeletionMonitor; // This will remove the plane when no player enters it after 120 seconds!
	
	if(!isNull _civilianPilot && alive _civilianPilot) then // Let the civilian slowly move to a house and move him there
	{	
		unassignVehicle _civilianPilot;
		if(vehicle _civilianPilot != _civilianPilot) then
		{
			while {vehicle _civilianPilot == _civilianPilot} do // Ensure this dude is out of the vehicle
			{
				[_civilianPilot] orderGetIn false;
				uiSleep 2;
			};
		};
	
		_dudePos = getPos _civilianPilot;
		_civilianGroup = group _civilianPilot;
		_nearestBuilding = [_dudePos, 1000] call DGCore_fnc_nearestBuilding;
		if(!isNil "_nearestBuilding") then
		{
			_allBuildingPositions = [_nearestBuilding] call BIS_fnc_buildingPositions;
			_randomPos = selectRandom _allBuildingPositions;
			_civilianGroup setSpeedMode "LIMITED";
			_civilianPilot move _randomPos;
			while {!unitReady _civilianPilot && alive _civilianPilot} do
			{
				if(unitReady _civilianPilot) exitWith{};
				_newPos = getPos _civilianPilot;
				if (_newPos distance2D _randomPos < 10) exitWith{}; // To remove him looping in circles
				uiSleep 2;
			};
			{deleteVehicle _x;} forEach units _civilianGroup;
			deleteGroup _civilianGroup;
		} else
		{
			deleteVehicle _civilianPilot;
			deleteGroup _civilianGroup;
		};
	};
};

[_civilianGroup, _takeOffAirportInfo select 0, _landAirportInfo select 0]
