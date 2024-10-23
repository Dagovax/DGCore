/*
    DGCore_fnc_getMarkerColorByLevel
	
    Purpose: Creates a complete marker when a mission was succesfull. Will be deleted after 4 minutes

	Parameters:
		_level:			The input string. Choose between ->		LOW | MEDIUM | HIGH | VETERAN
		_inputColors:	Input marker colors. Should be an array containing four valid colors

	Examples: 
		private _markerColor = ["low"] call DGCore_fnc_getMarkerColorByLevel;

    Copyright 2024 by Dagovax
*/

private ["_level", "_color", "_inputColors"];
params["_level", ["_inputColors", DGCore_MarkerColors]];

if(isNil "_level") then
{
	_color = DGCore_MarkerDefaultColor;
} else
{
	switch (toLowerANSI _level) do 
	{
		case "low":
		{
			_color = _inputColors select 0;
		};
		case "medium":
		{
			_color = _inputColors select 1;
		};
		case "high":
		{
			_color = _inputColors select 2;
		};
		case "veteran":
		{
			_color = _inputColors select 3;
		};
	};
	
	if(isNil "_color") then
	{
		_color = DGCore_MarkerDefaultColor;
	};
	
	[format["Input level = %1 | Result color = %2", _level, _color], "DGCore_fnc_getMarkerColorByLevel", "debug"] call DGCore_fnc_log;
};

_color 