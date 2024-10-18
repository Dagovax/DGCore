/*

	DGCore_fnc_spawnConvoyArray

	Purpose: spawns an AI convoy at random coordinates, using input array data

	Parameters:
		_side: 	Group side
		_pos: 	Position to spawn
		_count: 

	Example: ["I am being logged", "DG RoamingAI", "information"] call DGCore_fnc_log;

	Returns: Spawned Convoy info 

	Copyright 2024 by Dagovax
*/
params[["_convoyType", objNull], ["_arrayData", []], ["_spawnPos", [0,0,0]], ["_travelDistance", -1]];
if(isNil "_arrayData" || typeName _arrayData != "ARRAY" ) exitWith
{
	["Not enough valid params to spawn convoy (array)! -> _arrayData is not of type array! Use '[]' if you want to spawn random configuration instead!", "DGCore_fnc_spawnConvoyArray", "error"] call DGCore_fnc_log;
};

if(typeName _convoyType == "ARRAY" || isNil "_convoyType") then
{
	_convoyType = selectRandom ["ArmedConvoy", "ArmedTroopConvoy", "ArmedTankConvoy"];
};

private ["_convoyInfo", "_convoyData", "_travelDistance", "_spawnRadius", "_convoySide", "_speedLimit", "_playerCanGetIn", "_dynamicLoot", "_aiLevel", "_weapons", "_enableLauncher", "_markerData"];

if !(_arrayData isEqualTo []) then
{
	_convoyData = _arrayData select 0;
	if(_travelDistance isEqualTo -1) then
	{
		_travelDistance = _arrayData select 1; // Use config travel distance, not the default
	};
	_spawnRadius = _arrayData select 2;
	_convoySide = _arrayData select 3;
	_speedLimit = _arrayData select 4;
	_playerCanGetIn = _arrayData select 5;
	_dynamicLoot = _arrayData select 6;
	_aiLevel = _arrayData select 7;
	_weapons = _arrayData select 8;
	_enableLauncher = _arrayData select 9;
	_markerData = _arrayData select 10;
} else
{
	switch (toLowerANSI _convoyType) do 
	{
		case "armedtankconvoy": 
		{
			_convoyData = DGCore_ArmedTankConvoy;
			_markerData = [true, "loc_Attack", "ColorBlack", 0.8, "Convoy"];
			_dynamicLoot = 
			[
				// Items
				[ 
					DGCore_CountItemVehicle,
					[	
						"HandGrenade","HandGrenade","APERSBoundingMine_Range_Mag","optic_Nightstalker"
					]
				],
				[], // Backpacks
				[] // Weapons
			];
		};
		case "armedtroopconvoy": 
		{
			_convoyData = DGCore_ArmedTroopConvoy;
			_markerData = [true, "loc_Truck", "ColorRed", 0.8, "Convoy"];
			_dynamicLoot = 
			[
				// Items
				[ 
					DGCore_CountItemVehicle,
					[	
						"HandGrenade","HandGrenade","APERSBoundingMine_Range_Mag","optic_Nightstalker"
					]
				],
				[], // Backpacks
				[] // Weapons
			];
		};
		default 
		{
			_convoyData = DGCore_ArmedConvoy;
			_markerData = [true, "loc_car", "ColorOrange", 0.8, "Convoy"];
			_dynamicLoot = 
			[
				[], // Items
				[], // Backpacks
				[] // Weapons
			];
		};
	};
	
	_spawnRadius = 250;
	_convoySide = DGCore_Side;
	_speedLimit = 50;
	_playerCanGetIn = true;
	_aiLevel = "calculate";
	_weapons = DGCore_AIWeapons;
	_enableLauncher = true;
	
	["Creating random DGCore Convoy Defaults!", "DGCore_fnc_spawnConvoyArray", "debug"] call DGCore_fnc_log;
};

[format ["Spawning Convoy with arguments -> _convoyType = %1 | _convoyData = %2 | _spawnRadius = %3 | _convoySide = %4 | _speedLimit = %5", _convoyType, _convoyData, _spawnRadius, _convoySide, _speedLimit], "DGCore_fnc_spawnConvoyArray", "debug"] call DGCore_fnc_log;
_convoyInfo = [_convoyType, _convoyData, _spawnPos, _travelDistance, _spawnRadius, _convoySide, _speedLimit, _dynamicLoot, _playerCanGetIn, _aiLevel, _weapons, _enableLauncher, _markerData] call DGCore_fnc_spawnConvoy;

_convoyInfo
