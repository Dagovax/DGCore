/*
	DGCore_fnc_getWaypointRadiusByLevel

	Purpose: Convert input string into waypoint radius

	Parameters:
		_level:		The input string. Choose between ->		LOW | MEDIUM | HIGH | VETERAN

	Example: private _radius = ["low"] call DGCore_fnc_getWaypointRadiusByLevel;

	Return: A radius to be used for patrol waypoints

	Copyright 2024 by Dagovax
*/

private ["_level", "_radius"];
params["_level"];

if(isNil "_level") then
{
	_level = "normal";
};

_radius = 40;

switch (toLowerANSI _level) do 
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

_radius
