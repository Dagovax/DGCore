/*

	DGCore_fnc_addIdleMonitor

	Purpose: monitors a vehicle idle position and removes true when it is idle for too long

	Parametsrs:
		_vehicle: vehicle object to add monitor too
		_refuel: automatically refuel the vehicle when it was stuck
		_repair: automatically repairs the vehicle when it was stuck

	Example: _variableToCheck = [_vehicle] call DGCore_fnc_addIdleMonitor;

	Returns: Variable added to this vehicle. Will be set to 'true' when the vehicle has been idle for too long, 'false' otherwise

	Copyright 2023 by Dagovax
*/
params [["_vehicle", objNull], ["_refuel", false], ["_repair", false]];
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

[_variable, _vehicle, _vicName, _refuel, _repair, _spawnPos] spawn
{
	params[["_variable", ""],["_vehicle", objNull], ["_vicName", ""], ["_refuel", false], ["_repair", false], "_spawnPos"];
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
		_currentPos = getPos _vehicle;				
		if (!alive _vehicle) exitWith
		{
			_vehicle setVariable [_variable, true];
		}; 
		if ((_currentPos distance2D _idlePosition) <= 25) then 
		{
			_idleTimer = _idleTimer + 20;
			if (_idleTimer > (_idleTimeWarning * _idleTimeLog)) then
			{
				_idleTimeLog = _idleTimeLog + 1;
				[format["The %1 is stuck! Idle now for %2 seconds (max=%3)! Current pos= %4", _vicName, _idleTimer, 120, _currentPos], "DGCore_fnc_addIdleMonitor", "warning"] call DGCore_fnc_log;
				[_vehicle] call DGCore_fnc_unFlipVehicle; // Checks if vehicle needs to be flipped and does unflip
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