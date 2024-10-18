/*

	DGCore_fnc_spawnHeliDrop

	Purpose: 	Spawns a given helicopter at certain distance away from target player. Heli moves to player, unloads troops or drops a vehicle.
				

	Parameters:
		_class: 			Helicopter class to spawn
		_targetPlayer: 		Target player
		_spawnPos: 			The static, predefined spawn position			|	Optional -> Use empty array '[]' to spawn at a random position with below _distance
		_distance:			Distance in m the random position will spawn	|	Optional -> Not used when _spawnPos has a value!
		_spawnHeight:		Spawn height									|	Optional -> Defaults to 150
		_flyHeight:			Height of the helicopter's flight path			| 	Optional -> Defaults to 75
		_side:				What side the pilot will be						|	Optional -> Defaults to player's side
		_vehicleDrop:		Array in format [true/false, "vehicleClass"]	|	Optional
		_allowDamage:		Can the helicopter be shot down?				|	Optional -> Defaults to true
		_setCaptive:		If set to true, helicopter will be ignored by AI|	Optional -> Default false

	Example: _spawnHeliRequest = ["I_Heli_Transport_02_F"] call DGCore_fnc_spawnHeliDrop;

	Returns: Array in format [_helicopter (Vehicle), _dropVehicle (Vehicle)]

	Copyright 2024 by Dagovax
*/

params["_class", "_targetPlayer", ["_spawnPos", [0,0,0,0]], ["_distance", 2000], ["_spawnHeight", 150], ["_flyHeight", 75], ["_side", DGCore_playerSide], ["_vehicleDrop", [false, ""]], ["_allowDamage", true], ["_setCaptive", false]];
if((isNil "_class") || (isNil "_targetPlayer") || (isNull _targetPlayer)) exitWith
{
	[format["Not enough valid params to spawn helicopter crop! -> _class = %1 | _targetPlayer = %2", _class, _targetPlayer], "DGCore_fnc_spawnHeliDrop", "error"] call DGCore_fnc_log;
};
private["_helicopter", "_pilot", "_pilotGroup", "_randomSpawnPos", "_heliDirection", "_targetPosition", "_flyPosition", "_carryVehicle", "_vehicleSpawned", "_spawnPosition"];
_targetPosition = getPosATL _targetPlayer;
if(_spawnPos isEqualTo [0,0,0,0] || _spawnPos isEqualTo []) then
{
	_randomSpawnPos = true;
	_heliDirection = random 360;
	_spawnPosition =[(_targetPosition select 0) - (sin _heliDirection) * _distance, (_targetPosition select 1) - (cos _heliDirection) * _distance, (_targetPosition select 2) + _spawnHeight];
} else
{
	_heliDirection = (_spawnPos select 3);
	_spawnPosition =[(_spawnPos select 0), (_spawnPos select 1), (_spawnPos select 2) + _spawnHeight];
};

_dir = ((_targetPosition select 0) - (_spawnPosition select 0)) atan2 ((_targetPosition select 1) - (_spawnPosition select 1));
_flyPosition = [(_targetPosition select 0) + (sin _dir) * _distance, (_targetPosition select 1) + (cos _dir) * _distance, (_targetPosition select 2) + _spawnHeight];
_spawnAngle = [_spawnPosition,_targetPosition] call BIS_fnc_dirTo;

_helicopter = createVehicle [_class, _spawnPosition, [], 0, "FLY"];
_helicopter setPosATL (_helicopter modelToWorld [0,0,_spawnHeight]);
_helicopter setDir _spawnAngle;
_helicopter setVelocity [25 * (sin _spawnAngle), 25 * (cos _spawnAngle), 0];
_helicopter flyInHeight _flyHeight;
_helicopterName = getText (configFile >> "CfgVehicles" >> (typeOf _helicopter) >> "displayName");

_pilot = [_helicopter, "", _side, _allowDamage] call DGCore_fnc_spawnPilot;
if(isNil "_pilot" || isNull _pilot) exitWith
{
	[format["Failed to create a pilot. Heli drop aborted!"], "DGCore_fnc_spawnHeliDrop", "error"] call DGCore_fnc_log;
};
_helicopter allowCrewInImmobile true; // let AI stay in vehicle
[format["Spawned a %1 @ %2", _helicopterName, _spawnPosition], "DGCore_fnc_spawnHeliDrop", "debug"] call DGCore_fnc_log;
_helicopter allowDamage _allowDamage;
_helicopter setCaptive _setCaptive;

