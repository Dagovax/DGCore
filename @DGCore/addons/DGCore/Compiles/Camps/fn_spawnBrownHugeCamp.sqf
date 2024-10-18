/*

	DGCore_fnc_spawnBrownLargeCamp

	Purpose: Spawns buildings on a position, using ASL 

	Example: _camp = call DGCore_fnc_spawnBrownLargeCamp;

	Returns: Huge Camp buildings (50x50) radius

	Copyright 2024 by Dagovax
*/

params[["_pos", [-1,-1,-1]]];
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to spawn large brown camp! -> _pos = %1", _pos], "DGCore_fnc_spawnBrownLargeCamp", "error"] call DGCore_fnc_log;
};

private _name = "Huge Military Camp";

// 46 Objects from EDEN format
private _objects = [
	["Land_GarbageContainer_open_F", [4718.26, 4757.41, 72.3128], [-0.999803, 0.0198718, 0], [0, 0, 1], true],
	["Land_Fire_barrel_burning", [4640.01, 4753.21, 72.1527], [-0.178856, 0.983875, 0], [0, 0, 1], true],
	["Land_Fire_barrel_burning", [4641.19, 4746.92, 72.1527], [0.215841, -0.976428, 0], [0, 0, 1], true],
	["Land_HBarrier_5_F", [4640.72, 4750.13, 72.3149], [-0.977502, -0.210926, 0], [0, 0, 1], true],
	["Campfire_burning_F", [4642.23, 4750.43, 71.7939], [-0.972738, -0.231907, 0], [0, 0, 1], true],
	["Land_CampingChair_V2_white_F", [4643.83, 4750.68, 72.0758], [0.965925, 0.258823, 0], [0, 0, 1], true],
	["Land_CampingChair_V2_F", [4642.12, 4751.78, 72.0758], [-0.254084, 0.967182, 0], [0, 0, 1], true],
	["Land_CampingChair_V2_F", [4642.69, 4749.01, 72.0758], [0.0747285, -0.997204, 0], [0, 0, 1], true],
	["Land_Cargo20_grey_F", [4694.48, 4761.93, 72.8987], [-0.985072, -0.17214, 0], [0, 0, 1], true],
	["Land_Cargo10_sand_F", [4647.81, 4725.99, 72.9272], [0.214967, -0.976621, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4635.25, 4745.16, 72.6582], [-0.988292, -0.152577, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4634.02, 4753.07, 72.6582], [-0.999215, 0.039622, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4712.96, 4764.66, 72.6582], [0.880091, -0.474804, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4713.44, 4760.45, 72.6582], [0.896475, 0.443094, 0], [0, 0, 1], true],
	["Land_HBarrier_Big_F", [4723.04, 4763.58, 72.7843], [-0.989627, -0.14366, 0], [0, 0, 1], true],
	["Land_HBarrierWall_corridor_F", [4630.66, 4748.68, 72.3363], [0.0933195, -0.995636, 0], [0, 0, 1], true],
	["Land_LampAirport_F", [4674.66, 4748.37, 83.9934], [0.165351, -0.986235, 0], [0, 0, 1], true],
	["Land_LampAirport_F", [4672.04, 4762.69, 83.9934], [-0.211796, 0.977314, 0], [0, 0, 1], true],
	["Land_LampAirport_F", [4712.79, 4762.52, 83.9934], [-0.990134, -0.140125, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4652.5, 4728.23, 77.5565], [0.987324, 0.158718, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4646.36, 4775.01, 77.5565], [-0.984388, -0.176013, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4697.64, 4783.52, 77.5565], [-0.988244, -0.152882, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4703.99, 4737.21, 77.5565], [0.989415, 0.145114, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4634.22, 4744.97, 73.2742], [0.966756, 0.255701, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4632.88, 4753.04, 73.2742], [0.998815, 0.0486775, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4633.89, 4733.74, 73.2742], [0.967045, 0.254606, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4647.9, 4723.94, 73.2742], [-0.220053, 0.975488, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4643.99, 4723.73, 73.2742], [0.121078, 0.992643, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4657.77, 4726.17, 73.2742], [-0.172173, 0.985067, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4635, 4729.96, 73.2742], [0.943132, 0.33242, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4636.93, 4726.66, 73.2742], [0.754039, 0.65683, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4640.07, 4724.58, 73.2742], [0.283065, 0.959101, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4630.14, 4763.76, 73.2742], [0.995959, 0.0898086, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4630.33, 4767.69, 73.2742], [0.981049, -0.193761, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4631.63, 4771.39, 73.2742], [0.904121, -0.427276, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4633.97, 4774.34, 73.2742], [0.641723, -0.766937, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4637.38, 4776.27, 73.2742], [0.323839, -0.946112, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4641.2, 4777.22, 73.2742], [0.198549, -0.980091, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4661.73, 4726.93, 73.2742], [-0.172173, 0.985067, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4665.67, 4727.57, 73.2742], [-0.172173, 0.985067, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4669.55, 4728.27, 73.2742], [-0.172173, 0.985067, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4673.46, 4728.97, 73.2742], [-0.172173, 0.985067, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4684.25, 4730.86, 73.2742], [-0.172173, 0.985067, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4688.22, 4731.62, 73.2742], [-0.172173, 0.985067, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4692.16, 4732.26, 73.2742], [-0.172173, 0.985067, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4696.04, 4732.96, 73.2742], [-0.172173, 0.985067, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4699.95, 4733.65, 73.2742], [-0.172173, 0.985067, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4719.56, 4744.88, 73.2742], [-0.984483, 0.175483, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4719.67, 4748.81, 73.2742], [-0.994117, -0.108315, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4718.33, 4741.16, 73.2742], [-0.911911, 0.410388, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4716.04, 4738.16, 73.2742], [-0.655874, 0.75487, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4712.68, 4736.17, 73.2742], [-0.341378, 0.939926, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4708.87, 4735.15, 73.2742], [-0.216742, 0.976229, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4692.6, 4785.74, 73.2742], [0.157212, -0.987565, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4688.63, 4785.04, 73.2742], [0.157212, -0.987565, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4684.68, 4784.46, 73.2742], [0.157212, -0.987565, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4680.79, 4783.82, 73.2742], [0.157212, -0.987565, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4676.87, 4783.18, 73.2742], [0.157212, -0.987565, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4666.05, 4781.45, 73.2742], [0.157212, -0.987565, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4662.08, 4780.76, 73.2742], [0.157212, -0.987565, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4658.12, 4780.17, 73.2742], [0.157212, -0.987565, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4654.23, 4779.54, 73.2742], [0.157212, -0.987565, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4650.32, 4778.9, 73.2742], [0.157212, -0.987565, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4701.98, 4787.43, 73.2742], [0.187463, -0.982272, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4705.89, 4787.5, 73.2742], [-0.154051, -0.988063, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4709.78, 4786.53, 73.2742], [-0.314832, -0.949147, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4712.85, 4784.35, 73.2742], [-0.775484, -0.631367, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4714.66, 4780.98, 73.2742], [-0.953673, -0.300844, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4715.65, 4777.17, 73.2742], [-0.974983, -0.222277, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4717.06, 4773.42, 73.2742], [-0.875485, -0.483245, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4718.49, 4769.74, 73.2742], [-0.972866, -0.231369, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4719.53, 4752.87, 73.2742], [-0.999229, 0.0392522, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4720.06, 4756.91, 73.2742], [-0.9865, 0.163762, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4720.27, 4760.88, 73.2742], [-0.996532, -0.0832138, 0], [0, 0, 1], true],
	["Land_Mil_WallBig_4m_battered_F", [4719.37, 4765.9, 73.2742], [-0.974453, -0.224592, 0], [0, 0, 1], true],
	["Land_Cargo_HQ_V3_F", [4686.55, 4775.18, 75.4497], [-0.98511, -0.171924, 0], [0, 0, 1], true],
	["Land_Cargo_HQ_V3_F", [4691.96, 4741.82, 75.4497], [0.985338, 0.170614, 0], [0, 0, 1], true],
	["Land_Cargo_HQ_V3_F", [4662.75, 4736.65, 75.4497], [0.985338, 0.170614, 0], [0, 0, 1], true],
	["Land_Cargo_HQ_V3_F", [4659.56, 4770.61, 75.4497], [-0.98511, -0.171924, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4712.69, 4775.44, 76.4793], [-0.9393, -0.343096, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4715.75, 4747.87, 76.4793], [-0.994154, 0.107969, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4640.73, 4728.79, 76.4793], [0.512973, 0.858405, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4635.44, 4769.87, 76.4793], [0.812631, -0.582779, 0], [0, 0, 1], true],
	["Land_Cargo_Tower_V3_F", [4673.22, 4755.32, 84.4605], [-0.171301, 0.985219, 0], [0, 0, 1], true],
	["Land_Bunker_01_blocks_3_F", [4630.15, 4751.52, 72.9481], [-0.136789, 0.9906, 0], [0, 0, 1], true],
	["Land_Bunker_01_blocks_3_F", [4630.98, 4745.77, 72.9481], [0.127484, -0.991841, 0], [0, 0, 1], true],
	["Land_Bunker_01_HQ_F", [4658.83, 4753.42, 73.7532], [-0.985495, -0.169705, 0], [0, 0, 1], true],
	["Land_Bunker_01_HQ_F", [4687.65, 4758.24, 73.8834], [-0.986028, -0.166577, 0], [0, 0, 1], true],
	["Land_Bunker_01_small_F", [4716.8, 4762.52, 74.6265], [-0.985489, -0.16974, 0], [0, 0, 1], true],
	["Land_Bunker_01_tall_F", [4630.23, 4758.23, 75.7632], [0.986729, 0.162379, 0], [0, 0, 1], true],
	["Land_Bunker_01_tall_F", [4633.17, 4739.17, 75.7632], [0.986729, 0.162379, 0], [0, 0, 1], true],
	["Land_Bunker_01_tall_F", [4678.9, 4729.92, 75.7632], [-0.139131, 0.990274, 0], [0, 0, 1], true],
	["Land_Bunker_01_tall_F", [4671.42, 4782.31, 75.7632], [0.124095, -0.99227, 0], [0, 0, 1], true],
	["Land_Bunker_02_light_left_F", [4645.2, 4778.79, 72.9728], [-0.176712, 0.984263, 0], [0, 0, 1], true],
	["Land_Bunker_02_light_left_F", [4704.85, 4733.62, 72.9728], [0.140707, -0.990051, 0], [0, 0, 1], true],
	["Land_Bunker_02_light_right_F", [4652.46, 4724.55, 72.9728], [0.165473, -0.986214, 0], [0, 0, 1], true],
	["Land_Bunker_02_light_right_F", [4697.72, 4787.33, 72.9728], [-0.127356, 0.991857, 0], [0, 0, 1], true],
	["Land_Loudspeakers_F", [4652.6, 4752.08, 75.0775], [-0.99459, -0.103882, 0], [0, 0, 1], true]
];

// Spawn buildings
private _baseObjects = [_objects, _pos] call DGCore_fnc_createEdenConvertedBase;

[_name, _baseObjects]