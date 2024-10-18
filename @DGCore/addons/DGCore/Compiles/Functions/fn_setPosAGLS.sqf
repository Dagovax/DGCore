/*

	DGCore_fnc_setPosAGLS

	Purpose: Set an object to AGLS format position

	Parameters:
		_obj: 		Object to move
		_pos: 		Position
		_offset: 	Offset

	Example: [_vehicle, [10,10,20], 30] call DGCore_fnc_setPosAGLS;

	Copyright 2024 by Dagovax
*/

params["_obj", "_pos", "_offset"];
_offset = _pos select 2;
if (isNil "_offset") then 
{
	_offset = 0;
};
if (isNil "_obj") exitWith
{
	[format["Not enough valid params to set position AGLS! -> _obj isEqualTo = %1", _obj], "DGCore_fnc_setPosAGLS", "error"] call DGCore_fnc_log;
};

_pos set [2, worldSize];
_obj setPosASL _pos;
_pos set [2, vectorMagnitude (_pos vectorDiff getPosVisual _obj) + _offset];
_obj setPosASL _pos;
[format["Moved the (%1) to position @ %2", _obj, _pos], "DGCore_fnc_setPosAGLS", "debug"] call DGCore_fnc_log;