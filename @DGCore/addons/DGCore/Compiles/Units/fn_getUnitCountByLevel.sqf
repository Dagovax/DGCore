/*
	DGCore_fnc_getUnitCountByLevel

	Purpose: Convert input string into (pre)defined unit count

	Parameters:
		_level:		The input string. Choose between ->		LOW | MEDIUM | HIGH | VETERAN

	Example: ["low"] call DGCore_fnc_getUnitCountByLevel;

	Return: A _unitCount integer array in format [min, max]

	Copyright 2024 by Dagovax
*/

private ["_unitCount", "_level", "_low", "_medium", "_high", "_veteran"];
params["_level", ["_low", DGCore_AIEasyTroopCount], ["_medium", DGCore_AINormalTroopCount], ["_high", DGCore_AIHardTroopCount], ["_veteran", DGCore_AIExtremeTroopCount]];

if(isNil "_level") then
{
	_unitCount = _medium;
}
else
{
	if(toLowerANSI _level isEqualTo "random") then
	{
		_level = selectRandom ["low", "medium", "high", "veteran"];
	};
	
	switch (toLowerANSI _level) do 
	{
		case "low":
		{
			_unitCount = _low;
			[format["Input level = %1 | Resulting unit count will be pulled from %2 | _unitCount = %3", _level, "DGCore_AIEasyTroopCount", _unitCount], "DGCore_fnc_getUnitCountByLevel", "debug"] call DGCore_fnc_log;
		};
		case "medium":
		{
			_unitCount = _medium;
			[format["Input level = %1 | Resulting unit count will be pulled from %2 | _unitCount = %3", _level, "DGCore_AINormalTroopCount", _unitCount], "DGCore_fnc_getUnitCountByLevel", "debug"] call DGCore_fnc_log;
		};
		case "high":
		{
			_unitCount = _high;
			[format["Input level = %1 | Resulting unit count will be pulled from %2 | _unitCount = %3", _level, "DGCore_AIHardTroopCount", _unitCount], "DGCore_fnc_getUnitCountByLevel", "debug"] call DGCore_fnc_log;
		};
		case "veteran":
		{
			_unitCount = _veteran;
			[format["Input level = %1 | Resulting unit count will be pulled from %2 | _unitCount = %3", _level, "DGCore_AIExtremeTroopCount", _unitCount], "DGCore_fnc_getUnitCountByLevel", "debug"] call DGCore_fnc_log;
		};
	};
};

_unitCount
