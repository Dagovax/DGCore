/*

	DGCore_fnc_absolutePosToRelativePos

	Purpose: Retrieve relative position coords from one position to another. 

	Parameters:
		_basePos: position that will be used as base reference
		_inputPos: position to calculate the relative position against _basePos 
		_includeZ: also return relative height. Default false

	Example: _relPos = [_basePos, _inputPos] call DGCore_fnc_absolutePosToRelativePos;

	Returns: Relative pos in Array format [x, y, (z)]

	Copyright 2024 by Dagovax
*/

params[["_basePos", [-1,-1,-1]], ["_inputPos", [-1,-1,-1]], ["_includeZ", false]];
if(_basePos isEqualTo [-1,-1,-1] || _inputPos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to get relative position! -> _basePos = %1 | _inputPos = %2 | _includeZ = %3", _basePos, _inputPos, _includeZ], "DGCore_fnc_absolutePosToRelativePos", "error"] call DGCore_fnc_log;
	[]
};
private _result = [];
private _newX = (_inputPos select 0) - (_basePos select 0);
private _newY = (_inputPos select 1) - (_basePos select 1);
_result pushBack _newX;
_result pushBack _newY;

if(_includeZ) then
{
	private _newZ = (_inputPos select 2) - (_basePos select 2);
	_result pushBack _newZ;
};

_result