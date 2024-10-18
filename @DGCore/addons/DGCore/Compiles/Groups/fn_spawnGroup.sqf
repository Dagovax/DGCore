/*

	DGCore_fnc_spawnGroup

	Purpose: spawns an AI group at given coordinates

	Parameters:
		_side: 	Group side
		_pos: 	Position to spawn
		_count: 

	Example: ["I am being logged", "DG RoamingAI", "information"] call DGCore_fnc_log;

	Returns: created Group 

	Copyright 2023 by Dagovax
*/

params["_side", ["_pos", [0,0,0]], ["_count", -1], ["_targetPlayer", objNull], ["_aiLevel", "calculate"], ["_weapons", DGCore_AIWeapons], ["_enableLauncher", DGCore_EnableLaunchers], ["_isParaGroup", false]];
if(_pos isEqualTo [0,0,0] || isNil "_side") exitWith
{
	[format["Not enough valid params to spawn AI group! -> _pos = %1 | _count = %2 | _side = %3", _pos, _count, _side], "DGCore_fnc_spawnGroup", "error"] call DGCore_fnc_log;
};
if(_count isEqualTo -1 && isNull _targetPlayer) exitWith
{
	[format["Cannot spawn a group with random AI count because _count == -1. Having this set to -1 means 'calculate' with _targetPlayer. But _targetPlayer -> %1", _targetPlayer], "DGCore_fnc_spawnGroup", "error"] call DGCore_fnc_log;
};

private ["_group"];
if(_side == DGCore_playerSide) then
{
	if(!isNull _targetPlayer) then
	{
		_group = group _targetPlayer;
		_group setGroupOwner (owner _targetPlayer);
		
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

if(_aiLevel != "calculate") then
{
	_skillList = [_aiLevel] call DGCore_fnc_getUnitSkillByLevel;
};

if(!isNull _targetPlayer) then
{	
	// Calculate unit count bases on player level
	if(_count == -1) then
	{
		_count = (_calcCount call BIS_fnc_randomInt);
		if(_count < 1) then
		{
			_count = 1;
		};
	};
};

for "_i" from 1 to _count do 
{
	private _unit = [_pos, _group, nil, _isParaGroup, _skillList, _weapons, _enableLauncher] call DGCore_fnc_spawnUnit; // Spawn unit in this group
	_unit setVariable ["DGCore_targetPlayer", _targetPlayer];
};

_group selectLeader ((units _group) select 0);
_group setFormation "DIAMOND";

_group setCombatMode "RED";
_group setBehaviour "COMBAT";

if(!isNull _targetPlayer) then
{
	_group setVariable ["DGCore_targetPlayer", _targetPlayer];
};

_group
