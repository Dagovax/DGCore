/*

	DGCore_fnc_addIdleMonitor

	Purpose: monitors a vehicle idle position and removes true when it is idle for too long

	Parameters:
		_vehicle: 			Vehicle object to add monitor too
		_refuel: 			Automatically refuel the vehicle when it was stuck
		_repair: 			Automatically repairs the vehicle when it was stuck
		_forcePlaceOnRoad: 	Forces vehicle to be placed on nearby road, facing target direction

	Example: _variableToCheck = [_vehicle] call DGCore_fnc_addIdleMonitor;

	Returns: Variable added to this vehicle. Will be set to 'true' when the vehicle has been idle for too long, 'false' otherwise

	Copyright 2024 by Dagovax
*/
params [["_vehicle", objNull], ["_refuel", false], ["_repair", false], ["_forcePlaceOnRoad", false], ["_targetPos", [-1,-1,-1]]];
if(isNull _vehicle) exitWith
{
	[format["Not enough valid params to add idle checker to vehicle! -> _vehicle = %1", _vehicle], "DGCore_fnc_addIdleMonitor", "error"] call DGCore_fnc_log;
};
private ["_vehicle", "_refuel", "_repair"];
private _variable = "DGCore_idleMonitorVariable";
_vehicle setVariable [_variable, false];
if(!alive _vehicle) exitWith
{
	[format["Tried to add idle check monitor to destroyed vehicle!"], "DGCore_fnc_addIdleMonitor", "warning"] call DGCore_fnc_log;
	_vehicle setVariable [_variable, true];
};

_vicName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");

_spawnPos = getPos _vehicle; // Get the initial pos;

[_variable, _vehicle, _vicName, _refuel, _repair, _forcePlaceOnRoad, _targetPos, _spawnPos] spawn
{
	params[["_variable", ""],["_vehicle", objNull], ["_vicName", ""], ["_refuel", false], ["_repair", false], ["_forcePlaceOnRoad", false], ["_targetPos", [-1,-1,-1]], "_spawnPos"];
	if(isNull _vehicle) exitWith
	{
		if(DGCore_EnableLogging) then
		{
			[format["Not enough valid params to add idle monitor! -> _vehicle = %1", _vehicle], "DGCore_fnc_addIdleMonitor", "error"] call DGCore_fnc_log;
		};
	};
	[format["Main loop for vehicle [%1] idle time checker now active", _vicName], "DGCore_fnc_addIdleMonitor", "debug"] call DGCore_fnc_log;
	_idleTimer = 0;
	_idleTimeWarning = 20;
	_idleTimeLog = 1; // Factor of above to count how much time it is logged already...
	_idlePosition =  getPos _vehicle;
	
	while {true} do
	{	
		if(isNull _vehicle) exitWith{};
		_currentPos = getPos _vehicle;			
		if (!alive _vehicle) exitWith
		{
			_vehicle setVariable [_variable, true];
		}; 
		_handled = _vehicle getVariable [_variable, false];
		if(_handled)exitWith{}; // Idle monitor already handled. Exit this loop
		if ((_currentPos distance2D _idlePosition) <= 25) then 
		{
			_idleTimer = _idleTimer + 20;
			
			_isRepairing = _vehicle getVariable ["DGCore_vehicleIsRepairing", false];
			
			if (!_isRepairing && _idleTimer > (_idleTimeWarning * _idleTimeLog)) then
			{
				_idleTimeLog = _idleTimeLog + 1;
				[format["The %1 is stuck! Idle now for %2 seconds (max=%3)! Current pos= %4", _vicName, _idleTimer, 120, _currentPos], "DGCore_fnc_addIdleMonitor", "warning"] call DGCore_fnc_log;

				_nearbyPlayers = [getPos _vehicle, 500] call DGCore_fnc_getNearbyPlayers;
				
				// Only unflip vehicle and place on road when no players are nearby!
				if(count _nearbyPlayers <= 0) then
				{
					[_vehicle] call DGCore_fnc_unFlipVehicle; // Checks if vehicle needs to be flipped and does unflip
					
					if(_forcePlaceOnRoad) then
					{
						[_vehicle, _targetPos, true] call DGCore_fnc_placeVehicleOnRoad;
						_idlePosition = getPos _vehicle; // Update idle position to new spawned coords...
					};
				};
			};
		}
		else
		{
			_idlePosition = _currentPos;
			_idleTimer = 0; // Reset the idle timer.
			if(_idleTimeLog > 1) then // Log that the vehicle is not idle anymore
			{
				[format["The %1 is not idle anymore. Current pos= %2", _vicName, _currentPos], "DGCore_fnc_addIdleMonitor", "debug"] call DGCore_fnc_log;
			};
			_idleTimeLog = 1; // Reset idle time logger
			_vehicle setVariable [_variable, false];
		};
		
		if(_refuel) then
		{
			_vehicle setFuel 1;
		};
		if(_repair) then
		{
			_vehicle setDamage 0; // repair
		};
		uiSleep 20;
		_newPos = getPos _vehicle;
		if((_spawnPos distance2D _newPos) <= 10) exitWith
		{
			[format["The %1 did not move at all from starting position %2 -> %3. Idle return true!", _vicName, _spawnPos, _newPos], "DGCore_fnc_addIdleMonitor", "debug"] call DGCore_fnc_log;
			_vehicle setVariable [_variable, true]; // Initial idle
		};
		if (_idleTimer >= 120) exitWith
		{
			_vehicle setVariable [_variable, true];
		};
	};
};

_variable 