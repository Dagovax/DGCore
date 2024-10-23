/*

	DGCore_fnc_spawnAirborneAssault

	Purpose: 	Spawns one or more planes that fly in a straight line over the _targetPos, dropping infantry. All in formation		

	Parameters:
			_planeClass:        String. 	The class name of the plane(s) to be spawned.
			_targetPos:         Array. 		The target position [x, y, z] that the planes will fly over and drop infantry.
			_planeCount:        Integer. 	Number of planes to spawn.
			_difficulty:		String.  	The level of skill set to use. DGCore_confing. Choose between [low | medium | high | veteran]
			_troopCount:		Array.  	A min-max troop count to be spawned. Will ignore _difficulty DGCore settings if used. Default: empty array [] (to calculate unit count with DGCore settings)
			_useLaunchers:		Boolean. 	Let troopers spawn with launchers? Or not. Will default to DGCore_EnableLaunchers;
			_spawnDistance:     Integer. 	Distance in meters from the target where the planes will spawn. (Optional, Default: DG_mapDistance).
			_crateCount:        Integer.	Amount of loot crates to spawn. If value = 0 and _forceCrate = true, at least 1 crate will spawn
			_forceCrate:        Boolean. 	Whether to always drop a crate, regardless of chance. (Optional, Default: true).
			_flyHeightRange:    Array. 		Range of altitude [min, max] at which the planes will fly. (Optional, Default: DGCore_FlyHeightRange).
			_flySpeed:          Integer. 	Speed of the planes. (Optional, Default: DGCore_FlySpeedLimit).
			_side:              Side. 		The faction or side to which the spawned planes and infantry belong. (Optional, Default: DGCore_Side).
			_allowDamage:       Boolean. 	Whether the planes are allowed to take damage. (Optional, Default: true).
			_setCaptive:        Boolean. 	Whether the planes should be treated as non-hostile (captive). (Optional, Default: false).


	Example: _objective = ["CUP_B_AC47_Spooky_USA", DG_mapCenter, 10] call DGCore_fnc_spawnAirborneAssault;

	Returns: Dummy object with objective information

	Copyright 2024 by Dagovax
*/

