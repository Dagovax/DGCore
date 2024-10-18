/*

	DGCore_fnc_addEventHandlers

	Purpose: adds eventhandlers to spawned AI

	Parameters:
		_unit: AI unit
		_killed: Add the MPKILLED event handler to this unit. DEFAULT=true

	Example: [_unit, true] call DGCore_fnc_addEventHandlers;

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
			if (!isServer || hasInterface) exitWith {}; // Only execute code on server
			
			if(DGCore_EnableDeadSound) then
			{
				private _dummy = [getPos _unit] call DGCore_fnc_getDummy;
				if(!isNil "_dummy" && !isNull _dummy) then
				{
					[_dummy] spawn
					{
						params ["_dummy"];
						uiSleep 1.5;
						[_dummy, [(selectRandom DGCore_DeadSound), 100, 1]] remoteExec ["say3d", 0, true]; // Kill/dead sound of this unit. Use dummy because dead soldiers can't say anything
						uiSleep 10;
						deleteVehicle _dummy;
					};
				};
			};
			
			_group = group _unit;
			// if (isNull _killer || {isNull _instigator}) exitWith {};
			if (side _group == DGCore_playerSide) then // This unit is from the same side as the player. 
			{
				private _targetPlayer = _unit getVariable ["_DGCore_targetPlayer", objNull]; // Moved code to unit.
				if(isNull _targetPlayer) then
				{
					_targetPlayer = [_group] call  DGCore_fnc_getPlayerGroupLeader;
				};
				
				if(!isNull _targetPlayer) then
				{
					private _left = [_group] call DGCore_fnc_countAI;
											
					if(DGCore_EnableKillSound) then
					{
						if(_left > 0) then // Only sound this when at least 1 ally is alive
						{
							[(selectRandom DGCore_AllyLostSound)] remoteExec ["playSound",_targetPlayer]; // An ally died
						};
					};
					
					if(DGCore_EnableKillMessage) then
					{						
						private _msg = switch (_left) do
						{
							case 0: 
							{
								format
								[
									"%1 lost final group member %2!",
									name _targetPlayer, 
									name _unit
								]; 
							};
							case 1: 
							{
								format
								[
									"%1 lost group member %2! Only %3 group member left!",
									name _targetPlayer, 
									name _unit,
									_left
								]; 
							};
							default
							{
								format
								[
									"%1 lost group member %2! Only %3 group members left!",
									name _targetPlayer, 
									name _unit,
									_left
								]; 
							};
						};

						[_msg] remoteExec["systemChat",-2];
					};
				};
			} else
			{				
				_instigatorIsPlayer = false;
				if(isPlayer _instigator) then
				{
					_instigatorIsPlayer = true;
				};
				if(!_instigatorIsPlayer) then
				{
					{
						if(_instigator isKindOf _x) then
						{
							_instigatorIsPlayer = true;
						};
					} forEach DG_playerUnitTypes;
				};
				if (_instigatorIsPlayer) then
				{
					if(DGCore_EnableKillMessage) then
					{
						if(DGCore_EnableKillSound) then
						{
							[(selectRandom DGCore_EnemyKillSound)] remoteExec ["playSound",_instigator];
						};
						_killerVehicle = objectParent _instigator;
						private ["_killerWeapon", "_weaponMsg", "_killDistance", "_distMsg"];
						_killDistance = _unit distance _instigator;
						if(!isNull _killerVehicle) then
						{
							_killerWeapon = getText (configFile >> "CfgVehicles" >> (typeOf _killerVehicle) >> "displayName");
						}
						else
						{
							_killerWeapon = getText(configFile >> "CfgWeapons" >> currentWeapon _instigator >> "displayName");
						};
						if(isNil "_killerWeapon" || _killerWeapon isEqualTo "") then
						{
							_weaponMsg = "";
						} else
						{
							_weaponMsg = format[" with %1", _killerWeapon];
						};
						
						if(isNil "_killDistance" || _killDistance isEqualTo "") then
						{
							_distMsg = "";
						} else
						{
							_distMsg = format[" at %1 meters", round(_killDistance)];
						};
						
						_msg = format[
							"%1 killed %2 (AI)%3%4!",
							name _instigator, 
							name _unit, 
							_weaponMsg,
							_distMsg
						];
						[_msg] remoteExec["systemChat",-2];
					};

					[_instigator, 25] call DGCore_fnc_giveTakeTabs; // Increase the Poptabs for this player
					[_instigator, 50] call DGCore_fnc_giveTakeRespect; // Increase the Respect for this player
				} else
				{
					// Check if intigator is in player group
					private _instigatorGroup = group _instigator;
					private _targetPlayer = _instigator getVariable ["_DGCore_targetPlayer", objNull]; // Moved code to unit.
					if(isNull _targetPlayer) then
					{
						_targetPlayer = [_instigatorGroup] call  DGCore_fnc_getPlayerGroupLeader;
					};
					if(!isNull _targetPlayer && (_targetPlayer in units _instigatorGroup)) then // Target Player is part of this group
					{
						if(DGCore_EnableKillMessage) then
						{
							if(DGCore_EnableKillSound) then
							{
								[(selectRandom DGCore_EnemyKillSound)] remoteExec ["playSound",_targetPlayer];
							};
							_killerVehicle = objectParent _instigator;
							private ["_killerWeapon", "_weaponMsg", "_killDistance", "_distMsg"];
							_killDistance = _unit distance _instigator;
							if(!isNull _killerVehicle) then
							{
								_killerWeapon = getText (configFile >> "CfgVehicles" >> (typeOf _killerVehicle) >> "displayName");
							}
							else
							{
								_killerWeapon = getText(configFile >> "CfgWeapons" >> currentWeapon _instigator >> "displayName");
							};
							if(isNil "_killerWeapon" || _killerWeapon isEqualTo "") then
							{
								_weaponMsg = "";
							} else
							{
								_weaponMsg = format[" with %1", _killerWeapon];
							};
							
							if(isNil "_killDistance" || _killDistance isEqualTo "") then
							{
								_distMsg = "";
							} else
							{
								_distMsg = format[" at %1 meters", round(_killDistance)];
							};
							
							_msg = format[
								"%1 (AI group member of %2) killed %3 (AI)%4%5!",
								name _instigator,
								name _targetPlayer,
								name _unit, 
								_weaponMsg, 
								_distMsg
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
