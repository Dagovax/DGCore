/*
    DGCore_fnc_createMarkers
    Purpose: Creates a marker on the map with a given set of parameters. The marker can either be an icon or a shape (ellipse/rectangle).

    Parameters:
        _missionName: 		The mission name used in the marker's unique identifier.
        _markerPos: 		The position of the marker on the map.
        _markerLabel: 		The label text for the marker.
        _markerColor: 		The color of the marker.
        _markerType: 		The type of marker (icon, "ELLIPSE", or "RECTANGLE").
        _markerSize: 		The size of the marker, used for non-icon markers (default is [0, 0]).
        _markerBrush: 		The brush style for the marker (default is "SolidBorder").

    Returns: An array of the created marker and label marker.

    Copyright 2024 by Dagovax
*/

private ["_markers", "_marker1", "_marker2", "_marker3"];
params
[
	"_missionName",  								// The mission name used when creating the marker. Must be unique.
	"_markerPos",									// Position
	"_markerLabel",  								// Text used to label the marker
	["_markerType", "ELLIPSE"],						// Use either the name of the icon or "ELLIPSE" or "RECTANGLE" where non-icon markers are used
	["_markerSize",[325,325]],						// Marker size
	["_markerBrush","SolidBorder"],					// Marker brush (for area)
	["_markerColor", DGCore_MarkerColor], 			// Marker color
	["_markerTextColor", DGCore_MarkerTextColor]  	// Marker text color
];

if (toUpper(_markerType) in ["ELLIPSE","RECTANGLE"]) then // not an Icon .... 
{
	_marker1 = createMarker [format ["DGCore_%1_%2_%3", _missionName, _markerPos select 0, _markerPos select 1], _markerPos];
	_marker1 setMarkerShape _markerType;
	_marker1 setMarkerColor _markerColor;
	_marker1 setMarkerBrush _markerBrush;
	_marker1 setMarkerSize _markerSize;
	
	_marker2 = createMarker [format ["DGCore_%1_%2_%3_label", _missionName, _markerPos select 0, _markerPos select 1], _markerPos];
	_marker2 setMarkerType "mil_dot";
	_marker2 setMarkerColor _markerTextColor;
	_marker2 setMarkerText _markerLabel;	
	
	_marker3 = createMarker [format ["DGCore_%1_%2_%3_dot", _missionName, _markerPos select 0, _markerPos select 1], _markerPos];
	_marker3 setMarkerType "mil_dot";
	_marker3 setMarkerColor "ColorBlack";
	
	_markers = [_marker1, _marker2, _marker3];	
} else 
{
	_marker1 = "";
	_marker3 = "";
	
	_marker2 = createMarker [format ["DGCore_%1_%2_%3_label", _missionName, _markerPos select 0, _markerPos select 1], _markerPos];
	_marker2 setMarkerType _markerType;
	_marker2 setMarkerColor _markerColor;
	_marker2 setMarkerText _markerLabel;
	
	_markers = [_marker, _marker2, _marker3];	
};

_markers
