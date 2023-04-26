# DGCore
Core functions for DagovaxGames Arma 3 Exile missions

This package is required for multiple DG missions, and its purpose is to have global functions that are being
used in those mission scripts.

## Installation

1. Download DGCore-main.zip and extract it to your documents.

2. Place the @DGCore folder and all its content into your server (same directory as @ExileServer).

3. Add the line `@DGCore` to your `-servermods=` launch parameter

4. Start your server

5. Check in your server logs if you see the message `"DGCore succesfully initialized!"`.

6. If you do not see that message, all other DG script will also fail. So contact me at the Discord.

## Example function calls
Defined below are ready-to-go functions that can be called anytime and that will perform a certain routine.

### Civilian Patrol
This function spawns a civilian in a random vehicle (or given) at a random position (or given) on the map. It will then move to a random `location` on the map. Once it reached his destination he will leave the vehicle and move into the nearest house where it despawns.

Parameters: _class, _pos

Default:
>```
> [] call DGCore_fnc_spawnCivilPatrol;
>```
This will spawn the routine with no parameters. `DGCore_config` entries will be used for random vehicle selection.

Optional 1:
>```
> ["B_Quadbike_01_F"] call DGCore_fnc_spawnCivilPatrol;
>```
Same as the default, but now the given vehicle class will be forced to spawn. 

Optional 2:
>```
> ["", [10500,6433,0]] call DGCore_fnc_spawnCivilPatrol;
>```
Same as the default, but now the spawn position will be forced. Array format [x, y, z]

Optional 3:
>```
> ["B_Quadbike_01_F", [10500,6433,0]] call DGCore_fnc_spawnCivilPatrol;
>```
`Optional 1` and `Optional 2` merged: now both vehicle class and spawn position will be forced.

### Civilian Plane
This function spawns a civilian plane at a random airport, and let it fly to another airport on the map. If there is only 1 airport, it will fly around first and land at that same airport. Once the plane landed and the pilot reached his destination he will leave the vehicle and move into the nearest house where it despawns.

Parameters: _class, _allowDamage

Default:
>```
> [] call DGCore_fnc_spawnCivilPlane;
>```
This will spawn the routine with no parameters. `DGCore_config` entries will be used for random plane selection. `_allowDamage` will be set to `false` in this case, meaning the plane can not be destroyed until it landed.

Optional 1:
>```
> ["C_Plane_Civil_01_F"] call DGCore_fnc_spawnCivilPlane;
>```
Same as the default, but now the given plane class will be forced to spawn. 

Optional 2:
>```
> ["", true] call DGCore_fnc_spawnCivilPlane;
>```
Same as the default, but now the spawned vehicle will be allowed to receive damage.

Optional 3:
>```
> ["C_Plane_Civil_01_F", true] call DGCore_fnc_spawnCivilPlane;
>```
`Optional 1` and `Optional 2` merged: now both plane class and allowDamage will be forced.

## Contact

Discord: https://discord.com/invite/JQHShny
