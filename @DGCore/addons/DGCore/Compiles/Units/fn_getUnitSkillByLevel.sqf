/*
	DGCore_fnc_getUnitSkillByLevel

	Purpose: Convert input string into (pre)defined skill list for AI

	Parameters:
		_level:		The input string. Choose between ->		LOW | MEDIUM | HIGH | VETERAN

	Example: ["low"] call DGCore_fnc_getUnitSkillByLevel;

	Return: A _skillList data array, defined in DGCore config file

	Copyright 2024 by Dagovax
*/

params["_level"];
private ["_skillList"];
if(isNil "_level") then
{
	_skillList = DGCore_AINormalSettings;
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
			_skillList = DGCore_AIEasySettings;
			[format["Input level = %1 | Resulting skill set will be pulled from %2 | _skillList = %3", _level, "DGCore_AIEasySettings", _skillList], "DGCore_fnc_getUnitSkillByLevel", "debug"] call DGCore_fnc_log;
		};
		case "medium":
		{
			_skillList = DGCore_AINormalSettings;
			[format["Input level = %1 | Resulting skill set will be pulled from %2 | _skillList = %3", _level, "DGCore_AINormalSettings", _skillList], "DGCore_fnc_getUnitSkillByLevel", "debug"] call DGCore_fnc_log;
		};
		case "high":
		{
			_skillList = DGCore_AIHardSettings;
			[format["Input level = %1 | Resulting skill set will be pulled from %2 | _skillList = %3", _level, "DGCore_AIHardSettings", _skillList], "DGCore_fnc_getUnitSkillByLevel", "debug"] call DGCore_fnc_log;
		};
		case "veteran":
		{
			_skillList = DGCore_AIExtremeSettings;
			[format["Input level = %1 | Resulting skill set will be pulled from %2 | _skillList = %3", _level, "DGCore_AIExtremeSettings", _skillList], "DGCore_fnc_getUnitSkillByLevel", "debug"] call DGCore_fnc_log;
		};
	};
};

_skillList
