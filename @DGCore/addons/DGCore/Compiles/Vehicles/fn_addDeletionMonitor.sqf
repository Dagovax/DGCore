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
params [["_vehicle", objNull], ["_killTime", 120], ["_cleanUpTime", DGCore_CleanupTime]];
if(isNull _vehicle) exitWith
{
	[format["Not enough valid params to add vehicle kill checker! -> _vehicle = %1", _vehicle], "DGCore_fnc_addDeletionMonitor", "error"] call DGCore_fnc_log;
};

[_vehicle, _killTime, _cleanUpTime] spawn
{
	params ["_vehicle", "_killTime", "_cleanUpTime"];
	waitUntil { unitReady _vehicle};
	[format["Started deletion monitor for: _vehicle = %1 | _killTime = %2 | _cleanUpTime = %3", _vehicle, _killTime, _cleanUpTime], "DGCore_fnc_addDeletionMonitor", "debug"] call DGCore_fnc_log;
	_killTimer = 0;
	_vehicleKilled = false;
	if(_killTime > 0) then
	{
		while {!isNull _vehicle && alive _vehicle} do
		{
			_playerInVehicle = false;
			{
				if(alive _x) then
				{
					_unit = _x;
					{
						if(_unit isKindOf _x) exitWith
						{
							_playerInVehicle = true;
						};
					} forEach DG_playerUnitTypes;
				};
				if(_playerInVehicle) exitWith{};
			} forEach crew _vehicle;
			if(_playerInVehicle) exitWith{}; // Player entered the vehicle
			
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
	
	_cleanUpTimer = 0;
	while {!isNull _vehicle} do
	{
		if(isNull _vehicle) exitWith{}; // Someone cleaned the vehicle already
		
		_playerInVehicle = false;
		{
			if(alive _x) then
			{
				_unit = _x;
				{
					if(_unit isKindOf _x) exitWith
					{
						_playerInVehicle = true;
					};
				} forEach DG_playerUnitTypes;
			};
			if(_playerInVehicle) exitWith{};
		} forEach crew _vehicle;
		if(_playerInVehicle) exitWith{}; // Player entered the vehicle
		
		if(_cleanUpTimer >= _cleanUpTime) exitWith
		{
			deleteVehicleCrew _vehicle;
			deleteVehicle _vehicle;
		};
		
		uiSleep 5;
		_cleanUpTimer = _cleanUpTimer + 5;
	};
};