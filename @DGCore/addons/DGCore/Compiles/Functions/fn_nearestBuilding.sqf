/*

	DGCore_fnc_nearestBuilding

	Purpose: To get the nearest (enterable) building

	Parameters:
		_center: position to start searching from

	Example: _nearestHouse = [_center, 100] call DGCore_fnc_nearestBuilding;

	Returns: nearest enterable building object

	Copyright 2024 by Dagovax
*/

params[["_center", [-1,-1,-1]], ["_radius", 500]];
if(_center isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to find nearest building! -> _center isEqualTo = %1 | _radius = %2", _center, _radius], "DGCore_fnc_nearestBuilding", "error"] call DGCore_fnc_log;
};
private _nearHouse = objNull;

_houseObjects = nearestObjects [_center, ["House","Building"], _radius];
if(count _houseObjects > 0) then
{
	_buildings = [];
	{
		_allpositions = _x buildingPos -1;
		if(count _allpositions > 0) then
		{
			_buildings pushBack _x;
		};
	} forEach _houseObjects;

	if(count _buildings > 0) then
	{
		_bld = _buildings select 0;
		{
			if((_x distance _center) < (_bld distance _center))then
			{ 
				_bld = _x; 
			};
		} forEach _buildings;
		_nearHouse = _bld;
	};
};

_nearHouse
