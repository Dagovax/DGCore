/*

	DGCore_fnc_spawnCUPCastle

	Purpose: Spawns buildings on a position, using ASL 

	Example: _newDummy = call DGCore_fnc_spawnCUPCastle;

	Returns: CUP Castle buildings (50x50) radius

	Copyright 2024 by Dagovax
*/

params[["_pos", [-1,-1,-1]]];
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to spawn castle! -> _pos = %1", _pos], "DGCore_fnc_spawnCastle", "error"] call DGCore_fnc_log;
};

private _name = "Large Castle";

// 46 Objects from EDEN format
private _objects = [
	["Land_A_Castle_Bergfrit", [4558.16, 4669.51, 84.9117], [-0.196759, 0.980452, 0], [0, 0, 1], true],
	["Land_A_Castle_Gate", [4520.82, 4664.28, 74.4317], [0.988246, 0.152872, 0], [0, 0, 1], true],
	["Land_A_Castle_Stairs_A", [4548.6, 4674.89, 75.1491], [0.975023, 0.222102, 0], [0, 0, 1], true],
	["Land_A_Castle_Wall1_20", [4526.9, 4644.85, 75.0612], [-0.979252, -0.202648, 0], [0, 0, 1], true],
	["Land_A_Castle_Wall1_20", [4518.82, 4684.46, 75.0612], [-0.979252, -0.202648, 0], [0, 0, 1], true],
	["Land_A_Castle_Wall1_Corner", [4528.05, 4636.23, 74.9525], [-0.902686, -0.430301, 0], [0, 0, 1], true],
	["Land_A_Castle_Wall1_20", [4537.72, 4637.67, 75.0612], [0.159239, -0.98724, 0], [0, 0, 1], true],
	["Land_A_Castle_Wall1_20", [4557.96, 4640.81, 75.0612], [0.159239, -0.98724, 0], [0, 0, 1], true],
	["Land_A_Castle_Wall1_Corner", [4566.66, 4641.96, 74.9525], [0.1168, -0.993155, 0], [0, 0, 1], true],
	["Land_A_Castle_Wall1_20", [4564.8, 4651.56, 75.0612], [0.981268, 0.192648, 0], [0, 0, 1], true],
	["Land_A_Castle_Wall1_20", [4560.58, 4671.48, 75.0612], [0.975297, 0.220899, 0], [0, 0, 1], true],
	["Land_A_Castle_Wall1_Corner", [4516.76, 4693.37, 74.9525], [-0.141908, 0.98988, 0], [0, 0, 1], true],
	["Land_A_Castle_Wall1_20", [4525.69, 4695.09, 75.0612], [-0.125799, 0.992056, 0], [0, 0, 1], true],
	["Land_A_Castle_Wall1_20", [4545.96, 4697.76, 75.0612], [-0.149745, 0.988725, 0], [0, 0, 1], true],
	["Land_A_Castle_Wall1_20", [4557.31, 4689.23, 75.0612], [0.977321, 0.211762, 0], [0, 0, 1], true],
	["Land_A_Castle_Wall1_Corner", [4555.45, 4698.7, 74.9525], [0.958733, 0.284307, 0], [0, 0, 1], true],
	["Flag_Red_F", [4552.92, 4660.9, 75.5511], [-0.796264, -0.60495, 0], [0, 0, 1], true],
	["Land_Loudspeakers_F", [4551.59, 4676.93, 75.0775], [-0.99995, 0.0100349, 0], [0, 0, 1], true],
	["Land_LampAirport_F", [4556.03, 4679.03, 83.9934], [-0.953933, 0.30002, 0], [0, 0, 1], true],
	["Land_LampAirport_F", [4560.04, 4660.75, 83.9934], [-0.51918, -0.854665, 0], [0, 0, 1], true],
	["Land_Addon_01_V1_ruins_F", [4533.32, 4641.03, 71.339], [0.150142, -0.988664, 0], [0, 0, 1], true],
	["Land_ruin_rubble", [4551.22, 4694.62, 71.4629], [0, 1, 0], [0, 0, 1], true],
	["Land_Fortress_01_bricks_v1_F", [4522.47, 4690.2, 72.0584], [0, 1, 0], [0, 0, 1], true],
	["CampEast_EP1", [4559.44, 4645.4, 72.9263], [0.989297, 0.145914, 0], [0, 0, 1], true],
	["CampEast_EP1", [4558.14, 4653, 72.9263], [0.989297, 0.145914, 0], [0, 0, 1], true],
	["CUP_sign_attention", [4515.21, 4659.7, 73.2791], [0.989403, 0.145197, 0], [0, 0, 1], true],
	["Land_HBarrier_large", [4531.48, 4666.05, 72.6148], [-0.983853, -0.178978, 0], [0, 0, 1], true],
	["Fort_RazorWire", [4533.4, 4666.58, 72.3294], [-0.976686, -0.214673, 0], [0, 0, 1], true],
	["Land_Misc_Cargo2D_EP1", [4538.21, 4694.4, 74.1172], [-0.994599, -0.103797, 0], [0, 0, 1], true],
	["Land_Fort_Watchtower", [4539.03, 4667.31, 73.7861], [0.98978, 0.142606, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4522.81, 4676.03, 77.5565], [0.769721, -0.63838, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4527.17, 4653.9, 77.5565], [-0.465996, -0.884787, 0], [0, 0, 1], true],
	["Land_Lampa_ind_zebr", [4514.77, 4659.13, 76.2528], [0, 1, 0], [0, 0, 1], true],
	["Land_Lampa_ind_zebr", [4513.52, 4667.69, 76.2528], [-0.312199, 0.950017, 0], [0, 0, 1], true]
];

// Spawn buildings
private _baseObjects = [_objects, _pos] call DGCore_fnc_createEdenConvertedBase;

[_name, _baseObjects]
