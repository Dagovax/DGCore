/*

	DGCore_fnc_nearestSettlement

	Purpose: To get the nearest settlement name as string

	Parameters:
		_pos: 			Position to start searching from
		_locationType:	Can be any Location type, or use:
							only_settlements 			= "CityCenter", "Strategic", "StrongpointArea", "NameVillage", "NameCity", "NameCityCapital"
							only_points_of_interests	= "nameLocal", "Area", "BorderCrossing", "Hill", "fakeTown", "Name", "RockArea", "ViewPoint"
							settlements_and_poi			= only_settlements + only_points_of_interests

	Example: _nearestCity = [_pos, "NameCity"] call DGCore_fnc_nearestSettlement;

	Returns: nearest enterable building object

	Copyright 2024 by Dagovax
*/
params[["_pos", [-1,-1,-1]], ["_locationType", "only_settlements"]];
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to find nearest building! -> _pos isEqualTo = %1", _pos], "DGCore_fnc_nearestSettlement", "error"] call DGCore_fnc_log;
};
private ["_nearestLocation", "_settlementName"];
// Find the nearest location

switch (_locationType) do
{
	case "only_settlements": 
	{
		_locationType = ["CityCenter", "Strategic", "StrongpointArea", "NameVillage", "NameCity", "NameCityCapital"];
	};
	case "only_points_of_interests": 
	{
		_locationType = ["nameLocal", "Area", "BorderCrossing", "Hill", "fakeTown", "Name", "RockArea", "ViewPoint"];
	};
	case "settlements_and_poi": 
	{
		_locationType = ["CityCenter", "Strategic", "StrongpointArea", "NameVillage", "NameCity", "NameCityCapital", "nameLocal", "Area", "BorderCrossing", "Hill", "fakeTown", "Name", "RockArea", "ViewPoint"];
	};
};

_nearestLocation = nearestLocation [_pos, _locationType];
_settlementName = text _nearestLocation;

_settlementName 