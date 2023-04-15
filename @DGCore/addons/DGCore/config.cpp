/*
	Copyright 2023 by DagovaxGames
*/

class DGCoreBuild {
	version = 1.00;
	build = 1;
	buildDate = "4-07-23";
};
class CfgPatches {
	class DGCore {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {};
	};
};

class CfgFunctions {
	class DGCore {
		tag = "DGCore";
		class DG_Initialization {
			file = "DGCore\init";
			class Initialize {postInit = 1;};
		};
		class DG_Vehicles {
			file = "DGCore\Compiles\Vehicles";
			class unFlipVehicle{};
		};
		class DG_Functions {
			file = "DGCore\Compiles\Functions";
			class selectMagazine{};
		};
		class DG_Utilities {
			file = "DGCore\Compiles\Utilities";
			class findWorld {};
			class log {};
		};
	};
};
