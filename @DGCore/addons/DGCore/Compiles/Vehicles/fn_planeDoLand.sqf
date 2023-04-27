/*

	DGCore_fnc_planeDoLand

	Purpose: force a plane to land at an AirportID.

	Parametsrs:
		_plane: plane object to add monitor to.
		_airportID: airport the plane should land at.
		_ilsPosition: the approach airport ilsPosition

	Example: _variableToCheck = [_plane, 1, [10200,2034,22]] call DGCore_fnc_planeDoLand;

	Returns: Variable added to this plane. Will be set to 'true' when the plane landed at the airport, 'false' otherwise

	Copyright 2023 by Dagovax
*/
params [["_plane", objNull], ["_airportID", -1], ["_ilsPosition", [-1, -1, -1]]];
if(isNull _plane || _airportID isEqualTo -1 || _ilsPosition isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to add waypoint landAt checker to plane! -> _plane = %1 | _airportID = %2 | _ilsPosition = %3", _plane, _airportID, _ilsPosition], "DGCore_fnc_planeDoLand", "error"] call DGCore_fnc_log;
};
private ["_plane"];
private _variable = "DGCore_doLandVariable";
_plane setVariable [_variable, false];
if(!alive _plane) exitWith
{
	[format["Tried to add do land monitor to destroyed vehicle!"], "DGCore_fnc_planeDoLand", "warning"] call DGCore_fnc_log;
	_plane setVariable [_variable, true];
};

_vicName = getText (configFile >> "CfgVehicles" >> (typeOf _plane) >> "displayName");
[_variable, _plane, _airportID, _ilsPosition, _vicName] spawn
{
	params[["_variable", ""],["_plane", objNull], "_airportID", ["_ilsPosition", [-1, -1, -1]], ["_vicName", ""]];
	if(isNull _plane || _airportID isEqualTo -1 || _ilsPosition isEqualTo [-1,-1,-1]) exitWith
	{
		[format["Not enough valid params to add waypoint landAt checker to plane! -> _plane = %1 | _airportID = %2 | _ilsPosition = %3", _plane, _airportID, _ilsPosition], "DGCore_fnc_planeDoLand", "error"] call DGCore_fnc_log;
	};
	
	[format["Main loop for plane [%1] landAt checker", _vicName], "DGCore_fnc_planeDoLand", "debug"] call DGCore_fnc_log;

	_currentPos = getPos _plane;
	_height = _currentPos select 2;
	_distanceFromIls = _currentPos distance2D _ilsPosition;
	_plane landAt _airportID; // Initial land
	[format["The %1 is now on route to land on airport with Id [%2]. _height = %3 | _distanceFromIls = %4", _vicName, _airportID, _height, _distanceFromIls], "DGCore_fnc_planeDoLand", "information"] call DGCore_fnc_log;
	while {!isNull _plane && alive _plane && (count(crew _plane) > 0)} do
	{
		_currentPos = getPos _plane;
		_height = _currentPos select 2;
		_distanceFromIls = _currentPos distance2D _ilsPosition;
		if(_distanceFromIls <= 100) exitWith // Plane is landing
		{
			[format["The %1 is on its final approach -> _distanceFromIls = %2 | _height = %3", _vicName, _distanceFromIls, _height], "DGCore_fnc_planeDoLand", "debug"] call DGCore_fnc_log;
			waitUntil { unitReady _plane || !alive _plane};
			[format["The %1 succesfully landed At airport with ID %2!", _vicName, _airportID], "DGCore_fnc_planeDoLand", "debug"] call DGCore_fnc_log;
			_plane setVariable [_variable, true];
		};

		if(_height < 10 && _distanceFromIls > 100) then
		{
			[format["The %1 reached too low height (%4) and is too far from the landing point (%5)! Performing landAt command now at airportId %2 with ilsPosition = %3 !", _vicName, _airportID, _ilsPosition, _height, _distanceFromIls], "DGCore_fnc_planeDoLand", "debug"] call DGCore_fnc_log;
			_plane landAt _airportID;
		};
		_plane setVariable [_variable, false];
		uiSleep 5;
	};
};

_variable