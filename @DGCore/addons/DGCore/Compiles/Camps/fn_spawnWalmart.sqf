/*

	DGCore_fnc_spawnWalmart

	Purpose: Spawns buildings on a position, using ASL 

	Example: _newDummy = call DGCore_fnc_spawnWalmart;

	Returns: Walmart buildings (20x20) radius

	Copyright 2024 by Dagovax
*/

params[["_pos", [-1,-1,-1]]];
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to spawn walmart! -> _pos = %1", _pos], "DGCore_fnc_spawnWalmart", "error"] call DGCore_fnc_log;
};

private _name = "Walmart";

// 46 Objects from EDEN format
private _objects = [
	["Land_Shop_Town_05_F", [4360.47, 4557.43, 74.4259], [0.972749, 0.23186, 0], [0, 0, 1], true],
	["Land_FuelStation_Build_F", [4336.39, 4552.1, 72.9638], [0.977581, 0.210558, 0], [0, 0, 1], true],
	["Land_LampAirport_F", [4350.67, 4544.43, 83.9934], [-0.233739, 0.972299, 0], [0, 0, 1], true],
	["Land_LampAirport_F", [4344.02, 4565.86, 83.9934], [0.202687, -0.979244, 0], [0, 0, 1], true],
	["Land_WoodenCounter_01_F", [4335.72, 4555.49, 72.0502], [-0.180768, 0.983526, 0], [0, 0, 1], true],
	["Land_MarketShelter_F", [4362.9, 4543.82, 73.1066], [0.199226, -0.979954, 0], [0, 0, 1], true],
	["Land_Billboard_04_supermarket_maskrtnik_F", [4339.61, 4553.16, 77.2649], [0.186759, -0.982406, 0], [0, 0, 1], true],
	["Land_CratesShabby_F", [4335.92, 4548.37, 72.3342], [-0.274694, 0.961532, 0], [0, 0, 1], true],
	["Land_stand_small_EP1", [4338.41, 4548.74, 72.076], [-0.241262, 0.97046, 0], [0, 0, 1], true],
	["CUP_icebox", [4354, 4565.77, 72.1966], [0.260679, -0.965425, 0], [0, 0, 1], true],
	["Land_CashDesk_F", [4353.5, 4558.09, 71.7243], [0.968646, 0.248446, 0], [0, 0, 1], true],
	["CUP_box_c", [4355.54, 4565.78, 71.5743], [0.177776, -0.984071, 0], [0, 0, 1], true],
	["RoadBarrier_small_F", [4337.34, 4555.76, 72.2144], [-0.167625, 0.985851, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4351.6, 4559.27, 77.5565], [-0.211106, 0.977463, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4353.31, 4551.78, 77.5565], [-0.211106, 0.977463, 0], [0, 0, 1], true],
	["Land_Loudspeakers_F", [4357.53, 4547.24, 75.0775], [0, 1, 0], [0, 0, 1], true]
];

// Spawn buildings
private _baseObjects = [_objects, _pos] call DGCore_fnc_createEdenConvertedBase;

[_name, _baseObjects]
