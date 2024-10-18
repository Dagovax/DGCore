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
params [["_vehicle", objNull], ["_markerType", "mil_unknown_noShadow"], ["_markerSize", 0.6], ["_markerColor", "ColorCIV"], ["_markerText", ""], ["_checkVariable", []]];
if(isNull _vehicle) exitWith
{
	[format["Not enough valid params to add vehicle marker checker! -> _vehicle = %1", _vehicle], "DGCore_fnc_addMarkerMonitor", "error"] call DGCore_fnc_log;
};

[_vehicle, _markerType, _markerSize, _markerColor, _markerText, _checkVariable] spawn
{
	params ["_vehicle", "_markerType", "_markerSize", "_markerColor", "_markerText", "_checkVariable"];
	_pos = getPos _vehicle;
	_vicName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
	_randomNr = [1, 1000] call BIS_fnc_randomInt;
	_markerName = format ["%1_%2_%3_%4_#%5", "DGCorevehicle", _pos select 0, _pos select 1, typeof _vehicle, _randomNr];
	private _marker = createMarker [_markerName, _pos];
	_marker setMarkerType _markerType;
	if(isNil "_markerText" || _markerText isEqualTo "") then
	{
		_marker setMarkerText _vicName;
	} else
	{
		_marker setMarkerText _markerText;
	};
	_marker setMarkerColor _markerColor;
	_marker setMarkerSize [_markerSize, _markerSize];
	
	_vehicle setVariable ["DGCore_VehicleMarker", _marker];
	[format["Added marker monitor to the %1 (%2), with marker name = %3", _vehicle, _vicName, _markerName], "DGCore_fnc_addMarkerMonitor", "debug"] call DGCore_fnc_log;
	
	while {!isNull _vehicle && alive _vehicle} do
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
		if(isNull _vehicle || !alive _vehicle) exitWith{}; // vehicle already destroyed
		
		private _playersInVehicle = [_vehicle] call DGCore_fnc_getPlayersInVehicle;
		if(!isNil "_playersInVehicle" && ((count _playersInVehicle) > 0)) exitWith{}; // Player(s) inside this vehicle. Delete marker
		
		// Check variable
		private ["_varChecked"];
		if(!isNil "_checkVariable" && !(_checkVariable isEqualTo [])) then
		{
			_varChecked = _vehicle getVariable [_checkVariable select 0, !(_checkVariable select 1)]; // Get variable. Always default to the opposite of the expected result!
		};
		if(_varChecked isEqualTo (_checkVariable select 1)) exitWith
		{
			[format["Variable '%1' is set to '%2', so we need to delete this marker %3!", _checkVariable select 0, _checkVariable select 1, _markerName], "DGCore_fnc_addMarkerMonitor", "debug"] call DGCore_fnc_log;
		}; // Certain variable is set to their need. Delete marker
	};
	deleteMarker _marker;
};