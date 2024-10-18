/*

	DGCore_fnc_addGroupWaypoints

	Purpose: spawns an AI group at given coordinates

	Parameters:
		_side: 	Group side
		_pos: 	Position to spawn
		_count: 

	Example: ["I am being logged", "DG RoamingAI", "information"] call DGCore_fnc_log;

	Returns: created Group 

	Copyright 2023 by Dagovax
*/

private ["_group", "_pos"];
params["_group", ["_pos", [-1,-1,-1]], ["_difficulty", "normal"]];
if(_pos isEqualTo [-1,-1,-1] || isNil "_group") exitWith
{
	[format["Not enough valid params to add group waypoints! -> _pos = %1 | _group = %2", _pos, _group], "DGCore_fnc_addGroupWaypoints", "error"] call DGCore_fnc_log;
};

private _radius = 40;

switch (toLowerANSI _difficulty) do 
{
	case "low":
	{
		_radius = DGCore_AI_WP_Radius_easy;
	};
	case "medium":
	{
		_radius = DGCore_AI_WP_Radius_normal;
	};
	case "high":
	{
		_radius = DGCore_AI_WP_Radius_hard;
	};
	case "veteran":
	{
		_radius = DGCore_AI_WP_Radius_extreme;
	};
};

// Remove all previous waypoints
for "_i" from count (waypoints _group) to 1 step -1 do
{
	deleteWaypoint ((waypoints _group) select _i);
};

// Add waypoints around the center position.
for "_i" from 0 to 359 step 45 do
{
	private _npos = _pos getPos [_radius,_i];
	private _wp = _group addWaypoint [_npos,5];
	_wp setWaypointType "MOVE";
};

_wp = _group addWaypoint [_pos,0];
_wp setWaypointType "CYCLE";

true 