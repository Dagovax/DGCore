/*

	DGCore_fnc_selectMagazine

	Purpose: to get a weapon's magazine

	Parametsrs:
		_weapon: weapon class

	Example: ["CUP_m107"] call DGCore_fnc_selectMagazine;

	Returns: class of the first found magazine 

	Copyright 2023 by Dagovax
*/

params["_weapon"];
private["_result","_ammoArray"];

if(isNil "_weapon") exitWith{
	["Failed to execute DGCore_fnc_selectMagazine because _weapon was undefined"] call DGCore_fnc_log;
};

_result 	= "";
_ammoArray 	= getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");

if (count _ammoArray > 0) then
{
	_result = _ammoArray select 0;
};

_result
