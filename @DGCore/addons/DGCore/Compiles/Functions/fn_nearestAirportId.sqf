/*

	DGCore_fnc_nearestAirportId

	Purpose: To get the nearest ID of airport (to be used for landAt)

	Parametsrs:
		_center: position to start searching from. Defaults to DG_mapCenter

	Example: _airportID = [_center] call DGCore_fnc_nearestAirportId;

	Returns: nearest airport ID

	Copyright 2023 by Dagovax
*/

params[["_center", DG_mapCenter]];
if(_center isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to find nearest airport! -> _center isEqualTo = %1 = %2", _center], "DGCore_fnc_nearestAirportId", "error"] call DGCore_fnc_log;
};
private _world = configfile >> "CfgWorlds" >> worldname;
private _index = 0;
private _closestDist = 1000000;
private _airportId = -1;

_checkAirport =
{
	params ["_ilspos"];
	private _p = getArray _ilspos;
	private _dist = _p distance2D _center;
	if(_dist < _closestDist) then
	{
		_airportId = _index;
		_closestDist = _dist;
	};
	_index = _index + 1;
};

(_world >> "ilsPosition") call _checkAirport;
_secondaries = _world >> "SecondaryAirports";

for "_i" from 0 to (count _secondaries - 1) do
{
	_airport = _secondaries select _i;
	(_airport >> "ilsPosition") call _checkAirport;
};

_airportId
