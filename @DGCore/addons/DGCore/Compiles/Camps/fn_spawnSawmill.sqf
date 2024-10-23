/*

	DGCore_fnc_spawnSawmill

	Purpose: Spawns buildings on a position, using ASL 

	Example: _newDummy = call DGCore_fnc_spawnSawmill;

	Returns: Lumbermill buildings (25x25) radius

	Copyright 2024 by Dagovax
*/

params[["_pos", [-1,-1,-1]]];
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to spawn lumbermill! -> _pos = %1", _pos], "DGCore_fnc_spawnSawmill", "error"] call DGCore_fnc_log;
};

private _name = "Lumbermill";

// 46 Objects from EDEN format
private _objects = [
	["Land_Sawmill_01_F", [5005.51, 4561.81, 77.3664], [-0.494261, -0.869314, 0], [0, 0, 1], true],
	["Land_WoodenShelter_01_ruins_F", [5010.19, 4553.65, 71.6949], [-0.627835, -0.778346, 0], [0, 0, 1], true],
	["Land_WoodenBox_F", [5001.15, 4571.37, 71.6044], [0.885953, -0.463776, 0], [0, 0, 1], true],
	["Land_WoodenLog_02_F", [4997.66, 4571.49, 71.9259], [-0.627835, -0.778346, 0], [0, 0, 1], true],
	["Land_WoodenBox_02_F", [4997.4, 4565.25, 72.091], [0.862987, -0.505226, 0], [0, 0, 1], true],
	["Land_WoodenBox_02_F", [4996.61, 4564.03, 72.091], [0.862987, -0.505226, 0], [0, 0, 1], true],
	["Land_Shed_09_F", [5004.45, 4546.63, 73.2171], [-0.532844, -0.846213, 0], [0, 0, 1], true],
	["Land_WoodenShelter_01_F", [5011.1, 4558.87, 72.7181], [-0.859614, 0.510944, 0], [0, 0, 1], true],
	["Pile_of_wood", [4999.41, 4568.05, 72.5873], [-0.471343, -0.88195, 0], [0, 0, 1], true],
	["Land_WoodPile_large_F", [4996.42, 4569.29, 71.9731], [-0.627835, -0.778346, 0], [0, 0, 1], true],
	["Land_WoodPile_large_F", [4993.54, 4565.05, 71.9731], [-0.627835, -0.778346, 0], [0, 0, 1], true],
	["Land_WoodPile_large_F", [4995.18, 4569.66, 71.9731], [0.46658, 0.884479, 0], [0, 0, 1], true],
	["Land_WoodPile_large_F", [4992.16, 4565.78, 71.9731], [0.46658, 0.884479, 0], [0, 0, 1], true],
	["Land_WoodPile_F", [4991.7, 4559.57, 71.8643], [-0.873359, 0.487077, 0], [0, 0, 1], true],
	["Land_WoodPile_02_F", [4990.76, 4549.15, 72.412], [0.49723, 0.867619, 0], [0, 0, 1], true],
	["Land_WoodPile_03_F", [4988.26, 4550.65, 72.398], [0.501375, 0.86523, 0], [0, 0, 1], true],
	["Land_WoodenCart_F", [4988.42, 4558.47, 72.2831], [-0.562378, -0.82688, 0], [0, 0, 1], true],
	["Axe_woodblock", [4996.45, 4572.3, 71.9573], [-0.627835, -0.778346, 0], [0, 0, 1], true],
	["Land_transport_crates_EP1", [5003.59, 4572.51, 72.3433], [-0.531221, -0.847233, 0], [0, 0, 1], true],
	["Land_KBud", [5013.18, 4565.38, 72.8365], [-0.847089, 0.531451, 0], [0, 0, 1], true],
	["Exile_Construction_WoodWall_Static", [5011.97, 4570.22, 71.6043], [0.887713, -0.460396, 0], [0, 0, 1], true],
	["Exile_Construction_WoodWall_Static", [5006.27, 4573.32, 71.6043], [0.827473, -0.561506, 0], [0, 0, 1], true],
	["Exile_Construction_WoodGate_Static", [5010.61, 4574.28, 71.6043], [-0.490689, -0.871335, 0], [0, 0, 1], true],
	["Land_Loudspeakers_F", [4996.03, 4563.14, 75.1075], [-0.890544, 0.454898, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [5001.69, 4573.1, 77.5865], [0.894954, 0.446158, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [5012.29, 4567.67, 77.5865], [0.373418, -0.927663, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [5000.8, 4543.98, 77.5865], [-0.999759, -0.021932, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4986.73, 4551.73, 77.5865], [-0.889133, 0.457649, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4995.77, 4562.01, 77.5865], [0.524143, 0.851631, 0], [0, 0, 1], true]
];

// Spawn buildings
private _baseObjects = [_objects, _pos] call DGCore_fnc_createEdenConvertedBase;

[_name, _baseObjects]
