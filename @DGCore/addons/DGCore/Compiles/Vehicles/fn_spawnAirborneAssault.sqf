/*

	DGCore_fnc_spawnAirborneAssault

	Purpose: 	Spawns one or more planes that fly in a straight line over the _targetPos, dropping infantry. All in formation		

	Parameters:
		_class: 			Helicopter class to spawn
		_targetPlayer: 		Target player
		_spawnPos: 			The static, predefined spawn position			|	Optional -> Use empty array '[]' to spawn at a random position with below _distance
		_distance:			Distance in m the random position will spawn	|	Optional -> Not used when _spawnPos has a value!
		_spawnHeight:		Spawn height									|	Optional -> Defaults to 150
		_flyHeight:			Height of the helicopter's flight path			| 	Optional -> Defaults to 75
		_side:				What side the pilot will be						|	Optional -> Defaults to player's side
		_vehicleDrop:		Array in format [true/false, "vehicleClass"]	|	Optional
		_allowDamage:		Can the helicopter be shot down?				|	Optional -> Defaults to true
		_setCaptive:		If set to true, helicopter will be ignored by AI|	Optional -> Default false

	Example: _spawnHeliRequest = ["I_Heli_Transport_02_F"] call DGCore_fnc_spawnHeliDrop;

	Returns: Array in format [_helicopter (Vehicle), _dropVehicle (Vehicle)]

	Copyright 2024 by Dagovax
*/

params["_planeClass", "_targetPos", "_planeCount", ["_spawnDistance", DG_mapDistance], ["_crateChance", 20], ["_forceCrate", true], ["_flyHeight", 350], ["_flySpeed", 150], ["_side", DGCore_Side], ["_allowDamage", true], ["_setCaptive", false]];
if((isNil "_planeClass") || (isNil "_targetPos") || (isNil "_planeCount")) exitWith
{
	[format["Not enough valid params to spawn airborne assault! -> _planeClass = %1 | _targetPos = %2 | _planeCount = %3", _planeClass, _targetPos, _planeCount], "DGCore_fnc_spawnAirborneAssault", "error"] call DGCore_fnc_log;
};
private["_objective", "_planes", "_spawnPos", "_targetPos", "_spawnDir", "_spawnAngle"];
_objective = [_targetPos] call DGCore_fnc_getDummy;
_planes = [];
_randomDir = random 360;

while{true} do
{
	_spawnPos =[(_targetPos select 0) - (sin _randomDir) * _spawnDistance, (_targetPos select 1) - (cos _randomDir) * _spawnDistance, (_targetPos select 2) + _flyHeight];
	private _nearbyPlayers = [_spawnPos, 750] call DGCore_fnc_getNearbyPlayers;
	if(count _nearbyPlayers < 1) exitWith{};
	
	_randomDir = random 360;
};

_spawnPos =[(_targetPos select 0) - (sin _randomDir) * _spawnDistance, (_targetPos select 1) - (cos _randomDir) * _spawnDistance, (_targetPos select 2) + _flyHeight];
_spawnDir = ((_targetPos select 0) - (_spawnPos select 0)) atan2 ((_targetPos select 1) - (_spawnPos select 1));
_spawnAngle = [_spawnPos,_targetPos] call BIS_fnc_dirTo;

[format["Using _spawnPos @ %1, _spawnAngle = %2", _spawnPos, _spawnAngle], "DGCore_fnc_spawnAirborneAssault", "debug"] call DGCore_fnc_log;
if (isNil "_spawnPos" || {_spawnPos isEqualTo []}) exitWith {
    [format["Failed to find a safe spawn position!"], "DGCore_fnc_spawnAirborneAssault", "error"] call DGCore_fnc_log;
};

_genericSmoke = selectRandom DGCore_LootSmokeTypes;
_genericLight = selectRandom DGCore_LootBoxLightTypes;

private _missionCrateParam = format["DGCore_fnc_spawnAirborneAssault_%1_%2", (_targetPos select 0), (_targetPos select 1)];
missionNamespace setVariable [_missionCrateParam, false];

