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
			class addIdleMonitor{};
			class vehicleDoMove{};
			class addDeletionMonitor{};
			class addMarkerMonitor{};
		};
		class DG_Functions {
			file = "DGCore\Compiles\Functions";
			class selectMagazine{};
			class nearestBuilding{};
			class nearestAirportId{};
		};
		class DG_Groups {
			file = "DGCore\Compiles\Groups";
			class spawnCivilPatrol{};
			class spawnCivilPlane{};
			class spawnGroup {};
			class countAI {};
			class getUnitInfo {};
		};
		class DG_Units {
			file = "DGCore\Compiles\Units";
			class spawnUnit {};
			class spawnCivilian {};
			class addEventHandlers {};
		};
		class DG_Utilities {
			file = "DGCore\Compiles\Utilities";
			class findWorld {};
			class log {};
			class getInversePos{};
		};
		class DG_Players {
			file = "DGCore\Compiles\Players";
			class giveTakeRespect {};
			class giveTakeTabs {};
			class updatePlayerKills {};
			class getNearbyPlayers {};
		};
	};
};
