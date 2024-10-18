/*
    DGCore_fnc_addCrateMarker
    Purpose: Creates a marker on the map for a loot crate. Will be removed once crate moved.

    Parameters:
        _crate: 			Crate / container

    Copyright 2024 by Dagovax
*/

private ["_crate", "_cratePos", "_crateMarker"];
params ["_crate"];

_cratePos = position _crate;

_crateMarker = createMarker [format ["DG_CrateMarker_%1_%2", _cratePos select 0, _cratePos select 1], _cratePos];
_crateMarker setMarkerType DGCore_LootMarkerType;
_crateMarker setMarkerColor DGCore_LootMarkerColor;
_crateMarker setMarkerText "Mission Loot";

[_crate, _cratePos, _crateMarker] spawn
{
	params ["_crate", "_cratePos", "_crateMarker"];
	private _timer = 0;
	private _timeUp = false;
	
	// Loop to check for movement or timeout
	while {!_timeUp} do
	{
		uiSleep 2;  // Wait for 2 seconds each iteration

		// Check if the crate has been moved more than 10 meters from its original position
		if ((position _crate distance _cratePos) > 10) exitWith 
		{
			[format["Crate has been moved from its original position. Deleting marker."], "DGCore_fnc_addCrateMarker", "debug"] call DGCore_fnc_log;
			_timeUp = true;
		};

		// Check if the timer has exceeded the marker's up-time
		if (_timer >= DGCore_LootMarkerUpTime) exitWith 
		{
			[format["Crate marker time (%1) exceeded %2 seconds. Deleting marker.", _timer, DGCore_LootMarkerUpTime], "DGCore_fnc_addCrateMarker", "debug"] call DGCore_fnc_log;
			_timeUp = true;
		};
		
		_timer = _timer + 2;  // Increment the timer by 2 seconds per loop iteration
	};
	
	deleteMarker _crateMarker;
};

