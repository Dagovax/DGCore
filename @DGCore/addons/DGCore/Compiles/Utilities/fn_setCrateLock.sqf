/*

	DGCore_fnc_setCrateLock

	Purpose: Set a crate lock state. Actually also works on vehicles

	Parameters:
		_crate: 		Crate object
		_lock: 			Lock (true) or Unlock (false)

	Examples: 
		[_crate] call DGCore_fnc_setCrateLock;
		[_crate, false] call DGCore_fnc_setCrateLock;
		
	Returns: None 

	Copyright 2024 by Dagovax
*/
private["_crate", "_lock"];
params["_crate", ["_lock", true]];
if (isNil "_crate" || isNull _crate) exitWith
{
	[format["Failed to unlock a crate. It is either gone or invalid parameter (_crate = nil)"], "DGCore_fnc_setCrateLock", "error"] call DGCore_fnc_log;
};

if(_lock) then
{
	_crate setVariable ["ExileIsLocked", -1,true]; // Lock crate
	_crate setVariable ["DGCore_CrateLocked", true];
	[format["Locked the crate @ %1", getPos _crate], "DGCore_fnc_setCrateLock", "debug"] call DGCore_fnc_log;
} else
{
	_crate setVariable ["ExileIsLocked", 0,true]; // Unlock crate
	_crate setVariable ["DGCore_CrateLocked", false];
	[format["Unlocked the crate @ %1", getPos _crate], "DGCore_fnc_setCrateLock", "debug"] call DGCore_fnc_log;
};