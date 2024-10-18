/*

	DGCore_fnc_moveGroupInVehicle

	Purpose: Moves group inside vehicle (as transport or complete).

	Parametsrs:
		_group: 			Group
		_targetVehicle: 	Target vehicle
		_asTransport: 		Move this group into any slot which is not the driver seat. Also adds the '_DGTransportGroup' variable to the target vehicle.	|	Optional
		_teleport:			If true, units will be teleported into their seats. If set to false, units need to enter the target vehicle by foot.			|	Optional
		_deleteRemaining:	If there are no more seats, delete the remaining units in the group.															|	Optional -> Default false

	Example: [_group, _heli, true, false] call DGCore_fnc_moveGroupInVehicle;

	Copyright 2023 by Dagovax
*/
params["_group", "_targetVehicle", ["_asTransport", false], ["_teleport", true], ["_deleteRemaining", false]];
if(isNil "_group" || isNil "_targetVehicle") exitWith
{
	[format["Not enough valid params to move group inside target vehicle! -> _group = %1 | _targetVehicle = %2", _group, _targetVehicle], "DGCore_fnc_moveGroupInVehicle", "error"] call DGCore_fnc_log;
};
if(isNull _group || isNull _targetVehicle) exitWith
{
	[format["Not enough valid params to move group inside target vehicle! -> _group = %1 | _targetVehicle = %2", _group, _targetVehicle], "DGCore_fnc_moveGroupInVehicle", "error"] call DGCore_fnc_log;
};

_moveGroupCode = [_group, _targetVehicle, _asTransport, _teleport, _deleteRemaining];
_moveGroupCode spawn
{
	params["_group", "_targetVehicle", "_asTransport", "_teleport", "_deleteRemaining"];
	_units = units _group;
	_vehicleName = getText (configFile >> "CfgVehicles" >> (typeOf _targetVehicle) >> "displayName");
	
	_driverFree = 0;
	if(!_asTransport) then
	{
		_driverFree = _targetVehicle emptyPositions "Driver";
	};
	_commanderFree = _targetVehicle emptyPositions "Commander";
	_gunnerFree = _targetVehicle emptyPositions "Gunner";
	_turretFree = _targetVehicle emptyPositions "Turret";
	
	_turretPaths = allTurrets _targetVehicle;
	
	if((count _turretPaths) > _turretFree) then
	{
		[format["There are more Turret Paths %1 (count: %2) than turret seats (count: %3)? This is weird. Anyway, resized the array.", _turretPaths, count _turretPaths, _turretFree], "DGCore_fnc_moveGroupInVehicle", "debug"] call DGCore_fnc_log;
		_turretPaths resize _turretFree;
	};
	if((count _turretPaths) > 0) then
	{
		[format["Available turret paths for %1 = %2", _vehicleName, _turretPaths], "DGCore_fnc_moveGroupInVehicle", "debug"] call DGCore_fnc_log;
	};
	
	_cargoFree = _targetVehicle emptyPositions "Cargo";

	{ // Assign units to the aircraft and let them move in
		_assigned = false;
		_assignedTo = "";
		
		if(_driverFree > 0 && !_assigned && !_asTransport) then
		{
			if(_teleport) then
			{
				_x moveInDriver _targetVehicle;
			} else
			{
				_x assignAsDriver _targetVehicle;
				[_x] orderGetIn true;
			};
			_assigned = true;
			_assignedTo = "driver";
			_driverFree = _driverFree - 1;
		};	
		if(_commanderFree > 0 && !_assigned) then
		{
			if(_teleport) then
			{
				_x moveInCommander _targetVehicle;
			} else
			{
				_x assignAsCommander _targetVehicle;
				[_x] orderGetIn true;
			};
			_assigned = true;
			_assignedTo = "commander";
			_commanderFree = _commanderFree - 1;
		};
		if (_gunnerFree > 0 && !_assigned) then
		{
			if(_teleport) then
			{
				_x moveInGunner _targetVehicle;
			} else
			{
				_x assignAsGunner _targetVehicle;
				[_x] orderGetIn true;
			};
			_assigned = true;
			_assignedTo = "gunner";
			_gunnerFree = _gunnerFree - 1;
		};
		if (_turretFree > 0 && !_assigned) then
		{	
			_turretPath = _turretPaths select 0;
			if(!isNil "_turretPath") then
			{
				if(_teleport) then
				{
					_x moveInTurret [_targetVehicle, _turretPath];
				} else
				{
					_x assignAsTurret [_targetVehicle, _turretPath];
					[_x] orderGetIn true;
				};
				_assigned = true;
				_assignedTo = format ["turret %1", _turretPath];
				_turretFree = _turretFree - 1;
				_turretPaths deleteAt 0;
				
				if(_x == (vehicle _x)) then
				{
					_assigned = false;
					unassignVehicle _x;
				};
			};
		};
		if (_cargoFree > 0 && !_assigned) then
		{
			if(_teleport) then
			{
				_x moveInCargo _targetVehicle;
			} else
			{
				_x assignAsCargo _targetVehicle;
				[_x] orderGetIn true;
			};
			_assigned = true;
			_assignedTo = "cargo";
			_cargoFree = _cargoFree - 1;
		};
		if((_driverFree == 0 && _commanderFree == 0 && _gunnerFree == 0 && _turretFree == 0 && _cargoFree == 0) || !_assigned || (isNull (assignedVehicle _x)) || ((isNull objectParent _x))) then
		{
			if(_assignedTo == "") then
			{
				_assignedTo = "none";
			};
			[format["Unit %1 has not been assigned to any seat! -> _driverFree = %2 | _commanderFree = %3 | _gunnerFree = %4 | _turretFree = %5 | _cargoFree = %6 | _assignedTo = %7", _x, _driverFree, _commanderFree, _gunnerFree, _turretFree, _cargoFree, _assignedTo], "DGCore_fnc_moveGroupInVehicle", "warning"] call DGCore_fnc_log;
			if(_deleteRemaining) then
			{
				[_x] spawn
				{
					params["_unit"];
					[_unit] orderGetIn false;
					unassignVehicle _unit;
					uiSleep 2;
					[format["Deleted unit %1", _unit], "DGCore_fnc_moveGroupInVehicle", "debug"] call DGCore_fnc_log;
					deleteVehicle _unit;
				};
			};
		};
		if(alive _x) then
		{
			[format["Assigned %1 to the %2 with position %3", _x, _vehicleName, _assignedTo], "DGCore_fnc_moveGroupInVehicle", "debug"] call DGCore_fnc_log;
			//waitUntil {vehicle _x == _x};
			[format["%1 is now in the %2", _x, _vehicleName], "DGCore_fnc_moveGroupInVehicle", "debug"] call DGCore_fnc_log;
		};
	} forEach _units;
	
	// Assign this group as transport variable of the vehicle. Required for unload (heli drop)
	if(_asTransport) then
	{
		_targetVehicle setVariable ["_DGTransportGroup", _group];
	} else
	{
		_targetVehicle setVariable ["_DGVehicleGroup", _group];
	};
};