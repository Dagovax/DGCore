/*

	DGCore_fnc_updatePlayerKills

	Purpose: provides a mechanism to update the logs of player kills of AI or other players 

	Parameters:
		_player, the player on which to effect the change 
		_newKills, number of new kills (typically 1)

	Example: [_player, 1] call DGCore_fnc_updatePlayerKills;

	Returns: None

	Copyright 2023 by Dagovax
	
	CREDITS: Adapted from scripts by the ExileMod Development team 
*/

params[["_player", objNull],["_newKills", 0]];
if(isNull _player || _newKills == 0) exitWith{}; // Nothing to update

switch (toLowerANSI DGCore_modType) do 
{
	case "epoch": {
		#define toClient true
		#define isTotal false
		[_player,"AIKills",_newKills, toClient, isTotal] call EPOCH_server_updatePlayerStats;
	};
	case "exile": {
		private _playerKills = _player getVariable ["ExileKills", 0];
		_player setVariable ["ExileKills", _playerKills + _newKills];
		format["addAccountKill:%1", getPlayerUID _player] call ExileServer_system_database_query_fireAndForget;
		_player call ExileServer_object_player_sendStatsUpdate;
	};
	_player addScore _newKills; // score board
};