for "_i" from 1 to _planeCount do 
{	
	// Add random variation to fly height between -50 and +50
	_randomHeightOffset = -100 + (random 400);
	_adjustedFlyHeight = _flyHeight + _randomHeightOffset;
	if (_adjustedFlyHeight < 50) then
	{
		_adjustedFlyHeight = _flyHeight;
	};
	
	_planeSpawnPos = [_spawnPos, 50, 500, 8, 1,20,0] call BIS_fnc_findSafePos;
	
	_plane = createVehicle [_planeClass, _planeSpawnPos, [], 0, "FLY"];
	_plane setPosATL (_plane modelToWorld [0,0,_adjustedFlyHeight]);
	_plane setDir _spawnAngle;
	_plane setVelocity [50 * (sin _spawnAngle), 50 * (cos _spawnAngle), 0];
	_plane flyInHeight _flyHeight;
	_planeName = getText (configFile >> "CfgVehicles" >> (typeOf _plane) >> "displayName");
	
	_pilot = [_plane, "", _side, _allowDamage] call DGCore_fnc_spawnPilot;
	if(isNil "_pilot" || isNull _pilot) exitWith
	{
		[format["Failed to create a pilot. Airborne assault aborted!"], "DGCore_fnc_spawnAirborneAssault", "error"] call DGCore_fnc_log;
	};
	_plane allowCrewInImmobile true; // let AI stay in vehicle
	[format["Spawned a %1 @ %2", _planeName, _planeSpawnPos], "DGCore_fnc_spawnAirborneAssault", "debug"] call DGCore_fnc_log;
	_plane allowDamage _allowDamage;
	_plane setCaptive _setCaptive;
	_plane limitSpeed _flySpeed;
	_plane setPilotLight true;   

	_pilotGroup = group _pilot;
	_pilotGroup setCombatMode "BLUE";
	_pilotGroup setBehaviour "CARELESS";  //Just out for a sunday stroll.
	{_x disableAI "AUTOTARGET"; _x disableAI "TARGET"; _x disableAI "FSM"; _x allowfleeing 0;} forEach units _pilotGroup;

	_pilotGroup setVariable ["DG_AirborneAssaultPlaneAssigned", _plane];

    private _planeTargetPos = [
        (_planeSpawnPos select 0) + (sin _spawnAngle) * _spawnDistance,
        (_planeSpawnPos select 1) + (cos _spawnAngle) * _spawnDistance,
        _adjustedFlyHeight
    ];
	
	private _planeEndPos = 
	[
		(_planeTargetPos select 0) + (sin _spawnAngle) * _spawnDistance,
		(_planeTargetPos select 1) + (cos _spawnAngle) * _spawnDistance,
		_adjustedFlyHeight
	];

	[format["Calculated _planeTargetPos @ %1", _planeTargetPos], "DGCore_fnc_spawnAirborneAssault", "debug"] call DGCore_fnc_log;

	_planes pushBack _plane;
	
	_flyMission = [_objective, _plane, _planeTargetPos, _planeEndPos, _spawnDistance, _pilot, _pilotGroup, _side, _targetPos, _crateChance, _forceCrate, _genericSmoke, _genericLight, _missionCrateParam];
	_flyMission spawn
	{
		params ["_objective", "_plane", "_planeTargetPos", "_planeEndPos", "_spawnDistance", "_pilot", "_pilotGroup", "_side", "_targetPos", "_crateChance", "_forceCrate", "_genericSmoke", "_genericLight", "_missionCrateParam"];
		_plane moveTo _planeTargetPos;
		
		_planeName = getText (configFile >> "CfgVehicles" >> (typeOf _plane) >> "displayName");
		_targetReached = false;
		_endReached = false;
		
		while {alive _plane} do
		{
			if (isNil "_planeTargetPos" || _planeTargetPos isEqualTo [-1, -1, -1]) exitWith
			{
				_targetReached = false;
			};
			
			_distance = _plane distance2D _planeTargetPos;
			if (_distance <= 250) exitWith 
			{
				_targetReached = true;
			};
			uiSleep 5;
			_pilotGroup move _planeTargetPos;
		};
		[format["A %1 reached its _planeTargetPos @ %2. Moving to final end position now.", _planeName, _planeTargetPos], "DGCore_fnc_spawnAirborneAssault", "debug"] call DGCore_fnc_log;
		
		if(_targetReached) then
		{
			_planeParaCount = [0, 5] call BIS_fnc_randomInt;
			if (_planeParaCount > 0) then
			{
				private _enemyGroup = [_side, position _plane, _planeParaCount, objNull, "high", DGCore_AIWeapons, false] call DGCore_fnc_spawnGroup;		
				private _allGroups = _objective getVariable ["DGCore_AIGroups", []];
				private _allUnits = _objective getVariable ["DGCore_AIUnits", []];
				_allGroups pushBack _enemyGroup;
				_objective setVariable ["DGCore_AIGroups", _allGroups];
				
				[_enemyGroup, _targetPos, "high"] call DGCore_fnc_addGroupWaypoints;
				{
					_allUnits pushBack _x;
					_x doMove _targetPos;
				} forEach units _enemyGroup;
				_objective setVariable ["DGCore_AIUnits", _allUnits];
			};
		
			private _cratePercentage = floor random 100;
			private _dropCrate = false;
			
			if(_cratePercentage <= _crateChance) then
			{
				_dropCrate = true;
			};
		
			private _crateSpawned =  missionNamespace getVariable [_missionCrateParam, true];
			if(_forceCrate) then // Always drop one crate if force crate is set to true
			{
				if(!_crateSpawned) then
				{
					[format["Forced to spawn a loot crate due to having no crates assigned yet.."], "DGCore_fnc_spawnAirborneAssault", "debug"] call DGCore_fnc_log;
					_dropCrate = true;
					missionNamespace setVariable [_missionCrateParam, true];
				};
			};
		
			if(_dropCrate) then
			{
				private _allCrates = _objective getVariable ["DGCore_Crates", []];
				private _crate = [position _plane, 75000, _genericSmoke, _genericLight, true] call DGCore_fnc_spawnLootCrate;
				_allCrates pushBack _crate;
				_objective setVariable ["DGCore_Crates", _allCrates];
			};
		
			while {alive _plane} do
			{				
				_distance = _plane distance2D _planeTargetPos;
				_distanceEnd = _plane distance2D _planeEndPos;
				if (_distanceEnd <= 150) exitWith 
				{
					_endReached = true;
				};
				if (_distance > _spawnDistance) exitWith 
				{
					_endReached = true;
				};
				uiSleep 5;
				_pilotGroup move _planeEndPos;
			};
		};
		
		[format["Deleted a %1 @ %2 after it reached the final destination.", _planeName, getPos _plane], "DGCore_fnc_spawnAirborneAssault", "debug"] call DGCore_fnc_log;
		
		deleteVehicleCrew _plane;
		deleteGroup _pilotGroup;
		if(!alive _plane) then
		{
			uiSleep DGCore_CleanupTime;
		};
		
		deleteVehicle _plane;
	};
};
_objective setVariable ["DGCore_AirborneAssaultPlanes", _planes];

_objective
