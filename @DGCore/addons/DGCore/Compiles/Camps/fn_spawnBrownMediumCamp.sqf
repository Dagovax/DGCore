/*

	DGCore_fnc_spawnBrownMediumCamp

	Purpose: Spawns buildings on a position, using ASL 

	Example: _camp = call DGCore_fnc_spawnBrownMediumCamp;

	Returns: Medium Camp buildings (30x30) radius

	Copyright 2024 by Dagovax
*/

params[["_pos", [-1,-1,-1]]];
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to spawn medium brown camp! -> _pos = %1", _pos], "DGCore_fnc_spawnBrownMediumCamp", "error"] call DGCore_fnc_log;
};

private _name = "Medium Military Camp";

// 46 Objects from EDEN format
private _objects = [
	["Land_Cargo_HQ_V3_F", [4708.85, 4607.52, 75.4797], [-0.135695, 0.990751, 0], [0, 0, 1], true],
	["Land_Cargo_HQ_V3_F", [4706.78, 4625.58, 75.4797], [-0.156143, 0.987734, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4695.95, 4594.33, 76.5093], [-0.13504, 0.99084, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4688.65, 4632.8, 76.5053], [0.154402, -0.988008, 0], [0, 0, 1], true],
	["Land_Loudspeakers_F", [4705.05, 4618.45, 75.1075], [0, 1, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4678.83, 4604.77, 76.5093], [0.988367, 0.152085, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4676.13, 4617.93, 76.5093], [0.988367, 0.152085, 0], [0, 0, 1], true],
	["Land_Wall_IndCnc_4_F", [4678.45, 4607.88, 72.3293], [0.155937, -0.987767, 0], [0, 0, 1], true],
	["Land_Wall_IndCnc_4_F", [4676.65, 4614.77, 72.3293], [0.155937, -0.987767, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4672.8, 4613.48, 72.4505], [-0.144504, 0.989504, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4673.84, 4607.47, 72.4505], [-0.144504, 0.989504, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4675.4, 4603.86, 72.4505], [0.981965, 0.189064, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4678.63, 4597.76, 72.4505], [0.721726, 0.692179, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4684.5, 4593.51, 72.4505], [0.457359, 0.889282, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4691.44, 4591.12, 72.4505], [0.189325, 0.981915, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4698.75, 4591.18, 72.4505], [-0.145391, 0.989374, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4706.1, 4592.37, 72.4505], [-0.153816, 0.988099, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4713.42, 4593.63, 72.4505], [-0.196921, 0.980419, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4720.47, 4595.78, 72.4505], [-0.367697, 0.929946, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4725.46, 4600.34, 72.4505], [-0.888672, 0.458544, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4726.3, 4607.06, 72.4505], [-0.980874, -0.194645, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4724.78, 4614.29, 72.4505], [-0.980874, -0.194645, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4723.26, 4621.55, 72.4505], [-0.980874, -0.194645, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4721.8, 4628.82, 72.4505], [-0.980874, -0.194645, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4672.74, 4617.45, 72.4505], [-0.980874, -0.194645, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4673.01, 4624.54, 72.4369], [0.959873, -0.280434, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4676.84, 4630.47, 72.4411], [0.622313, -0.782768, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4682.95, 4634.51, 72.437], [0.455067, -0.890457, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4689.84, 4636.77, 72.4501], [0.163003, -0.986626, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4697.2, 4637.87, 72.4505], [0.120528, -0.99271, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4704.57, 4638.78, 72.4505], [0.119628, -0.992819, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4711.58, 4638.01, 72.4505], [-0.344529, -0.938776, 0], [0, 0, 1], true],
	["Land_CncBarrierMedium4_F", [4718.07, 4634.53, 72.4505], [-0.602268, -0.798294, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4722.34, 4618.93, 76.5093], [-0.981517, -0.191373, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4719.99, 4631.58, 77.5865], [-0.736308, 0.676647, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4725.54, 4603.7, 77.5865], [0.287279, 0.957847, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4678.32, 4599.76, 77.5865], [0.658398, -0.75267, 0], [0, 0, 1], true],
	["Land_LampHalogen_F", [4673.94, 4623.52, 77.576], [-0.478987, -0.877818, 0.00260722], [0, 0.0029701, 0.999996], true],
	["Land_PortableLight_double_F", [4702.48, 4620.24, 72.6882], [0.987816, 0.155629, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4703.58, 4610.21, 72.6882], [0.987816, 0.155629, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4696.23, 4592.15, 72.6882], [0.225544, -0.974233, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4689.06, 4635.49, 72.6853], [-0.191752, 0.981443, -0.000569525], [-0.0029701, 0, 0.999996], true],
	["Land_PortableLight_double_F", [4706.15, 4637.74, 72.6882], [-0.137501, 0.990502, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4712.1, 4594.59, 72.6882], [0.247765, -0.96882, 0], [0, 0, 1], true],
	["Land_SignM_WarningMilitaryArea_english_F", [4672.1, 4615.17, 72.6443], [0.986044, 0.166484, 0], [0, 0, 1], true],
	["Land_Sign_WarningNoWeaponAltis_F", [4673.81, 4605.67, 72.6443], [0.985477, 0.169807, 0], [0, 0, 1], true],
	["Land_Sign_WarningUnexplodedAmmo_F", [4670.01, 4606.95, 72.6443], [0.98619, 0.165615, 0], [0, 0, 1], true],
	["Land_Wreck_HMMWV_F", [4699.47, 4636.25, 72.4424], [0.985136, 0.171774, 0], [0, 0, 1], true],
	["Land_Wreck_Hunter_F", [4700.64, 4595.74, 73.4752], [0.189535, -0.981874, 0], [0, 0, 1], true],
	["Land_Wreck_Offroad_F", [4723.78, 4609.53, 72.5391], [-0.19217, 0.981362, 0], [0, 0, 1], true],
	["Land_Fire_barrel_burning", [4681.99, 4608.42, 72.1827], [-0.94675, -0.321969, 0], [0, 0, 1], true],
	["Land_Fire_barrel_burning", [4679.98, 4615.27, 72.1827], [-0.94675, -0.321969, 0], [0, 0, 1], true],
	["Land_BagBunker_Large_F", [4690.94, 4613.3, 72.494], [0.989171, 0.146771, 0], [0, 0, 1], true],
	["Land_BagBunker_Small_F", [4669.57, 4619.44, 72.57], [0.991086, 0.133225, 0], [0, 0, 1], true],
	["Land_BagBunker_Small_F", [4673.18, 4601.13, 72.57], [0.991086, 0.133225, 0], [0, 0, 1], true],
	["Land_ConcretePipe_F", [4710.44, 4636.59, 72.9106], [0.92307, -0.384633, 0], [0, 0, 1], true],
	["Land_CncBarrier_stripes_F", [4685.68, 4612.44, 71.99], [0.989432, 0.144998, 0], [0, 0, 1], true]
];

// Spawn buildings
private _baseObjects = [_objects, _pos] call DGCore_fnc_createEdenConvertedBase;

[_name, _baseObjects]
