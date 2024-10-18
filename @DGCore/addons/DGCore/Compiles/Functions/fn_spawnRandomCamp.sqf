/*
    DGCore_fnc_spawnRandomCamp

    Purpose: Randomly choose a camp to spawn by selecting from predefined camp-spawning functions.

    Parameters: None

    Example: _camp = [getPos player, 200] call DGCore_fnc_spawnRandomCamp;

    Returns: The result of the selected camp-spawning function (likely a camp object).
*/

private ["_pos", "_minDistance", "_maxDistance", "_bases", "_cupBases", "_camp"];
params [["_pos", []], ["_minDistance", 0], ["_maxDistance", DG_mapRange]];

if(_pos isEqualTo []) then // If not defined, find a random pos. Otherwise use pos
{
	_pos = [_pos, _minDistance, _maxDistance] call DGCore_fnc_findPosition;
};

if(_pos isEqualTo [-1,-1,-1]) exitWith{}; // Invalid pos

_bases = 
[
	"BrownSmallCamp",
	"BrownMediumCamp",
	"BrownLargeCamp",
	"BrownHugeCamp",
	"Castle",
	"Villa"
];

_cupBases =
[
	"CUPCastle"
];

if(DG_hasMod_CUPTerrain) then
{
	_bases = _bases + _cupBases;
};

private _randomBase = _bases call BIS_fnc_selectRandom;

switch (_randomBase) do 
{
	case "BrownSmallCamp":  { _camp = [_pos] call DGCore_fnc_spawnBrownSmallCamp; };
	case "BrownMediumCamp": { _camp = [_pos] call DGCore_fnc_spawnBrownMediumCamp; };
	case "BrownLargeCamp": { _camp = [_pos] call DGCore_fnc_spawnBrownLargeCamp; };
	case "BrownHugeCamp": { _camp = [_pos] call DGCore_fnc_spawnBrownHugeCamp; };
	case "Castle": { _camp = [_pos] call DGCore_fnc_spawnCastle; };
	case "Villa": { _camp = [_pos] call DGCore_fnc_spawnVilla; };
	
	case "CUPCastle": { _camp = [_pos] call DGCore_fnc_spawnCUPCastle; };
};

if(!isNil "_camp" && typeName _camp == "ARRAY") then
{
	[format["Spawned %1 (%2) @ position %3", (_camp select 0), _randomBase, _pos], "DGCore_fnc_spawnRandomCamp", "debug"] call DGCore_fnc_log;
};

_camp
