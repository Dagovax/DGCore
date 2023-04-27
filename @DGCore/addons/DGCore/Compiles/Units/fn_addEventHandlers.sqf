/*

	DGCore_fnc_addEventHandlers

	Purpose: adds eventhandlers to spawned AI

	Parametsrs:
		_unit: AI unit
		_killed: Add the MPKILLED event handler to this unit. DEFAULT=true
		_player: Player object assigned to this _unit (part of his group or target)

	Example: [_unit, true, _player] call DGCore_fnc_addEventHandlers;

	Returns: None

	Copyright 2023 by Dagovax
*/

params[["_unit", objNull], ["_killed", true]];
if(isNull _unit || !alive _unit) exitWith
{
	[format["Tried to add event handlers to <NULL> unit (or dead)! -> _unit = %1", _unit], "DGCore_fnc_addEventHandlers", "error"] call DGCore_fnc_log;
};
if(_killed) then
{
	_unit addMPEventHandler ["MPKILLED",  
	{
		_this spawn
		{
			params ["_unit", "_killer", "_instigator"];
			_group = group _unit;
			// if (isNull _killer || {isNull _instigator}) exitWith {};
			if (side _group == DGCore_playerSide) then // This unit is from the same side as the player. 
			{
				_targetPlayer = _group getVariable "_DGCore_targetPlayer";
				if(!isNil "_targetPlayer" && !isNull _targetPlayer && DGCore_EnableKillMessage) then
				{
					_left = [_group] call DGCore_fnc_countAI;
					
					_msg = format[
						"%1 lost group member %2! Only %3 group member(s) left!",
						name _targetPlayer, 
						name _unit, 
						_left
					];
					[_msg] remoteExec["systemChat",-2];
				};
			} else
			{	
				_instigatorIsPlayer = false;
				{
					if(_instigator isKindOf _x) then
					{
						_instigatorIsPlayer = true;
					};
				} forEach DG_playerUnitTypes;
				if (_instigatorIsPlayer) then
				{
					if(DGCore_EnableKillMessage) then
					{
						["FD_CP_Clear_F"] remoteExec ["playSound",_instigator];
						_msg = format[
							"%1 killed %2 (AI) with %3 at %4 meters!",
							name _instigator, 
							name _unit, 
							getText(configFile >> "CfgWeapons" >> currentWeapon _instigator >> "displayName"), 
							_unit distance _instigator
						];
						[_msg] remoteExec["systemChat",-2];
					};

					[_instigator, 25] call DGCore_fnc_giveTakeTabs; // Increase the Poptabs for this player
					[_instigator, 50] call DGCore_fnc_giveTakeRespect; // Increase the Respect for this player
				} else
				{
					// Check if intigator is in player group
					_instigatorGroup = group _instigator;
					_targetPlayer = _instigatorGroup getVariable "_DGCore_targetPlayer";
					if(!isNil "_targetPlayer" && !isNull _targetPlayer && (_targetPlayer in units _instigatorGroup)) then
					{
						if(DGCore_EnableKillMessage) then
						{
							["FD_CP_Clear_F"] remoteExec ["playSound",_targetPlayer];
							_msg = format[
								"%1 (AI group member of %2) killed %3 (AI) with %4 at %5 meters!",
								name _instigator,
								name _targetPlayer,
								name _unit, 
								getText(configFile >> "CfgWeapons" >> currentWeapon _instigator >> "displayName"), 
								_unit distance _instigator
							];
							[_msg] remoteExec["systemChat",-2];
						};
						[_targetPlayer, 1] call DGCore_fnc_updatePlayerKills; // Increase the score for this player
						[_targetPlayer, 25] call DGCore_fnc_giveTakeTabs; // Increase the Poptabs for this player
						[_targetPlayer, 50] call DGCore_fnc_giveTakeRespect; // Increase the Respect for this player
					};
				};
			};
		};
	}];
};
