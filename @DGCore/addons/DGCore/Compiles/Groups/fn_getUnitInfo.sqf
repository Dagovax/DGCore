/*
	DGCore_fnc_getUnitInfo

	Purpose: change amount of tabs for a player (not locker)

	Parameters:
		_target, The target to calculate the skill list for. Can be player or territory

	Example: [_player] call DGCore_fnc_getUnitInfo;

	Return: Array -> format [_skillList, _unitCount] 

	Copyright 2023 by Dagovax
*/

params[["_target", objNull]];
private ["_skillList", "_unitCount"];
if(isNull _target) then
{
	_skillList = DGCore_AINormalSettings;
	_unitCount = DGCore_AINormalTroopCount;
};

if(!isNull _target) then
{
	if(_target isKindOf "Exile_Construction_Flag_Static") then
	{
		_baseLevel = _target getVariable ["ExileTerritoryLevel", 1];
		if((_baseLevel < (DGCore_BaseLevelRange select 0))) then // EASY 
		{
			_skillList = DGCore_AIEasySettings;
			_unitCount = DGCore_AIEasyTroopCount;
		};
		if((_baseLevel >= (DGCore_BaseLevelRange select 0)) && (_baseLevel < (DGCore_BaseLevelRange select 1))) then // NORMAL 
		{
			_skillList = DGCore_AINormalSettings;
			_unitCount = DGCore_AINormalTroopCount;
		};
		if((_baseLevel >= (DGCore_BaseLevelRange select 1)) && (_baseLevel < (DGCore_BaseLevelRange select 2))) then // HARD 
		{
			_skillList = DGCore_AIHardSettings;
			_unitCount = DGCore_AIHardTroopCount;
		};
		if((_baseLevel >= (DGCore_BaseLevelRange select 2))) then // EXTREME 
		{
			_skillList = DGCore_AIExtremeSettings;
			_unitCount = DGCore_AIExtremeTroopCount;
		};
	} else
	{
		_playerExperience = _target getVariable ["ExileScore", 10000];
		if((_playerExperience < (DGCore_PlayerExpRange select 0))) then // EASY 
		{
			_skillList = DGCore_AIEasySettings;
			_unitCount = DGCore_AIEasyTroopCount;
		};
		if((_playerExperience >= (DGCore_PlayerExpRange select 0)) && (_playerExperience < (DGCore_PlayerExpRange select 1))) then // NORMAL 
		{
			_skillList = DGCore_AINormalSettings;
			_unitCount = DGCore_AINormalTroopCount;
		};
		if((_playerExperience >= (DGCore_PlayerExpRange select 1)) && (_playerExperience < (DGCore_PlayerExpRange select 2))) then // HARD 
		{
			_skillList = DGCore_AIHardSettings;
			_unitCount = DGCore_AIHardTroopCount;
		};
		if((_playerExperience >= (DGCore_PlayerExpRange select 2))) then // EXTREME 
		{
			_skillList = DGCore_AIExtremeSettings;
			_unitCount = DGCore_AIExtremeTroopCount;
		};
	};
};

[_skillList, _unitCount]
