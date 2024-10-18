/*

	DGCore_fnc_relativePosToAbsolutePos

	Purpose: Retrieve absolute position coords from relative position against static position. 

	Parameters:
		_basePos: position that will be used as base reference
		_relPos: relative position from the _basePos 
		_includeZ: also return absolute height. Default false

	Example: _absPos = [_basePos, _relPos] call DGCore_fnc_relativePosToAbsolutePos;

	Returns: Absolute pos in Array format [x, y, (z)]

	Copyright 2024 by Dagovax
*/

params[["_basePos", [-1,-1,-1]], ["_relPos", [-999,-999,-999]], ["_includeZ", false]];
if(_basePos isEqualTo [-1,-1,-1] || _relPos isEqualTo [-999,-999,-999]) exitWith
{
	[format["Not enough valid params to get relative position! -> _basePos = %1 | _relPos = %2 | _includeZ = %3", _basePos, _relPos, _includeZ], "DGCore_fnc_relativePosToAbsolutePos", "error"] call DGCore_fnc_log;
	[]
};
private _result = [];
private _newX = (_basePos select 0) + (_relPos select 0);
private _newY = (_basePos select 1) + (_relPos select 1);
_result pushBack _newX;
_result pushBack _newY;

if(_includeZ) then
{
	private _newZ = (_basePos select 2) + (_relPos select 2);
	_result pushBack _newZ;
};

_result