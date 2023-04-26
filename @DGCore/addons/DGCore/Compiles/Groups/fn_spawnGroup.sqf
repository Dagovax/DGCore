/*

	DGCore_fnc_spawnGroup

	Purpose: spawns an AI group at given coordinates

	Parametsrs:
		_message: message to be logged
		_scriptName: name of the calling script to be used in logging
		_type: 

	Example: ["I am being logged", "DG RoamingAI", "information"] call DGCore_fnc_log;

	Returns: created Group 

	Copyright 2023 by Dagovax
*/

params["_side", ["_pos", [0,0,0]], ["_count", 1], ["_targetPlayer", objNull], ["_isParaGroup", false]];
if("_pos" isEqualTo [0,0,0] || _count == 0 || isNil "_side") exitWith
{
	[format["Not enough valid params to spawn AI group! -> _pos = %1 | _count = %2 | _side = %3", _pos, _count, _side], "DGCore_fnc_spawnGroup", "error"] call DGCore_fnc_log;
};
private "_group";
if(_side == DGCore_playerSide) then
{
	if(!isNull _targetPlayer) then
	{
		_group = group _targetPlayer;
		
		[_group, name _targetPlayer] spawn // Update the leader of the unit
		{
			params["_group", "_targetPlayerName"];
			while {true} do
			{
				if(isNull _group || count(units _group) < 1) exitWith{};
				
				_groupLeader = leader _group;
				if (name _groupLeader isEqualTo _targetPlayerName) then
				{
					_group selectLeader _groupLeader;
				} else
				{
					_allPlayers = call BIS_fnc_listPlayers;
					{
						if(name _x isEqualTo _targetPlayerName) exitWith
						{
							if (group _x isEqualTo _group) then
							{
								_group selectLeader _x;
							} else
							{
								(units _group) joinSilent (group _x);
							};
						};
					} forEach _allPlayers;
				};
				uiSleep 10;
			};
		};
	} else
	{
		_group = createGroup _side;
	};
} else
{
	_group = createGroup _side;
};

_groupInfo = [_targetPlayer] call DGCore_fnc_getUnitInfo;
_skillList = _groupInfo select 0;
_calcCount = _groupInfo select 1;

if(!isNull _targetPlayer) then
{
	_group setVariable ["_DGCore_targetPlayer", _targetPlayer];
	
	// Calculate unit count bases on player level
	if(_count == -1) then
	{
		_count = (_calcCount call BIS_fnc_randomInt);
	};
};

for "_i" from 1 to _count do 
{
	[_pos, _group, nil, _isParaGroup, _skillList] call DGCore_fnc_spawnUnit; // Spawn unit in this group
};

_group
