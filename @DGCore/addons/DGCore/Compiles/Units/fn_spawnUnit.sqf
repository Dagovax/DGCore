/*

	DGCore_fnc_spawnUnit

	Purpose: spawns an AI at given coordinates

	Parametsrs:
		_message: message to be logged
		_scriptName: name of the calling script to be used in logging
		_type: 

	Example: ["I am being logged", "DG RoamingAI", "information"] call DGCore_fnc_log;

	Returns: Unit

	Copyright 2023 by Dagovax
*/

params[["_pos", [0,0,0]], ["_group", grpNull], ["_class", nil], ["_spawnAsPara", false],["_skillSettings", DGCore_AINormalSettings], ["_weapon", ""], ["_uniform", ""], ["_vest", ""], ["_backpack", ""], ["_optic", ""] ,["_headGear", ""]];
if("_pos" isEqualTo [0,0,0] || isNull _group) exitWith
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
if(_spawnAsPara) then
{
	if(_unitPos select 2 > 10) then
	{
		_unitPos =  [(_unitPos select 0), (_unitPos select 1), (_unitPos select 2) - 5]; // Spawn below the give position	
	};
} else
{
	if(_unitPos select 2 < 10) then
	{
		_unitPos =  [(_unitPos select 0), (_unitPos select 1), 0]; // Spawn at the ground
	};
};
_unitClass = selectRandom DGCore_enemyTypes;
if(!isNil "_class") then
{
	_unitClass = _class;
} else
{
	if (side _group == DGCore_playerSide) then
	{
		_unitClass = selectRandom DGCore_allyTypes;
	};
};
_unit = _group createUnit [_unitClass, _unitPos, [], 0, "FORM"]; // Create the unit
_unit allowDamage false; // First initialize this dude.
removeAllWeapons _unit;
removeBackpackGlobal _unit;
removeVest _unit;
removeHeadgear _unit;
removeGoggles _unit;
//_targetPlayer = _group getVariable "_DGCore_targetPlayer";
[_unit] call DGCore_fnc_addEventHandlers; // Add event handlers
// if(!isNil "_targetPlayer") then
// {
	// [_unit, true, _targetPlayer] call DGCore_fnc_addEventHandlers; // Add event handlers with target player (or friendly player assigned to this group)
// } else
// {
	// [_unit] call DGCore_fnc_addEventHandlers; // Add event handlers
// };

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

// Add weapon to this trooper
if (_weapon isEqualTo "") then
{
	_weapon = selectRandom DGCore_AIWeapons;
};
_ammo = _weapon call DGCore_fnc_selectMagazine;
for "_i" from 1 to 3 do 
{ 
	_unit addMagazineGlobal _ammo;
};
_unit addWeaponGlobal _weapon;

// Add weapon optics
if (_optic isEqualTo "") then
{
	_optic = selectRandom DGCore_AIWeaponOptics;
};
_unit addPrimaryWeaponItem _optic;

// Add backpack
if (_backpack isEqualTo "") then
{
	_backpack = selectRandom DGCore_Backpacks;
	_unit addBackpackGlobal _backpack;
};

// Add launcher
if(DGCore_EnableLaunchers) then
{
	_percentage = floor random 100;
	if(_percentage <= _launcherChance) then
	{
		_launcherClass = selectRandom DGCore_AILaunchers;
		_launcherAmmo = _launcherClass call DGCore_fnc_selectMagazine;
		for "_i" from 1 to 2 do 
		{ 
			_unit addMagazine _launcherAmmo;
		};
		_unit addWeapon _launcherClass;
	};
};

// Add other inventory items
for "_i" from 1 to _inventoryItems do
{
	_unit addItem (selectRandom DGCore_AIItems);
};

_isParatrooper = false;
if(position _unit select 2 > 5) then // This guy needs a chute
{
	_isParatrooper = true;
	// _unit addBackpack "B_Parachute"; // First parachute lol
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

if(_isParatrooper) then
{
	[_unit] spawn
	{
		params ["_trooper"];
		if(isNil "_trooper" || isNull _trooper) exitWith{};
		uiSleep 0.4;
		_chute = createVehicle ["Steerable_Parachute_F", (getPosATL _trooper), [], 0, "NONE"];
		_chute allowDamage false;
		_chute setPosATL (getPosATL _trooper);
		_trooper moveInDriver _chute;
		_chute allowDamage false;
		uiSleep 0.5;
		_trooper allowDamage true;
		waitUntil {isTouchingGround _trooper};
		uiSleep 2;
		if ((vehicle _trooper) == _chute) then
		{
			moveOut _trooper;
			uiSleep 0.5;
			deleteVehicle _chute;
		};
	};
} else
{
	waitUntil {isTouchingGround _unit};
	_unit allowDamage true;
};

[format["Created unit %1 and added it to group %2", _unit, _group]] call DGCore_fnc_log;

_unit
