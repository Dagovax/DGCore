/*

	DGCore_fnc_spawnBrownSmallCamp

	Purpose: Spawns buildings on a position, using ASL 

	Example: _newDummy = call DGCore_fnc_spawnBrownSmallCamp;

	Returns: Small Camp buildings (20x20) radius

	Copyright 2024 by Dagovax
*/

params[["_pos", [-1,-1,-1]]];
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to spawn small brown camp! -> _pos = %1", _pos], "DGCore_fnc_spawnBrownSmallCamp", "error"] call DGCore_fnc_log;
};

private _name = "Small Military Camp";

// 46 Objects from EDEN format
private _objects = [
	["Land_Cargo_House_V3_F", [4852.74, 4805.51, 72.2643], [0.161163, 0.986928, 0], [0, 0, 1], true],
	["Land_Cargo_House_V3_F", [4856.76, 4786.39, 72.2643], [0.431947, -0.901899, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4842.17, 4784.02, 76.4793], [0.991087, 0.133215, 0], [0, 0, 1], true],
	["Land_Cargo_Patrol_V3_F", [4839.47, 4797.91, 76.4793], [0.991087, 0.133215, 0], [0, 0, 1], true],
	["Land_Cargo20_light_green_F", [4849.77, 4781.55, 72.8987], [0.126124, -0.992014, 0], [0, 0, 1], true],
	["Land_Cargo_HQ_V3_F", [4861.93, 4797.56, 75.4497], [-0.246021, 0.969264, 0], [0, 0, 1], true],
	["Land_Cargo20_orange_F", [4844.19, 4805.39, 72.8987], [0.333557, -0.94273, 0], [0, 0, 1], true],
	["Land_New_WiredFence_10m_F", [4834.38, 4798.82, 72.7882], [0.981888, 0.189461, 0], [0, 0, 1], true],
	["Land_New_WiredFence_10m_F", [4837.85, 4805.44, 72.7882], [0.417586, -0.908637, 0], [0, 0, 1], true],
	["Land_New_WiredFence_10m_F", [4847.24, 4808.92, 72.7882], [0.271432, -0.962457, 0], [0, 0, 1], true],
	["Land_New_WiredFence_10m_F", [4856.98, 4809.69, 72.7882], [-0.0995286, -0.995035, 0], [0, 0, 1], true],
	["Land_New_WiredFence_10m_F", [4865.73, 4806.58, 72.7882], [-0.550634, -0.834747, 0], [0, 0, 1], true],
	["Land_New_WiredFence_10m_F", [4870.8, 4799.18, 72.7882], [-0.982159, -0.188053, 0], [0, 0, 1], true],
	["Land_New_WiredFence_10m_F", [4837.71, 4782.54, 72.7882], [0.984596, 0.174846, 0], [0, 0, 1], true],
	["Land_New_WiredFence_10m_F", [4843.28, 4778.09, 72.7882], [-0.0378907, 0.999282, 0], [0, 0, 1], true],
	["Land_New_WiredFence_10m_F", [4853.01, 4779.63, 72.7882], [-0.265033, 0.964239, 0], [0, 0, 1], true],
	["Land_New_WiredFence_10m_F", [4862.14, 4783.51, 72.7882], [-0.507091, 0.861893, 0], [0, 0, 1], true],
	["Land_New_WiredFence_10m_F", [4869.08, 4790.29, 72.7882], [-0.843482, 0.537157, 0], [0, 0, 1], true],
	["Land_BagFence_Long_F", [4836.23, 4793.76, 71.9937], [-0.144329, 0.98953, 0], [0, 0, 1], true],
	["Land_BagFence_Long_F", [4837.24, 4787.73, 71.9937], [-0.144329, 0.98953, 0], [0, 0, 1], true],
	["Land_BagFence_Long_F", [4840.15, 4788.17, 71.9937], [-0.144329, 0.98953, 0], [0, 0, 1], true],
	["Land_BagFence_Long_F", [4843.05, 4788.68, 71.9937], [-0.144329, 0.98953, 0], [0, 0, 1], true],
	["Land_BagFence_Long_F", [4839.31, 4794.22, 71.9937], [-0.144329, 0.98953, 0], [0, 0, 1], true],
	["Land_BagFence_Long_F", [4842.29, 4794.71, 71.9937], [-0.144329, 0.98953, 0], [0, 0, 1], true],
	["Land_Loudspeakers_F", [4860.63, 4790.31, 75.0775], [0, 1, 0], [0, 0, 1], true],
	["Land_BagFence_Round_F", [4834.3, 4803.18, 71.9937], [0.876137, -0.482061, 0], [0, 0, 1], true],
	["Land_BagFence_Round_F", [4838.9, 4778.73, 71.9937], [0.76113, 0.6486, 0], [0, 0, 1], true],
	["Land_Fire_barrel_burning", [4844.04, 4795.06, 72.1527], [-0.990987, -0.133961, 0], [0, 0, 1], true],
	["Land_Fire_barrel_burning", [4844.8, 4789, 72.1527], [-0.739533, -0.67312, 0], [0, 0, 1], true],
	["Land_TentA_F", [4863.18, 4786.8, 72.157], [-0.87424, 0.485494, 0], [0, 0, 1], true],
	["Land_TentA_F", [4863.74, 4789.49, 72.157], [0.993627, 0.11272, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4836.07, 4803.99, 72.6582], [-0.742997, 0.669295, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4841.38, 4778.63, 72.6582], [-0.210663, -0.977559, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4867.24, 4788.63, 72.6582], [0.937059, -0.34917, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4862.64, 4807.78, 72.6582], [0.759568, 0.650428, 0], [0, 0, 1], true],
	["Land_Camping_Light_F", [4862.94, 4788.55, 71.7046], [0, 0.999998, -0.00185932], [0.00329333, 0.00185931, 0.999993], true],
	["Land_LampHalogen_F", [4869.74, 4800.4, 77.5565], [-0.19084, 0.981621, 0], [0, 0, 1], true],
	["Land_CratesWooden_F", [4841.43, 4787.42, 72.3133], [0.164863, -0.986316, 0], [0, 0, 1], true],
	["Sign_F", [4858.63, 4791.9, 72.2806], [0.972891, 0.231266, 0], [0, 0, 1], true],
	["Land_WoodPile_large_F", [4849.54, 4793.01, 71.9431], [0.199131, -0.979973, 0], [0, 0, 1], true],
	["Land_Campfire_burning", [4851.31, 4793.35, 71.8096], [0, 1, 0], [0, 0, 1], true],
	["Land_CampingChair_V2_white_F", [4852.2, 4791.95, 72.0758], [0.683172, -0.730257, 0], [0, 0, 1], true],
	["Land_CampingChair_V2_F", [4851.55, 4794.99, 72.0758], [0.536594, 0.843841, 0], [0, 0, 1], true],
	["Land_BagFence_Long_F", [4848.26, 4792.71, 71.9937], [0.981965, 0.189062, 0], [0, 0, 1], true],
	["Land_BagFence_Round_F", [4849.3, 4790.36, 71.9937], [0.575734, 0.817637, 0], [0, 0, 1], true],
	["Land_BagFence_Round_F", [4848.28, 4795.3, 71.9937], [0.892805, -0.450443, 0], [0, 0, 1], true]
];

// Spawn buildings
private _baseObjects = [_objects, _pos] call DGCore_fnc_createEdenConvertedBase;

[_name, _baseObjects]
