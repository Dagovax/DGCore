/*

	DGCore_fnc_unFlipVehicle

	Purpose: Checks if a vehicle is flipped and unflips it back on its wheels

	Parametsrs:
		_vehicle: Vehicle object

	Example: [_vehicle] call DGCore_fnc_unFlipVehicle;

	Returns: None

	Copyright 2023 by Dagovax
*/

params["_vehicle"];
if(isNil "_vehicle" || isNull _vehicle) exitWith
{
	[format["Calling DGCore_fnc_unFlipVehicle with invalid parameters: %1", _vehicle]] call DGCore_fnc_log;
};

if(!alive _vehicle) exitWith{}; //If it is destroyed, no need to test

// Now check if it is flipped
(_vehicle call BIS_fnc_getPitchBank) params ["_vx","_vy"];
if (([_vx,_vy] findIf {_x > 80 || _x < -80}) != -1) then {	
	[_vehicle] spawn {
		private _vehicle = param [0, objNull, [objNull]];
		waitUntil {(_vehicle nearEntities ["Man", 10]) isEqualTo [] || !alive _vehicle};
		if (!alive _vehicle) exitWith {};
		_vehicle allowDamage false;
		_vehicle setVectorUp [0,0,1];
		_vehicle setPosATL [(getPosATL _vehicle) select 0, (getPosATL _vehicle) select 1, 0];
		_vehicle allowDamage true;
	};
};
