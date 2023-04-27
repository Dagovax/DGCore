/*

	DGCore_fnc_spawnCivilian

	Purpose: spawns a civilian at given coordinates

	Parametsrs:
		_pos: position to spawn this unit
		_class: class name of the unit
		_vehicle: vehicle object to spawn this unit in. (if no more room insinde this vehicle, unit will not create!)
		_group: group to add this unit too. If _vehicle is not null, and it has crew, that group will be used instead.
		_uniform: uniform class to add to this civilian
		_headGear: headgear to add to this civilian

	Example: [[10400,10400,0], "C_man_1"] call DGCore_fnc_spawnCivilian;

	Returns: Civilian Unit

	Copyright 2023 by Dagovax
*/

params[["_pos", [0,0,0]], ["_class", ""], ["_side", DGCore_CivilSide], ["_setCaptive", true], ["_vehicle", objNull],  ["_group", grpNull], ["_uniform", ""] ,["_headGear", ""]];
if(_pos isEqualTo [0,0,0]) exitWith
{
	[format["Not enough valid params to spawn civilian unit! -> _pos = %1", _pos], "DGCore_fnc_spawnCivilian", "error"] call DGCore_fnc_log;
};
private ["_civilian", "_group"];
_civilianPos = _pos;
_civilianClass = selectRandom DGCore_civilianTypes;
if(!isNil "_class" && !(_class isEqualTo "")) then
{
	_civilianClass = _class;
};

_assignToVehicle = false;
if(!isNull _vehicle) then
{
	_vicName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
	_allVehiclePos = fullCrew [_vehicle, "", true];
	_vehicleCrew = crew _vehicle;
	[format["Vehicle %1 checked: fullCrew capacity = %2 | crew inside vehicle = %3", _vicName, count _allVehiclePos, count _vehicleCrew], "DGCore_fnc_spawnCivilian", "debug"] call DGCore_fnc_log;
	if(count _allVehiclePos > 0 && count _vehicleCrew == 0) exitWith // Enough available seets, need to create a new group.
	{
		_assignToVehicle = true;
		[format["_assignToVehicle checked: %1 | There are enough available seets, need to create a new group.", _assignToVehicle], "DGCore_fnc_spawnCivilian", "debug"] call DGCore_fnc_log;
	};
	
	if(count _allVehiclePos > count _vehicleCrew) exitWith // There are available seetse, crew is present
	{
		_group = group(_vehicleCrew select 0); // Group of the first unit
		_assignToVehicle = true;
		[format["_assignToVehicle checked: %1 | There are available seetse, crew is present (_group = %2)", _assignToVehicle, _group], "DGCore_fnc_spawnCivilian", "debug"] call DGCore_fnc_log;
	};
	_assignToVehicle = false;
};

if(!isNull _vehicle && !_assignToVehicle) exitWith
{
	[format["Did not spawn civilian because the assigned vehicle has already max crew!"], "DGCore_fnc_spawnCivilian", "warning"] call DGCore_fnc_log;
};

if(isNull _group) then // If _group equals Null at this point, create a new group
{
	_group = createGroup _side;
};

_civilian = _group createUnit [_civilianClass, _civilianPos, [], 0, "FORM"]; // Create the unit
_civilian allowDamage false; // First initialize this dude.
_civilian setCaptive _setCaptive;
_group setCombatMode "BLUE";
_group setBehaviour "CARELESS";
_group allowFleeing 0;

removeAllWeapons _civilian;
removeBackpackGlobal _civilian;
removeVest _civilian;
removeHeadgear _civilian;
removeGoggles _civilian;

// Add uniform
if (_uniform isEqualTo "") then
{
	_uniform = selectRandom DGCore_CivilianUniforms;
};
_civilian forceAddUniform _uniform;

// Add headgear
if (_headGear isEqualTo "") then
{
	_headGear = selectRandom DGCore_CivilianHeadgear;
	_percentage = floor random 100;
	if(_percentage <= 65) then // Only add headgear for random civilians for 65% chance
	{
		_civilian addHeadgear _headGear;
	};
} else
{
	_civilian addHeadgear _headGear;
};

[format["Created civilian %1 with class %2 @ %3", _civilian, _civilianClass, _civilianPos], "DGCore_fnc_spawnCivilian", "information"] call DGCore_fnc_log;

if(_assignToVehicle && !isNull _vehicle) then
{
	_civilian moveInAny _vehicle; // Move this civilian inside this vehicle
	_vicName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
	[format["Civilian %1 is now on the [%2] position of the %3", _civilian, (assignedVehicleRole _civilian) select 0, _vicName]] call DGCore_fnc_log;
};

_civilian
