/*

	DGCore_fnc_placeVehicleOnRoad

	Purpose: Places a vehicle on nearest road tile, facing the correct direction

	Parameters:
		_side: 	Group side
		_pos: 	Position to spawn
		_count: 

	Example: ["I am being logged", "DG RoamingAI", "information"] call DGCore_fnc_log;

	Returns: Spawned Convoy info 

	Copyright 2024 by Dagovax
*/
params [["_vehicle", objNull], ["_endPosition", [-1,-1,-1]], ["_ignoreIsOnRoad", false], ["_radius", 100]];
if(isNull _vehicle) exitWith
{
	[format["Not enough valid params to place vehicle on nearby road tile! -> _vehicle = %1", _vehicle], "DGCore_fnc_placeVehicleOnRoad", "error"] call DGCore_fnc_log;
};

[_vehicle, _endPosition, _ignoreIsOnRoad, _radius] spawn
{
	params ["_vehicle", "_endPosition", "_ignoreIsOnRoad", "_radius"];
	private ["_currentPos", "_dirToEnd", "_road", "_direction"];
	if(isNull _vehicle || !alive _vehicle) exitWith{}; // vehicle is null or destroyed
	
	if(!_ignoreIsOnRoad && (isOnRoad _vehicle)) exitWith{}; // Vehicle is already on road. Do not place!
	
	_currentPos = getPos _vehicle;
	_roadTiles = _currentPos nearRoads _radius; // Get all roads near the pos
	if(count _roadTiles > 0) then
	{		
		_nearestRoadDistance = _radius;
		{
			_presentVehicle = nearestObjects [_x, ["Car", "Air", "Tank", "Bike"], 5];
			_freeTile = false;
			if(count _presentVehicle == 0) then
			{
				_freeTile = true;
			};
			_distance = _currentPos distance2d _x;
			if(_freeTile && (_distance < _nearestRoadDistance)) then
			{
				_nearestRoadDistance = _distance;
				_road = _x;
			};
		} forEach _roadTiles;
	};
	
	if(_endPosition isEqualTo [-1,-1,-1]) exitWith
	{
		// Place vehicle on the middle of the road, facing road direction
		if(!isNil "_road") then
		{
			_roadConnectedTo = roadsConnectedTo _road;
			_connectedRoad = _roadConnectedTo select 0;
							
			[_vehicle, _road, 0.3, true, true] call DGCore_fnc_placeVehicleRelative;
			_vectorUp = vectorUp _road;
			_vehicle setVectorUp _vectorUp;
							
			if(!isNil "_connectedRoad") then
			{
				_direction = [_road, _connectedRoad] call BIS_fnc_DirTo;
				
				_vehicle setDir _direction;
			};
			[format["Placed the %1 on the center of the road, no _endPosition specified!", _vehicle], "DGCore_fnc_placeVehicleOnRoad", "debug"] call DGCore_fnc_log;
		};
	};
	
	// We have end position. Check relative direction
	// Place vehicle on the middle of the road, facing direction of end position
	if(!isNil "_road") exitWith
	{
		_roadConnectedTo = roadsConnectedTo _road;
		_connectedRoad = _roadConnectedTo select 0;
		
		[_vehicle, _road, 0.3, true, true] call DGCore_fnc_placeVehicleRelative;
		_vectorUp = vectorUp _road;
		_vehicle setVectorUp _vectorUp;
		
		if(!isNil "_connectedRoad") then
		{
			_direction = [_road, _connectedRoad] call BIS_fnc_DirTo;
			_vehicle setDir _direction;
		
			// Now change direction based on _directionToTarget
			_directionToTarget = [_vehicle, _endPosition] call BIS_fnc_DirTo;
			
			 // Calculate the difference in angles
			_angleDifference = abs(_direction - _directionToTarget);
			
			// If the difference is greater than 90 degrees, rotate the vehicle 180 degrees
			if (_angleDifference > 90) then
			{
				_vehicle setDir (_direction + 180);
			};
			[format["Placed the %1 on the center of the road, facing the _endPosition (_angleDifference = %2)", _vehicle, _angleDifference], "DGCore_fnc_placeVehicleOnRoad", "debug"] call DGCore_fnc_log;
		};
	};
};