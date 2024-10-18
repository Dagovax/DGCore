/*

	DGCore_fnc_addVehicleLoot

	Purpose: spawns an AI convoy at random coordinates, using input array data

	Parameters:
		_side: 	Group side
		_pos: 	Position to spawn
		_count: 

	Example: ["I am being logged", "DG RoamingAI", "information"] call DGCore_fnc_log;

	Returns: Spawned Convoy info 

	Copyright 2024 by Dagovax
*/
params[["_vehicle", objNull], ["_staticLoot", []], ["_dynamicLoot", []], ["_money", 0]];
if(isNull _vehicle || !alive _vehicle) exitWith
{
	[format["Not enough valid params to add loot to vehicle! -> _vehicle = %1", _vehicle], "DGCore_fnc_addVehicleLoot", "error"] call DGCore_fnc_log;
};

_vehicle setVariable ["ExileMoney", _money, true];
clearItemCargoGlobal _vehicle;
clearWeaponCargoGlobal _vehicle;
clearMagazineCargoGlobal _vehicle;
clearBackPackCargoGlobal _vehicle;

// First add static loot
if !(_staticLoot isEqualTo []) then
{
	{
		_classStatic = _x select 0;
		_countStatic = _x select 1;
		_typeStatic = _x select 2;
	
		switch (_typeStatic) do
		{
			case 1: {_vehicle addWeaponCargoGlobal [_classStatic, _countStatic];};
			case 2: {_vehicle addMagazineCargoGlobal [_classStatic, _countStatic];};
			case 3: {_vehicle addBackpackCargoGlobal [_classStatic, _countStatic];};
			case 4: {_vehicle addItemCargoGlobal [_classStatic, _countStatic];};
			default {[format["Wrong type for item %1 in static loot for %2 -> '%3' is not supported!", _classStatic, _vehicle, _typeStatic], "DGCore_fnc_addVehicleLoot", "warning"] call DGCore_fnc_log;};
		};
		
		[format["Adding item %1 in static loot to vehicle %2", _classStatic, _vehicle], "DGCore_fnc_addVehicleLoot", "debug"] call DGCore_fnc_log;
	} forEach _staticLoot;
};

if !(_dynamicLoot isEqualTo []) then
{
	_dynamicItems = _dynamicLoot select 0;
	_dynamicBackpacks = _dynamicLoot select 1;
	_dynamicWeapons = _dynamicLoot select 2;

	private ["_countItems", "_vehicleItems", "_countBackpacks", "_vehicleBackpacks", "_countWeapons", "_vehicleWeapons"];
	
	// Items
	if(!isNil "_dynamicItems" && typeName _dynamicItems == "ARRAY" && !(_dynamicItems isEqualTo [])) then
	{
		_itemCountMinMax = _dynamicItems select 0;
		_vehicleItems = _dynamicItems select 1;
		_countItems = (_itemCountMinMax select 0) + round random ((_itemCountMinMax select 1) - (_itemCountMinMax select 0));
	} else
	{
		_countItems = (DGCore_CountItemVehicle select 0) + round random ((DGCore_CountItemVehicle select 1) - (DGCore_CountItemVehicle select 0));
		_vehicleItems = DGCore_AIItems;
	};
	for "_i" from 1 to _countItems do
	{
		if (count(_vehicleItems) > 0) then
		{
			_itemVeh =  selectRandom _vehicleItems;
			_vehicle addItemCargoGlobal [_itemVeh,1];
		};
	};
	[format["Adding %1 random items from dynamic loot to vehicle %2", _countItems, _vehicle], "DGCore_fnc_addVehicleLoot", "debug"] call DGCore_fnc_log;
	
	// Backpack
	if(!isNil "_dynamicBackpacks" && typeName _dynamicBackpacks == "ARRAY" && !(_dynamicBackpacks isEqualTo [])) then
	{
		_backpackCountMinMax = _dynamicBackpacks select 0;
		_vehicleBackpacks = _dynamicBackpacks select 1;
		_countBackpacks = (_backpackCountMinMax select 0) + round random ((_backpackCountMinMax select 1) - (_backpackCountMinMax select 0));
	} else
	{
		_countBackpacks = (DGCore_CountBackpackVehicle select 0) + round random ((DGCore_CountBackpackVehicle select 1) - (DGCore_CountBackpackVehicle select 0));
		_vehicleBackpacks = DGCore_Backpacks;
	};
	for "_i" from 1 to _countBackpacks do
	{
		if (count(_vehicleBackpacks) > 0) then
		{
			_backpackVeh =  selectRandom _vehicleBackpacks;
			_vehicle addBackpackCargoGlobal [_backpackVeh,1];
		};
	};
	[format["Adding %1 random backpacks from dynamic loot to vehicle %2", _countBackpacks, _vehicle], "DGCore_fnc_addVehicleLoot", "debug"] call DGCore_fnc_log;
	
	// Weapons
	if(!isNil "_dynamicWeapons" && typeName _dynamicWeapons == "ARRAY" && !(_dynamicWeapons isEqualTo [])) then
	{
		_weaponCountMinMax = _dynamicWeapons select 0;
		_vehicleWeapons = _dynamicWeapons select 1;
		_countWeapons = (_weaponCountMinMax select 0) + round random ((_weaponCountMinMax select 1) - (_weaponCountMinMax select 0));
	} else
	{
		_countWeapons = (DGCore_CountWeaponVehicle select 0) + round random ((DGCore_CountWeaponVehicle select 1) - (DGCore_CountWeaponVehicle select 0));
		_vehicleWeapons = DGCore_AIWeapons;
	};
	for "_i" from 1 to _countWeapons do
	{
		if (count(_vehicleWeapons) > 0) then
		{
			_weaponVeh =  selectRandom _vehicleWeapons;
			_ammo1 = [_weaponVeh] call DGCore_fnc_selectMagazine;
			_ammo2 = [_weaponVeh, true] call DGCore_fnc_selectMagazine;
			_ammo3 = [_weaponVeh, true] call DGCore_fnc_selectMagazine;
			_vehicle addMagazineCargoGlobal [_ammo1, 1];
			_vehicle addMagazineCargoGlobal [_ammo2, 1];
			_vehicle addMagazineCargoGlobal [_ammo3, 1];
			_vehicle addWeaponCargoGlobal [_weaponVeh,1];
		};
	};
	[format["Adding %1 random weapons + magazines from dynamic loot to vehicle %2", _countWeapons, _vehicle], "DGCore_fnc_addVehicleLoot", "debug"] call DGCore_fnc_log;
};

