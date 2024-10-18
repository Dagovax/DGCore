/*
    DGCore_fnc_selectMagazine

    Purpose: Get a weapon's magazine.

    Parameters:
        _weapon: Weapon class to retrieve magazines for.
        _returnRandom: Whether to return a random magazine (default: true).

    Example: ["CUP_m107"] call DGCore_fnc_selectMagazine;

    Returns: Class of the first valid magazine, or an empty string if none found.

    Copyright 2023 by Dagovax
*/

params["_weapon", ["_returnRandom", true]];
private["_result","_ammoArray"];

if(isNil "_weapon") exitWith
{
	["Failed to execute DGCore_fnc_selectMagazine because _weapon was undefined"] call DGCore_fnc_log;
};

_result 	= "";
_ammoArray 	= getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");

// If no magazines are found, return an empty string
if (count _ammoArray <= 0) exitWith 
{
    ["No magazines found for weapon: " + _weapon] call DGCore_fnc_log;
    "";
};

// Filter out blacklisted ammo and select magazine
private _validAmmo = false;
while {(count _ammoArray > 0) && !_validAmmo} do 
{
    // Select a random magazine or the first one
    if (_returnRandom) then 
	{
        _result = selectRandom _ammoArray;
    } else 
	{
        _result = _ammoArray select 0;
    };

    // Check if the magazine is blacklisted
    if (DGCore_AmmoBlacklist findIf {_x == _result} == -1) then 
	{
        // The selected magazine is valid (not blacklisted)
        _validAmmo = true;
    } else 
	{
        // Remove the blacklisted magazine and continue searching
        _ammoArray deleteAt (_ammoArray find _result);
        [format["Magazine '%1' is inside the ammo blacklist! Searching for another class...", _result], "DGCore_fnc_selectMagazine", "debug"] call DGCore_fnc_log;
    };
};

// If no valid magazine was found, return an empty result
if (!_validAmmo) then 
{
    ["All magazines were blacklisted for weapon: " + _weapon] call DGCore_fnc_log;
    _result = "";
};

_result
