/*

	DGCore_fnc_spawnUnit

	Purpose: spawns an AI at given coordinates

	Parameters:
		_pos: 				Spawn position
		_group: 			Group to spawn unit in
		_class: 			Unit model class
		_spawnAsPara:		If set to true, if unit is spawned in the air, it will get a parachute (Duh)
		_skillSettings:		Array of skill data
		_weapons:			Array of weapon classes
		_enableLauncher:	Unit might spawn with launcher (random chance based on _skillSettings)
		_weapon:			Forced weapon class. Force unit to spawn with this weapon
		_uniform:			Forced uniform class. Force unit to spawn with this uniform
		_vest:				Forced vest class. Force unit to spawn with this vest
		_backpack:			Forced backpack class. Force unit to spawn with this backpack
		_optic:				Forced optic class. Force unit to spawn with this weapon optic
		_headGear:			Forced headgear class. Force unit to spawn with this headgear

	Example: [_pos, _group, "I_soldier_F"] call DGCore_fnc_spawnUnit;

	Returns: Unit

	Copyright 2024 by Dagovax
*/

params[["_pos", [0,0,0]], ["_group", grpNull], ["_class", nil], ["_spawnAsPara", false],["_skillSettings", DGCore_AINormalSettings], ["_weapons", DGCore_AIWeapons], ["_enableLauncher", DGCore_EnableLaunchers], ["_weapon", ""], ["_uniform", ""], ["_vest", ""], ["_backpack", ""], ["_optic", ""] ,["_headGear", ""]];
if(_pos isEqualTo [0,0,0] || isNull _group) exitWith
{
	[format["Not enough valid params to spawn AI unit! -> _pos = %1 | _group = %2", _pos, _group], "DGCore_fnc_spawnUnit", "error"] call DGCore_fnc_log;
};
if(_skillSettings isEqualTo []) exitWith
{
	[format["Can not spawn an AI without a valid skill settings! Don't pass this parameter if you want normal AI skill (_skillSettings = %1)", _skillSettings], "DGCore_fnc_spawnUnit", "error"] call DGCore_fnc_log;
};
private ["_unit", "_skillLevel", "_inventoryItems", "_maxMoney", "_launcherChance"];
_skillLevel = _skillSettings select 0;
_inventoryItems = _skillSettings select 1; // Instadoc and foot etc.
_maxMoney = _skillSettings select 2;
_launcherChance = _skillSettings select 3;
if(isNil "_skillLevel") then
{
	_skillLevel = 0.5; // default to normal
};
if(isNil "_inventoryItems") then
{
	_inventoryItems = 2;
};
if (isNil "_maxMoney") then
{
	_maxMoney = 250;
};
_money = ceil(random(_maxMoney));

_unitPos = _pos;

if(_unitPos select 2 > 10) then
{
	_unitPos =  [(_unitPos select 0), (_unitPos select 1), (_unitPos select 2) - 5]; // Spawn below the give position	
} else
{
	_unitPos =  [(_unitPos select 0), (_unitPos select 1), 0]; // Spawn at the ground
};

private _groupSide = side _group;
private _unitClass = selectRandom DGCore_enemyTypes;
if(!isNil "_class") then
{
	_unitClass = _class;
} else
{
	if(DGCore_modType isEqualTo "default") then
	{
		if(_groupSide isEqualTo east) then
		{
			_unitClass = "O_soldier_F";
		};
		if(_groupSide isEqualTo west) then
		{
			_unitClass = "B_soldier_F";
		};
		if(_groupSide isEqualTo resistance) then
		{
			_unitClass = "I_soldier_F";
		};
	} else
	{
		if (_groupSide == DGCore_playerSide) then
		{
			_unitClass = selectRandom DGCore_allyTypes;
		};
	};
};

_unit = _group createUnit [_unitClass, _unitPos, [], 0, "FORM"]; // Create the unit

if (_groupSide != DGCore_playerSide) then
{
	[_unit] joinSilent _group;
};

_unit allowDamage false; // First initialize this dude.
removeAllWeapons _unit;
removeBackpackGlobal _unit;
removeVest _unit;
removeHeadgear _unit;
removeGoggles _unit;

[_unit] call DGCore_fnc_addEventHandlers; // Add event handlers

// Add uniform
if (_uniform isEqualTo "") then
{
	_uniform = selectRandom DGCore_Uniforms;
};

_unit forceAddUniform _uniform;

