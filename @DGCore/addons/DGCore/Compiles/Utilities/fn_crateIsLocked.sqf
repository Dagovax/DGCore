/*

	DGCore_fnc_crateIsLocked

	Purpose: Returns a locked state

	Parameters:
		_crate: 		Crate object
		_defaultState:	Default state of the crate if variable could not be found. True = locked. False = unlocked

	Example: 
		private _locked = [_crate] call DGCore_fnc_crateIsLocked;
		
	Returns: True or false 

	Copyright 2024 by Dagovax
*/
private["_crate", "_locked", "_defaultState"];
params["_crate", ["_defaultState", true]];
if (isNil "_crate" || isNull _crate) exitWith
{
	[format["Failed get crate lock state. It is either gone or invalid parameter (_crate = nil)"], "DGCore_fnc_crateIsLocked", "error"] call DGCore_fnc_log;
};
private _locked = _defaultState;

private _exileLocked = _crate getVariable ["ExileIsLocked", -1];
private _dgCoreLocked = _crate getVariable ["DGCore_CrateLocked", _defaultState];

if(_exileLocked > -1) then
{
	_locked = false;
	
	if(_dgCoreLocked) then // Exile crate unlocked, but DGCore = locked
	{
		[_crate, _locked] call DGCore_fnc_setCrateLock; // Make sure crate is unlocked by DGCore as well.
	};
} else
{
	_locked = true;
	
	if(!_dgCoreLocked) then // DGCore crate unlocked, but Exile = locked
	{
		_locked = false;
		[_crate, _locked] call DGCore_fnc_setCrateLock; // Make sure crate is unlocked by Exile as well.
	};
};

_locked 