_pilotGroup = group _pilot;
_pilotGroup setCombatMode "BLUE";
_pilotGroup setBehaviour "CARELESS";  //Just out for a sunday stroll.
{_x disableAI "AUTOTARGET"; _x disableAI "TARGET"; _x disableAI "FSM"; _x allowfleeing 0;} forEach units _pilotGroup;

_pilotGroup setVariable ["_helicoptedAssigned", _helicopter];
_pilotGroup setVariable ["_targetPlayer", _targetPlayer];

_vehicleSpawned = false;

if(_vehicleDrop select 0) then
{
	_vehicleDropClass = _vehicleDrop select 1;
	if(isNil "_vehicleDropClass" || _vehicleDropClass == "") then
	{
		_vehicleDropClass = "B_G_Offroad_01_armed_F"; // fallback to Offroad HMG
	};
	_vehicleSpawnPos = [(_spawnPosition select 0), (_spawnPosition select 1), (_spawnPosition select 2) - 10];
	
	if((toLowerANSI DGCore_modType) isEqualTo "exile") then
	{
		_carryVehicle = [_vehicleDropClass, _vehicleSpawnPos, 0, FALSE] call ExileServer_object_vehicle_createNonPersistentVehicle;
	} 
	else
	{
		_carryVehicle = createVehicle [_vehicleDropClass, _vehicleSpawnPos];
	};
	_carryVehicle attachTo [_helicopter, [0,0,-7]]; //Attach Object to the aircraft
	_carryVehicle allowDamage false; //Let's not let these things get destroyed on the way there, shall we?
	_carryVehicleName = getText (configFile >> "CfgVehicles" >> (typeOf _carryVehicle) >> "displayName");
	[format ["Spawned a %1 underneath the %2", _carryVehicleName, _helicopterName], "DGCore_fnc_spawnHeliDrop", "debug"] call DGCore_fnc_log;
	_pilotGroup setVariable ["_dropObjectAssigned", _carryVehicle];
	_pilotGroup setVariable ["_vehicleDropped", false];
	if(!isNil "_carryVehicle" && !isNull _carryVehicle) then
	{
		_vehicleSpawned = true;
	};
} else
{
	_carryVehicle = objNull;
};

