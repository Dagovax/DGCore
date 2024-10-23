if (!isServer) exitWith {
	["Failed to load configuration data for @DGCore!"] call DGCore_fnc_log;
};

["Loading configuration data..."] call DGCore_fnc_log;

/****************************************************************************************************/
/********************************  CONFIG PART. EDIT AS YOU LIKE!!  ************************************/
/****************************************************************************************************/

// Generic
DGCore_DebugMode					= false; 								// For testing purposes. Do not set this on live server or players will die
DGCore_CleanupTime					= 5*60; 								// Time in seconds an object will be timed out for deletion (can be vehicle). Default = 5 min
DGCore_BodyCleanupTime				= 10*60;								// Time in seconds dead bodies will be removed/deleted (units only). Default = 10 min
DGCore_BaseCleanupTime				= 15*60;								// Time in seconds spawned base buildings will remain after a mission ends. Default = 15 min
DGCore_EnableLogging				= true;
DGCore_LogLevel						= "information"; 						// choose between:  "information" | "debug" | "errors" | "warnings"
DGCore_UseDynamicAirports			= true; 								// If dynamic airports are created for the map, planes will land and take off there too. 
DGCore_MissionTimeout				= 30*60; 								// Timeout in seconds of a mission when no player is nearby
DGCore_PlayerSearchRadius			= 1500; 								// Distance in meters around missions a player has to be before setting it up/making it active
DGCore_MarkerType					= "ELLIPSE";							// Marker type
DGCore_MarkerSize					= [325,325];							// Marker size
DGCore_MarkerBrush					= "SolidBorder";						// Marker brush
DGCore_MarkerColors =														// Marker color for the different difficulty levels. DGCore_DefaultDifficulty will be used to pick the color per difficulty
[ 												
	"ColorGreen",	// low
	"ColorYellow",	// medium
	"ColorOrange",	// high
	"ColorRed"		// veteran
];
DGCore_MarkerDefaultColor			= "ColorBrown";							// Default Marker color, if system fails to find a good one per level
DGCore_MarkerTextColor				= "ColorWhite";							// Marker text color
DGCore_MarkerCompleteColor			= "ColorBlue";							// Mission marker complete (text) color
DGCore_LootMarkerType				= "mil_box";							// Loot marker type
DGCore_LootMarkerColor				= "ColorPink";							// Loot marker color
DGCore_LootMarkerUpTime				= 120; 									// Amount of seconds the loot crate marker will be visible. Default = 120 sec (2 minutes)
DGCore_DummyObjectClass				= "HeliHEmpty";							// Class name we should use for dummies. Invisible objects. Default = "Land_Map_blank_F" (will be visible for a short time only)

// Dynamic Missions Settings
DGCore_MinPlayerDistance			 = 1000; 								// Minimum distance a mission should spawn away from any player.
DGCore_MinObjectDistance			 = 65; 									// Minimum distance a mission spawns away from any object.
DGCore_MinMissionDistance			 = 2000; 								// Missions won't spawn in a position this many meters close to another mission
DGCore_MinWaterNearDistance 		 = 75;									// Missions won't spawn in a position this many meters close to water
DGCore_MinTerritoryDistance			 = 200;									// Missions won't spawn in a position this many meters close to a territory flag. This is a resource intensive check, don't set this value too high!
DGCore_MinSurfaceNormal				 = 0.8; 								// Missions won't spawn in a position where its surfaceNormal is less than this amount. The lower the value, the steeper the location. Greater values means flatter locations. Values can range from 0-1, with 0 being sideways, and 1 being perfectly flat. For reference: SurfaceNormal of about 0.7 is when you are forced to walk up a surface. If you want to convert surfaceNormal to degrees, use the arc-cosine of the surfaceNormal. 0.9 is about 25 degrees. Google "(arccos 0.9) in degrees"
DGCore_RetriesPerSurfaceNormalLevel	 = 5;									// How many attempts will be done for finding a safe spot per surface normal level. Don't make this too high!
DGCore_RotBuildingMode 				 = "auto"; 								// Choose between:  "auto" | "up" | "slope" | // Rotate buildings using the spawn position's terrain slope (auto/slope). If set to "up", buildings will be forced set with vector up.
DGCore_RotBuildingAngle				 = 25; 									// Terrain angle (in rads) from which we place buildings. Buildings placed on terrain higer than this value will be placed vertically.

