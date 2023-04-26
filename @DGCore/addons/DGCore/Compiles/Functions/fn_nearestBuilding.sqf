/*

	DGCore_fnc_nearestBuilding

	Purpose: To get the nearest (enterable) building

	Parametsrs:
		_center: position to start searching from

	Example: _nearestHouse = [_center, 100] call DGCore_fnc_nearestBuilding;

	Returns: nearest enterable building object

	Copyright 2023 by Dagovax
*/

params[["_center", [-1,-1,-1]], ["_radius", 500]];
if(_center isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to find nearest building! -> _center isEqualTo = %1 | _radius = %2", _center, _radius], "DGCore_fnc_nearestBuilding", "error"] call DGCore_fnc_log;
};
private["_nearHouse"];

_houseObjects = nearestObjects [_center, ["House","building"], _radius];

if(isNil("_houseObjects"))exitWith{nil};
if((count _houseObjects)==0)exitWith{nil};

_buildings = [];
{
	if(str(_x buildingPos 0) != "[0,0,0]")then{_buildings set[(count _buildings),_x];};
	sleep 0.001;
}forEach _houseObjects;

if((count _buildings)==0)exitWith{nil};

_bld = _buildings select 0;
{
	if((_x distance _center)<(_bld distance _center))then{ _bld = _x; };
	sleep 0.001;
}forEach _buildings;
_nearHouse = _bld;

_nearHouse
