/*
	DGCore_fnc_getUnitInfoByLevel

	Purpose: Convert input string into (pre)defined skill list and unit count for AI

	Parameters:
		_level:		The input string. Choose between ->		RANDOM | LOW | MEDIUM | HIGH | VETERAN

	Example: ["low"] call DGCore_fnc_getUnitInfoByLevel;

	Return: Array: level, list of skills, unit count, vehicle crew percentage

	Copyright 2024 by Dagovax
*/

params["_level"];
private ["_level", "_skillList", "_unitCount"];
if(isNil "_level") then
{
	_level = "normal";
	_skillList = DGCore_AINormalSettings;
	_unitCount = DGCore_AINormalTroopCount;
}
else
{
	if(toLowerANSI _level isEqualTo "random") then
	{
		_level = selectRandom ["low", "medium", "high", "veteran"];
	};
	
	_skillList = [_level] call DGCore_fnc_getUnitSkillByLevel;
	_unitCount = [_level] call DGCore_fnc_getUnitCountByLevel;
};

[_level, _skillList, _unitCount]
