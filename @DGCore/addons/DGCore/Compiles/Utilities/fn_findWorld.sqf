/*

	DGCore_fnc_findWorld

	Purpose: to initialize world data

	Parameters: None

	Example: [] call DGCore_fnc_findWorld;

	Returns: None 

	Copyright 2023 by Dagovax
*/

[format["Loading world data for map '%1'",toLowerANSI worldName], "DGCore_fnc_findWorld", "debug"] call DGCore_fnc_log;

switch (toLowerANSI worldName) do 
{// These may need some adjustment - including a test for shore or water should help as well to avoid missions spawning on water.
		case "altis":{DG_mapCenter = [12000,10000,0]; DG_mapRange = 25000;};
		case "stratis":{DG_mapCenter = [3900,4500,0]; DG_mapRange = 4500;}; 
		case "tanoa":{DG_mapCenter = [9000,9000,0];  DG_mapRange = 10000;};
		case "malden":{	DG_mapCenter = [6000,7000,0];	DG_mapRange = 6000;};		
		case "enoch":{DG_mapCenter = [6500,6000,0];  DG_mapRange = 5800;};
		case "gm_weferlingen_summer":{DG_mapCenter = [10000,10000,0];	DG_mapRange = 10000;};
		case "gm_weferlingen_winter":{DG_mapCenter = [10000,10000,0];	DG_mapRange = 10000;};
		case "chernarus":{DG_mapCenter = [7100, 7750, 0]; DG_mapRange = 5300;};	
		case "namalsk":{DG_mapCenter = [5700, 8700, 0]; DG_mapRange = 10000;};		
		case "chernarus_summer":{DG_mapCenter = [7100, 7750, 0]; DG_mapRange = 6000;}; 
		case "chernarus_winter":{DG_mapCenter = [7100, 7750, 0]; DG_mapRange = 6000;}; 
		case "cup_chernarus_a3":{DG_mapCenter = [7100, 7750, 0]; DG_mapRange = 6000;};
		case "bornholm":{DG_mapCenter = [11240, 11292, 0];DG_mapRange = 14400;};
		case "esseker":{DG_mapCenter = [6049.26,6239.63,0]; DG_mapRange = 6000;};
		case "taviana":{DG_mapCenter = [10370, 11510, 0];DG_mapRange = 14400;};
		case "napf": {DG_mapCenter = [10240,10240,0]; DG_mapRange = 14000;}; 
		case "napfwinter": {DG_mapCenter = [10240,10240,0]; DG_mapRange = 14000;};  
		case "australia": {DG_mapCenter = [20480,20480, 150];DG_mapRange = 40960;};
		case "panthera3":{DG_mapCenter = [4400, 4400, 0];DG_mapRange = 4400;};
		case "isladuala":{DG_mapCenter = [4400, 4400, 0];DG_mapRange = 4400;};
		case "sauerland":{DG_mapCenter = [12800, 12800, 0];DG_mapRange = 12800;};
		case "trinity":{DG_mapCenter = [6400, 6400, 0];DG_mapRange = 6400;};
		case "utes":{DG_mapCenter = [3500, 3500, 0];DG_mapRange = 3500;};
		case "zargabad":{DG_mapCenter = [4096, 4096, 0];DG_mapRange = 4096;};
		case "fallujah":{DG_mapCenter = [3500, 3500, 0];DG_mapRange = 3500;};
		case "tavi":{DG_mapCenter = [10370, 11510, 0];DG_mapRange = 14090;};
		case "lingor":{DG_mapCenter = [4400, 4400, 0];DG_mapRange = 4400;};	
		case "takistan":{DG_mapCenter = [5500, 6500, 0];DG_mapRange = 5000;};
		case "lythium":{DG_mapCenter = [10000,10000,0];DG_mapRange = 8500;};
		case "vt7": {DG_mapCenter = [9000,9000,0]; DG_mapRange = 9000};		
		default {DG_mapCenter = [6322,7801,0]; DG_mapRange = 6000};
};
DG_mapMarker = createMarkerLocal ["DG_mapMarker",DG_mapCenter];
DG_mapMarker setMarkerShapeLocal "RECTANGLE";
DG_mapMarker setMarkerSizeLocal [DG_mapRange,DG_mapRange];
DG_world = worldname;
DG_worldSize = worldSize;
DG_mapDistance = worldSize * 0.75;
DG_axis = DG_worldSize / 2;
DG_mapCenter = [DG_axis, DG_axis, 0];
DG_mapRadius = sqrt 2 * DG_axis;
DG_maxRangePatrols =  DG_axis * 2 / 3;
DG_locationsForWaypoints =  ["NameVillage","NameCity","NameCityCapital","NameLocal"];
DG_patrolLocations = nearestLocations[DG_mapCenter,DG_locationsForWaypoints,DG_mapRange];