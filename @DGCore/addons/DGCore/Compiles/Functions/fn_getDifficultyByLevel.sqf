/*
	DGCore_fnc_getDifficultyByLevel

	Purpose: Retrieves a valid difficulty level. Currently we support:
		- random
		- low
		- medium
		- high
		- veteran

	Parameters:
		_level:		The input string. 

	Example: ["random"] call DGCore_fnc_getDifficultyByLevel;

	Return: Array: level, list of skills, unit count, vehicle crew percentage

	Copyright 2024 by Dagovax
*/

private ["_level", "_difficulty"];
params["_level"];
if(isNil "_level") then
{
	_difficulty = DGCore_DefaultDifficulty;
}
else
{
	switch (toLowerANSI _level) do 
	{
		case "low":
		{
			_difficulty = "low";
		};
		case "medium":
		{
			_difficulty = "medium";
		};
		case "high":
		{
			_difficulty = "high";
		};
		case "veteran":
		{
			_difficulty = "veteran";
		};
		case "random":
		{
			_difficulty = selectRandom ["low", "medium", "high", "veteran"];
		};
		default
		{
			_difficulty = DGCore_DefaultDifficulty;
		};
	};
};

_difficulty
