#define CRATE_ATTACH_OFFSET 0.81

params[["_pos", [-1,-1,-1]], ["_maxMoney", 0], ["_attachSmoke", nil], ["_attachLight", nil], ["_locked", false], ["_lootLauncherCount", 5], ["_lootWeaponCount", 20], ["_lootVestCount", 5], ["_lootBackpackCount", 5], ["_lootAttachmentCount", 6], ["_lootMaterialCount", 20], ["_lootItemCount", 10]];
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to spawn loot crate! -> _pos = %1", _pos], "DGCore_fnc_spawnLootCrate", "error"] call DGCore_fnc_log;
};

if ((count DGCore_LootSmokeTypes) == 0) exitWith 
{ 
	[format["DGCore_LootSmokeTypes contains no elements! Validate the array in DGCore_config.sqf!"], "DGCore_fnc_spawnLootCrate", "error"] call DGCore_fnc_log;
};
if ((count DGCore_LootBoxLightTypes) == 0) exitWith 
{
	[format["DGCore_LootBoxLightTypes contains no elements! Validate the array in DGCore_config.sqf!"], "DGCore_fnc_spawnLootCrate", "error"] call DGCore_fnc_log;
};

if(isNil "_attachSmoke") then
{
	_attachSmoke = selectRandom DGCore_LootSmokeTypes;
};
if(isNil "_attachLight") then
{
	_attachLight = selectRandom DGCore_LootBoxLightTypes;
};

private ["_lootCrate", "_money", "_smoke", "_light"];
_smoke = nil;
_light = nil;

if (isNil "_maxMoney") then
{
	_maxMoney = 250;
};
_money = ceil(random(_maxMoney));

_cratePos = _pos;

if(_cratePos select 2 > 10) then
{
	_cratePos =  [(_cratePos select 0), (_cratePos select 1), (_cratePos select 2) - 5]; // Spawn below the give position	
} else
{
	_cratePos =  [(_cratePos select 0), (_cratePos select 1), 0]; // Spawn at the ground
};

_lootCrateClass = selectRandom DGCore_LootBoxTypes;
_lootCrate = createVehicle [_lootCrateClass, _cratePos, [], 0, "CAN_COLLIDE"];
_lootCrate allowDamage false;
_lootCrate setVariable ["ExileIsPersistent", false];
_lootCrate setVariable ["ExileMoney",_money ,true];
_lootCrate enableSimulationGlobal true;

// Add content to the crate
for "_i" from 1 to (_lootLauncherCount) do
{
	private _launcher = DGCore_AILaunchers call BIS_fnc_selectRandom;
	for "_a" from 1 to 2 do 
	{ 
		private _ammo = [_launcher] call DGCore_fnc_selectMagazine;
		if !(_ammo isEqualTo "") then
		{
			_lootCrate addItemCargoGlobal [_ammo,1];
		};
	};
	if (_launcher isEqualType "") then
	{
		_launcher = [_launcher,1];
	};
	_lootCrate addWeaponCargoGlobal _launcher;
};

for "_i" from 1 to (_lootWeaponCount) do
{
	private _weapon = DGCore_AIWeapons call BIS_fnc_selectRandom;
	for "_a" from 1 to 4 do 
	{ 
		private _ammo = [_weapon] call DGCore_fnc_selectMagazine;
		if !(_ammo isEqualTo "") then
		{
			_lootCrate addItemCargoGlobal [_ammo,1];;
		};
	};
	if (_weapon isEqualType "") then
	{
		_weapon = [_weapon,1];
	};
	_lootCrate addWeaponCargoGlobal _weapon;
};

for "_i" from 1 to _lootVestCount do
{
	_vest = DGCore_AIVests call BIS_fnc_selectRandom;
	if (_vest isEqualType "") then
	{
		_vest = [_vest,1];
	};
	_lootCrate addItemCargoGlobal _vest;
};

