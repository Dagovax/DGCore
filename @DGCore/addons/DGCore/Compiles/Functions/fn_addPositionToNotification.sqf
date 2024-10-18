/*

	DGCore_fnc_addPositionToNotification

	Purpose: Adds an end to any notification title or input string. Uses DGCore_NotificationAddition

	Parameters:
		_weapon: weapon class

	Example: _message = [_inputMessage, _pos] call DGCore_fnc_addPositionToNotification;

	Returns: improved message

	Copyright 2024 by Dagovax
*/

params["_inputMessage", ["_pos", [-1,-1,-1]]];
private["_result"];

if(isNil "_inputMessage") exitWith
{
	["Failed to execute because _inputMessage was undefined!", "DGCore_fnc_addPositionToNotification", "error"] call DGCore_fnc_log;
};
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	["Failed to execute because _pos was undefined ([-1,-1,-1])!", "DGCore_fnc_addPositionToNotification", "error"] call DGCore_fnc_log;
};

switch (DGCore_NotificationAddition) do
{
	case "settlement": 
	{
		_nearestCity = [_pos] call DGCore_fnc_nearestSettlement;
		[format ["Adding settlement with name '%1' to _inputMessage = %2", _nearestCity, _inputMessage], "DGCore_fnc_addPositionToNotification", "debug"] call DGCore_fnc_log;
		_result = format["%1, nearby %2", _inputMessage, _nearestCity];
	};
	case "grid": 
	{
		_grid = mapGridPosition _pos;
		[format ["Adding grid position '%1' to _inputMessage = %2", _grid, _inputMessage], "DGCore_fnc_addPositionToNotification", "debug"] call DGCore_fnc_log;
		_result = format["%1 @ %2", _inputMessage, _grid];
	};
	default
	{
		[format ["Adding just a period '.' to end this _inputMessage = %1", _inputMessage], "DGCore_fnc_addPositionToNotification", "debug"] call DGCore_fnc_log;
		_result = format["%1.", _inputMessage];
	};
};

_result
