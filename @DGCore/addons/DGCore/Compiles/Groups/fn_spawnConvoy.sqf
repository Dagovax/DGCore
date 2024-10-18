/*

	DGCore_fnc_spawnConvoy

	Purpose: spawns an AI convoy at random coordinates

	Parameters:
		_side: 	Group side
		_pos: 	Position to spawn
		_count: 

	Example: ["I am being logged", "DG RoamingAI", "information"] call DGCore_fnc_log;

	Returns: Spawned Convoy info 
	
	Copyright 2024 by Dagovax
*/

params[["_convoyType", objNull], ["_convoyData", []], ["_spawnPos", [0,0,0]], ["_travelDistance", -1], ["_spawnRadius", 250], ["_convoySide", DGCore_Side], ["_speedLimit", -1], ["_dynamicLoot", []], ["_playerCanGetIn", true], ["_aiLevel", "calculate"], ["_weapons", DGCore_AIWeapons], ["_enableLauncher", DGCore_EnableLaunchers], ["_markerData", []]];
if(isNil "_convoyData" || typeName _convoyData != "ARRAY" ) exitWith
{
	[format["Not enough valid params to spawn convoy! -> _convoyType = %1 | _convoyData = %2 | _spawnRadius = %3 | _convoySide = %4 | _speedLimit = %5", _convoyType, _convoyData, _spawnRadius, _convoySide, _speedLimit], "DGCore_fnc_spawnConvoy", "error"] call DGCore_fnc_log;
};
private ["_convoyInfo", "_vehicles", "_allRoads", "_spawnConvoyLocation", "_vehicleSpawnPoints"];

_allRoads = DG_mapCenter nearRoads 50000; // Get all roads on current map

if(_spawnPos isEqualTo [0,0,0]) then
{
	_spawnConvoyLocation = getPos (selectRandom _allRoads);
	_vehicleSpawnPoints = _spawnConvoyLocation nearRoads _spawnRadius;
} else
{
	_nearbyRoads = _spawnPos nearRoads 200; // Get all nearby roads
	if !(_nearbyRoads isEqualTo []) then
	{
		_spawnConvoyLocation = getPos (selectRandom _nearbyRoads);
		_vehicleSpawnPoints = _spawnConvoyLocation nearRoads _spawnRadius;
	} else
	{
		[format ["We tried spawning a convoy near location %1, but there is no road nearby! Defaulting to random location instead!", _spawnPos], "DGCore_fnc_spawnConvoy", "debug"] call DGCore_fnc_log;
		_spawnConvoyLocation = getPos (selectRandom _allRoads);
		_vehicleSpawnPoints = _spawnConvoyLocation nearRoads _spawnRadius;
	};
};

