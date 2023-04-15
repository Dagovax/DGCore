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
		DGCore_playerSide = RESISTANCE;
		DGCore_unitType = "O_Soldier_lite_F";
	};
	case "epoch": 
	{
		DGCore_Side = RESISTANCE;
		DG_playerUnitTypes = ["Epoch_Male_F","Epoch_Female_F"];
		DGCore_playerSide = WEST;		
		DGCore_unitType = "I_Soldier_M_F";			
	};
	default {
		DGCore_Side = EAST;
		DGCore_unitType = "O_Soldier_lite_F";
		DGCore_playerSide = WEST;		
	};
};
[format["DGCore_Side = %1",DGCore_Side]] call DGCore_fnc_log;

private _ver =  getNumber(configFile >> "DGCoreBuild" >> "version");
private _build = getNumber(configFile >> "DGCoreBuild" >> "build");
private _buildDate = getText(configFile >> "DGCoreBuild" >> "buildDate");

[] call DGCore_fnc_findWorld; // Initialize world data

["DGCore succesfully initialized!"] call DGCore_fnc_log;
[format["Build= %1 | Build Date= %2 | Version= %3 | Initialized at %4 with DGCore_modType = %5",_build,_buildDate, _ver,diag_tickTime,DGCore_modType]] call DGCore_fnc_log;
DGCore_Initialized = true;
