/*

	DGCore_fnc_spawnCastle

	Purpose: Spawns buildings on a position, using ASL 

	Example: _newDummy = call DGCore_fnc_spawnCastle;

	Returns: Small Camp buildings (25x25) radius

	Copyright 2024 by Dagovax
*/

params[["_pos", [-1,-1,-1]]];
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to spawn castle! -> _pos = %1", _pos], "DGCore_fnc_spawnCastle", "error"] call DGCore_fnc_log;
};

private _name = "Small Castle";

// 46 Objects from EDEN format
private _objects = [
	["Land_Castle_01_tower_F", [4570.25, 4585.58, 81.9857], [0.754383, -0.656434, 0], [0, 0, 1], true],
	["Land_Loudspeakers_F", [4569.34, 4590.97, 75.1075], [0.198718, -0.980057, 0], [0, 0, 1], true],
	["Land_CastleRuins_01_bastion_F", [4561.17, 4606.11, 72.8951], [-0.156377, 0.987697, 0], [0, 0, 1], true],
	["Land_CastleRuins_01_wall_10m_F", [4575.14, 4593.9, 72.7521], [0.989263, 0.146149, 0], [0, 0, 1], true],
	["Land_BasaltWall_01_gate_F", [4546.61, 4590.85, 72.5658], [-0.97818, -0.20776, 0], [0, 0, 1], true],
	["Land_CastleRuins_01_wall_10m_F", [4576.46, 4584.43, 72.7521], [0.993084, 0.11741, 0], [0, 0, 1], true],
	["Land_CastleRuins_01_wall_10m_F", [4571.8, 4579.45, 72.7521], [0.132978, -0.991119, 0], [0, 0, 1], true],
	["Land_CastleRuins_01_wall_10m_F", [4562.64, 4578.18, 72.7521], [0.132978, -0.991119, 0], [0, 0, 1], true],
	["Land_CastleRuins_01_wall_10m_F", [4552.85, 4576.8, 72.7521], [0.132978, -0.991119, 0], [0, 0, 1], true],
	["Land_CastleRuins_01_wall_10m_F", [4570.1, 4601.49, 72.7521], [0.498202, 0.867061, 0], [0, 0, 1], true],
	["Land_CastleRuins_01_wall_d_R_F", [4548.25, 4574.57, 72.6015], [0.988335, 0.152293, 0], [0, 0, 1], true],
	["Land_CastleRuins_01_wall_10m_F", [4546.99, 4581.86, 72.7521], [0.980252, 0.197754, 0], [0, 0, 1], true],
	["Land_CastleRuins_01_wall_10m_F", [4543.73, 4599.37, 72.7521], [0.98726, 0.159116, 0], [0, 0, 1], true],
	["Land_CastleRuins_01_wall_10m_F", [4546.43, 4606.45, 72.7521], [0.603515, -0.797352, 0], [0, 0, 1], true],
	["Land_CastleRuins_01_wall_10m_F", [4554.8, 4610.07, 72.7519], [0.178483, -0.983943, 0], [0, 0, 1], true],
	["Flag_Red_F", [4559.65, 4593.33, 75.5811], [0, 1, 0], [0, 0, 1], true],
	["Land_SharpStones_erosion", [4567.67, 4596.79, 71.5959], [-0.918196, 0.396126, 0], [0, 0, 1], true],
	["Land_Stone_Shed_V1_ruins_F", [4549.48, 4602.77, 71.0147], [-0.598955, 0.800783, 0], [0, 0, 1], true],
	["Land_Grave_V3_F", [4549.8, 4579.97, 72.4135], [0.161494, -0.986874, 0], [0, 0, 1], true],
	["Land_i_Stone_Shed_01_c_raw_F", [4562.14, 4583.83, 71.9663], [0.164103, -0.986443, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4559.07, 4599.45, 72.6882], [-0.128714, 0.991682, 0], [0, 0, 1], true],
	["Lantern_01_black_F", [4549.57, 4581.61, 72.2253], [0, 1, -0.000345267], [0.00192236, 0.000345266, 0.999998], true],
	["Land_LampHalogen_F", [4548.18, 4586.11, 77.5865], [-0.571758, -0.820422, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4546.33, 4596.09, 77.5865], [0.601502, -0.798871, 0], [0, 0, 1], true],
	["Land_LampShabby_F", [4544.66, 4586.39, 75.3764], [0, 1, 0], [0, 0, 1], true],
	["Land_LampShabby_F", [4543.14, 4594.66, 75.3764], [0.165001, -0.986293, 0], [0, 0, 1], true],
	["Land_LampAirport_F", [4573.55, 4590.1, 84.0234], [-0.982984, -0.18369, 0], [0, 0, 1], true]
];

// Spawn buildings
private _baseObjects = [_objects, _pos] call DGCore_fnc_createEdenConvertedBase;

[_name, _baseObjects]
