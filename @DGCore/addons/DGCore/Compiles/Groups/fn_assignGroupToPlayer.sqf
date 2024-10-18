/*

	DGCore_fnc_assignGroupToPlayer

	Purpose: Adds all units from input group to the target's group

	Parameters:
		_group: 			(Old) Group
		_targetPlayer:		Target player
		
	Example: [_group, _targetPlayer] call DGCore_fnc_assignGroupToPlayer;

	Copyright 2024 by Dagovax
*/
params["_group", "_targetPlayer"];
if(isNil "_group" || isNil "_targetPlayer") exitWith
{
	[format["Not enough valid params to change group assignment! -> _group = %1 | _targetPlayer = %2", _group, _targetPlayer], "DGCore_fnc_assignGroupToPlayer", "error"] call DGCore_fnc_log;
};
if(isNull _group || isNull _targetPlayer) exitWith
{
	[format["Null reference exception! -> _group = %1 | _targetPlayer = %2", _group, _targetPlayer], "DGCore_fnc_assignGroupToPlayer", "error"] call DGCore_fnc_log;
};
_playerGroup = group _targetPlayer;
[_group, _playerGroup, name _targetPlayer] spawn // Update the leader of the unit
{
	params["_group", "_playerGroup", "_targetPlayerName"];
	while {true} do
	{
		if(isNull _group || isNull _playerGroup || count(units _playerGroup) < 1) exitWith{};
		
		(units _group) joinSilent _playerGroup;	
		
		_groupLeader = leader _playerGroup;
		if (name _groupLeader isEqualTo _targetPlayerName) then
		{
			_playerGroup selectLeader _groupLeader;
		} else
		{
			_allPlayers = call BIS_fnc_listPlayers;
			{
				if(name _x isEqualTo _targetPlayerName) exitWith
				{
					if (group _x isEqualTo _playerGroup) then
					{
						_playerGroup selectLeader _x;
					} else
					{
						(units _playerGroup) joinSilent (group _x);
					};
				};
			} forEach _allPlayers;
		};
		uiSleep 10;
	};
};

_playerGroup