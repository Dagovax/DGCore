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
		class DG_Functions {
			file = "DGCore\Compiles\Functions";
			class selectMagazine{};
			class nearestBuilding{};
			class nearestAirportId{};
			class absolutePosToRelativePos{};
			class relativePosToAbsolutePos{};
			class getDynamicAirportInfo{};
			class setPosAGLS{};
			class setVectorUp{};
			class getDummy{};
			class addCrateMarker{};
			class createMarkerComplete{};
			class createMarkers{};
			class deleteMarkers{};
			class nearestSettlement{};
			class addPositionToNotification{};
			class getObjectHeight{};
			class createEdenConvertedBase{};
			class vectorToRotation{};
			class rotationToVector{};
			class isNearWater{};
			class isValidPos{};
			class findPosition{};
			class spawnRandomCamp{};
		};
		class DG_Vehicles {
			file = "DGCore\Compiles\Vehicles";
			class unFlipVehicle{};
			class addIdleMonitor{};
			class vehicleDoMove{};
			class planeDoLand{};
			class addDeletionMonitor{};
			class addMarkerMonitor{};
			class addUnderTerrainMonitor{};
			class placeVehicleRelative{};
			class spawnHeliDrop{};
			class spawnAirborneAssault{};
			class placeVehicleOnRoad{};
			class addConvoyMonitor{};
			class addRepairRefuelMonitor{};
			class addVehicleLoot{};
		};
		class DG_Groups {
			file = "DGCore\Compiles\Groups";
			class spawnCivilPatrol{};
			class spawnCivilPlane{};
			class addGroupWaypoints{};
			class spawnGroup {};
			class countAI {};
			class getUnitInfo {};
			class civilianDoFinalMove {};
			class moveGroupInVehicle {};
			class assignGroupToPlayer {};
			class spawnConvoy {};
			class spawnConvoyArray {};
		};
		class DG_Units {
			file = "DGCore\Compiles\Units";
			class spawnUnit {};
			class spawnPilot {};
			class spawnCivilian {};
			class recruitUnitDrop{};
			class recruitUnitVehicle{};
			class addEventHandlers {};
			class getUnitSkillByLevel {};
		};
		class DG_Utilities {
			file = "DGCore\Compiles\Utilities";
			class findWorld {};
			class findMods {};
			class log {};
			class getInversePos {};
			class spawnLootCrate {};
		};
		class DG_Players {
			file = "DGCore\Compiles\Players";
			class giveTakeRespect {};
			class giveTakeTabs {};
			class updatePlayerKills {};
			class getPlayerGroupLeader{};
			class getNearbyPlayers {};
			class getPlayersInVehicle{};
			class getAllAlivePlayers{};
			class sendNotification{};
		};
		class DG_Camps {
			file = "DGCore\Compiles\Camps";
			class spawnBrownSmallCamp{};
			class spawnBrownMediumCamp{};
			class spawnBrownLargeCamp{};
			class spawnBrownHugeCamp{};
			class spawnCastle{};
			class spawnCUPCastle{};
			class spawnVilla{};
		};
	};
};
