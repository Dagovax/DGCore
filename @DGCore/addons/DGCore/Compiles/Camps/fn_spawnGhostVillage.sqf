/*

	DGCore_fnc_spawnGhostVillage

	Purpose: Spawns buildings on a position, using ASL 

	Example: _newDummy = call DGCore_fnc_spawnGhostVillage;

	Returns: Ghost Village buildings (20x20) radius

	Copyright 2024 by Dagovax
*/

params[["_pos", [-1,-1,-1]]];
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to spawn ghost village! -> _pos = %1", _pos], "DGCore_fnc_spawnGhostVillage", "error"] call DGCore_fnc_log;
};

private _name = "Ghost Hamlet";

// 46 Objects from EDEN format
private _objects = [
	["Land_u_House_Big_01_V1_F", [4446.06, 4704.68, 74.6407], [-0.160813, 0.986985, 0], [0, 0, 1], true],
	["Land_d_House_Big_02_V1_F", [4432.91, 4689.31, 74.7257], [0.183768, -0.98297, 0], [0, 0, 1], true],
	["Land_GH_House_1_F", [4429.2, 4718.88, 74.3326], [0, 1, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4414.14, 4707.45, 72.3785], [-0.981169, -0.193149, 0], [0, 0, 1], true],
	["Land_PoleWall_01_3m_F", [4416.63, 4703.91, 71.7809], [0.162087, -0.986777, 0], [0, 0, 1], true],
	["Land_PoleWall_01_3m_F", [4417.43, 4700.61, 71.7809], [0.162087, -0.986777, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4416.7, 4696.35, 72.3785], [-0.981169, -0.193149, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4414.98, 4715.17, 72.4715], [0.918395, -0.395666, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4419.9, 4721.06, 72.6598], [0.548893, -0.835892, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4427.23, 4723.73, 72.8033], [0.110389, -0.993888, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4435.26, 4724.25, 72.5909], [0.0432625, -0.999064, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4443.25, 4723.64, 72.3785], [-0.141209, -0.98998, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4450.83, 4721.18, 72.3785], [-0.463389, -0.886155, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4456.96, 4716.26, 72.3785], [-0.751554, -0.659671, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_4m_F", [4460.07, 4711.29, 72.3785], [-0.974894, -0.22267, 0], [0, 0, 1], true],
	["Land_PoleWall_01_3m_F", [4458.9, 4708.95, 71.7809], [0.162087, -0.986777, 0], [0, 0, 1], true],
	["Land_PoleWall_01_3m_F", [4459.95, 4704.79, 71.7809], [0.162087, -0.986777, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_4m_F", [4461.94, 4703.02, 72.3785], [-0.974894, -0.22267, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4460.18, 4697.73, 72.3785], [-0.842573, 0.538583, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4455.02, 4691.72, 72.3785], [-0.659305, 0.751875, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4448.79, 4686.65, 72.3785], [-0.608863, 0.793275, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4441.73, 4683.22, 72.3785], [-0.239259, 0.970956, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4433.9, 4681.33, 72.3785], [-0.225556, 0.97423, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4426.25, 4681.79, 72.3785], [0.314932, 0.949114, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_8m_F", [4420.46, 4686.51, 72.3785], [0.868392, 0.495879, 0], [0, 0, 1], true],
	["Land_WoodenWall_01_m_4m_F", [4417.98, 4691.25, 72.3785], [0.922223, 0.386659, 0], [0, 0, 1], true],
	["Land_Tyres_F", [4460.16, 4703.29, 71.8467], [0.373112, 0.927786, 0], [0, 0, 1], true],
	["Land_Tyres_F", [4458.44, 4710.69, 71.8467], [0.860216, -0.50993, 0], [0, 0, 1], true],
	["Land_Tyres_F", [4418.15, 4698.44, 71.8467], [0.897782, -0.44044, 0], [0, 0, 1], true],
	["Land_Tyres_F", [4416.28, 4705.79, 71.8467], [0.388776, 0.921332, 0], [0, 0, 1], true],
	["Land_Loudspeakers_F", [4435.03, 4710.41, 75.0812], [-0.985831, -0.167739, 0], [0, 0, 1], true],
	["Campfire_burning_F", [4428.59, 4689.09, 71.7939], [0, 1, 0], [0, 0, 1], true],
	["Land_LampStreet_small_F", [4415.47, 4699.75, 74.6764], [0, 1, 0], [0, 0, 1], true],
	["Land_LampStreet_small_F", [4414.47, 4703.84, 74.6764], [0, 1, 0], [0, 0, 1], true],
	["Land_LampStreet_small_F", [4460.8, 4710.38, 74.6764], [0, 1, 0], [0, 0, 1], true],
	["Land_LampStreet_small_F", [4462.17, 4704.46, 74.6764], [0, 1, 0], [0, 0, 1], true],
	["Land_Fortress_01_bricks_v2_F", [4419.42, 4694.76, 71.8059], [-0.967805, -0.2517, 0], [0, 0, 1], true],
	["Land_d_Windmill01_F", [4425.92, 4685.98, 74.1316], [0, 1, 0], [0, 0, 1], true],
	["Land_Tank_rust_F", [4422.34, 4714.54, 73.0136], [0.999765, -0.0216938, -0.000390467], [0, -0.0179961, 0.999838], true],
	["Land_WheelCart_F", [4447.8, 4696.38, 71.9478], [-0.990072, -0.140562, 0], [0, 0, 1], true],
	["Land_StallWater_F", [4440.75, 4722.46, 71.9858], [0.229102, 0.973402, 0], [0, 0, 1], true],
	["Land_Grave_dirt_F", [4445.14, 4686.95, 71.9295], [0.850129, 0.526574, 0], [0, 0, 1], true],
	["Land_Grave_dirt_F", [4447.05, 4688.52, 71.9295], [0.79936, 0.600852, 0], [0, 0, 1], true],
	["Land_Grave_rocks_F", [4442.92, 4685.84, 71.756], [0.926407, 0.376523, 0], [0, 0, 1], true],
	["Land_RowBoat_V1_F", [4449.88, 4720.18, 72.085], [-0.319993, -0.94742, 0], [0, 0, 1], true],
	["Land_Wreck_Car2_F", [4452.2, 4706.32, 72.4173], [-0.0484804, 0.998824, 0], [0, 0, 1], true]
];

// Spawn buildings
private _baseObjects = [_objects, _pos] call DGCore_fnc_createEdenConvertedBase;

[_name, _baseObjects]