// Add vest
if (_vest isEqualTo "") then
{
	_vest = selectRandom DGCore_AIVests;
};
_unit addVest _vest;

// Add headgear
if (_headGear isEqualTo "") then
{
	_headGear = selectRandom DGCore_Headgear;
};
_unit addHeadgear _headGear;

// Add backpack
if (_backpack isEqualTo "") then
{
	_backpack = selectRandom DGCore_Backpacks;
	_unit addBackpackGlobal _backpack;
};

// Add weapon to this trooper
if (_weapon isEqualTo "") then
{
	_weapon = selectRandom _weapons;
};

for "_i" from 1 to 3 do 
{ 
	private _ammo = [_weapon] call DGCore_fnc_selectMagazine;
	if !(_ammo isEqualTo "") then
	{
		_unit addMagazine _ammo;
	};
};
_unit addWeapon _weapon;

// Add weapon optics
if (_optic isEqualTo "") then
{
	_optic = selectRandom DGCore_AIWeaponOptics;
};
_unit addPrimaryWeaponItem _optic;

// Add launcher
if(_enableLauncher) then
{
	_percentage = floor random 100;
	if(_percentage <= _launcherChance) then
	{
		_launcherClass = selectRandom DGCore_AILaunchers;
		for "_i" from 1 to 2 do 
		{
			private _launcherAmmo = [_launcherClass] call DGCore_fnc_selectMagazine;
			if !(_launcherAmmo isEqualTo "") then
			{
				_unit addMagazine _launcherAmmo;
			};
		};
		_unit addWeapon _launcherClass;
	};
};

// Add other inventory items
for "_i" from 1 to (_inventoryItems + 2) do
{
	_unit addItem (selectRandom DGCore_AIItems);
};

_isParatrooper = false;
if(position _unit select 2 > 5) then // This guy needs a chute
{
	_isParatrooper = true;
};

// Add money
if(_money > 0) then
{
	if(toLowerANSI DGCore_modType == "exile") then
	{
		_unit setVariable ["ExileMoney",_money ,true]; // Add some money
	};
};

_unit setskill ["aimingAccuracy",_skillLevel];
_unit setskill ["aimingShake",_skillLevel];
_unit setskill ["aimingSpeed",_skillLevel];
_unit setskill ["spotDistance",_skillLevel];
_unit setskill ["spotTime",_skillLevel];
_unit setskill ["courage",_skillLevel];
_unit setskill ["reloadSpeed",_skillLevel];
_unit setskill ["commanding",_skillLevel];
_unit setskill ["general",_skillLevel];

// Enable this AI
_unit enableAI "TARGET";
_unit enableAI "AUTOTARGET";
_unit enableAI "MOVE";
_unit enableAI "ANIM";
//_unit disableAI "TEAMSWITCH";
_unit enableAI "FSM";
_unit enableAI "AIMINGERROR";
_unit enableAI "SUPPRESSION";
_unit enableAI "CHECKVISIBLE";
_unit enableAI "COVER";
_unit enableAI "AUTOCOMBAT";
_unit enableAI "PATH";

[format["Created unit %1 with class %2 and added it to group %3", _unit, _unitClass, _group]] call DGCore_fnc_log;

if(_isParatrooper) then
{
	[_unit, _uniform, _pos] spawn
	{
		params ["_trooper", "_uniform", "_pos"];
		if(isNil "_trooper" || isNull _trooper) exitWith{};
		uiSleep 0.4;
		_chute = createVehicle ["Steerable_Parachute_F", (getPosATL _trooper), [], 0, "NONE"];
		_chute allowDamage false;
		_chute setPosATL (getPosATL _trooper);
		_trooper moveInDriver _chute;
		_chute allowDamage false;
		uiSleep 0.5;
		_trooper moveInDriver _chute;
		_trooper allowDamage true;
		waitUntil {isTouchingGround _trooper};
		uiSleep 2;
		if ((vehicle _trooper) == _chute) then
		{
			moveOut _trooper;
			uiSleep 0.5;
			deleteVehicle _chute;
		};
		_trooper forceAddUniform _uniform;
		_trooper doMove _pos;
	};
} else
{
	[_unit, _uniform, _pos] spawn
	{
		params ["_unit", "_uniform", "_pos"];
		if(isNil "_unit" || isNull _unit) exitWith{};
		waitUntil {isTouchingGround _unit};
		_unit allowDamage true;
		_unit forceAddUniform _uniform;
		_unit doMove _pos;
	};
};

_unit