// Blacklist zones
DGCore_MinSpawnZoneDistance			 = 1500;								// Missions won't spawn in a position this many meters close to a spawn zone
DGCore_SpawnZoneMarkerTypes =												// If you're using custom spawn zone markers, make sure you define them here. CASE SENSITIVE!!!
[																			
	"ExileSpawnZoneIcon",
	"ExileSpawnZone"
];
DGCore_MinTraderZoneDistance		 = 1500;								// Missions won't spawn in a position this many meters close to a trader zone
DGCore_TraderZoneMarkerTypes =												// If you're using custom trader markers, make sure you define them here. CASE SENSITIVE!!!		
[ 
	"ExileTraderZoneIcon",
	"ExileTraderZone"
];
DGCore_MinMixerDistance				 = 1000;								// Missions won't spawn in a position this many meters close to a concrete mixer
DGCore_MixerMarkerTypes =													// If you're using custom concrete mixer map markers, make sure you define them here. CASE SENSITIVE!!!		
[ 
	"ExileConcreteMixerZoneIcon",
	"ExileConcreteMixerZone"
];
DGCore_ContaminatedZoneNearDistance  = 1000;								// Missions won't spawn in a position this many meters close to a contaminated zone
DGCore_ContaminatedZoneMarkerTypes =										// If you're using custom contaminated zone markers, make sure you define them here. CASE SENSITIVE!!!
[ 
	"ExileContaminatedZoneIcon",
	"ExileContaminatedZone"
];
DGCore_BlacklistNearDistance		= 1000;									// Missions won't spawn in a position this many meters close to any of the defined below blacklisted positions
DGCore_BlacklistPositions =													// If you have specific positions you don't want to use for mission spawning, define them in the array below.
[
	//[4072.67,4507.11,0], // EXAMPLE: Napf South airfield
	//[14617.5,16761.3,0]  // EXAMPLE: Napf international airfield
];

// Notifications Settings
DGCore_EnableKillMessage			= true; 								// Plays a sound and gives the kill message in side chat. 
DGCore_NotificationAddition			= "settlement"; 						// Adds additional info in mission spawn message, such as settlement name or grid position. Choose between: "none" | "settlement" | "grid" | "point_of_interest"
DGCore_EnableKillSound				= true;									// Give player that killed AI a sound, defined at DGCore_EnemyKillSound
DGCore_EnableDeadSound				= true; 								// When an AI dies, let him say 'his final words'.
DGCore_EnemyKillSound				= ["FD_CP_Clear_F"]; 					// Random sound will play when an enemy got killed.
DGCore_DeadSound =															// A sound played by the killed unit when he dies. Only applies to allies
[ 
	"DG_BeingHit1", "DG_BeingHit2", 
	"DG_BeingHit3", "DG_BeingHit4", 
	"DG_BeingHit5", "DG_BeingHit6", 
	"DG_JAP_Dying1", "DG_JAP_Dying2", 
	"DG_JAP_Dying3", "DG_JAP_Dying4", 
	"DG_JAP_Dying5", "DG_JAP_Dying6", 
	"DG_JAP_Dying7", "DG_JAP_Dying8",
	"DG_US_Dying1", "DG_US_Dying2",
	"DG_US_Dying3", "DG_US_Dying4",
	"DG_US_Dying5", "DG_US_Dying6",
	"DG_US_Dying7", "DG_US_Dying8"
]; 
DGCore_AllyLostSound = 														 // A sound played when you lose an ally. Will be played from the player. 
[
	"DG_JAP_WeAreRunningLowOnReinforce",
	"DG_JAP_WeAreTakingHeavyCasualities",
	"DG_RUS_WeAreTakingHeavyCasualities",
	"DG_RUS_WeAreRunningLowOnReinforce",
	"DG_UK_WeAreRunningLowOnReinforce",
	"DG_UK_WeAreTakingHeavyCasualities",
	"DG_US_WeAreRunningLowOnReinforce",
	"DG_US_WeAreTakingHeavyCasualities",
	"DG_GER_WeAreRunningLowOnReinforce",
	"DG_GER_WeAreTakingHeavyCasualities"
];

