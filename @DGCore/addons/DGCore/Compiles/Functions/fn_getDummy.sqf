/*

	DGCore_fnc_getDummy

	Purpose: Create a dummy object, to be used for mission parameters

	Parameters:
		_position:  Position of the dummy object. 							| 	Optional -> Defaults to DG_mapCenter
		_invisible: Make object invisible to players						| 	Optional -> Default true

	Example: _newDummy = call DGCore_fnc_getDummy;

	Returns: New dummy object

	Copyright 2024 by Dagovax
*/

private ["_position", "_invisible"];  // Declare variables private to avoid scope conflicts
params[["_position", [-1,-1,-1]], ["_invisible", true]];
if(typeName _position != "ARRAY" || _position isEqualTo [-1,-1,-1]) then
{
	_position = DG_mapCenter;
	_invisible = true;
	[format["Creating default dummy @ %1", _position], "DGCore_fnc_getDummy", "debug"] call DGCore_fnc_log;
} else
{
	//[format["Creating dummy @ %1", _position], "DGCore_fnc_getDummy", "debug"] call DGCore_fnc_log;
};

private["_dummy"];

// Ensure the position has 3 elements (x, y, z), with z = 0 if missing
if (count _position == 2) then {
    _position pushBack 0;
};

_dummy = createVehicle [DGCore_DummyObjectClass, _position, [], 0, "NONE"];
_dummy enableSimulationGlobal false;
_dummy setVelocity [0, 0, 0];
_position set [2, -1.5]; // A bit under ground
_dummy setPos _position;
if(_invisible) then
{
	hideObjectGlobal _dummy;
};

_dummy 
