/*
    DGCore_fnc_vectorToRotation

    Purpose: Convert a vector direction to yaw (Z-axis rotation) in degrees.

    Example: _yaw = [[0.623635, 0.781715, 0]] call DGCore_fnc_vectorToRotation;

    Input: Vector [x, y, z].
    Output: Yaw rotation in degrees (rotation around Z-axis).
*/

params ["_vector"];  // Input vector [x, y, z]

// Extract the X and Y components of the vector
private _vectorX = _vector select 0;
private _vectorY = _vector select 1;

// Convert yaw from radians to degrees
private _yawDegrees = _vectorX atan2 _vectorY;

// Normalize the yaw to be between 0 and 360 degrees
if (_yawDegrees > 360) then {
    _yawDegrees = _yawDegrees - 360;
};
if (_yawDegrees < -360) then {
    _yawDegrees = _yawDegrees + 360;
};

_yawDegrees;  // Return the yaw rotation in degrees
