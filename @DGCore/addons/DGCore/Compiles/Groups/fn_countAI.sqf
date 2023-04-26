/*

	DGCore_fnc_countAI

	Purpose: counts the alive units of a Group that are not of the player's type

	Parametsrs:
		_group: Group to count

	Example: [_group] call DGCore_fnc_countAI;

	Returns: group count

	Copyright 2023 by Dagovax
*/

params[["_group", grpNull]];
if(isNil "_group" || isNull _group) exitWith
{
	[format["Not enough valid params to count a group! -> _group = %1", _group], "DGCore_fnc_countAI", "error"] call DGCore_fnc_log;
};

private "_count";

_aliveAllies = [];
{
	if (alive _x) then
	{
		_locUnit = _x;
		_isPlayer = false;
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