// AI Settings
DGCore_PlayerExpRange 		= [25000, 75000, 150000]; 						// Range of the player's experience until it reaches next level. [easy > normal, normal > hard, hard > extreme] (for AI that targets a player)
DGCore_BaseLevelRange		= [3, 6, 8]; 									// Range of base level it reaches next difficulty level. [easy > normal, normal > hard, hard > extreme] (used for base raids)
DGCore_EnableLaunchers		= true; 										// Set to false to have no AI spawned with launchers. Setting this to true will still check definition below for spawn chance per AI level
DGCore_FlyHeightRange		= [250, 400]; 									// A random flyheight will be used between these numbers
DGCore_FlySpeedLimit		= 150; 											// Generic speed limit for air vehicles. 
DGCore_DefaultDifficulty	= "medium";										// Default difficulty if mission does not supplt one. Choose between [low | medium | high | veteran]
DGCore_AI_WP_Radius_easy	= 20;											// Waypoint radius for "easy" AI.
DGCore_AI_WP_Radius_normal	= 30;											// Waypoint radius for "normal" AI.
DGCore_AI_WP_Radius_hard	= 50;											// Waypoint radius for "hard" AI.
DGCore_AI_WP_Radius_extreme	= 75;											// Waypoint radius for "extreme" AI.
DGCore_AIEasyTroopCount		= [1,3]; 										// Array containing min - max troops
DGCore_AIEasySettings 		= 
[
	0.3, 			// General unit skill level
	1, 				// Inventory items
	100, 			// Max poptabs
	0, 				// Launcher spawn chance
	[0, 1], 		// Amount of ground vehicles that spawn for a mission in array format [min, max]
	10				// Percentage of vehicle seats used when spawning a vehicle
];
DGCore_AINormalTroopCount	= [2,5]; 										// Array containing min - max troops
DGCore_AINormalSettings		= 
[
	0.5, 			// General unit skill level
	2,              // Inventory items
	250,            // Max poptabs
	12,             // Launcher spawn chance
	[1, 2],         // Amount of ground vehicles that spawn for a mission in array format [min, max]
	25              // Percentage of vehicle seats used when spawning a vehicle
];
DGCore_AIHardTroopCount		= [3,6];									 	// Array containing min - max troops
DGCore_AIHardSettings 		= 
[
	0.7, 			// General unit skill level
	3,              // Inventory items
	500,            // Max poptabs
	25,             // Launcher spawn chance
	[1, 3],         // Amount of ground vehicles that spawn for a mission in array format [min, max]
	40              // Percentage of vehicle seats used when spawning a vehicle
];
DGCore_AIExtremeTroopCount	= [5,10]; 										// Array containing min - max troops
DGCore_AIExtremeSettings 	= 
[
	0.9, 			// General unit skill level
	4,              // Inventory items
	1000,           // Max poptabs
	33,             // Launcher spawn chance
	[2, 3],         // Amount of ground vehicles that spawn for a mission in array format [min, max]
	55              // Percentage of vehicle seats used when spawning a vehicle
];

// Dynamic Loot
DGCore_LootBoxTypes			= ["Exile_Container_SupplyBox"];				// Type of loot box crate
DGCore_LootSmokeTypes = 													// Smoke type to spawn when spawning the lootcrate. A random item will be chosen each drop
[
	"SmokeShell", "SmokeShellRed", 
	"SmokeShellGreen", "SmokeShellYellow", 
	"SmokeShellPurple", "SmokeShellBlue", 
	"SmokeShellOrange"
];
DGCore_LootBoxLightTypes = 													// Type of light being attached to the lootcrate (until players are nearby + unlocked)
[
	"PortableHelipadLight_01_blue_F", "PortableHelipadLight_01_green_F", 
	"PortableHelipadLight_01_red_F", "PortableHelipadLight_01_white_F", 
	"PortableHelipadLight_01_yellow_F", "Land_PortableHelipadLight_01_F"
];
DGCore_CountItemVehicle 	= [3,6]; 										// The amount [min,max] of items that the vehicle will spawn in with
DGCore_CountBackpackVehicle = [1,3]; 										// The amount [min,max] of backpacks that the vehicle will spawn in with
DGCore_CountWeaponVehicle 	= [2,4]; 										// The amount [min,max] of weapons that the vehicle will spawn in with

// Notification Settings
DGCore_Notification_Title_Color		= "#FFFF00";							// Toast title color for "ExileToast" client notification type. Defaults to yellow (#FFFF00)
DGCore_Notification_Error_Color		= "#FF0000";							// Toast title color for "ExileToast" client error notification type. Defaults to red (#FF0000)
DGCore_Notification_Success_Color	= "#0080FF";							// Toast title color for "ExileToast" client success notification type. Defaults to dark blue (#0080FF)
DGCore_Notification_Title_Size		= 23;									// Size for Client Exile Toasts  mission titles.
DGCore_Notification_Title_Font		= "puristaMedium";						// Font for Client Exile Toasts  mission titles.
DGCore_Notification_Message_Color	= "#FFFFFF";							// Toasts color for "ExileToast" client notification type.Defaults to white (#FFFFFF)
DGCore_Notification_Message_Size	= 19;									// Toasts size for "ExileToast" client notification type.
DGCore_Notification_Message_Font	= "PuristaLight";						// Toasts font for "ExileToast" client notification type.

// AI Loadout settings
DGCore_AmmoBlacklist =														// List of ammo/magazine classes that will not be picked by DGCore when finding a magazine for a weapon. 
[
	"Exile_Magazine_Swing",
	"Exile_Magazine_Boing",
	"Exile_Magazine_Swoosh",
	"CBA_FakeLauncherMagazine"
];

