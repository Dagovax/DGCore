/*

	DGCore_fnc_spawnPilot

	Purpose: spawns an AI pilot inside certain aircraft vehicle

	Parameters:
		_aircraft: 		Aircraft to spawn pilot into
		_class: 		Unit model class 												| Optional -> Defaults to one of the default classes.
		_side:			Pilot side 														| Optional -> Defaults to DGCore_playerSide
		_allowDamage:	Pilot can be killed 											| Optional -> Default set to true
		_group: 		Existing group. If not given pilot will be added with new group | Optional

	Example: [_heli] call DGCore_fnc_spawnPilot;

	Returns: Pilot

	Copyright 2024 by Dagovax
*/

params["_aircraft", ["_class", ""], ["_side", DGCore_playerSide], ["_allowDamage", true], ["_group", grpNull]];
if(isNil "_aircraft") exitWith
{
	[format["Not enough valid params to spawn AI pilot! -> _aircraft = %1", _aircraft], "DGCore_fnc_spawnPilot", "error"] call DGCore_fnc_log;
};
private ["_pilot", "_aircraftPos"];

if(isNull _group) then
{
	_group = createGroup _side;
};

if(_class isEqualTo "") then
{
	if(_side isEqualTo DGCore_playerSide) then
	{
		_class = selectRandom DGCore_allyTypes;
	};
	if( _side isEqualTo DGCore_Side) then
	{
		_class = selectRandom DGCore_enemyTypes;
	};
	if(_side isEqualTo DGCore_CivilSide) then
	{
		_class = selectRandom DGCore_civilianPilot;
	};
};

if(_class isEqualTo "") then // still no class. Use hardcoded pilot now
{
	if(_side isEqualTo east) then
	{
		_class = "O_soldier_F";
	};
	if(_side isEqualTo west) then
	{
		_class = "B_soldier_F";
	};
	if(_side isEqualTo resistance) then
	{
		_class = "I_soldier_F";
	};
};

_aircraftPos = getPosATL _aircraft;

_pilot = driver _aircraft;
_pilot = _group createUnit [_class, _aircraftPos, [], 0, "NONE"];
[_pilot] joinSilent _group;
_pilot moveInDriver _aircraft;

if(_allowDamage) then
{
	_pilot allowDamage true;
};

_pilot
