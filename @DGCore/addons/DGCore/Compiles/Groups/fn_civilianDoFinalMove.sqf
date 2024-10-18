/*

	DGCore_fnc_civilianDoFinalMove

	Purpose: moves a civilian unit to a position and deletes it when it reached the target

	Parameters:
		_unit: 				AI unit
		_pos:				Position the unit has to move to
		_completionRadius: 	Radius in which the move command will be completed 

	Example: [_unit, _pos] spawn DGCore_fnc_civilianDoFinalMove;
	
	Returns: None.

	Copyright 2024 by Dagovax
*/

params[["_unit", objNull], ["_pos", [-1,-1,-1]], ["_completionRadius", 20], ["_speedMode", "LIMITED"]];
if(isNull _unit || _pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to perform final civilian move! -> _unit = %1 | _pos = %2", _unit, _pos], "DGCore_fnc_civilianDoFinalMove", "error"] call DGCore_fnc_log;
};

[_unit, _pos, _completionRadius, _speedMode] spawn
{
	params[["_unit", objNull], "_pos", "_completionRadius", "_speedMode"];
	if(isNull _unit) exitWith{};
	
	_group = group _unit;
	_isOnFoot = isNull objectParent _unit;	
	if(!_isOnFoot) then
	{
		_vehicle = objectParent _unit;
		_unit leaveVehicle _vehicle;
		_group leaveVehicle _vehicle;
		{
			[_x] orderGetin false;
		} forEach units _group;
	};
	uiSleep 2;
	unassignVehicle _unit;
	_group setSpeedMode _speedMode;
	[format["%1 is now moving with speedMode [%2] to position %3!", _unit, _speedMode, _pos], "DGCore_fnc_civilianDoFinalMove", "information"] call DGCore_fnc_log;
	_unit move _pos;
	while {!isNull _unit && alive _unit} do
	{
		_exitLoop = false;
		_newPos = getPos _unit;
		_distance = _newPos distance2D _pos;
		if(unitReady _unit && _distance > _completionRadius) then
		{
			_unit move _pos;
			uiSleep 10;
			_waitPos = getPos _unit;
			_waitDistance = _waitPos distance2D _newPos;
			if(_waitDistance < 2) exitWith
			{
				_exitLoop = true;
			};
		};
		if(_exitLoop) exitWith{};
		// if(unitReady _unit) exitWith{};
		if (_distance < _completionRadius) exitWith{}; // To remove him looping in circles
		uiSleep 2;
	};
	{deleteVehicle _x;} forEach units _group;
	deleteGroup _group;
};




