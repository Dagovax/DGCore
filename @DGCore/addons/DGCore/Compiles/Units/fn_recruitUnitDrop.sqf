/*

	DGCore_fnc_recruitUnitDrop

	Purpose: call in one (or two when vehicle drop) helicopters that drop down allied troops

	Parametsrs:
		_class: 			Helicopter (aircraft) class
		_targetPlayer:		Player object to deliver the drop to.
		_distance:			Distance in m. away from the _targetPlayer to spawn helicopter
		_aiCount:			Number of AI units
		_aiLevel:			AI skill level
		_weapons:			Array of weapon classes
		_enableLauncher:	Enable launcher spawn
		_spawnHeight:		Spawn height of the heli
		_flyHeight:			Height in m the heli will fly
		_side:				Side of the unit drop.
		_vehicleDrop:		Array -> format [<true/false>, "<vehicleClass>"]
		_allowDamage:		Heli can be damaged/destroyed
		_setCaptive:		Heli will be ignored by other AI

	Example: 	-> 	["class", _player] call DGCore_fnc_recruitUnitDrop;
				->	["CUP_B_CH47F_GB", thePlayer, nil, nil, nil, 500, 150, 75, _side, [true, "I_MRAP_03_F"]] call DGCore_fnc_recruitUnitDrop;

	Copyright 2024 by Dagovax
*/

params["_class", "_targetPlayer", ["_distance", 2000], ["_aiCount", 5], ["_aiLevel", "calculate"], ["_weapons", DGBA_AIWeapons], ["_enableLauncher", DGCore_EnableLaunchers], ["_spawnHeight", 150], ["_flyHeight", 75], ["_side", DGCore_playerSide], ["_vehicleDrop", [false, ""]], ["_allowDamage", true], ["_setCaptive", false]];
if((isNil "_class") || (isNil "_targetPlayer") || (isNull _targetPlayer)) exitWith
{
	[format["Not enough valid params to spawn helicopter crop! -> _class = %1 | _targetPlayer = %2", _class, _targetPlayer], "DGCore_fnc_recruitUnitDrop", "error"] call DGCore_fnc_log;
};
_targetPosition = getPosATL _targetPlayer;
_heliDirection = random 360;
_spawnPosition =[(_targetPosition select 0) - (sin _heliDirection) * _distance, (_targetPosition select 1) - (cos _heliDirection) * _distance, (_targetPosition select 2) + _spawnHeight];

_executeDrops = [_class, _targetPlayer, _spawnPosition, _heliDirection, _distance, _aiCount, _aiLevel, _weapons, _enableLauncher, _spawnHeight, _flyHeight, _side, _vehicleDrop];
_executeDrops spawn
{
	params ["_class", "_targetPlayer", "_spawnPosition", "_heliDirection", "_distance", "_aiCount", "_aiLevel", "_weapons", "_enableLauncher", "_spawnHeight", "_flyHeight", "_side", "_vehicleDrop"];
	private["_helicopterTroop", "_helicopterVehicle"];
	if(_vehicleDrop select 0) then
	{
		_helicopterVehicle = [_class, _targetPlayer, [_spawnPosition select 0, _spawnPosition select 1, _spawnPosition select 2, _heliDirection], _distance, _spawnHeight, _flyHeight, _side, [true, (_vehicleDrop select 1)], false, true] call DGCore_fnc_spawnHeliDrop;
	};
	uiSleep 5;
	_helicopterTroop = [_class, _targetPlayer, [_spawnPosition select 0, _spawnPosition select 1, _spawnPosition select 2, _heliDirection], _distance, _spawnHeight, _flyHeight, _side, [false, ""], false, true] call DGCore_fnc_spawnHeliDrop;
	
	_troopGroup = [_side, _spawnPosition, _aiCount, nil, _aiLevel, _weapons, _enableLauncher] call DGCore_fnc_spawnGroup;
	[_troopGroup, (_helicopterTroop select 0), true, true, true] call DGCore_fnc_moveGroupInVehicle;
	
	_currTime = diag_tickTime;
	while {true} do // Wait until troops unloaded
	{
		_unloaded = _troopGroup getVariable ["_DGUnloaded", false]; 
		if(_unloaded) exitWith{}; // Group unloaded and is on the ground
		
		_timeRemaining = 300 - (diag_tickTime - _currTime);
		if ((_timeRemaining) < 0) exitWith // 5minutes of nothing. Delete group
		{
			{
				_x setDamage 1;
				deleteVehicle _x;
			} forEach units _troopGroup;
		};
		uiSleep 5;
	};

	if((_vehicleDrop select 0) && !isNil "_helicopterVehicle") then
	{
		_droppedVehicle = _helicopterVehicle select 1;
		if(!isNil "_droppedVehicle" && !isNull _droppedVehicle) then
		{
			_droppedVehicle allowDamage false;
			_droppedVehicle lock true;
			[_troopGroup, _droppedVehicle, false, false] call DGCore_fnc_moveGroupInVehicle;
			_troopCount = (count units _troopGroup);
			waitUntil { uiSleep 5; ((count fullCrew _droppedVehicle) > 0) };
			_droppedVehicle lock false;
			_droppedVehicle allowDamage true;
			
			_currTime = diag_tickTime;
			while {true} do // Wait until units are inside vehicle
			{
				if(((count fullCrew _droppedVehicle) == _troopCount) || ((count (fullCrew [_droppedVehicle, "", true])) == (count fullCrew _droppedVehicle))) exitWith{}; // All inside vehicle
				
				_timeRemaining = 20 - (diag_tickTime - _currTime);
				if ((_timeRemaining) < 0) exitWith{}; // time over. Continue code
				uiSleep 5;
			};

			_droppedVehicle move getPosATL _targetPlayer;
		};
	};
	_troopGroup move getPosATL _targetPlayer;
	if(side _targetPlayer isEqualTo _side) then
	{	
		_playerGroup = [_troopGroup, _targetPlayer] call DGCore_fnc_assignGroupToPlayer;
	};
};