DGCore_AIWeapons =
[
	"arifle_Katiba_F",
	"arifle_Katiba_C_F",
	"arifle_Katiba_GL_F",
	"arifle_MXC_F",
	"arifle_MX_F",
	"arifle_MX_GL_F",
	"arifle_MXM_F",
	"arifle_SDAR_F",
	"arifle_TRG21_F",
	"arifle_TRG20_F",
	"arifle_TRG21_GL_F",
	"arifle_Mk20_F",
	"arifle_Mk20C_F",
	"arifle_Mk20_GL_F",
	"arifle_Mk20_plain_F",
	"arifle_Mk20C_plain_F",
	"arifle_Mk20_GL_plain_F",
	"srifle_EBR_F",
	"srifle_GM6_F",
	"srifle_LRR_F",
	"srifle_DMR_01_F",
	"MMG_02_sand_F",
	"MMG_02_black_F",
	"MMG_02_camo_F",
	"MMG_01_hex_F",
	"MMG_01_tan_F",
	"srifle_DMR_05_blk_F",
	"srifle_DMR_05_hex_F",
	"srifle_DMR_05_tan_F"
];
DGCore_AILaunchers =
[
	"launch_RPG7_F",
	"launch_B_Titan_tna_F",
	"launch_B_Titan_F",
	"launch_O_Titan_short_F",
	"launch_B_Titan_short_F",
	"launch_RPG32_F",
	"rhs_weap_igla",
	"CUP_launch_Javelin",
	"CUP_launch_NLAW",
	"CUP_launch_APILAS",
	"CUP_launch_M47"
];
DGCore_AIWeaponOptics =	
[
	"bipod_01_F_snd",
	"bipod_02_F_blk",
	"optic_LRPS",
	"optic_LRPS_tna_F",
	"optic_LRPS_ghex_F",
	"optic_DMS",
	"RPG32_F",
	"optic_AMS","optic_AMS_khk","optic_AMS_snd",
	"optic_DMS",
	"optic_KHS_blk","optic_KHS_hex","optic_KHS_old","optic_KHS_tan",
	"optic_LRPS",
	"optic_NVS",
	"optic_SOS"
];
						
DGCore_AIVests =
[
	"V_Press_F",
	"V_Rangemaster_belt",
	"V_TacVest_blk",
	"V_TacVest_blk_POLICE",
	"V_TacVest_brn",
	"V_TacVest_camo",
	"V_TacVest_khk",
	"V_TacVest_oli",
	"V_TacVestCamo_khk",
	"V_TacVestIR_blk",
	"V_I_G_resistanceLeader_F",
	"V_BandollierB_blk",
	"V_BandollierB_cbr",
	"V_BandollierB_khk",
	"V_BandollierB_oli",
	"V_BandollierB_rgr",
	"V_Chestrig_blk",
	"V_Chestrig_khk",
	"V_Chestrig_oli",
	"V_Chestrig_rgr",
	"V_HarnessO_brn",
	"V_HarnessO_gry",
	"V_HarnessOGL_brn",
	"V_HarnessOGL_gry",
	"V_HarnessOSpec_brn",
	"V_HarnessOSpec_gry",
	"V_PlateCarrier1_blk",
	"V_PlateCarrier1_rgr",
	"V_PlateCarrier2_rgr",
	"V_PlateCarrier3_rgr",
	"V_PlateCarrierGL_blk",
	"V_PlateCarrierGL_mtp",
	"V_PlateCarrierGL_rgr",
	"V_PlateCarrierH_CTRG",
	"V_PlateCarrierIA1_dgtl",
	"V_PlateCarrierIA2_dgtl",
	"V_PlateCarrierIAGL_dgtl",
	"V_PlateCarrierIAGL_oli",
	"V_PlateCarrierL_CTRG",
	"V_PlateCarrierSpec_blk",
	"V_PlateCarrierSpec_mtp"
];
DGCore_Backpacks = 
[
	"B_Carryall_ocamo",
	"B_Carryall_oucamo",
	"B_Carryall_mcamo",
	"B_Carryall_oli",
	"B_Carryall_khk",
	"B_Carryall_cbr"
];
DGCore_Headgear = 
[
	"H_Cap_blk",
	"H_Cap_blk_Raven",
	"H_Cap_blu",
	"H_Cap_brn_SPECOPS",
	"H_Cap_grn",
	"H_Cap_headphones",
	"H_Cap_khaki_specops_UK",
	"H_Cap_oli",
	"H_Cap_press",
	"H_Cap_red",
	"H_Cap_tan",
	"H_Cap_tan_specops_US",
	"H_Watchcap_blk",
	"H_Watchcap_camo",
	"H_Watchcap_khk",
	"H_Watchcap_sgg",
	"H_MilCap_blue",
	"H_MilCap_dgtl",
	"H_MilCap_mcamo",
	"H_MilCap_ocamo",
	"H_MilCap_oucamo",
	"H_MilCap_rucamo",
	"H_Bandanna_camo",
	"H_Bandanna_cbr",
	"H_Bandanna_gry",
	"H_Bandanna_khk",
	"H_Bandanna_khk_hs",
	"H_Bandanna_mcamo",
	"H_Bandanna_sgg",
	"H_Bandanna_surfer",
	"H_Booniehat_dgtl",
	"H_Booniehat_dirty",
	"H_Booniehat_grn",
	"H_Booniehat_indp",
	"H_Booniehat_khk",
	"H_Booniehat_khk_hs",
	"H_Booniehat_mcamo",
	"H_Booniehat_tan",
	"H_Hat_blue",
	"H_Hat_brown",
	"H_Hat_camo",
	"H_Hat_checker",
	"H_Hat_grey",
	"H_Hat_tan",
	"H_StrawHat",
	"H_StrawHat_dark",
	"H_Beret_02",
	"H_Beret_blk",
	"H_Beret_blk_POLICE",
	"H_Beret_brn_SF",
	"H_Beret_Colonel",
	"H_Beret_grn",
	"H_Beret_grn_SF",
	"H_Beret_ocamo",
	"H_Beret_red",
	"H_Shemag_khk",
	"H_Shemag_olive",
	"H_Shemag_olive_hs",
	"H_Shemag_tan",
	"H_ShemagOpen_khk",
	"H_ShemagOpen_tan",
	"H_TurbanO_blk",
	"H_CrewHelmetHeli_B",
	"H_CrewHelmetHeli_I",
	"H_CrewHelmetHeli_O",
	"H_HelmetCrew_I",
	"H_HelmetCrew_B",
	"H_HelmetCrew_O",
	"H_PilotHelmetHeli_B",
	"H_PilotHelmetHeli_I",
	"H_PilotHelmetHeli_O"	
];
DGCore_Helmets = 
[
	"H_HelmetB",
	"H_HelmetB_black",
	"H_HelmetB_camo",
	"H_HelmetB_desert",
	"H_HelmetB_grass",
	"H_HelmetB_light",
	"H_HelmetB_light_black",
	"H_HelmetB_light_desert",
	"H_HelmetB_light_grass",
	"H_HelmetB_light_sand",
	"H_HelmetB_light_snakeskin",
	"H_HelmetB_paint",
	"H_HelmetB_plain_blk",
	"H_HelmetB_sand",
	"H_HelmetB_snakeskin",
	"H_HelmetCrew_B",
	"H_HelmetCrew_I",
	"H_HelmetCrew_O",
	"H_HelmetIA",
	"H_HelmetIA_camo",
	"H_HelmetIA_net",
	"H_HelmetLeaderO_ocamo",
	"H_HelmetLeaderO_oucamo",
	"H_HelmetO_ocamo",
	"H_HelmetO_oucamo",
	"H_HelmetSpecB",
	"H_HelmetSpecB_blk",
	"H_HelmetSpecB_paint1",
	"H_HelmetSpecB_paint2",
	"H_HelmetSpecO_blk",
	"H_HelmetSpecO_ocamo",
	"H_CrewHelmetHeli_B",
	"H_CrewHelmetHeli_I",
	"H_CrewHelmetHeli_O",
	"H_HelmetCrew_I",
	"H_HelmetCrew_B",
	"H_HelmetCrew_O",
	"H_PilotHelmetHeli_B",
	"H_PilotHelmetHeli_I",
	"H_PilotHelmetHeli_O",
	"H_Helmet_Skate",
	"H_HelmetB_TI_tna_F",
	"H_HelmetB_tna_F",
	"H_HelmetB_Enh_tna_F",
	"H_HelmetB_Light_tna_F",
	"H_HelmetSpecO_ghex_F",
	"H_HelmetLeaderO_ghex_F",
	"H_HelmetO_ghex_F",
	"H_HelmetCrew_O_ghex_F"			
];
DGCore_Headgear = DGCore_Headgear + DGCore_Helmets;