if !(_vehicleSpawnPoints isEqualTo []) then
{
	if !(_convoyData isEqualTo []) then
	{
		// _convoyVehicles = _convoyData select 0;
		// _numberAI = _convoyData select 1;
		// _flyHeight = _convoyData select 2;
		
		if ((count _vehicleSpawnPoints) > (count _convoyData)) then
		{
			// Find a good position to the other side of the map
			_goodPos = false;
			_endWaypoint = getPos (selectRandom _allRoads);
			if(_travelDistance isEqualTo -1) then
			{
				[format ["Searching for valid _endWaypoint position, using minimum range of DG_maxRangePatrols (%1)", DG_maxRangePatrols], "DGCore_fnc_spawnConvoy", "debug"] call DGCore_fnc_log;
				while {!_goodPos} do
				{
					_goodPosDist = 0;
					while {_goodPosDist < DG_maxRangePatrols} do
					{
						_endWaypoint = getPos (selectRandom _allRoads);
						_goodPosDist = _spawnConvoyLocation distance2D _endWaypoint;
					};
					_goodPos = true;
				};
			} else
			{
				[format ["Searching for valid _endWaypoint position, using maximum _travelDistance of %1m", _travelDistance], "DGCore_fnc_spawnConvoy", "debug"] call DGCore_fnc_log;
				_minimumDistance = _travelDistance - 400;
				if(_minimumDistance <= 200) then
				{
					_minimumDistance = 200;
					_travelDistance = _minimumDistance + 400;
				};
				
				while {!_goodPos} do
				{
					_goodPosDist = (_travelDistance*2);
					while {_goodPosDist > _travelDistance || _goodPosDist < _minimumDistance} do
					{
						_endWaypoint = getPos (selectRandom _allRoads);
						_goodPosDist = _spawnConvoyLocation distance2D _endWaypoint;
					};
					_goodPos = true;
				};
			};
			
			_groupArray = [];
			
			//[format["Using _convoyData -> _convoyVehicles = %1 | _numberAI = %2 | _flyHeight = %3", _convoyVehicles, _numberAI, _flyHeight], "DGCore_fnc_spawnConvoy", "debug"] call DGCore_fnc_log;
			
			{
				private["_vehiclesArray", "_numberAI", "_flyHeight", "_loot", "_minMaxMoney", "_vehicle"];
				_vehiclesArray = 	_x select 0; // Get the array of vehicles for the current convoy type
				_numberAI = 		_x select 1; // Number of AI
				_flyHeight = 		_x select 2; // Obj height
				_loot = 			_x select 3; // Loot inside vehicle
				_minMaxMoney =		_x select 4; // Min and max money
	
				_vehicleClass = selectRandom _vehiclesArray;
				_spawnVehicleLoc = selectRandom _vehicleSpawnPoints;
				 _indexVehSpawn = _vehicleSpawnPoints find _spawnVehicleLoc;
				_spawnPos = getPos _spawnVehicleLoc;
				_vehicleSpawnPoints deleteAt _indexVehSpawn;
			
				_vehicleMoney = ceil((_minMaxMoney select 0) + random((_minMaxMoney select 1) - (_minMaxMoney select 0)));
				
				// Spawn vehicle
				_special = "NONE";
				if(_flyHeight > 0) then
				{
					_special = "FLY";
				};
				_vehicle = createVehicle [_vehicleClass, _spawnPos, [], _flyHeight, _special];
				[_vehicle, _loot, _dynamicLoot, _vehicleMoney] call DGCore_fnc_addVehicleLoot;
				
				[_vehicle, _endWaypoint, true] call DGCore_fnc_placeVehicleOnRoad;

				_vehicleName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
				[format ["Spawned a %1 (%2) at position %3", _vehicleName, _vehicleClass, _spawnPos], "DGCore_fnc_spawnConvoy", "debug"] call DGCore_fnc_log;
				
				_vehicleGroup = [_convoySide, _spawnPos, _numberAI, nil, _aiLevel, _weapons, _enableLauncher] call DGCore_fnc_spawnGroup;
				
				[_vehicle, _vehicleGroup, _spawnPos] spawn
				{
					params["_vehicle", "_vehicleGroup", "_spawnPos"];
					{ _x allowDamage false; } forEach units _vehicleGroup;
					[_vehicleGroup, _vehicle, false, true, true] call DGCore_fnc_moveGroupInVehicle;
					uiSleep 5; // Give moveGroupInVehicle some time to execute
					{ _x allowDamage true; } forEach units _vehicleGroup;
					
					_vehicle disableAI "LIGHTS"; // override AI
					_vehicle action ["LightOn", _vehicle];
				};
				
				_vehicleGroup setCombatMode "YELLOW";
				_vehicleGroup setBehaviour "SAFE";
				_vehicleGroup setFormation "STAG COLUMN";
				
				_driver = driver _vehicle;
				
				// Make sure the driver gets out when we tell him to...
				if(!isNull _driver && alive _driver) then
				{
					_driver setUnitCombatMode "BLUE";
					_driver setCombatBehaviour "CARELESS";
				};	
				
				_groupArray pushBack [_vehicle, _vehicleGroup];
				
				[_vehicle, _vehicleGroup, _endWaypoint, _speedLimit] spawn
				{
					params["_vehicle", "_vehicleGroup", "_endWaypoint", "_speedLimit"];
					if(isNil "_vehicle" || isNil "_vehicleGroup") exitWith{}; // Vehicle and group is nil	
					
					uiSleep 10; // Give above code some execution time...
					//_vehicle forceFollowRoad true;
					_vehicle allowCrewInImmobile true; // Allow crew to stay in vehicle when it's not moving
					
					[_vehicle, _endWaypoint, 150, _speedLimit, true, true] call DGCore_fnc_addConvoyMonitor;
				};
				
				// Spawn code for updating the vehicle marker
				[_vehicle, _vehicleGroup, _vehicleClass, _spawnPos, _markerData] spawn
				{
					params["_vehicle", "_vehicleGroup", "_vehicleClass", "_spawnPos", "_markerData"];
					uiSleep 10;
					if(isNil "_vehicle" || isNil "_vehicleGroup") exitWith{}; // Vehicle and group is nil
					
					if (_markerData isEqualTo []) exitWith{}; // Marker data is empty
					
					_convoyMarker = _markerData select 0;
					
					if !(_convoyMarker) exitWith{}; // Do not use marker at all
					
					_convoyMarkerType = _markerData select 1;
					_convoyMarkerColor =  _markerData select 2;
					_convoyMarkerSize =  _markerData select 3;
					_convoyMarkerText = _markerData select 4;
					
					[_vehicle, _convoyMarkerType, _convoyMarkerSize, _convoyMarkerColor, _convoyMarkerText, ["DGCore_IsConvoyActive", false]] call DGCore_fnc_addMarkerMonitor;
				};
			} forEach _convoyData;
			
			_convoyInfo = [_spawnConvoyLocation, _groupArray];
			_totalDistance =  _spawnConvoyLocation distance2D _endWaypoint;
			
			[format ["%1 spawned, and is moving to _endWaypoint %2 (total distance = %3)", _convoyType, _endWaypoint, _totalDistance], "DGCore_fnc_spawnConvoy", "debug"] call DGCore_fnc_log;
		} else
		{
			[format["Skipped spawning a convoy, because available _vehicleSpawnPoints count [%1] is not bigger than vehicle count [%2]!", count _vehicleSpawnPoints, count _convoyData], "DGCore_fnc_spawnConvoy", "debug"] call DGCore_fnc_log;
		};
	} else
	{
		["Skipped spawning a convoy, because input _convoyData array was empty!", "DGCore_fnc_spawnConvoy", "debug"] call DGCore_fnc_log;
	};
} else
{
	["Skipped spawning a convoy, because available _vehicleSpawnPoints array was empty!", "DGCore_fnc_spawnConvoy", "debug"] call DGCore_fnc_log;
};

_convoyInfo 