/*

	DGCore_fnc_createEdenConvertedBase

	Purpose: Spawn buildings from Eden array to the position. Will use the first building as relative point. Returns base objects

	Parameters:
		_buildings: Array of buildings in Eden exported format (Exile)
		_pos: 		Position

	Example: _baseBuildings = [_buildings, [10200,10200,0]] call DGCore_fnc_createEdenConvertedBase;

	Returns: Spawned buildings in array

	Copyright 2024 by Dagovax
*/

private["_buildings", "_pos"];
params["_buildings", ["_pos", [-1,-1,-1]]];
if(isNil "_buildings") exitWith{
	[format["Not enough valid params to convert Eden base! -> _buildings = undefined"], "DGCore_fnc_createEdenConvertedBase", "error"] call DGCore_fnc_log;
};
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to convert Eden base! -> _pos = %1", _pos], "DGCore_fnc_createEdenConvertedBase", "error"] call DGCore_fnc_log;
};

// Calculate the center position of all the objects
private _sumX = 0;
private _sumY = 0;
private _count = count _buildings;
{
    private _objPos = _x select 1;
    _sumX = _sumX + (_objPos select 0);  // Sum X values
    _sumY = _sumY + (_objPos select 1);  // Sum Y values
} forEach _buildings;

// Calculate the average X and Y values to find the center point
private _centerX = _sumX / _count;
private _centerY = _sumY / _count;

private ["_baseObjects","_firstObjectPos","_firstObjectX","_firstObjectY","_xChange","_yChange","_pos", "_buildings"];
_baseObjects = [];

_xChange = _pos select 0;
_yChange = _pos select 1;

{
	private ["_obj", "_objClass", "_objPos", "_objNewPos", "_dir", "_terrainHeight"];
	_objClass = _x select 0;
	_objPos = [((_x select 1) select 0), ((_x select 1) select 1), 0];
	
	_objNewPos = [((_objPos select 0) - _centerX + _xChange), ((_objPos select 1) - _centerY + _yChange),(_objPos select 2)];
	_obj = createVehicle [_objClass, _objNewPos, [], 0, "CAN_COLLIDE"];
	_obj allowDamage false;
	_dir = [(_x select 2)] call DGCore_fnc_vectorToRotation;
	_obj setDir _dir;
	
	_terrainHeight = getTerrainHeightASL [_objNewPos select 0, _objNewPos select 1];
	
	_obj setPosASL [_objNewPos select 0, _objNewPos select 1, _terrainHeight];
		
	[_obj] call DGCore_fnc_setVectorUp;
	[_obj] call DGCore_fnc_addUnderTerrainMonitor;
	
	_obj setVelocity [0, 0, 0];
	
	_baseObjects pushBack _obj;
} forEach _buildings;

_baseObjects
