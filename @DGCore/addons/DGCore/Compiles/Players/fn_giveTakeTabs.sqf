/*
	DGCore_fnc_giveTakeTabs 

	Purpose: change amount of tabs for a player (not locker)

	Parameters:
		_player, the player for which to effect the change 
		_amtTabs, the change in tabs 

	Example: [_player, -10] call DGCore_fnc_giveTakeTabs;

	Return: None 

	CREDITS: Adapted from scripts by the ExileMod Development team 	
*/

params[["_player", objNull],["_amtTabs", 0]];
if(isNull _player || _amtTabs == 0) exitWith{}; // Nothing to update

if (toLowerANSI DGCore_modType == "exile") then
{
	private _tabs = _player getVariable ["ExileMoney", 0];
	_tabs = _tabs + _amtTabs;
	_player setVariable ["ExileMoney", _tabs, true];
	format["setPlayerMoney:%1:%2", _tabs, _player getVariable ["ExileDatabaseID", 0]] call ExileServer_system_database_query_fireAndForget;
	_player call ExileServer_object_player_sendStatsUpdate;
};
