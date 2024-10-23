/*
    DGCore_fnc_spawnRandomCamp

    Purpose: Randomly choose a camp to spawn by selecting from predefined camp-spawning functions.

    Parameters: None

    Example: _camp = [getPos player, 200] call DGCore_fnc_spawnRandomCamp;

    Returns: The result of the selected camp-spawning function (likely a camp object).
*/

private ["_pos", "_difficulty", "_minDistance", "_maxDistance", "_bases", "_cupBases", "_camp"];
params [["_pos", []], ["_difficulty", "none"], ["_minDistance", 0], ["_maxDistance", DG_mapRange]];

if(_pos isEqualTo []) then // If not defined, find a random pos. Otherwise use pos
{
	_pos = [_pos, _minDistance, _maxDistance] call DGCore_fnc_findPosition;
};

if(_pos isEqualTo [-1,-1,-1]) exitWith{}; // Invalid pos

private["_lowBases", "_mediumBases", "_highBases", "_veteranBases"];

_lowBases =
[
	"BrownSmallCamp",
	"Villa",
	"GhostVillage",
	"Walmart"
];

_mediumBases =
[
	"BrownMediumCamp",
	"Sawmill"
];

_highBases =
[
	"BrownLargeCamp",
	"Castle",
	"LargeFactory"
];

_veteranBases =
[
	"BrownHugeCamp"
];

_cupHighBases =
[
	"CUPCastle"
];

private["_randomBase"];

if(_difficulty isEqualTo "none" || _difficulty isEqualTo "random") then
{
	// Select a random base from all known templates
	private _allBases = _lowBases + _mediumBases + _highBases + _veteranBases;
	if(DG_hasMod_CUPTerrain) then
	{
		_allBases = _allBases + _cupHighBases;
	};
	
	_randomBase = _allBases call BIS_fnc_selectRandom;
} else
{
	_mediumBases = _mediumBases + _lowBases;

	if(DG_hasMod_CUPTerrain) then
	{
		_highBases = _highBases + _cupHighBases;
		_veteranBases = _veteranBases + _cupHighBases;
	};
	
	switch (_difficulty) do
	{
		case "low":
		{
			_randomBase = _lowBases call BIS_fnc_selectRandom;
		};
		case "medium":
		{
			_randomBase = _mediumBases call BIS_fnc_selectRandom;
		};
		case "high":
		{
			_randomBase = _highBases call BIS_fnc_selectRandom;
		};
		case "veteran":
		{
			_randomBase = _veteranBases call BIS_fnc_selectRandom;
		};
	};	
};

switch (_randomBase) do 
{
	case "BrownSmallCamp":  { _camp = [_pos] call DGCore_fnc_spawnBrownSmallCamp; };
	case "Villa": { _camp = [_pos] call DGCore_fnc_spawnVilla; };
	case "GhostVillage":  { _camp = [_pos] call DGCore_fnc_spawnGhostVillage; };
	case "Walmart":  { _camp = [_pos] call DGCore_fnc_spawnWalmart; };
	
	case "BrownMediumCamp": { _camp = [_pos] call DGCore_fnc_spawnBrownMediumCamp; };
	case "Sawmill": { _camp = [_pos] call DGCore_fnc_spawnSawmill; };
	
	case "BrownLargeCamp": { _camp = [_pos] call DGCore_fnc_spawnBrownLargeCamp; };
	case "LargeFactory": { _camp = [_pos] call DGCore_fnc_spawnLargeFactory; };
	case "Castle": { _camp = [_pos] call DGCore_fnc_spawnCastle; };
	
	case "BrownHugeCamp": { _camp = [_pos] call DGCore_fnc_spawnBrownHugeCamp; };

	case "CUPCastle": { _camp = [_pos] call DGCore_fnc_spawnCUPCastle; };
};

if(!isNil "_camp" && typeName _camp == "ARRAY") then
{
	[format["Spawned %1 (%2) @ position %3, _difficulty = %4", (_camp select 0), _randomBase, _pos, _difficulty], "DGCore_fnc_spawnRandomCamp", "debug"] call DGCore_fnc_log;
};

_camp
