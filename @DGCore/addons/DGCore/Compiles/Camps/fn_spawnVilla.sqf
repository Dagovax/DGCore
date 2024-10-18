/*

	DGCore_fnc_spawnVilla

	Purpose: Spawns buildings on a position, using ASL 

	Example: _newDummy = call DGCore_fnc_spawnVilla;

	Returns: Villa buildings (20x20) radius

	Copyright 2024 by Dagovax
*/

params[["_pos", [-1,-1,-1]]];
if(_pos isEqualTo [-1,-1,-1]) exitWith
{
	[format["Not enough valid params to spawn small brown camp! -> _pos = %1", _pos], "DGCore_fnc_spawnBrownSmallCamp", "error"] call DGCore_fnc_log;
};

private _name = "Villa";

// 46 Objects from EDEN format
private _objects = [
	["Land_Fire_barrel_burning", [4399.46, 4571.17, 72.1527], [-0.306262, 0.951947, 0], [0, 0, 1], true],
	["Land_HBarrier_01_line_5_green_F", [4422.1, 4583.79, 72.3149], [-0.181244, 0.983438, 0], [0, 0, 1], true],
	["Land_i_House_Big_01_V2_F", [4434.26, 4571.53, 74.6407], [-0.179721, 0.983718, 0], [0, 0, 1], true],
	["Land_Cargo20_light_blue_F", [4403.68, 4554.15, 72.8987], [0.98279, 0.184725, 0], [0, 0, 1], true],
	["Land_City_8m_F", [4398.71, 4570.13, 72.136], [0.982347, 0.18707, 0], [0, 0, 1], true],
	["Land_City_8m_F", [4400.5, 4560.18, 72.136], [0.982347, 0.18707, 0], [0, 0, 1], true],
	["Land_City_8m_F", [4401.78, 4553.33, 72.136], [0.982347, 0.18707, 0], [0, 0, 1], true],
	["Land_City_8m_F", [4405.7, 4550.19, 72.136], [-0.159821, 0.987146, 0], [0, 0, 1], true],
	["Land_City_8m_F", [4412.59, 4551.17, 72.136], [-0.159821, 0.987146, 0], [0, 0, 1], true],
	["Land_City_8m_F", [4419.4, 4552.23, 72.136], [-0.159821, 0.987146, 0], [0, 0, 1], true],
	["Land_City_8m_F", [4397.57, 4577.05, 72.136], [0.98954, 0.144256, 0], [0, 0, 1], true],
	["Land_City_8m_F", [4400.74, 4581.01, 72.136], [0.193331, -0.981134, 0], [0, 0, 1], true],
	["Land_City_8m_F", [4407.58, 4582.3, 72.136], [0.193331, -0.981134, 0], [0, 0, 1], true],
	["Land_City_8m_F", [4414.49, 4583.56, 72.136], [0.193331, -0.981134, 0], [0, 0, 1], true],
	["Land_City_8m_F", [4421.36, 4584.84, 72.136], [0.193331, -0.981134, 0], [0, 0, 1], true],
	["Land_City_Pillar_F", [4399.44, 4566.49, 72.0473], [0.988529, 0.151029, 0], [0, 0, 1], true],
	["Land_CncBarrier_F", [4401.38, 4563.63, 71.96], [0.187682, -0.98223, 0], [0, 0, 1], true],
	["Land_CncBarrier_F", [4400.89, 4566.72, 71.96], [0.187682, -0.98223, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4427.44, 4577.24, 72.6582], [0.712305, 0.70187, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4421.91, 4553.61, 72.6582], [0.738881, -0.673836, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4402.21, 4557.79, 72.6582], [-0.714673, -0.699459, 0], [0, 0, 1], true],
	["Land_PortableLight_double_F", [4410.15, 4581.4, 72.6582], [-0.707751, 0.706462, 0], [0, 0, 1], true],
	["Land_FirewoodPile_01_F", [4404.34, 4572.41, 72.5435], [0.975194, 0.221354, 0], [0, 0, 1], true],
	["Land_Pot_02_F", [4420.15, 4573.08, 71.4475], [0, 1, 0], [0, 0, 1], true],
	["Land_FlowerPot_01_Flower_F", [4429.47, 4565.43, 72.3754], [0, 1, 0], [0, 0, 1], true],
	["Land_Pot_01_F", [4426.15, 4573.99, 71.9396], [-0.145728, 0.989325, 0], [0, 0, 1], true],
	["Land_Pot_01_F", [4422.88, 4573.47, 71.9396], [-0.145728, 0.989325, 0], [0, 0, 1], true],
	["Land_i_House_Big_02_V2_F", [4427.03, 4557.89, 75.2014], [0.187364, -0.98229, 0], [0, 0, 1], true],
	["Land_i_House_Small_02_V2_F", [4428.51, 4586.39, 72.6994], [0.982232, 0.187669, 0], [0, 0, 1], true],
	["Land_LampAirport_F", [4431.94, 4562.55, 83.9934], [-0.896974, 0.442083, 0], [0, 0, 1], true],
	["Land_Portable_generator_F", [4420.94, 4562.41, 71.9335], [-0.971027, -0.238969, 0], [0, 0, 1], true],
	["Exile_Construction_PortableGenerator_Static", [4424.89, 4583.05, 71.9337], [-0.985799, -0.16793, 0], [0, 0, 1], true],
	["Land_PowerGenerator_F", [4410.76, 4576.42, 72.3699], [-0.161115, 0.986936, 0], [0, 0, 1], true],
	["Land_PortableGenerator_01_black_F", [4401.53, 4558.92, 71.95], [-0.975325, -0.220774, 0], [0, 0, 1], true],
	["Land_Shed_08_brown_F", [4404.25, 4576.07, 72.6193], [-0.211691, 0.977337, 0], [0, 0, 1], true],
	["Land_LampStreet_02_F", [4400.01, 4559.2, 75.8068], [0.958057, 0.286579, 0], [0, 0, 1], true],
	["Land_LampStreet_02_F", [4398.17, 4570.57, 75.8068], [-0.935762, -0.352633, 0], [0, 0, 1], true],
	["TyreBarrier_01_black_F", [4400.69, 4562.81, 71.8966], [0, 1, 0], [0, 0, 1], true],
	["Land_Loudspeakers_F", [4427.66, 4573.39, 75.0775], [-0.987305, -0.158839, 0], [0, 0, 1], true]
];

// Spawn buildings
private _baseObjects = [_objects, _pos] call DGCore_fnc_createEdenConvertedBase;

[_name, _baseObjects]
