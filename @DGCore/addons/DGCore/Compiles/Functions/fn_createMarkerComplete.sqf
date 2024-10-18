/*
    DGCore_fnc_createMarkerComplete
	
    Purpose: Creates a complete marker when a mission was succesfull. Will be deleted after 4 minutes

    Parameters:
        _position: 			The mission name used in the marker's unique identifier.
        _markerLabel: 		The label text for the marker.

    Copyright 2024 by Dagovax
*/

private ["_position"];
params ["_position", ["_markerLabel", ""]];

if(isNil "_position" || typeName _position != "ARRAY") exitWith{};

private _name = str(random(1000000)) + "DG_MarkerCleared"; 
private _m = createMarker [_name, _position];
_m setMarkerColor DGCore_MarkerCompleteColor;
_m setMarkerType "n_hq";

if(_markerLabel isEqualTo "") then
{
	_m setMarkerText "Mission Cleared";
} else
{
	_m setMarkerText format["Mission Cleared: %1", _markerLabel];
};

[_m] spawn
{
	params ["_m"];
	uiSleep 240;
	deleteMarker _m;
};