DGCore_AIItems =
[
	"Exile_Item_InstaDoc",
	"Exile_Item_BBQSandwich",
	"Exile_Item_BeefParts",
	"Exile_Item_Catfood",
	"Exile_Item_Cheathas",
	"Exile_Item_ChristmasTinner",
	"Exile_Item_Dogfood",
	"Exile_Item_EMRE",
	"Exile_Item_GloriousKnakworst",
	"Exile_Item_InstantCoffee",
	"Exile_Item_MacasCheese",
	"Exile_Item_Moobar",
	"Exile_Item_Noodles",
	"Exile_Item_Raisins",
	"Exile_Item_SausageGravy",
	"Exile_Item_SeedAstics",
	"Exile_Item_Surstromming",
	"Exile_Item_Can_Empty",
	"Exile_Item_Beer",
	"Exile_Item_ChocolateMilk",
	"Exile_Item_EnergyDrink",
	"Exile_Item_MountainDupe",
	"Exile_Item_PlasticBottleCoffee",
	"Exile_Item_PlasticBottleFreshWater",
	"Exile_Item_PowerDrink"
];

DGCore_Materials =
[
	"Exile_Item_PlasticBottleCoffee",
	"Exile_Item_PowerDrink",
	"Exile_Item_PlasticBottleFreshWater",
	"Exile_Item_Beer",
	"Exile_Item_EnergyDrink",
	"Exile_Item_MountainDupe",
	"Exile_Item_EMRE",		
	"Exile_Item_GloriousKnakworst",
	"Exile_Item_Surstromming",
	"Exile_Item_SausageGravy",
	"Exile_Item_Catfood",
	"Exile_Item_ChristmasTinner",
	"Exile_Item_BBQSandwich",
	"Exile_Item_Dogfood",
	"Exile_Item_BeefParts",
	"Exile_Item_Cheathas",
	"Exile_Item_Noodles",
	"Exile_Item_SeedAstics",
	"Exile_Item_Raisins",
	"Exile_Item_Moobar",
	"Exile_Item_InstantCoffee"
];

