/*

	DGCore_fnc_addGroupWaypoints

	Purpose: add group waypoints around given position

	Parameters:
		_group: 	Group
		_pos: 		Position to add waypoints around

	Example: [_group, _pos] call DGCore_fnc_addGroupWaypoints;

	Returns: True or false

	Copyright 2024 by Dagovax
*/

private ["_group", "_pos", "_canSwim"];
params["_group", ["_pos", [-1,-1,-1]], ["_difficulty", "normal"], ["_canSwim", false]];
if(_pos isEqualTo [-1,-1,-1] || isNil "_group") exitWith
{
	[format["Not enough valid params to add group waypoints! -> _pos = %1 | _group = %2", _pos, _group], "DGCore_fnc_addGroupWaypoints", "error"] call DGCore_fnc_log;
	false
};

private _radius = [_difficulty] call DGCore_fnc_getWaypointRadiusByLevel;

// Remove all previous waypoints
for "_i" from count (waypoints _group) to 1 step -1 do
{
	deleteWaypoint ((waypoints _group) select _i);
};

// Add waypoints around the center position.
for "_i" from 0 to 359 step 45 do
{
	private _npos = _pos getPos [_radius,_i];
	private _isNearWater = [_npos, 5] call DGCore_fnc_isNearWater;
	if(!_canSwim && _isNearWater) then 
	{
		continue; // Skips this waypoint if unit is not allowed to be in water.
	};
	private _wp = _group addWaypoint [_npos,5];
	_wp setWaypointBehaviour "COMBAT";
	_wp setWaypointCombatMode "RED";
	_wp setWaypointFormation "DIAMOND";
	_wp setWaypointSpeed "FULL";
	_wp setWaypointType "MOVE";
};

_wp = _group addWaypoint [_pos,0];
_wp setWaypointType "CYCLE";

true 