private["_objective", "_planes", "_spawnPos", "_targetPos", "_spawnDir", "_spawnAngle", "_flyHeight", "_crateCount"];
params["_planeClass", "_targetPos", "_planeCount", ["_difficulty", DGCore_DefaultDifficulty], ["_troopCount", []], ["_useLaunchers", DGCore_EnableLaunchers], ["_spawnDistance", DG_mapDistance], ["_crateCount", 0], ["_forceCrate", true], ["_flyHeightRange", DGCore_FlyHeightRange], ["_flySpeed", DGCore_FlySpeedLimit], ["_side", DGCore_Side], ["_allowDamage", true], ["_setCaptive", false]];
if((isNil "_planeClass") || (isNil "_targetPos") || (isNil "_planeCount")) exitWith
{
	[format["Not enough valid params to spawn airborne assault! -> _planeClass = %1 | _targetPos = %2 | _planeCount = %3", _planeClass, _targetPos, _planeCount], "DGCore_fnc_spawnAirborneAssault", "error"] call DGCore_fnc_log;
};
_objective = [_targetPos] call DGCore_fnc_getDummy;
_planes = [];
_randomDir = random 360;
_flyHeight = (_flyHeightRange select 0) + random((_flyHeightRange select 1) - (_flyHeightRange select 0)); // random fly height

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
missionNamespace setVariable [_missionCrateParam, 0];
private _enemyGroupInfo = [_difficulty] call DGCore_fnc_getUnitInfoByLevel; // Gather generic skill level that will be used for each plane

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
	_plane allowDamage false; // Only allow damage after they at least dropped the cargo!
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
	
	_flyMission = [_objective, _enemyGroupInfo, _plane, _planeTargetPos, _planeEndPos, _spawnDistance, _pilot, _pilotGroup, _side, _targetPos, _crateCount, _forceCrate, _genericSmoke, _genericLight, _missionCrateParam, _allowDamage, _difficulty, _useLaunchers, _troopCount];
	_flyMission spawn
	{
		private ["_crateCount", "_cratesSpawned"];
		params ["_objective", "_enemyGroupInfo", "_plane", "_planeTargetPos", "_planeEndPos", "_spawnDistance", "_pilot", "_pilotGroup", "_side", "_targetPos", "_crateCount", "_forceCrate", "_genericSmoke", "_genericLight", "_missionCrateParam", "_allowDamage", "_difficulty", "_useLaunchers", "_troopCount"];
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
			
			private _distance = _plane distance2D _planeTargetPos;
			private _height = ((getPos _plane) select 2);
			if (_distance <= 250) exitWith 
			{
				_targetReached = true;
			};
			if(_height < 5) exitWith // Plane is too low. It either crashed or is bugged. Or both. 
			{
				[_plane, 0] call DGCore_fnc_addDeletionMonitor;
				_targetReached = false;
			};
			
			uiSleep 5;
			_pilotGroup move _planeTargetPos;
		};
		[format["A %1 reached its _planeTargetPos @ %2. Moving to final end position now.", _planeName, _planeTargetPos], "DGCore_fnc_spawnAirborneAssault", "debug"] call DGCore_fnc_log;
		
		if(_targetReached) then
		{
			private _groupLevel = _enemyGroupInfo select 0; // group level. low | medium | high | veteran
			private _groupSkills = _enemyGroupInfo select 1; // skill list
			private "_groupCount";
			if(_troopCount isEqualTo []) then
			{
				_groupCount = (_enemyGroupInfo select 2) call BIS_fnc_randomInt; // random troop count based on difficulty
			} else
			{
				_groupCount = _troopCount call BIS_fnc_randomInt; // random troop count based on input array
			};
			
			if (_groupCount > 0) then
			{
				private _enemyGroup = [_side, position _plane, _groupCount, objNull, _groupLevel, DGCore_AIWeapons, _useLaunchers] call DGCore_fnc_spawnGroup;		
				private _allGroups = _objective getVariable ["DGCore_AIGroups", []];
				private _allUnits = _objective getVariable ["DGCore_AIUnits", []];
				_allGroups pushBack _enemyGroup;
				_objective setVariable ["DGCore_AIGroups", _allGroups];
				
				[_enemyGroup, _targetPos, _groupLevel] call DGCore_fnc_addGroupWaypoints;
				{
					_allUnits pushBack _x;
					_x doMove _targetPos;
				} forEach units _enemyGroup;
				_objective setVariable ["DGCore_AIUnits", _allUnits];
			};
		
			_cratesSpawned =  missionNamespace getVariable [_missionCrateParam, 0];
			private _dropCrate = false;
			
			[format["DEBUG: _cratesSpawned = %1", _cratesSpawned], "DGCore_fnc_spawnAirborneAssault", "debug"] call DGCore_fnc_log;
			if (typeName _crateCount != "SCALAR") exitWith {
				[format["ERROR: _crateCount is not a number! Current value: %1", _crateCount], "DGCore_fnc_spawnAirborneAssault", "error"] call DGCore_fnc_log;
				_objective
			};
			if (typeName _cratesSpawned != "SCALAR") exitWith {
				[format["ERROR: _cratesSpawned is not a number! Current value: %1", _cratesSpawned], "DGCore_fnc_spawnAirborneAssault", "error"] call DGCore_fnc_log;
				_objective
			};
			
			if(_cratesSpawned < _crateCount) then
			{
				_dropCrate = true;
			};
		
			if(_forceCrate) then // Always drop one crate if force crate is set to true
			{
				if(_cratesSpawned < 1) then
				{
					[format["Forced to spawn a loot crate due to having no crates assigned yet.."], "DGCore_fnc_spawnAirborneAssault", "debug"] call DGCore_fnc_log;
					_dropCrate = true;
				};
			};
		
			if(_dropCrate) then
			{
				_cratesSpawned = _cratesSpawned + 1;
				missionNamespace setVariable [_missionCrateParam, _cratesSpawned];
				private _locked = false;
				// Atomic check and lock the crates list
				while {!_locked} do
				{
					// Try to acquire the lock
					if (!(_objective getVariable ["DGCore_CrateLock", false])) then
					{
						_objective setVariable ["DGCore_CrateLock", true, true];  // Lock acquired
						_locked = true;
					}
					else
					{
						// If the lock is active, wait and try again
						uiSleep 0.1;
					};
				};
				
				private _allCrates = _objective getVariable ["DGCore_Crates", []];
				private _crate = [position _plane, 75000, _genericSmoke, _genericLight, true] call DGCore_fnc_spawnLootCrate;
				_allCrates pushBack _crate;
				_objective setVariable ["DGCore_Crates", _allCrates];
				
				// Release the lock after modification
				_objective setVariable ["DGCore_CrateLock", false, true];
			};
		
			_plane allowDamage _allowDamage; // Now allow damage if set to true
		
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
		
		[_plane, 0, 0] call DGCore_fnc_addDeletionMonitor; // Delete planes
	};
};
_objective setVariable ["DGCore_AirborneAssaultPlanes", _planes];

_objective