DGCore_BuildingMaterials = 	
[
	"Exile_Item_ExtensionCord",
	"Exile_Item_DuctTape",
	"Exile_Item_LightBulb",
	"Exile_Item_MetalBoard",
	"Exile_Item_MetalPole",
	"Exile_Item_MetalScrews",
	"Exile_Item_Cement",
	"Exile_Item_Sand",
	"Exile_Item_MetalWire",
	"Exile_Item_ExtensionCord",
	"Exile_Item_JunkMetal",
	"BlockConcrete_F_Kit",
	"Exile_ConcreteMixer_Kit",
	"Exile_Item_ConcreteWallKit",
	"Exile_Item_ConcreteFloorKit",
	"Exile_Item_ConcreteGateKit",
	"Land_CncWall4_F_Kit",
	"Land_CargoBox_V1_F_Kit",
	"Exile_Item_WaterBarrelKit",
	"Exile_Item_WaterCanisterDirtyWater",
	"Exile_Item_Foolbox"
];

DGCore_LootMaterials = DGCore_Materials + DGCore_BuildingMaterials; // For when you want both arrays

//This defines the skin list, some skins are disabled by default to permit players to have high visibility uniforms distinct from those of the AI.
DGCore_Uniforms = 		
[
	"Exile_Uniform_Woodland",
	"U_BG_Guerilla1_1",
	"U_BG_Guerilla2_1",
	"U_BG_Guerilla2_2",
	"U_BG_Guerilla2_3",
	"U_BG_Guerilla3_1",
	"U_BG_Guerrilla_6_1",
	"U_BG_leader",
	"U_B_CTRG_1",
	"U_B_CTRG_2",
	"U_B_CTRG_3",
	"U_B_CombatUniform_mcam",
	"U_B_CombatUniform_mcam_tshirt",
	"U_B_CombatUniform_mcam_vest",
	"U_B_CombatUniform_mcam_worn",
	"U_B_HeliPilotCoveralls",
	"U_B_PilotCoveralls",
	"U_B_SpecopsUniform_sgg",
	"U_B_Wetsuit",
	"U_B_survival_uniform",
	"U_C_HunterBody_grn",
	"U_C_Journalist",
	"U_C_Poloshirt_blue",
	"U_C_Poloshirt_burgundy",
	"U_C_Poloshirt_salmon",
	"U_C_Poloshirt_stripped",
	"U_C_Poloshirt_tricolour",
	"U_C_Poor_1",
	"U_C_Poor_2",
	"U_C_Poor_shorts_1",
	"U_C_Scientist",
	"U_Competitor",
	"U_IG_Guerilla1_1",
	"U_IG_Guerilla2_1",
	"U_IG_Guerilla2_2",
	"U_IG_Guerilla2_3",
	"U_IG_Guerilla3_1",
	"U_IG_Guerilla3_2",
	"U_IG_leader",
	"U_I_CombatUniform",
	"U_I_CombatUniform_shortsleeve",
	"U_I_CombatUniform_tshirt",
	"U_I_G_Story_Protagonist_F",
	"U_I_G_resistanceLeader_F",
	"U_I_HeliPilotCoveralls",
	"U_I_OfficerUniform",
	"U_I_Wetsuit",
	"U_I_pilotCoveralls",
	"U_NikosAgedBody",
	"U_NikosBody",
	"U_O_CombatUniform_ocamo",
	"U_O_CombatUniform_oucamo",
	"U_O_OfficerUniform_ocamo",
	"U_O_PilotCoveralls",
	"U_O_SpecopsUniform_blk",
	"U_O_SpecopsUniform_ocamo",
	"U_O_Wetsuit",
	"U_OrestesBody",
	"U_Rangemaster",
	"U_B_FullGhillie_ard",
	"U_B_FullGhillie_lsh",
	"U_B_FullGhillie_sard",
	"U_B_GhillieSuit",
	"U_I_FullGhillie_ard",
	"U_I_FullGhillie_lsh",
	"U_I_FullGhillie_sard",
	"U_I_GhillieSuit",
	"U_O_FullGhillie_ard",
	"U_O_FullGhillie_lsh",
	"U_O_FullGhillie_sard",
	"U_O_GhillieSuit"
];
	
