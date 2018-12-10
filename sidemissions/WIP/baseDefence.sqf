//Checks if sidemission in progress and exits else sets sidemission in progress and proceeds. 
if (salmon_sideMission) exitWith {
	["Side Mission", "ASSIGNED"] call BIS_fnc_taskHint;
};
salmon_sideMission = true; 

/*
//Create enemy groups.
_techieGroup = createGroup [east, true];
_tankGroup = createGroup [east, true];
_tankGroup setSpeedMode "LIMITED";
_infGroup = createGroup [east, true];
_sGroup = createGroup [east, true];
_sGroup setBehaviour "CARELESS";
{
	_x setSpeedMode "FULL";
} forEach [_sGroup, _infGroup];

_sGroup setSpeedMode "FULL";
{
	[_x, 0] setWaypointCombatMode "RED";
} forEach [_techieGroup, _tankGroup, _infGroup, _sGroup];

//Pick where they spawn.
_spawnPoint = vArsenal getRelPos [2500, random 360];
_gSpawnPoint = vArsenal getRelPos [1500, random 360];

//Create tank.
_tankList = [
	"LOP_ISTS_OPF_BMP1",
	"LOP_ISTS_OPF_BMP2",
	"LOP_ISTS_OPF_BTR60",
	"LOP_ISTS_OPF_M113_W",
	"LOP_ISTS_OPF_T34",
	"LOP_ISTS_OPF_T55",
	"LOP_ISTS_OPF_T72BA",
	"LOP_ISTS_OPF_ZSU234"
];
for "_i" from 1 to 1 + round random 2 do {
	_tank = createVehicle [selectRandom _tankList, _spawnPoint, [], 100, "NONE"];
	createVehicleCrew _tank;
	_dGroup = group driver _tank;
	{
		[_x] joinSilent _tankGroup;
	} forEach units _dGroup;
};

//Create techie.
_techieList = [
	"LOP_ISTS_OPF_Landrover_M2",
	"LOP_ISTS_OPF_Landrover_SPG9",
	"LOP_ISTS_OPF_M1025_W_M2",
	"LOP_ISTS_OPF_M1025_W_Mk19",
	"LOP_ISTS_OPF_Nissan_PKM",
	"LOP_AM_OPF_Landrover_M2",
	"LOP_AM_OPF_Landrover_SPG9",
	"LOP_AM_OPF_Nissan_PKM",
	"LOP_AM_OPF_UAZ_AGS",
	"LOP_AM_OPF_UAZ_DshKM",
	"LOP_AM_OPF_UAZ_SPG"
];
for "_i" from 1 to 1 + round random 3 do {
	_techie = createVehicle [selectRandom _techieList, _spawnPoint, [], 100, "NONE"];
	createVehicleCrew _techie;
	_dGroup = group driver _techie;
	{
		[_x] joinSilent _techieGroup;
	} forEach units _dGroup;
};

//Create infantry.
_infList = [
	"LOP_ISTS_OPF_Infantry_SL",
	"LOP_ISTS_OPF_Infantry_AR_Asst",
	"LOP_ISTS_OPF_Infantry_AR",
	"LOP_ISTS_OPF_Infantry_AT",
	"LOP_ISTS_OPF_Infantry_Marksman",
	"LOP_ISTS_OPF_Infantry_Rifleman_3",
	"LOP_ISTS_OPF_Infantry_Rifleman_2",
	"LOP_ISTS_OPF_Infantry_Rifleman_4",
	"LOP_ISTS_OPF_Infantry_Rifleman",
	"LOP_ISTS_OPF_Infantry_Rifleman_6",
	"LOP_ISTS_OPF_Infantry_GL",
	"LOP_ISTS_OPF_Infantry_Rifleman_5",
	"LOP_ISTS_OPF_Infantry_TL",
	"LOP_ISTS_OPF_Infantry_Corpsman",
	"LOP_ISTS_OPF_Infantry_Engineer",
	"LOP_AM_OPF_Infantry_Engineer",
	"LOP_AM_OPF_Infantry_Corpsman",
	"LOP_AM_OPF_Infantry_GL",
	"LOP_AM_OPF_Infantry_Rifleman_6",
	"LOP_AM_OPF_Infantry_Rifleman",
	"LOP_AM_OPF_Infantry_Rifleman_2",
	"LOP_AM_OPF_Infantry_Rifleman_4",
	"LOP_AM_OPF_Infantry_Rifleman_5",
	"LOP_AM_OPF_Infantry_Rifleman_3",
	"LOP_AM_OPF_Infantry_AT",
	"LOP_AM_OPF_Infantry_Marksman",
	"LOP_AM_OPF_Infantry_AR",
	"LOP_AM_OPF_Infantry_AR_Asst",
	"LOP_AM_OPF_Infantry_SL"
];
for "_i" from 1 to 15 + round random 20 do {
	_infGroup createUnit [selectRandom _infList, _gSpawnPoint, [], 50, "FORM"];
};

//Create Suicide bomber.
for "_i" from 1 to 2 + round random 5 do {
	_suicider = _sGroup createUnit ["LOP_Tak_Civ_Random", _gSpawnPoint, [], 50, "NONE"];
	_suicider addEventHandler ["killed", "'R_MRAAWS_HE_F' createVehicle (getPos (_this select 0))"]
};

//Create waypoints.
{
	_x addWaypoint [SF_House, 50, 1];
} forEach [_sGroup, _infGroup, _tankGroup, _techieGroup];
*/
null=[["base_defence"],[4,2],[1,1],[1],[0,0],[0,0,500,OPFOR,TRUE,FALSE],[30, 3, 60, FALSE, FALSE]] call Bastion_Spawn;

//Create task. 
[west,["Side Mission"],["THE BASE IS UNDER ATTACK!","Defend Base",getPos vArsenal],getPos vArsenal,true,2,true,"defend",false] call BIS_fnc_taskCreate;

//Misison completed task has been completed!
while {salmon_sideMission} do {
	sleep 2;
    if !(salmon_sideMission) then {
		["Side Mission", "CANCELED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
    };
	if ({_x distance ({_x} forEach units west) < 10} forEach units _sGroup) then {
		
	if (false) then {
		["Side Mission", "FAILED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
    };
    if (false) then {
		["Side Mission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
    };
};