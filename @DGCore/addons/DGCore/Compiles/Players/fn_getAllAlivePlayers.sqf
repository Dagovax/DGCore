/*
	DGCore_fnc_getAllAlivePlayers

	Purpose: Retrieve players all alive players

	Example: private _alivePlayers = call DGCore_fnc_getAllAlivePlayers;

	Return: Array 
*/

private _alivePlayers = [];

_alivePlayers = allPlayers select {alive _x};

if(_alivePlayers isEqualTo [] || count _alivePlayers == 0) then
{
	_alivePlayersCore = nearestObjects [DG_mapCenter, DG_playerUnitTypes, DG_mapRadius, true] select{alive _x}; // Select alive units
	if(count _alivePlayersCore > 0) then
	{
		_alivePlayers = _alivePlayersCore;
	};
};

_alivePlayers