DGCore_CivilianVehicles = 
[
	"B_Quadbike_01_F",
	"B_G_Van_01_fuel_F",
	"B_G_Van_01_transport_F",
	"B_Truck_01_box_F",
	"B_Truck_01_cargo_F",
	"B_Truck_01_fuel_F",
	"I_E_Offroad_01_F",
	"I_C_Van_01_transport_F",
	"C_Van_01_fuel_F",
	"C_Hatchback_01_F",
	"C_Hatchback_01_sport_F",
	"C_Offroad_01_F",
	"C_SUV_01_F",
	"C_Van_01_box_F",
	"C_Van_01_transport_F",
	"C_Truck_02_covered_F",
	"C_Truck_02_transport_F",
	"C_Truck_02_fuel_F",
	
	"B_GEN_Offroad_01_gen_F", // APEX
	"C_Offroad_02_unarmed_F",
	
	"Golf_Civ_Black", // Exile
	"Golf_Civ_pink", // Exile
	"Golf_Civ_Base", // Exile
	"Exile_Car_Lada_Red", // Exile
	"Exile_Car_Lada_Hipster", // Exile
	"Exile_Car_Lada_Green", // Exile
	"Exile_Car_Lada_White", // Exile
	"Exile_Car_OldTractor_Red", // Exile
	"Exile_Car_SUVXL_Black", // Exile
	
	"dbo_CIV_ol_bike", // Exile bike
	"dbo_CIV_new_bike", // Exile bike
	
	"CUP_C_Bus_City_CIV",
	"CUP_C_Pickup_unarmed_CIV",
	"CUP_C_Datsun",
	"rhsusf_m998_w_2dr",
	"CUP_O_UAZ_Open_RU",
	"CUP_O_Ural_Empty_RU",
	"CUP_O_Volha_SLA",
	"CUP_O_SUV_TKA",
	"CUP_O_Hilux_unarmed_TK_INS",
	"CUP_I_Van_Transport_ION",
	"CUP_I_Van_Cargo_ION",
	"CUP_B_UAZ_Unarmed_ACR",
	"CUP_B_LR_Ambulande_GB_D",
	"CUP_B_MTVR_BAF_DES",
	"CUP_B_CDF_Militia_MNT",
	"CUP_B_Ural_Empty_CDF",
	"CUP_B_Tractor_CDF"
];

DGCore_CivilianPlanes = 
[
	"I_C_Plane_Civil_01_F", // APEX
	"C_Plane_Civil_01_F", // APEX
	"C_Plane_Civil_01_racing_F", // APEX
	
	"Exile_Plane_AN2_Stripe", // EXILE
	"Exile_Plane_AN2_Green", // EXILE
	"Exile_Plane_AN2_White", // Exile
	"GNT_C185F", // Exile
	
	"CUP_I_CESSNA_T41_UNARMED_HIL",
	"CUP_B_AC47_Spooky_USA",
	"CUP_O_C47_SLA",
	"CUP_O_AN2_TK",
	"CUP_I_Plane_ION",
	"CUP_I_CESSNA_T41_UNARMED_ION",
	"CUP_I_CESSNA_T41_UNARMED_LDF",
	"CUP_I_CESSNA_T41_UNARMED_RACS",
	"CUP_C_C47_CIV",
	"CUP_C_Plane_Orbit",
	"CUP_C_DC3_CIV",
	"CUP_C_DC3_TanoAir_CIV",
	"CUP_C_AN2_CIV",
	"CUP_C_CESSNA_CIV",
	"CUP_C_DC3_ChernAvia_CIV",
	"CUP_C_AN2_AEROSCHROT_TK_CIV",
	"CUP_C_AN2_AIRTAK_TK_CIV"
];

DGCore_CivilianUniforms =
[
	"U_C_Poloshirt_blue",
	"U_C_Poloshirt_burgundy",
	"U_C_Poloshirt_salmon",
	"U_C_Poloshirt_stripped",
	"U_C_Poloshirt_tricolour",
	"U_C_Poor_1",
	"U_C_Poor_2",
	"U_C_Poor_shorts_1",
	"U_C_Scientist",
	"U_Competitor",
	"U_C_HunterBody_grn",
	"U_C_Journalist",
	"U_Marshal",
	"U_Rangemaster",
	"U_B_survival_uniform",
	"U_I_C_Soldier_Bandit_1_F", // APEX
	"U_I_C_Soldier_Bandit_2_F", // APEX
	"U_I_C_Soldier_Bandit_3_F", // APEX
	"U_I_C_Soldier_Bandit_4_F", // APEX
	"U_I_C_Soldier_Bandit_5_F", // APEX
	"U_C_Man_casual_1_F", // APEX
	"U_C_Man_casual_2_F", // APEX
	"U_C_Man_casual_3_F", // APEX
	"U_C_Man_casual_4_F", // APEX
	"U_C_Man_casual_5_F", // APEX
	"U_C_Man_casual_6_F", // APEX
	"U_C_man_sport_1_F",	//APEX
	"U_C_man_sport_2_F",	//APEX
	"U_C_man_sport_3_F",	//APEX
	"CUP_U_C_Villager_01",
	"CUP_U_C_Villager_02",
	"CUP_U_C_Villager_03",
	"CUP_U_C_Villager_04",
	"CUP_U_C_Worker_01",
	"CUP_U_C_Worker_02",
	"CUP_U_C_Worker_03",
	"CUP_U_C_Worker_04"
];
	
