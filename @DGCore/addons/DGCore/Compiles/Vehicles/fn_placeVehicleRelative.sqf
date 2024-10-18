/*

	DGCore_fnc_placeVehicleRelative

	Purpose: Moves a vehicle relative to a certain object.

	Parameters:
		_vehicle: 		Vehicle to move
		_relObj: 		Object to spawn vehicle on
		_offset: 		(Optional) Height offset above the target object | Default 0
		_absolutePos:	(Optional) Use the absolute position of the target object. No length calculations will be done | Default true
		_careful:		(Optional) Place vehicle on position with damage disabled. Will be set back if not already done | Default true		
		_backwards:		(Optional) We calculate the length of the vehicle. If length is bigger than _relObj length, we move the _vehicle a bit forward. Set this to true to place it backwards instead (relative to the object) | Default false

	Example: [_car, _road, 1, false] call DGCore_fnc_placeVehicleRelative;

	Copyright 2024 by Dagovax
*/

params[["_vehicle", objNull], ["_relObj", objNull], ["_offset", 0], ["_absolutePos", true], ["_careful", true], ["_backwards", false]];
if(isNull _vehicle || isNull _relObj) exitWith
{
	[format["Not enough valid params place vehicle on relative object! -> _vehicle = %1 | _relObj = %2", _vehicle, _relObj], "DGCore_fnc_placeVehicleRelative", "error"] call DGCore_fnc_log;
};
private ["_vehicle", "_relObj", "_offset", "_absolutePos", "_careful", "_backwards", "_objBoundingBox", "_objBBMax", "_objBBMin", "_objBBLength", "_vecDirecton", "_vecUp", "_position", "_isDamageAllowed", "_vehicleBoundingBox", "_vehicleBBMax", "_vehicleBBMin", "_vehicleLength"];
_objBoundingBox = boundingBox _relObj;
_objBBMax = _objBoundingBox select 1;
_objBBMin = _objBoundingBox select 0;
_objBBLength = (_objBBMax select 1) - (_objBBMin select 1);
_vecDirecton = vectorDir _relObj;
_vecUp = vectorUp _relObj;
_position = getPosATL _relObj;
_isDamageAllowed = isDamageAllowed _vehicle;
_invincableSet = false;

if(_careful && _isDamageAllowed) then
{
	_vehicle allowDamage false;
	_invincableSet = true;
};

_vehicle setVectorDir _vecDirecton;
_vehicle setVectorUp _vecUp;

_vehicleBoundingBox = boundingBox _vehicle;
_vehicleBBMax = _vehicleBoundingBox select 1;
_vehicleBBMin = _vehicleBoundingBox select 0;
_vehicleLength = (_vehicleBBMax select 1) - (_vehicleBBMin select 1);

if (!_absolutePos) then
{
	if(_vehicleLength > _objBBLength) then
	{
		_diff = (_vehicleLength - _objBBLength);
		if(_backwards) then
		{
			_position = _relObj getRelPos [-(_diff/2), 0];
		} 
		else
		{
			_position = _relObj getRelPos [(_diff/2), 0];
		};
	};
};

[_vehicle, [_position select 0, _position select 1, _offset]] call DGCore_fnc_setPosAGLS;

if(_careful && _invincableSet) then
{
	_vehicle allowDamage true;
};

[format["Moved the (%1) to position of object (%2). New position @ %3", _vehicle, _relObj, getPos _vehicle], "DGCore_fnc_placeVehicleRelative", "debug"] call DGCore_fnc_log;