_dropMission = [_helicopter, _targetPlayer, _pilot, _pilotGroup, _carryVehicle, _vehicleSpawned, _flyPosition];
_dropMission spawn
{
	params ["_helicopter", "_targetPlayer", "_pilot", "_pilotGroup", "_carryVehicle", "_vehicleSpawned", "_flyPosition"];
	// Lets fly this heli to the target right?
	_targetPosition = getPosATL _targetPlayer;
	_pilotGroup move _targetPosition;

	_carryVehicleName = "";
	_helicopterName = getText (configFile >> "CfgVehicles" >> (typeOf _helicopter) >> "displayName");
	if(!isNil "_carryVehicle") then
	{
		_carryVehicleName = getText (configFile >> "CfgVehicles" >> (typeOf _carryVehicle) >> "displayName");
	};

	// Let us now wait and move until the helicopter reached this point!
	_targetReached = false;
	_targetPlayerName = name _targetPlayer;
	while {alive _helicopter} do
	{
		if (isNil "_targetPlayer" || isNull _targetPlayer) exitWith
		{
			[format["Player %1 disconnected or is bugged, because _targetPlayer equals undefined! Cleaning up and stopping this drop now!", _targetPlayerName], "DGCore_fnc_spawnHeliDrop", "warning"] call DGCore_fnc_log;
			_targetReached = false;
		};
		_targetPos = getPos _targetPlayer;
		_distance = _helicopter distance2D _targetPlayer;
		if (_distance <= 150) exitWith 
		{
			_targetReached = true;
		};
		uiSleep 5;
		_pilotGroup move _targetPos;
	};

	// Helicopter never reached the target
	if(!_targetReached) exitWith
	{
		[format["The %1 failed to reach _targetPlayer %2! Cleaning the mess up now!", _helicopterName, _targetPlayerName], "DGCore_fnc_spawnHeliDrop", "warning"] call DGCore_fnc_log;
		_helicopter flyInHeight 200;
		_helicopter move _flyPosition;
		_vehicleDropped = _pilotGroup getVariable "_vehicleDropped";
		_carryVehicle = _pilotGroup getVariable "_dropObjectAssigned";
		if(!isNil "_vehicleDropped" && !isNil "_carryVehicle") then
		{
			if(!_vehicleDropped && !isNull _carryVehicle) then
			{
				[format["Deleted the %1, because the drop did not reach player %2! _vehicleDropped = %3", _carryVehicle, _targetPlayerName, _vehicleDropped], "DGCore_fnc_spawnHeliDrop", "debug"] call DGCore_fnc_log;
				deleteVehicle _carryVehicle;
			};
		};
		if(!alive _helicopter) then // Already destroyed.
		{
			uiSleep 10;
		} else
		{
			while{not unitReady _helicopter} do
			{
				if(!alive _helicopter) exitWith
				{
					uiSleep 5;
				};
				uiSleep 5;
			};
		};
		
		deleteVehicleCrew _helicopter;
		deleteGroup _pilotGroup;
		deleteVehicle _helicopter;
	};

	[format["The %1 reached _targetPlayer %2!", _helicopterName, _targetPlayerName], "DGCore_fnc_spawnHeliDrop", "debug"] call DGCore_fnc_log;
	_safeSpot = [getPos _targetPlayer, 2,75,5,0,0.45,0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
	_safeUnload = true;
	if(_safeSpot isEqualTo [0,0,0]) then
	{
		[format["Could not find a valid position for safe drop unloading! _safeSpot equals %1", _safeSpot], "DGCore_fnc_spawnHeliDrop", "debug"] call DGCore_fnc_log;
		_safeUnload = false;
	};

	if(_safeUnload) then
	{
		_helicopter move _safeSpot;
		_canContinue = true;
		while { alive _helicopter && not unitReady _helicopter } do
		{
			if(isNil "_targetPlayer" || isNull _targetPlayer) exitWith
			{
				[format["Player %1 disconnected before safely dropping the cargo to the ground! Finishing without dropping anything!", _targetPlayerName], "DGCore_fnc_spawnHeliDrop", "warning"] call DGCore_fnc_log;
				_canContinue = false;
			};
			if(!alive _targetPlayer) exitWith
			{
				[format["Player %1 died before receiving the cargo!", _targetPlayerName], "DGCore_fnc_spawnHeliDrop", "warning"] call DGCore_fnc_log;
				_canContinue = false;
			};
			uiSleep 1;
		};
		if(!_canContinue) exitWith
		{
			[format["Group %1 is unable to continue to move to player %2 (disconnected?), skipping drop and moving to _flyPosition @ %3", _pilotGroup, _targetPlayerName, _flyPosition], "DGCore_fnc_spawnHeliDrop", "warning"] call DGCore_fnc_log;
		};
		_carryVehicle = _pilotGroup getVariable "_dropObjectAssigned";
		_safeFlyHeight = 3;
		if(_vehicleSpawned) then // If a vehicle is underneath, calculate the flyheight before vehicle drop.
		{	
			if(isNil "_carryVehicle" || isNull _carryVehicle) exitWith{};
			_zHeli = (position _helicopter) select 2;
			_zObj = (position _carryVehicle) select 2;
			_safeFlyHeight = _zHeli - _zObj + 3; // fly height for heli with drop.	 	
			if(_safeFlyHeight < 3) then
			{
				[format["We calculated _safeFlyHeight for vehicle drop to be %1 > %2", _safeFlyHeight, 3], "DGCore_fnc_spawnHeliDrop", "warning"] call DGCore_fnc_log;
				_safeFlyHeight = 3;
			} else
			{
				[format["We calculated _safeFlyHeight and will be %1", _safeFlyHeight], "DGCore_fnc_spawnHeliDrop", "warning"] call DGCore_fnc_log;
			};
		};
		
		
		if(_vehicleSpawned) then // Drop
		{
			_heliPadPos = [_safeSpot select 0, _safeSpot select 1, _safeFlyHeight];
			_heliPadClass = "Land_HelipadEmpty_F";
			_invisibleHelipad = createVehicle [_heliPadClass, _heliPadPos, [], 0, "CAN_COLLIDE"];
		
			_currTime = diag_tickTime;
			while{alive _helicopter} do
			{
				_helicopter land "LAND";
				_zATL = position _helicopter select 2;
				if (_zATL < (_safeFlyHeight + 3)) exitWith
				{
					[format["Reached safe dropping altitude of %1! Dropping cargo and moving away!", _safeFlyHeight], "DGCore_fnc_spawnHeliDrop", "debug"] call DGCore_fnc_log;
				};
				_timeRemaining = 60 - (diag_tickTime - _currTime);
				if ((_timeRemaining) < 0) exitWith
				{
					[format["(%1) Landing aborted. We tried landing for 60 seconds!", _helicopterName], "DGCore_fnc_spawnHeliDrop", "warning"] call DGCore_fnc_log;
				}; // time over. Continue code
				uiSleep 2;
			};

			detach _carryVehicle; // detach hehe
			_pilotGroup setVariable ["_vehicleDropped", true];
			[format["Group %1 succesfully dropped the %1 safely to the ground, and will now be going home.", _pilotGroup, _carryVehicleName], "DGCore_fnc_spawnHeliDrop", "debug"] call DGCore_fnc_log;		
			deleteVehicle _invisibleHelipad;
			//_carryVehicle allowDamage true;
		} else
		{
			_troopGroup = _helicopter getVariable ["_DGTransportGroup", grpNull]; // Group inside the heli which is not the pilot!
			if(!isNil "_troopGroup" && !isNull _troopGroup) then
			{
				_heliPadPos = [_safeSpot select 0, _safeSpot select 1, 0];
				_heliPadClass = "Land_HelipadEmpty_F";
				_invisibleHelipad = createVehicle [_heliPadClass, _heliPadPos, [], 0, "CAN_COLLIDE"];

				_currTime = diag_tickTime;
				while{alive _helicopter} do
				{
					_helicopter land "GET OUT";
					if((getPosATL _helicopter select 2) <= 0.5) exitWith{};
					_timeRemaining = 60 - (diag_tickTime - _currTime);
					if ((_timeRemaining) < 0) exitWith
					{
						[format["(%1) Landing and unload aborted. We tried landing for 60 seconds!", _helicopterName], "DGCore_fnc_spawnHeliDrop", "warning"] call DGCore_fnc_log;
					}; // time over. Continue code
					uiSleep 2;
				};
				
				{
					doGetOut _x;
					unassignVehicle _x;
					waitUntil {isTouchingGround _x};
					[format["%1 left the %2", _x, _helicopterName], "DGCore_fnc_spawnHeliDrop", "debug"] call DGCore_fnc_log;		
				} foreach units _troopGroup;
				
				waitUntil { uiSleep 5; (count fullCrew _helicopter) < 2 }; // Only Pilot left
				_troopGroup setVariable ["_DGUnloaded", true];
				[format["The %1 landed and unloaded group %2", _helicopterName, _troopGroup], "DGCore_fnc_spawnHeliDrop", "debug"] call DGCore_fnc_log;
				deleteVehicle _invisibleHelipad;
			} else
			{
				[format["The %1 landed and was ready to unload, but there is no assigned group to unload! -> _DGTransportGroup = %2", _helicopterName, _troopGroup], "DGCore_fnc_spawnHeliDrop", "warning"] call DGCore_fnc_log;		
			};
		};
	};

	// Fly back to base
	_helicopter land "NONE";
	{ _x allowDamage true; } forEach units _pilotGroup;
	_helicopter allowDamage true; 
	_helicopter setCaptive false;
	
	_helicopter flyInHeight 200;
	_helicopter move _flyPosition;
	if(!alive _helicopter) then // Already destroyed.
	{
		uiSleep 10;
	} else
	{
		while{not unitReady _helicopter} do
		{
			if(!alive _helicopter) exitWith
			{
				uiSleep 5;
			};
			uiSleep 5;
		};
	};
	_carryVehicle = _pilotGroup getVariable "_dropObjectAssigned";
	_vehicleDropped = _pilotGroup getVariable "_vehicleDropped";

	if(!isNil "_vehicleDropped" && !isNil "_carryVehicle") then
	{
		if(!_vehicleDropped && !isNull _carryVehicle) then
		{
			[format["Deleted the %1, because the drop did not reach player %2! _vehicleDropped = %3", _carryVehicle, _targetPlayerName, _vehicleDropped], "DGCore_fnc_spawnHeliDrop", "debug"] call DGCore_fnc_log;
			deleteVehicle _carryVehicle;
		};
	};

	deleteVehicleCrew _helicopter;
	deleteGroup _pilotGroup;
	deleteVehicle _helicopter;
};

[_helicopter, _carryVehicle];