DGCore_CivilianHeadgear =
[
	"H_Bandanna_camo",
	"H_Bandanna_cbr",
	"H_Bandanna_gry",
	"H_Bandanna_khk",
	"H_Bandanna_khk_hs",
	"H_Bandanna_mcamo",
	"H_Bandanna_sgg",
	"H_Bandanna_surfer",
	"H_Booniehat_dgtl",
	"H_Booniehat_dirty",
	"H_Booniehat_grn",
	"H_Booniehat_indp",
	"H_Booniehat_khk",
	"H_Booniehat_khk_hs",
	"H_Booniehat_mcamo",
	"H_Booniehat_tan",
	"H_Cap_blk",
	"H_Cap_blk_Raven",
	"H_Cap_blu",
	"H_Cap_brn_SPECOPS",
	"H_Cap_grn",
	"H_Cap_headphones",
	"H_Cap_khaki_specops_UK",
	"H_Cap_oli",
	"H_Cap_press",
	"H_Cap_red",
	"H_Cap_tan",
	"H_Cap_tan_specops_US",
	"H_StrawHat",
	"H_StrawHat_dark",
	"H_Hat_blue",
	"H_Hat_brown",
	"H_Hat_camo",
	"H_Hat_checker",
	"H_Hat_grey",
	"H_Hat_tan"
];


// CONVOY DEFAULT CONFIG...
DGCore_ArmedConvoy =
[
	// Vehicle 0
	[
		// Possible vehicle classes
		[
			"Exile_Car_Offroad_Armed_Guerilla01","Exile_Car_Offroad_Armed_Guerilla02","Exile_Car_Offroad_Armed_Guerilla03",
			"Exile_Car_Offroad_Armed_Guerilla04","Exile_Car_Offroad_Armed_Guerilla05","Exile_Car_Offroad_Armed_Guerilla06",
			"Exile_Car_Offroad_Armed_Guerilla07","Exile_Car_Offroad_Armed_Guerilla08","Exile_Car_Offroad_Armed_Guerilla09",
			"Exile_Car_Offroad_Armed_Guerilla10","Exile_Car_Offroad_Armed_Guerilla11","Exile_Car_Offroad_Armed_Guerilla012"
		],
		3, // AI count
		0, // Object height. Also fly height if you want helicopters. 0 - default for ground vehicles
		[], // Static loot array
		[0, 750] // Min and max amount of poptabs in vehicle
	],
	
	// Vehicle 1
	[
		// Possible vehicle classes
		[
			"Exile_Car_SUV_Armed_Black"
		],
		4, // AI count
		0, // Object height. Also fly height if you want helicopters. 0 - default for ground vehicles
		[], // Static loot array
		[100, 1000] // Min and max amount of poptabs in vehicle
	],
	
	// Vehicle 2 etc.
	[
		[
			"O_G_Offroad_01_armed_F"
		],
		3, // AI count
		0, // Object height. Also fly height if you want helicopters. 0 - default for ground vehicles
		[], // Static loot array
		[0, 750] // Min and max amount of poptabs in vehicle
	]
];

DGCore_ArmedTroopConvoy =
[
	// Vehicle 0
	[
		// Possible vehicle classes
		[
			"O_MRAP_02_hmg_F"
		],
		3, // AI count
		0, // Object height. Also fly height if you want helicopters. 0 - default for ground vehicles
		[], // Static loot array
		[500, 1000] // Min and max amount of poptabs in vehicle
	],
	
	// Vehicle 1
	[
		// Possible vehicle classes
		[
			"O_Truck_03_transport_F"
		],
		10, // AI count
		0, // Object height. Also fly height if you want helicopters. 0 - default for ground vehicles
		[], // Static loot array
		[750, 2000] // Min and max amount of poptabs in vehicle
	],
	
	// Vehicle 2 etc.
	[
		// Possible vehicle classes
		[
			"O_MRAP_02_gmg_F"
		],
		3, // AI count
		0, // Object height. Also fly height if you want helicopters. 0 - default for ground vehicles
		[], // Static loot array
		[500, 1000] // Min and max amount of poptabs in vehicle
	]
];

DGCore_ArmedTankConvoy =
[
	// Vehicle 0
	[
		// Possible vehicle classes
		[
			"O_MBT_02_cannon_F", "CUP_O_T34_TKA", "B_MBT_01_cannon_F", "CUP_B_FV432_Bulldog_GB_W", "CUP_B_BTR80_FIA", "I_APC_tracked_03_cannon_F", "B_APC_Tracked_01_CRV_F", "CUP_B_M60A3_USMC", "CUP_B_M1A2SEP_TUSK_II_NATO", "CUP_O_T90_RU", "CUP_O_T55_CSAT"
		],
		3, // AI count
		0, // Object height. Also fly height if you want helicopters. 0 - default for ground vehicles
		[], // Static loot array
		[5000, 10000] // Min and max amount of poptabs in vehicle
	]
];

["Internal Configuration loaded"] call DGCore_fnc_log;
DGCore_Initialized = true;