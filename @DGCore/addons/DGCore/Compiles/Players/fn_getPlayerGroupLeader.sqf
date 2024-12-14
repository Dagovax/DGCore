/*
	DGCore_fnc_getPlayerGroupLeader

	Purpose: Finds the leader of a group, prioritizing player-controlled units. If the group leader is not a player, it searches for any player in the group.

	Parameters:
		_group: The group to find the leader from.

	Returns: 
		The player (or player-like unit) leading the group or `objNull` if no player is found.

	Copyright 2024 by Dagovax
*/

params[["_group", grpNull]];
if(isNull _group) exitWith
{
	//[format["Not enough valid params to find player group leader! -> _group == undefined"], "DGCore_fnc_getPlayerGroupLeader", "error"] call DGCore_fnc_log;
	objNull
};

private _player = objNull;

private _leader = leader _group;
if(isPlayer _leader) exitWith
{
	_leader
};

{
	if(alive _x) then
	{
		if(isPlayer _x) exitWith
		{
			_player = _x;
		};
		
		private _unit = _x;
		{
			if(_unit isKindOf _x) exitWith
			{
				_player = _unit;
			};
		} forEach DG_playerUnitTypes;
	};
} forEach units _group;

_player
