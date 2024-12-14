/*

	DGCore_fnc_addDeletionMonitor

	Purpose: monitors a vehicle idle position without a driver and kills it after certain period of time

	Parametsrs:
		_vehicle: vehicle object to add monitor too
		_killTime: time in seconds until the kill of the vehicle exist
		_cleanUpTime: time in seconds after the _killTime the vehicle will be deleted

	Example: [_vehicle] call DGCore_fnc_addDeletionMonitor;

	Returns: Variable added to this vehicle. Will be set to 'true' when the vehicle has been idle for too long, 'false' otherwise

	Copyright 2023 by Dagovax
*/
private["_hasDeletionMonitor", "_vehicle", "_killTime", "_cleanUpTime"];
params [["_vehicle", objNull], ["_killTime", 120], ["_cleanUpTime", DGCore_CleanupTime]];
if(isNull _vehicle) exitWith
{
	[format["Deletion monitor was called to a vehicle that does not exist anymore! Skipping whole monitor.."], "DGCore_fnc_addDeletionMonitor", "warning"] call DGCore_fnc_log;
};
_hasDeletionMonitor = _vehicle getVariable ["DGCore_HasDeletionMonitor", false];
if(_hasDeletionMonitor) exitWith
{
	// Vehicle already has a deletion monitor. Do nothing
};

[_vehicle, _killTime, _cleanUpTime] spawn
{
	params ["_vehicle", "_killTime", "_cleanUpTime"];
	//waitUntil { unitReady _vehicle};
	[format["Started deletion monitor for: _vehicle = %1 | _killTime = %2 | _cleanUpTime = %3", _vehicle, _killTime, _cleanUpTime], "DGCore_fnc_addDeletionMonitor", "debug"] call DGCore_fnc_log;
	private _killTimer = 0;
	private _vehicleKilled = false;
	private _playerInVehicle = false;
	
	_vehicle setVariable ["DGCore_HasDeletionMonitor", true];
	_nearbyPlayers = [getPos _vehicle, 4000] call DGCore_fnc_getNearbyPlayers;
	if(count _nearbyPlayers <= 0) then
	{
		[format["No players nearby monitored vehicle for deletion [%1]! Setting _killTime to zero and ignoring vehicle explosion...", _vehicle], "DGCore_fnc_addDeletionMonitor", "debug"] call DGCore_fnc_log;
		_killTime = -1; // no players in range. No need to explode something. Delete vehicle instantly
	};
	
	if(_killTime >= 0) then
	{
		while {!isNull _vehicle && alive _vehicle} do
		{
			_playerInVehicle = false;
			_playersInVehicle = [_vehicle] call DGCore_fnc_getPlayersInVehicle;
			if(count _playersInVehicle > 0) exitWith
			{
				[format["Players %1 entered the %2. Deletion monitor for this vehicle discontinued!", _playerInVehicle, _vehicle], "DGCore_fnc_addDeletionMonitor", "information"] call DGCore_fnc_log;
				_playerInVehicle = true;
			};
			
			if(_killTimer >= _killTime) exitWith
			{
				_vehicle allowDamage true;
				_vehicle setDamage 1;
				_vehicleKilled = true;
			};
			
			uiSleep 5;
			_killTimer = _killTimer + 5;
		};
	};
	if(_playerInVehicle) exitWith
	{
		_vehicle setVariable ["DGCore_HasDeletionMonitor", false];
	}; // Already player in vehicle
	
	_cleanUpTimer = 0;
	while {!isNull _vehicle} do
	{
		if(isNull _vehicle) exitWith{}; // Someone cleaned the vehicle already
		
		_playerInVehicle = false;
		_playersInVehicle = [_vehicle] call DGCore_fnc_getPlayersInVehicle;
		if(count _playersInVehicle > 0) exitWith
		{
			[format["Players %1 entered the %2. Deletion monitor for this vehicle discontinued!", _playerInVehicle, _vehicle], "DGCore_fnc_addDeletionMonitor", "information"] call DGCore_fnc_log;
			_playerInVehicle = true;
			_vehicle setVariable ["DGCore_HasDeletionMonitor", false];
		};
		
		if(_cleanUpTimer >= _cleanUpTime) exitWith
		{
			deleteVehicleCrew _vehicle;
			deleteVehicle _vehicle;
		};
		
		uiSleep 5;
		_cleanUpTimer = _cleanUpTimer + 5;
	};
};