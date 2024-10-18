/*
	DGCore_fnc_getNearbyPlayers

	Purpose: retrieve players in a nearby radius

	Parameters:
		_pos, position to search
		_radius, radius to search

	Example: [DGCore_center, 1000] call DGCore_fnc_getNearbyPlayers;

	Return: Array 
*/

params[["_pos", [-1,-1,-1]], ["_radius", 250]];
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to find nearby players! -> _pos isEqualTo = %1 | _radius = %2", _pos, _radius], "DGCore_fnc_getNearbyPlayers", "error"] call DGCore_fnc_log;
};
private _nearbyPlayers = [];

_nearbyPlayers = allPlayers select {(_x distance _pos) < _radius && alive _x};

if(_nearbyPlayers isEqualTo [] || count _nearbyPlayers == 0) then
{
	_alivePlayers = nearestObjects [_pos, DG_playerUnitTypes, _radius, true] select{alive _x}; // Select alive units
	if(count _alivePlayers > 0) then
	{
		_nearbyPlayers = _alivePlayers;
	};
};

_nearbyPlayers
