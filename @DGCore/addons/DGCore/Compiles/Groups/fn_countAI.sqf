/*

	DGCore_fnc_countAI

	Purpose: counts the alive units of a Group that are not of the player's type

	Parameters:
		_group: Group to count

	Example: [_group] call DGCore_fnc_countAI;

	Returns: group count

	Copyright 2024 by Dagovax
*/

params[["_group", grpNull]];
if(isNil "_group" || isNull _group) exitWith { 0 }; // Null group. Return 0

private "_count";

private _aliveAllies = [];
{
	if (alive _x) then
	{
		private _locUnit = _x;
		private _isPlayer = false;
		{
			if(_locUnit isKindOf _x) then
			{
				_isPlayer = true;
			};
		} forEach DG_playerUnitTypes;
		if(!_isPlayer) then
		{
			_aliveAllies pushBack _locUnit;
		};
	};
} forEach units _group;
_count = count _aliveAllies;

_count
