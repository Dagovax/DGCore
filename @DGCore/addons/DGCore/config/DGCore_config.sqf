if (!isServer) exitWith {
	["Failed to load configuration data for @DGCore!"] call DGCore_fnc_log;
};

["Loading configuration data..."] call DGCore_fnc_log;

/****************************************************************************************************/
/********************************  CONFIG PART. EDIT AS YOU LIKE!!  ************************************/
/****************************************************************************************************/

// Generic
DGCore_DebugMode			= false; // For testing purposes. Do not set this on live server or players will die
DGCore_CleanupTime			= 5*60; // Time in seconds an object will be timed out for deletion (can be vehicle/unit)
DGCore_EnableLogging		= true;
DGCore_LogLevel				= "information"; // choose between:  "information" | "debug" | "errors" | "warnings"

// Notification
DGCore_EnableKillMessage	= true; // Plays a sound and gives the kill message in side chat. 

// AI Settings
DGCore_PlayerExpRange 		= [25000, 75000, 150000]; // Range of the player's experience until it reaches next level. [easy > normal, normal > hard, hard > extreme] (for AI that targets a player)
DGCore_BaseLevelRange		= [3, 6, 8]; // Range of base level it reaches next difficulty level. [easy > normal, normal > hard, hard > extreme] (used for base raids)
DGCore_EnableLaunchers		= true; // Set to false to have no AI spawned with launchers. Setting this to true will still check definition below for spawn chance per AI level
DGCore_FlyHeightRange		= [100, 400]; // A random flyheight will be used

DGCore_AIEasyTroopCount		= [1,3]; // Array containing min - max troops
DGCore_AIEasySettings		= [0.3, 1, 100, 0]; // AI easy general level, followed by inventory items | max poptabs | launcher spawn chance 
DGCore_AINormalTroopCount	= [2,5]; // Array containing min - max troops
DGCore_AINormalSettings		= [0.5, 2, 250, 12]; // AI normal general level, followed by inventory items | max poptabs | launcher spawn chance 
DGCore_AIHardTroopCount		= [3,6]; // Array containing min - max troops
DGCore_AIHardSettings		= [0.7, 3, 500, 25]; // AI hard general level, followed by inventory items | max poptabs | launcher spawn chance 
DGCore_AIExtremeTroopCount	= [5,10]; // Array containing min - max troops
DGCore_AIExtremeSettings	= [0.9, 4, 1000, 33]; // AI extreme general level, followed by inventory items | max poptabs | launcher spawn chance 

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
	"Exile_Item_Surstromming"
];

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
	"C_Offroad_02_unarmed_F"//, 
	
	"Golf_Civ_Black", // Exile
	"Golf_Civ_pink", // Exile
	"Golf_Civ_Base", // Exile
	"Exile_Car_Lada_Red", // Exile
	"Exile_Car_Lada_Hipster", // Exile
	"Exile_Car_Lada_Green", // Exile
	"Exile_Car_Lada_White", // Exile
	"Exile_Car_OldTractor_Red", // Exile
	"Exile_Car_SUVXL_Black" // ,  // < don't forget this comma if you enable stuff below! // Exile
	
	// "dbo_CIV_ol_bike", // Exile bike
	// "dbo_CIV_new_bike", // Exile bike
	
	// CUP
	// "CUP_C_Bus_City_CIV",
	// "CUP_C_Pickup_unarmed_CIV",
	// "CUP_C_Datsun",
	// "CUP_O_UAZ_Open_RU",
	// "CUP_O_Ural_Empty_RU",
	// "CUP_O_Volha_SLA",
	// "CUP_O_SUV_TKA",
	// "CUP_O_Hilux_unarmed_TK_INS",
	// "CUP_I_Van_Transport_ION",
	// "CUP_I_Van_Cargo_ION",
	// "CUP_B_UAZ_Unarmed_ACR",
	// "CUP_B_LR_Ambulande_GB_D",
	// "CUP_B_MTVR_BAF_DES",
	// "CUP_B_CDF_Militia_MNT",
	// "CUP_B_Ural_Empty_CDF",
	// "CUP_B_Tractor_CDF",
	
	// RHS
	// "rhsusf_m998_w_2dr"
];

DGCore_CivilianPlanes = 
[
	"I_C_Plane_Civil_01_F", // APEX
	"C_Plane_Civil_01_F", // APEX
	"C_Plane_Civil_01_racing_F", // APEX
	
	"Exile_Plane_AN2_Stripe", // EXILE
	"Exile_Plane_AN2_Green", // EXILE
	"Exile_Plane_AN2_White", // Exile
	"GNT_C185F" //, < don't forget this comma if you enable stuff below! // Exile
	
	// "CUP_I_CESSNA_T41_UNARMED_HIL",
	// "CUP_B_AC47_Spooky_USA",
	// "CUP_O_C47_SLA",
	// "CUP_O_AN2_TK",
	// "CUP_I_Plane_ION",
	// "CUP_I_CESSNA_T41_UNARMED_ION",
	// "CUP_I_CESSNA_T41_UNARMED_LDF",
	// "CUP_I_CESSNA_T41_UNARMED_RACS",
	// "CUP_C_C47_CIV",
	// "CUP_C_Plane_Orbit",
	// "CUP_C_DC3_CIV",
	// "CUP_C_DC3_TranoAir_CIV",
	// "CUP_C_AN2_CIV",
	// "CUP_C_CESSNA_CIV",
	// "CUP_C_DC3_ChernAvia_CIV",
	// "CUP_C_AN2_AEROSCHROT_TK_CIV",
	// "CUP_C_AN2_AIRTAK_TK_CIV"
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
	"U_C_man_sport_3_F"	//APEX
	
	// "CUP_U_C_Villager_01",
	// "CUP_U_C_Villager_02",
	// "CUP_U_C_Villager_03",
	// "CUP_U_C_Villager_04",
	// "CUP_U_C_Worker_01",
	// "CUP_U_C_Worker_02",
	// "CUP_U_C_Worker_03",
	// "CUP_U_C_Worker_04"
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
	
["Internal Configuration loaded"] call DGCore_fnc_log;
DGCore_Initialized = true;