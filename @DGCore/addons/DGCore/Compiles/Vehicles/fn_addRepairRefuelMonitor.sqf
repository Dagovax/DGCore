/*

	DGCore_fnc_addRepairRefuelMonitor

	Purpose: monitors a vehicle idle position without a driver and kills it after certain period of time

	Parameters:
		_vehicle: vehicle object to add monitor too
		_killTime: time in seconds until the kill of the vehicle exist
		_cleanUpTime: time in seconds after the _killTime the vehicle will be deleted

	Example: [_vehicle] call DGCore_fnc_addDeletionMonitor;

	Returns: Variable added to this vehicle. Will be set to 'true' when the vehicle has been idle for too long, 'false' otherwise

	Copyright 2024 by Dagovax
*/
params [["_vehicle", objNull], ["_repair", true], ["_refuel", true], ["_repairAnim", false]];
if(isNull _vehicle) exitWith
{
	[format["Not enough valid params to add vehicle repair and refuel monitor! -> _vehicle = %1", _vehicle], "DGCore_fnc_addRepairRefuelMonitor", "error"] call DGCore_fnc_log;
};

[_vehicle, _repair, _refuel, _repairAnim] spawn
{
	params [["_vehicle", objNull], ["_repair", true], ["_refuel", true], ["_repairAnim", false]];
	private _playerDamagedVehicle = false;
	private _isRepairingVariable = "DGCore_vehicleIsRepairing";
	[format["Added repair and refuel monitor for the %1", _vehicle], "DGCore_fnc_addRepairRefuelMonitor", "debug"] call DGCore_fnc_log;
	
	_vehicle setVariable [_isRepairingVariable, false];
	
	while {!isNull _vehicle && alive _vehicle} do
	{
		_playersInVehicle = [_vehicle] call DGCore_fnc_getPlayersInVehicle;
		if(count _playersInVehicle > 0) exitWith
		{
			[format["Player(s) %1 entered the %2. Stopping this monitor!", _playersInVehicle, _vehicle], "DGCore_fnc_addRepairRefuelMonitor", "debug"] call DGCore_fnc_log;
		}; // Stop any repair/refuel command if a player enters this vehicle!
	
		if(count (crew _vehicle) < 1) exitWith
		{
			[format["This vehicle %1 has no crew inside! Stopping this monitor", _vehicle], "DGCore_fnc_addRepairRefuelMonitor", "debug"] call DGCore_fnc_log;
		}; // Nobody inside this vehicle!
	
		if(_refuel) then
		{
			_vehicle setFuel 1;
		};
	
		if (((_vehicle getHitPointDamage "HitEngine") > 0.8) || ((_vehicle getHitPointDamage "HitLFWheel") > 0.8) || ((_vehicle getHitPointDamage "HitLF2Wheel") > 0.8) || ((_vehicle getHitPointDamage "HitRFWheel") > 0.8) || ((_vehicle getHitPointDamage "HitRF2Wheel") > 0.8))then
		{
			// Engine or front wheels are damaged, so repair the vehicle
			if(_repair) then
			{
				[format["Vehicle %1 needs repair! Executing repairs now...", _vehicle], "DGCore_fnc_addRepairRefuelMonitor", "debug"] call DGCore_fnc_log;
				
				_nearbyPlayers = [getPos _vehicle, 1000] call DGCore_fnc_getNearbyPlayers;
				if(count _nearbyPlayers > 0 && _repairAnim) then
				{
					[format["Repair animation enabled, and enough player(s) %2 are nearby! So no instant repair this time...", _nearbyPlayers], "DGCore_fnc_addRepairRefuelMonitor", "debug"] call DGCore_fnc_log;
					private ["_repairUnit", "_isDriver"];
					while {true} do
					{
						_repairUnit = driver _vehicle;
						if(!isNull _repairUnit && alive _repairUnit) exitWith
						{
							_isDriver = true;
						};
						
						_repairUnit = selectRandom(crew _vehicle);
						if(!isNull _repairUnit && alive _repairUnit) exitWith
						{
							_isDriver = false;
						};
						
						if(isNull _vehicle || !alive _vehicle) exitWith{};
					};
					
					[format["Unit %1 is moving out to repair its assigned vehicle %2!", _repairUnit, _vehicle], "DGCore_fnc_addRepairRefuelMonitor", "debug"] call DGCore_fnc_log;
					
					if(!isNull _repairUnit && alive _repairUnit) then
					{
						_vehicle setVariable [_isRepairingVariable, true];
						
						doGetOut _repairUnit;
						uiSleep 2;
						//[_repairUnit] orderGetIn false;
						_vehiclePos = getPos _vehicle;
						_repairUnit doMove getPos _vehicle;
						
						waitUntil { ((_repairUnit distance _vehiclePos) < 5) || (not alive _repairUnit)};
						if !(_repairUnit isEqualTo objNull) then
						{
							if !(_vehicle isEqualTo objNull) then
							{
								_direction = [_repairUnit, _vehicle] call BIS_fnc_DirTo;
								_repairUnit setDir _direction;
							
								_repairUnit playMoveNow "Acts_carFixingWheel";
								_repairUnit disableAI "ANIM";
								uiSleep 10;
								if ((damage _repairUnit) < 1)then
								{
									if((damage _vehicle) < 1)then
									{
										_vehicle setDamage 0;
									};
								};
								_repairUnit enableAI "ANIM";
							};
						};
						
						if(alive _repairUnit && alive _vehicle) then
						{
							if(_isDriver) then
							{
								_repairUnit moveInDriver _vehicle;
							} else
							{
								[_repairUnit] orderGetIn true;
							};
							[format["Vehicle %1 repaired! Unit %2 is now ordered to get back in!", _vehicle, _repairUnit], "DGCore_fnc_addRepairRefuelMonitor", "debug"] call DGCore_fnc_log;
						};
						_vehicle setVariable [_isRepairingVariable, false];
						
						_endPos = _vehicle getVariable ["DGCore_doMoveEndPos", [-1,-1,-1]];
						if(!isNil "_endPos") then
						{
							if !(_endPos isEqualTo [-1,-1,-1]) then
							{
								_vehicle move _endPos; // Move vehicle to position
								uiSleep 5;
								if(unitReady _vehicle) then
								{
									_vehicle move _endPos; // Move vehicle to position
									if(alive _repairUnit) then
									{
										_repairUnit move _endPos; // Move vehicle to position
									} else
									{
										(group _vehicle) move _endPos;
									};
								};
							};
						};
					};
				} 
				else
				{
					_vehicle setDamage 0;
				};
			};
		};
	
		uiSleep 5;
	};
};