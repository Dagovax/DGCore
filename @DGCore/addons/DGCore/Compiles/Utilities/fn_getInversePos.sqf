/*

	DGCore_fnc_getInversePos

	Purpose: uses given position to receive the mirror position on the map. (Both X and Y flipped)

	Parameters: 
		_inputPosition: position to mirror.

	Example: [_center] call DGCore_fnc_getInversePos;

	Returns: mirrored position ATL

	Copyright 2023 by Dagovax
*/

params[["_inputPosition", [-1,-1,-1]]];
if(_inputPosition isEqualTo [-1,-1,-1]) exitWith
{
	[format["Invalid input parameter _inputPosition! -> _inputPosition isEqualTo = %1", _inputPosition], "DGCore_fnc_getInversePos", "error"] call DGCore_fnc_log;
};

private _resultPos = [0,0,0];
private _middle = worldSize/2;
_startX = _inputPosition select 0;
_startY = _inputPosition select 1;
_endPosX = 0;
_endPosY = 0;

if(_startX < _middle) then
{
	// X coord of spawnpos is lower than middle
	_diff = _middle - _startX;
	_endPosX = _diff + _middle;
};
if(_startX > _middle) then
{
	// X coord of spawnpos is higher than middle
	_diff = _startX - _middle;
	_endPosX = _middle - _diff;
};
if(_startX == _middle) then
{
	_endPosX = selectRandom [0, worldSize];
};
if(_startY < _middle) then
{
	// Y coord of spawnpos is lower than middle
	_diff = _middle - _startY;
	_endPosY = _diff + _middle;
};
if(_startY > _middle) then
{
	// Y coord of spawnpos is higher than middle
	_diff = _startY - _middle;
	_endPosY = _middle - _diff;
};
if(_startY == _middle) then
{
	_endPosY = selectRandom [0, worldSize];
};
_resultPos = [_endPosX, _endPosY, 0];

_resultPos