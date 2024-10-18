/*

	Purpose: initialize DGCore 
	
	Parameters: none
	
	Return: none
	
	By Dagovax
	Copyright 2023
*/

DGCore_modType = "default";
if (!isNull (configFile >> "CfgPatches" >> "exile_server")) then {DGCore_modType = "Exile"};
if (!isnull (configFile >> "CfgPatches" >> "a3_epoch_server")) then {DGCore_modType = "Epoch"}; 

[format["DGCore_modType = %1",DGCore_modType]] call DGCore_fnc_log;
// This block waits for the mod to start but is disabled for now
if ((toLowerANSI DGCore_modType) isEqualto "epoch") then {
	["Waiting until EpochMod is ready..."] call DGCore_fnc_log;
	waitUntil {!isnil "EPOCH_SERVER_READY"};
	["EpochMod is ready...loading DGCore"] call DGCore_fnc_log;
};
if ((toLowerANSI DGCore_modType) isEqualTo "exile") then
{
	["Waiting until ExileMod is ready ..."] call DGCore_fnc_log;
	waitUntil {!isNil "PublicServerIsLoaded"};
	["Exilemod is ready...loading DGCore"] call DGCore_fnc_log;	
};
publicVariable "DGCore_modType"; // Make this variable public

switch (toLowerANSI DGCore_modType) do 
{
	case "exile": 
	{
		DGCore_Side = EAST;
		DGCore_CivilSide = CIVILIAN;
		DG_playerUnitTypes = ["Exile_Unit_Player"];
		DGCore_playerSide = RESISTANCE;
		DGCore_allyTypes = ["I_soldier_F"];
		DGCore_enemyTypes = ["O_A_soldier_F"];
		DGCore_civilianTypes = ["CUP_C_C_Citizen_Random"];
		DGCore_civilianPilot = "CUP_C_C_Pilot_01";
	};
	case "epoch": 
	{
		DGCore_Side = RESISTANCE;
		DGCore_CivilSide = CIVILIAN;
		DG_playerUnitTypes = ["Epoch_Male_F","Epoch_Female_F"];
		DGCore_playerSide = WEST;		
		DGCore_allyTypes = ["B_G_Soldier_AR_F"];	
		DGCore_enemyTypes = ["I_Soldier_M_F"];
		DGCore_civilianTypes = ["C_man_1"];
		DGCore_civilianPilot = "CUP_C_C_Pilot_01";
	};
	default {
		DGCore_Side = EAST;
		DGCore_CivilSide = CIVILIAN;
		DG_playerUnitTypes = ["Exile_Unit_Player"];
		DGCore_playerSide = WEST;		
		DGCore_allyTypes = ["B_G_Soldier_AR_F"];
		DGCore_enemyTypes = ["O_Soldier_lite_F", "O_A_soldier_F"];
		DGCore_civilianTypes = ["C_man_1"];
		DGCore_civilianPilot = "CUP_C_C_Pilot_01";
	};
};
[format["DGCore_Side = %1",DGCore_Side]] call DGCore_fnc_log;

private _ver =  getNumber(configFile >> "DGCoreBuild" >> "version");
private _build = getNumber(configFile >> "DGCoreBuild" >> "build");
private _buildDate = getText(configFile >> "DGCoreBuild" >> "buildDate");

[] call DGCore_fnc_findWorld; // Initialize world data
[] call DGCore_fnc_findMods; // Initialize loaded mods

execvm "DGCore\config\DGCore_config.sqf"; // Load user config

waitUntil{uiSleep 1; !(isNil "DGCore_Initialized")};

["DGCore succesfully initialized!"] call DGCore_fnc_log;
[format["Build= %1 | Build Date= %2 | Version= %3 | Initialized at %4 with DGCore_modType = %5",_build,_buildDate, _ver,diag_tickTime,DGCore_modType]] call DGCore_fnc_log;

