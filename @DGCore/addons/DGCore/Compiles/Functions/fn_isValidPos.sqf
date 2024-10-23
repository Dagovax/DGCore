/*
    DGCore_fnc_isValidPos

    Purpose: Validate a position based on various constraints such as proximity to water, steep terrain, nearby missions, players, and other factors.

    Parameters:
        _pos: The position to validate. If not provided or invalid, the function returns false.				| Optional -> Defaults to [-1, -1, -1].

    Example:
        _isValid = [_pos] call DGCore_fnc_isValidPos;

    Returns: Boolean (true if the position is valid, false if it's too close to a restricted area).

    Copyright 2024 by Dagovax
*/

private ["_pos"];
params [["_pos", [-1,-1,-1]]];

if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	false
};

private _isValidPos = false;

try
{
	if ((count _pos) < 2) then
	{
		throw ("(UNDEFINED POSITION)");
	};

	if ((count _pos) isEqualTo 2) then
	{
		_pos set [2, 0];
	};

	// Check for nearby blaclisted positions
	if (DGCore_BlacklistNearDistance > 0) then
	{
		{
			private _distance = _x distance2d _pos;
			if(_distance <= DGCore_BlacklistNearDistance) throw "a blacklisted location";
		} forEach DGCore_BlacklistPositions;
	};

	// Check for nearby water
	if ((DGCore_MinWaterNearDistance > 0) && {[_pos] call DGCore_fnc_isNearWater}) throw "water";

	// Terrain steepness check
	// 0 surfacenormal means completely vertical, 1 surfaceNormal means completely flat and horizontal.
	// Take the arccos of the surfaceNormal to determine how many degrees it is from the horizontal. In SQF: {acos ((surfaceNormal _pos) select 2)}. Don't forget to define _pos.
	if ((DGCore_MinSurfaceNormal > 0) && {DGCore_MinSurfaceNormal <= 1}) then
	{
		if (((surfaceNormal _pos) select 2) < DGCore_MinSurfaceNormal) throw "a steep location";

		// Check the surrounding area (within 5 meters)
		private "_dir";
		for "_dir" from 0 to 359 step 45 do
		{
			if (((surfaceNormal (_pos getPos [5,_dir])) select 2) < DGCore_MinSurfaceNormal) throw "a nearby steep location";
		};
	};
	
	// Check A3XAI nearby missions
	{
		if (((getMarkerPos _x) distance2D _pos) <= DGCore_MinMissionDistance) throw "an A3XAI mission";
	} forEach (missionNamespace getVariable ["A3XAI_mapMarkerArray",[]]);
	
	// Check all map markers or other missions
	{
		private _markerType = markertype _x;

		// Check for nearby spawn points
		if ((_markerType in DGCore_SpawnZoneMarkerTypes) && {((getMarkerPos _x) distance2D _pos) <= DGCore_MinSpawnZoneDistance}) throw "a spawn zone";

		// Check for nearby trader zones
		if ((_markerType in DGCore_TraderZoneMarkerTypes) && {((getMarkerPos _x) distance2D _pos) <= DGCore_MinTraderZoneDistance}) throw "a trader zone";

		// Check for nearby concrete mixers
		if ((_markerType in DGCore_MixerMarkerTypes) && {((getMarkerPos _x) distance2D _pos) <= DGCore_MinMixerDistance}) throw "a concrete mixer";

		// Check for nearby contaminated zones
		if ((_markerType in DGCore_ContaminatedZoneMarkerTypes) && {((getMarkerPos _x) distance2D _pos) <= DGCore_ContaminatedZoneNearDistance}) throw "a contaminated zone";

		// Check for nearby missions
		if (DGCore_MinMissionDistance > 0) then
		{
			_missionPos = missionNamespace getVariable [format ["%1_pos",_x], []];
			if (!(_missionPos isEqualTo []) && {(_missionPos distance2D _pos) <= DGCore_MinMissionDistance}) throw "a DMS mission";

			if
			(
				(
					((_x find "DGCore_") >= 0)							// Look in the marker string for the DGCore marker prefix
				)
				&&
				{((getMarkerPos _x) distance2D _pos )<= DGCore_MinMissionDistance}	// Then check if the marker is close to the position
			) throw "a DGCore mission";

			if
			(
				(
					((_x find "ZCP_CM_dot_") >= 0)							// Look in the marker string for the ZCP marker prefix
					||
					{(_x find "VEMFr_DynaLocInva_ID") >= 0}					// Look in the marker string for the VEMF marker prefix
				)
				&&
				{((getMarkerPos _x) distance2D _pos)<= DGCore_MinMissionDistance}	// Then check if the marker is close to the position
			) throw "a VEMF or ZCP mission";
		};
	} forEach allMapMarkers;
	
	// Check for nearby players
	if (DGCore_MinPlayerDistance > 0) then
	{
		private _nearbyPlayers = [_pos, DGCore_MinPlayerDistance] call DGCore_fnc_getNearbyPlayers;
		if(count _nearbyPlayers > 0) throw "a player";
	};

	// Check for nearby territories. This is done last because it is likely to be the most resource intensive.
	if ((DGCore_MinTerritoryDistance > 0) && {[_pos, DGCore_MinTerritoryDistance] call ExileClient_util_world_isTerritoryInRange}) throw "a territory";
	
	// No exceptions found
	_isValidPos	= true;
} catch
{
	_isValidPos = false;
	[format["Position %1 is too close to %2!", _pos, _exception], "DGCore_fnc_isValidPos", "debug"] call DGCore_fnc_log;
};

_isValidPos


