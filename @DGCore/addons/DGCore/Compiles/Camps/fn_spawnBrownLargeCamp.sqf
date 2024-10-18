/*

	DGCore_fnc_spawnBrownLargeCamp

	Purpose: Spawns buildings on a position, using ASL 

	Example: _camp = call DGCore_fnc_spawnBrownLargeCamp;

	Returns: Large Camp buildings (35x35) radius

	Copyright 2024 by Dagovax
*/

params[["_pos", [-1,-1,-1]]];
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to spawn large brown camp! -> _pos = %1", _pos], "DGCore_fnc_spawnBrownLargeCamp", "error"] call DGCore_fnc_log;
};

private _name = "Large Military Camp";

// 46 Objects from EDEN format
private _objects = [
	["Land_Cargo_Tower_V3_F", [4704.09, 4694.2, 84.4605], [-0.113432, 0.993546, 0], [0, 0, 1], true],
	["Land_HBarrier_5_F", [4666.95, 4696.78, 72.3149], [-0.0724318, 0.997373, 0], [0, 0, 1], true],
	["Land_HBarrier_5_F", [4661.16, 4696.35, 72.3149], [-0.0724318, 0.997373, 0], [0, 0, 1], true],
	["Land_HBarrier_5_F", [4661.59, 4686.08, 72.3149], [0.114208, -0.993457, 0], [0, 0, 1], true],
	["Land_Cargo40_sand_F", [4665.42, 4714.15, 72.9026], [-0.600106, 0.79992, 0], [0, 0, 1], true],
	["Land_BluntRock_apart", [4703.81, 4686.36, 74.0877], [-0.753862, -0.657032, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4662.45, 4684.69, 73.3387], [0.106356, -0.994328, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4660.49, 4682.23, 73.3387], [0.99375, 0.111627, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4667.61, 4685.23, 73.3387], [0.106356, -0.994328, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4661.03, 4677.05, 73.3387], [0.99375, 0.111627, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4661.74, 4697.88, 73.3387], [-0.0696926, 0.997568, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4659.21, 4699.96, 73.3387], [0.99375, 0.111627, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4666.93, 4698.22, 73.3387], [-0.0696926, 0.997568, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4658.68, 4705.16, 73.3387], [0.99375, 0.111627, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4663.06, 4672.73, 73.3387], [0.716153, 0.697943, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4667.04, 4669.56, 73.3387], [0.528832, 0.848726, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4671.57, 4666.94, 73.3387], [0.461966, 0.886897, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4676.28, 4664.81, 73.3387], [0.379123, 0.925346, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4681.21, 4663.4, 73.3387], [0.21173, 0.977328, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4686.33, 4662.51, 73.3387], [0.143738, 0.989616, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4691.45, 4662.13, 73.3387], [0.0260893, 0.99966, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4696.51, 4662.65, 73.3387], [-0.223287, 0.974753, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4701, 4664.74, 73.3387], [-0.610238, 0.792218, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4704.66, 4668.27, 73.3387], [-0.769899, 0.638165, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4707.95, 4672.32, 73.3387], [-0.775306, 0.631586, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4710.15, 4676.69, 73.3387], [-0.971265, 0.238001, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4711.13, 4681.74, 73.3387], [-0.992602, 0.121413, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4711.37, 4686.84, 73.3387], [-0.997819, -0.0660125, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4710.79, 4691.95, 73.3387], [-0.989925, -0.14159, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4710.06, 4697.12, 73.3387], [-0.990097, -0.140383, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4708.51, 4701.88, 73.3387], [-0.886333, -0.463048, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4705.8, 4706.33, 73.3387], [-0.817238, -0.5763, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4702.51, 4710.27, 73.3387], [-0.711263, -0.702926, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4698.78, 4713.93, 73.3387], [-0.684667, -0.728856, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4695.16, 4717.72, 73.3387], [-0.755731, -0.654882, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4691.23, 4720.74, 73.3387], [-0.416156, -0.909293, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4686.4, 4721.91, 73.3387], [-0.0483795, -0.998829, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4681.27, 4721.62, 73.3387], [0.152723, -0.988269, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4676.08, 4720.73, 73.3387], [0.219173, -0.975686, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4671.03, 4719.42, 73.3387], [0.288732, -0.95741, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4666.39, 4717.26, 73.3387], [0.538593, -0.842566, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4662.47, 4713.99, 73.3387], [0.744372, -0.667766, 0], [0, 0, 1], true],
	["Land_CncWall4_F", [4659.55, 4709.87, 73.3387], [0.905262, -0.424853, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4687.2, 4687.8, 72.6582], [-0.993744, -0.111683, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4686.77, 4697.83, 72.6582], [-0.993744, -0.111683, 0], [0, 0, 1], true],
	["Land_Wreck_Truck_F", [4700.36, 4700.33, 72.8489], [0.978196, 0.207685, 0], [0, 0, 1], true],
	["Land_HBarrier_large", [4682.64, 4687.44, 72.6148], [0.0471069, -0.99889, 0], [0, 0, 1], true],
	["Land_HBarrier_large", [4681.92, 4697.51, 72.6148], [0.0471069, -0.99889, 0], [0, 0, 1], true],
	["Land_HBarrier_large", [4679.03, 4692.4, 72.6148], [0.999417, 0.0341554, 0], [0, 0, 1], true],
	["Land_LampAirport_F", [4704.42, 4705.56, 83.9934], [-0.823685, -0.567047, 0], [0, 0, 1], true],
	["Land_LampAirport_F", [4708.78, 4681.19, 83.9934], [-0.878738, 0.477304, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4662.53, 4676.87, 77.5565], [0.197459, -0.980311, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4660.36, 4705.13, 77.5565], [-0.0755185, -0.997144, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4678.67, 4719.82, 77.5565], [-0.992566, -0.121708, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4686.24, 4663.71, 77.5565], [0.995896, 0.0905094, 0], [0, 0, 1], true],
	["Land_Loudspeakers_F", [4699.84, 4688.51, 75.0775], [0.993094, 0.117324, 0], [0, 0, 1], true],
	["Land_Cargo_House_V3_F", [4684.62, 4692.61, 72.2643], [-0.997109, -0.0759879, 0], [0, 0, 1], true],
	["Land_Cargo_HQ_V3_F", [4692.67, 4671.64, 75.4497], [0.991908, 0.126958, 0], [0, 0, 1], true],
	["Land_Cargo_HQ_V3_F", [4687.1, 4711.76, 75.4497], [-0.99706, -0.0766207, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4705.25, 4674.83, 76.4793], [-0.775567, 0.631265, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4698.89, 4709.18, 76.4793], [-0.664539, -0.747254, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4662.6, 4700.98, 76.4793], [0.995467, 0.0951104, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4663.75, 4681.65, 76.4793], [0.995467, 0.0951104, 0], [0, 0, 1], true],
	["Land_Wreck_Van_F", [4684.21, 4671.23, 72.5833], [0.108408, -0.994106, 0], [0, 0, 1], true],
	["Land_BagBunker_Small_F", [4681.12, 4684.17, 72.54], [0.997487, 0.0708462, 0], [0, 0, 1], true],
	["Land_BagBunker_Small_F", [4679.94, 4700.68, 72.54], [0.997487, 0.0708462, 0], [0, 0, 1], true],
	["Land_Wreck_Slammer_hull_F", [4674.75, 4715.9, 72.2924], [-0.177506, 0.98412, 0], [0, 0, 1], true],
	["Land_Wreck_Slammer_turret_F", [4669.58, 4672.47, 72.4526], [-0.985799, -0.16793, 0], [0, 0, 1], true],
	["TyreBarrier_01_black_F", [4670.17, 4697.46, 71.8966], [0, 1, 0], [0, 0, 1], true],
	["Land_HBarrier_5_F", [4667.31, 4686.68, 72.3149], [-0.0724318, 0.997373, 0], [0, 0, 1], true],
	["Land_Fire_barrel_burning", [4677.12, 4697.29, 72.1527], [0.997809, 0.0661592, 0], [0, 0, 1], true],
	["Land_Fire_barrel_burning", [4678, 4687.14, 72.1527], [0.997809, 0.0661592, 0], [0, 0, 1], true],
	["Land_Campfire_burning", [4676.91, 4692.32, 71.8096], [0, 1, 0], [0, 0, 1], true],
	["Land_CampingChair_V1_F", [4677.05, 4690.8, 72.0851], [0.138386, -0.990378, 0], [0, 0, 1], true],
	["Land_CampingChair_V1_F", [4676.6, 4693.81, 72.0851], [0.0530023, 0.998594, 0], [0, 0, 1], true],
	["Land_ShootingPos_Roof_01_F", [4676.75, 4692.3, 72.5905], [0.99861, 0.0527117, 0], [0, 0, 1], true]
];


// Spawn buildings
private _baseObjects = [_objects, _pos] call DGCore_fnc_createEdenConvertedBase;

[_name, _baseObjects]