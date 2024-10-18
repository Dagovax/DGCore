/*

	DGCore_fnc_getObjectHeight

	Purpose: Get an object height

	Parameters:
		_obj: 		Object
		_useReal:	Use real bounding box method				| Optional -> Default true

	Example: _objHeight = [_vehicle] call DGCore_fnc_getObjectHeight;

	Returns: Maximum height value of the bounding box

	Copyright 2024 by Dagovax
*/

params["_obj", ["_useReal", true]];
if (isNil "_obj" || isNull _obj) exitWith
{
	[format["Not enough valid params to calculate object height! -> _obj isEqualTo = %1", _obj], "DGCore_fnc_getObjectHeight", "error"] call DGCore_fnc_log;
};

private _objBoundingBox = boundingBox _obj;
if(_useReal) then
{
	_objBoundingBox = boundingBoxReal _obj;
};

private _p1 = _objBoundingBox select 0;
private _p2 = _objBoundingBox select 1;
private _maxHeight = abs ((_p2 select 2) - (_p1 select 2));

if(_maxHeight < 0) then
{
	_maxHeight = 0;
};

_maxHeight 