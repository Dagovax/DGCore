/*

	DGCore_fnc_findMods

	Purpose: to initialize mods data

	Parameters: None

	Example: [] call DGCore_fnc_findMods;

	Returns: None 

	Copyright 2024 by Dagovax
*/

private["_CBA", "_CUPT", "_CUPU", "_CUPV", "_CUPW"];

[format["Loading mod data"], "DGCore_fnc_findMods", "debug"] call DGCore_fnc_log;

_CBA = false;
_CUPT = false;
_CUPU = false;
_CUPV = false;
_CUPW = false;

private _loadedMods = getLoadedModsInfo;

{
	private _modInfo = _x;
	_modInfo params ["_modname", "_modDir", "_isDefault", "_isOfficial", "_origin", "_hash", "_hashShort", "_itemID"];
	
    // Check for specific mods by their hashShort values
    if (_hashShort isEqualTo "e2942c8a") then { _CBA = true; };         // @CBA_A3
    if (_hashShort isEqualTo "503b396c") then { _CUPT = true; };        // @CUP Terrains - Core
    if (_hashShort isEqualTo "fdfd57d9") then { _CUPU = true; };        // @CUP Units
    if (_hashShort isEqualTo "db7cdbb1") then { _CUPV = true; };        // @CUP Vehicles
    if (_hashShort isEqualTo "347c577a") then { _CUPW = true; };        // @CUP Weapons
	
} forEach _loadedMods;

DG_hasMod_CBA = _CBA;
DG_hasMod_CUPTerrain = _CUPT;
DG_hasMod_CUPUnits = _CUPU;
DG_hasMod_CUPVehicles = _CUPV;
DG_hasMod_CUPWeapons = _CUPW;

[format["Mod Detection - CBA: %1, CUP Terrain: %2, CUP Units: %3, CUP Vehicles: %4, CUP Weapons: %5",DG_hasMod_CBA, DG_hasMod_CUPTerrain, DG_hasMod_CUPUnits, DG_hasMod_CUPVehicles, DG_hasMod_CUPWeapons], "DGCore_fnc_findMods", "debug"] call DGCore_fnc_log;