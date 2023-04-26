/*

	DGCore_fnc_addMarkerMonitor

	Purpose: monitors a vehicle idle position without a driver and kills it after certain period of time

	Parametsrs:
		_vehicle: vehicle object to add monitor too
		_killTime: time in seconds until the kill of the vehicle exist
		_cleanUpTime: time in seconds after the _killTime the vehicle will be deleted

	Example: [_vehicle] call DGCore_fnc_addMarkerMonitor;

	Returns: Variable added to this vehicle. Will be set to 'true' when the vehicle has been idle for too long, 'false' otherwise

	Copyright 2023 by Dagovax
*/
params [["_vehicle", objNull], ["_markerType", "mil_unknown_noShadow"], ["_markerSize", 0.6], ["_markerColor", "ColorCIV"]];
if(isNull _vehicle) exitWith
{
	[format["Not enough valid params to add vehicle marker checker! -> _vehicle = %1", _vehicle], "DGCore_fnc_addMarkerMonitor", "error"] call DGCore_fnc_log;
};

[_vehicle, _markerType, _markerSize, _markerColor] spawn
{
	params ["_vehicle", "_markerType", "_markerSize", "_markerColor"];
	_pos = getPos _vehicle;
	_vicName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
	private _marker = createMarker [format ["%1_%2_%3", "DGCorevehicle", _pos select 0, _pos select 1], _pos];
	_marker setMarkerType _markerType;
	_marker setMarkerText _vicName;
	_marker setMarkerColor _markerColor;
	_marker setMarkerSize [_markerSize, _markerSize];
	
	while {alive _vehicle && !isNull _vehicle} do
	{
		if(count fullCrew _vehicle > 0) then
		{
			_marker setMarkerAlpha 1;
			_newPos = getPos _vehicle;
			_marker setMarkerPos _newPos;
		} else
		{
			_marker setMarkerAlpha 0;
		};
		uiSleep 2;
	};
	deleteMarker _marker;
};