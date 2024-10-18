/*
    DGCore_fnc_deleteMarkers
    Purpose: Delete markers created by DGCore_fnc_createMarkers.

    Parameters:
        _markers: Array of created marker strings that were created with DGCore_fnc_createMarkers.

    Returns: 
        True if at least one marker was deleted, false otherwise.

    Example:
        // Example usage to delete an array of markers
        private _markers = ["marker1", "marker2", "marker3"];
        private _result = [_markers] call DGCore_fnc_deleteMarkers;
        if (_result) then {
            hint "Markers deleted!";
        } else {
            hint "No markers were deleted.";
        };

    Copyright 2024 by Dagovax
*/

private ["_markers", "_deletedMarkers"];
params [["_markers", []]];

if(_markers isEqualTo [] || (typeName _markers != "ARRAY")) exitWith { false };

_deletedMarkers = false;  // Keep track of whether any marker was deleted

{
    // Check if the marker string is valid (not empty)
    if !(_x isEqualTo "") then {
        // Check if the marker actually exists by verifying its color is not an empty string
        if !(getMarkerColor _x == "") then {
            deleteMarker _x;  // Delete the marker
            _deletedMarkers = true;  // Mark that we deleted at least one marker
        };
    };
} forEach _markers;

_deletedMarkers  // Return true if any marker was deleted, false otherwise
