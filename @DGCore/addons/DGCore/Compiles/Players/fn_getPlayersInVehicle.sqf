/*
	DGCore_fnc_getPlayersInVehicle

	Purpose: retrieve players that are crew of a certain vehicle

	Parameters:
		_vehicle, vehicle object

	Example: [_vehicle] call DGCore_fnc_getPlayersInVehicle;

	Return: Array 
*/

params[["_vehicle", objNull]];
if(isNull _vehicle) exitWith
{
	[format["Not enough valid params to find players in a vehicle! -> _vehicle isEqualTo = %1", _vehicle], "DGCore_fnc_getPlayersInVehicle", "error"] call DGCore_fnc_log;
};
private _playersInVehicle = [];
{
	if(alive _x) then
	{
		if(isPlayer _x) exitWith
		{
			_playersInVehicle pushBack _x;
		};
		_unit = _x;
		{
			if(_unit isKindOf _x) exitWith
			{
				_playersInVehicle pushBack _unit;
			};
		} forEach DG_playerUnitTypes;
	};
} forEach crew _vehicle;

_playersInVehicle
