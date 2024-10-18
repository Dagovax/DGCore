/*

	DGCore_fnc_recruitUnitVehicle

	Purpose: Spawn a non-persistent vehicle with allied units.

	Parametsrs:
		_class: 			Class of the vehicle
		_targetPlayer:		Target player
		_distance:			Distance to spawn vehicle away from _targetPlayer;
		_aiCount:			Number of units to spawn
		_weapons:			Array -> weapon class names
		_enableLauncher:	Spawn launchers with chance
		_side:				Side of the group/vehicle
		_atSea:				Spawn at sea (naval vehicles)

	Example: ["class", _target, nil, 3, nil, nil] call DGCore_fnc_recruitUnitVehicle;

	Returns: Vehicle

	Copyright 2024 by Dagovax
*/

params["_class", "_targetPlayer", ["_distance", 500], ["_aiCount", 5], ["_aiLevel", "calculate"], ["_weapons", DGCore_AIWeapons], ["_enableLauncher", DGCore_EnableLaunchers], ["_side", DGCore_playerSide], ["_atSea", false]];
if((isNil "_class") || (isNil "_targetPlayer") || (isNull _targetPlayer)) exitWith
{
	[format["Not enough valid params to spawn unit vehicle! -> _class = %1 | _targetPlayer = %2", _class, _targetPlayer], "DGCore_fnc_recruitUnitVehicle", "error"] call DGCore_fnc_log;
};
private["_vehicle", "_targetPosition", "_spawnPos", "_aiCount"];
_targetPosition = getPosATL _targetPlayer;
_spawnPos =  [_targetPosition, (_distance - 100),(_distance + 100),2,0,20,0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
if(_atSea) then
{
	_spawnPos = [_targetPosition, (_distance - 100),(_distance + 100),1,2,20,0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
};
if(_atSea && _spawnPos isEqualTo [0,0,0]) exitWith
{
	[format["Could not find a valid position for naval invasion. Aborted!"], "DGCore_fnc_recruitUnitVehicle", "warning"] call DGCore_fnc_log;
};
if(_spawnPos isEqualTo [0,0,0]) exitWith
{
	[format["Could not find a valid spawn position. Aborted!"], "DGCore_fnc_recruitUnitVehicle", "warning"] call DGCore_fnc_log;
};

// Spawn vehicle
if((toLowerANSI DGCore_modType) isEqualTo "exile") then
{
	_posATL = [_spawnPos select 0, _spawnPos select 1, (getTerrainHeightASL _spawnPos + 1)];
	_vehicle = [_class, _posATL, 0, FALSE] call ExileServer_object_vehicle_createNonPersistentVehicle;
} 
else
{
	_vehicle = createVehicle [_class, _spawnPos, [], 0, "CAN_COLLIDE"];
};

_executeBlock = [_vehicle, _spawnPos, _class, _targetPlayer, _aiCount, _aiLevel, _weapons, _enableLauncher, _side];
_executeBlock spawn
{
	params ["_vehicle", "_spawnPos", "_class", "_targetPlayer", "_aiCount", "_aiLevel", "_weapons", "_enableLauncher", "_side"]; 
	if(isNil "_vehicle" || isNil "_targetPlayer") exitWith
	{
		[format["Vehicle creation failed. Further execution aborted!"], "DGCore_fnc_recruitUnitVehicle", "error"] call DGCore_fnc_log;
	};
	if(isNull _vehicle || isNull _targetPlayer) exitWith
	{
		[format["Vehicle creation returned <NULL>. Further execution aborted!"], "DGCore_fnc_recruitUnitVehicle", "error"] call DGCore_fnc_log;
	};
	[format["Spawned the %1 @ %2. Find it at grid (%3)", _class, _spawnPos, mapGridPosition _vehicle], "DGCore_fnc_recruitUnitVehicle", "debug"] call DGCore_fnc_log;
	
	_vehicle disableAI "LIGHTS"; // override AI
	_vehicle action ["LightOn", _vehicle];	

	_targetPlayerName = name _targetPlayer;
		
	_vehicleGroup = [_side, _spawnPos, _aiCount, nil, _aiLevel, _weapons, _enableLauncher] call DGCore_fnc_spawnGroup;
	{ _x allowDamage false; } forEach units _vehicleGroup;
	[_vehicleGroup, _vehicle, false, true, true] call DGCore_fnc_moveGroupInVehicle;
	uiSleep 5; // Give moveGroupInVehicle some time to execute
	{ _x allowDamage true; } forEach units _vehicleGroup;
	
	_groupCountInVehicle = count units _vehicleGroup;
	
	_vehicle setVariable ["DGRecruitVehicle_groupCount", _groupCountInVehicle];
	
	_vehicleGroup move getPosATL _targetPlayer;
	
	_currTime = diag_tickTime;
	while {alive _vehicle} do
	{
		if (isNil "_targetPlayer" || isNull _targetPlayer) exitWith
		{
			[format["Player %1 disconnected or is bugged, because _targetPlayer equals undefined! Cleaning up and aborting now!", _targetPlayerName], "DGCore_fnc_recruitUnitVehicle", "warning"] call DGCore_fnc_log;
			_targetReached = false;
		};
		_targetPos = getPos _targetPlayer;
		_distance = _vehicle distance2D _targetPlayer;
		if (_distance <= 50) exitWith 
		{
			_targetReached = true;
		};
		_timeRemaining = 60 - (diag_tickTime - _currTime);
		_traveled = _vehicle distance2D _spawnPos;
		if ((_timeRemaining <= 0) && (_traveled < 100)) exitWith
		{
			// time over. Vehicle probably stuck. Assign it to the player now if true
			[format["Group %1 failed to reach %2 in time! Adding the group to this player now!", _vehicleGroup, _targetPlayerName], "DGCore_fnc_recruitUnitVehicle", "warning"] call DGCore_fnc_log;
		}; 
		uiSleep 5;
		_vehicle move _targetPos;
		_vehicleGroup move _targetPos;
	};
	
	if(side _targetPlayer isEqualTo _side) then
	{	
		_playerGroup = [_vehicleGroup, _targetPlayer] call DGCore_fnc_assignGroupToPlayer;
	};
};

_vehicle