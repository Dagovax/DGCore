/*

	DGCore_fnc_getDynamicAirportInfo

	Purpose: Get absolute position info from dynamic airports

	Parameters:
		_dynamicAirport: Dynamicly created vehicle from CfgVehicles

	Example: _dynamicAirportInfo = [_dynamicAirport] call DGCore_fnc_getDynamicAirportInfo;

	Returns: Array [absolute ilsPosition, ilsDirection, Array[ilsTaxiIn], Array[ilsTaxiOff]]

	Copyright 2023 by Dagovax
*/

params[["_dynamicAirport", ObjNull]];
if(isNull _dynamicAirport) exitWith
{
	[format["Not enough valid params to retrieve dynamic airport information -> _dynamicAirport isEqualTo = %1", _dynamicAirport], "DGCore_fnc_getDynamicAirportInfo", "error"] call DGCore_fnc_log;
	[]
};

private _class = typeOf _dynamicAirport;
if(_class isEqualTo "") exitWith
{
	[]
};
private _ilsPosition = getArray (configfile >> "CfgVehicles" >> _class >> "ilsPosition");
private _ilsDirection = getarray (configfile >> "CfgVehicles" >> _class >> "ilsDirection"); // No conversion needed for ilsDirection
private _ilsTaxiIn = getarray (configfile >> "CfgVehicles" >> _class >> "ilsTaxiIn");
private _ilsTaxiOff = getarray (configfile >> "CfgVehicles" >> _class >> "ilsTaxiOff");

if(_ilsPosition isEqualTo [] || _ilsDirection isEqualTo [] || _ilsTaxiIn isEqualTo [] || _ilsTaxiOff isEqualTo {}) exitWith
{
	[format["Unable to retrieve dynamic airport config data for %1 -> _ilsPosition = %1 | _ilsDirection = %2 | _ilsTaxiIn = %3 | _ilsTaxiOff = %4", _ilsPosition, _ilsDirection, _ilsTaxiIn, _ilsTaxiOff], "DGCore_fnc_getDynamicAirportInfo", "error"] call DGCore_fnc_log;
	[]
};

private _resultArr = [];
private _airportPos = getPos _dynamicAirport;
private _absoluteIlsPosition = [_airportPos, _ilsPosition] call DGCore_fnc_relativePosToAbsolutePos;
if(_absoluteIlsPosition isEqualTo []) exitWith
{
	[format["Calculation of _absoluteIlsPosition failed! -> _absoluteIlsPosition = %1", _absoluteIlsPosition], "DGCore_fnc_getDynamicAirportInfo", "error"] call DGCore_fnc_log;
	[]
};

private _absoluteIlsTaxiIn = [];
for "_i" from 0 to (count _ilsTaxiIn -1) step 2 do 
{
	_relXPos = _ilsTaxiIn select _i;
	_Ycounter = _i + 1;
	_relYPos = _ilsTaxiIn select _Ycounter;
	 _absolutePos = [_airportPos, [_relXPos, _relYPos]] call DGCore_fnc_relativePosToAbsolutePos;
	if(_absolutePos isEqualTo []) exitWith
	{
		[format["Calculation of _absoluteIlsTaxiIn failed! -> _absolutePos = %1 | _relXPos = %2 | _relYPos = %3", _absolutePos, _relXPos, _relYPos], "DGCore_fnc_getDynamicAirportInfo", "error"] call DGCore_fnc_log;
	};
	_absoluteIlsTaxiIn pushBack (_absolutePos select 0); // abs X
	_absoluteIlsTaxiIn pushBack (_absolutePos select 1); // abs Y
};

private _absoluteIlsTaxiOff = [];
for "_i" from 0 to (count _ilsTaxiOff - 1) step 2 do 
{
	_relXPos = _ilsTaxiOff select _i;
	_Ycounter = _i + 1;
	_relYPos = _ilsTaxiOff select _Ycounter;
	 _absolutePos = [_airportPos, [_relXPos, _relYPos]] call DGCore_fnc_relativePosToAbsolutePos;
	if(_absolutePos isEqualTo []) exitWith
	{
		[format["Calculation of _absoluteIlsTaxiOff failed! -> _absolutePos = %1 | _relXPos = %2 | _relYPos = %3", _absolutePos, _relXPos, _relYPos], "DGCore_fnc_getDynamicAirportInfo", "error"] call DGCore_fnc_log;
	};
	_absoluteIlsTaxiOff pushBack (_absolutePos select 0); // abs X
	_absoluteIlsTaxiOff pushBack (_absolutePos select 1); // abs Y
};

_resultArr pushBack _absoluteIlsPosition;
_resultArr pushBack _ilsDirection;
_resultArr pushBack _absoluteIlsTaxiIn;
_resultArr pushBack _absoluteIlsTaxiOff;

_resultArr
