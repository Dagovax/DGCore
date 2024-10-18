/*
    DGCore_fnc_rotationToVector

    Purpose: Convert a yaw rotation (Z-axis rotation) in degrees into a forward direction vector.

    Example: _vectorDir = [38.582] call DGCore_fnc_rotationToVector;

    Input: Yaw rotation in degrees (rotation around Z-axis).
    Output: A vector [x, y, z] that represents the forward direction.
*/

params ["_yaw"];  // Yaw rotation (Z-axis rotation) in degrees

// Calculate the X and Y components of the direction vector
// Adjust to account for Arma's coordinate system (0° = North on the Y-axis)
private _vectorX = sin _yaw;  // Yaw affects X based on sin
private _vectorY = cos _yaw;  // Yaw affects Y based on cos
private _vectorZ = 0;  // Z is zero for a 2D rotation in the XY plane

// Create the resulting vector
private _vectorDir = [_vectorX, _vectorY, _vectorZ];

_vectorDir;  // Return the vector