for "_i" from 1 to _lootBackpackCount do
{
	_bp = DGCore_Backpacks call BIS_fnc_selectRandom;
	if (_bp isEqualType "") then
	{
		_bp = [_bp,1];
	};
	_lootCrate addItemCargoGlobal _bp;
};

for "_i" from 1 to _lootAttachmentCount do
{
	_attachments = DGCore_AIWeaponOptics call BIS_fnc_selectRandom;
	if (_attachments isEqualType "") then
	{
		_attachments = [_attachments,1];
	};
	_lootCrate addItemCargoGlobal _attachments;
};

for "_i" from 1 to _lootItemCount do
{
	_item = DGCore_AIItems call BIS_fnc_selectRandom;
	if (_item isEqualType "") then
	{
		_item = [_item,1];
	};
	_lootCrate addItemCargoGlobal _item;
};

for "_i" from 1 to _lootMaterialCount do
{
	_material = DGCore_LootMaterials call BIS_fnc_selectRandom;
	if (_material isEqualType "") then
	{
		_material = [_material,1];
	};
	_lootCrate addItemCargoGlobal _material;
};

// Now continue with rest of loot crate behaviour
private _spawnedInAir = false;
if(position _lootCrate select 2 > 5) then // This crate needs a chute
{
	_spawnedInAir = true;
};

_crateHeight = [_lootCrate] call DGCore_fnc_getObjectHeight;
if(!isNil "_attachLight" && (_attachLight != "")) then
{
	_light = _attachLight createVehicle position _lootCrate;
    _light attachTo [_lootCrate, [0, 0, (_crateHeight - CRATE_ATTACH_OFFSET)]]; // Adjust position if needed
};

if(!isNil "_attachSmoke" && (_attachSmoke != "")) then
{
	_smoke = _attachSmoke createVehicle position _lootCrate;
	_smoke attachTo [_lootCrate, [0, 0, (_crateHeight - CRATE_ATTACH_OFFSET)]]; // Adjust position if needed
};

if(_spawnedInAir) then
{
	[_lootCrate] spawn
	{
		params ["_crate"];
		if(isNil "_crate" || isNull _crate) exitWith{};
		uiSleep 0.4;
		_chute = createVehicle ["B_Parachute_02_F", (getPosATL _crate), [], 0, "NONE"];
		_chute enableSimulationGlobal true;
		_crate attachTo [_chute,[0,0,-1.5]];
		
		//Wait until land
		WaitUntil {((((position _crate) select 2) < 2) || (isNil "_chute"))};
		detach _crate;
	};
};

[_lootCrate, _locked] call DGCore_fnc_setCrateLock; // set crate locked state

[_lootCrate, _attachSmoke, _smoke, _light] spawn
{
	params ["_crate", "_attachSmoke", "_smoke", "_light"];
	if(isNil "_crate" || isNull _crate) exitWith{};
	
	_crateHeight = [_crate] call DGCore_fnc_getObjectHeight;
	private _lootMarkerCreated = false;
	
	while {true} do
	{
		if(isNil "_crate" || isNull _crate) exitWith{};
		
        if (isNull _smoke && {_attachSmoke != ""}) then {
            _smoke = _attachSmoke createVehicle position _crate;
            _smoke attachTo [_crate, [0, 0, (_crateHeight - CRATE_ATTACH_OFFSET)]];
        };
		
		private _isCargoLocked = [_crate] call DGCore_fnc_crateIsLocked;		
		if(!_isCargoLocked && !_lootMarkerCreated) then
		{
			[_crate] call DGCore_fnc_addCrateMarker;
			_lootMarkerCreated = true;
		};
		
		private _nearbyPlayers = [position _crate, 25] call DGCore_fnc_getNearbyPlayers;
		if(count _nearbyPlayers > 0 && !_isCargoLocked) exitWith{};
		
		uiSleep 5;
	};
	
    // Clean up smoke and light
    if (!isNull _smoke) then { deleteVehicle _smoke; };
    if (!isNull _light) then { deleteVehicle _light; };
};

_lootCrate
