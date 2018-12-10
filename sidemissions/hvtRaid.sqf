//Checks if sidemission in progress and exits else sets sidemission in progress and proceeds. 
if (salmon_sideMission) exitWith {
	["Side Mission", "ASSIGNED"] call BIS_fnc_taskHint;
};
salmon_sideMission = true; 

//Pick building.
_buildings = [];
_buildingList = [
	"Land_House_C_11_EP1",
	"Land_House_C_11_dam_EP1",
	"Land_House_C_10_dam_EP1",
	"Land_House_C_10_EP1",
	"Land_A_Office01_EP1",
	"Land_House_C_4_EP1",
	"Land_House_C_4_dam_EP1"
];
{
	_list = [worldSize / 2, worldsize / 2, 0] nearObjects [_x, worldSize];
	_buildings append _list;
} forEach _buildingList;
_building = selectRandom _buildings;

//Make enemy group.
_group = createGroup [east, true];
_group setBehaviour "SAFE";
_group setSpeedMode "Limited";

//Spawn HVT.
_hvt = _group createUnit ["LOP_AM_OPF_Infantry_SL", _building, [], 0, "NONE"];

//Spawn guards.
_guardList = [
	"LOP_AM_OPF_Infantry_GL",
	"LOP_AM_OPF_Infantry_Rifleman_6",
	"LOP_AM_OPF_Infantry_Rifleman",
	"LOP_AM_OPF_Infantry_Rifleman_2",
	"LOP_AM_OPF_Infantry_Rifleman_4",
	"LOP_AM_OPF_Infantry_Rifleman_5"
];
{
	_guard = _group createUnit [selectRandom _guardList, getPos _building, [], 0, "NONE"];
} count _guardList;

//List enemies.
_enemies = [];
{
	_index = _enemies pushBack _x;
} forEach units _group;
/*

_guardSpots = [_building] call BIS_fnc_buildingPositions;
{
	_guard = _group createUnit [selectRandom _guardList, _x, [], 0, "NONE"];
	_index = _guards pushBack _guard;
} count _guardSpots;
*/

//Move units into position. 
_nul = [getPos _building,_enemies,14,0,[0,15],true,true] execvm "scripts\missions\shk_buildingpos.sqf";

//Add task.
[west,["Side Mission"],["Intel suggest a local warlord is held up in a building located here. Move in and neutralise the man.","HVT Raid",getpos _building],getpos _building,true,2,true,"kill",false] call BIS_fnc_taskCreate;

while {salmon_sideMission} do {
	sleep 10;
	if !(salmon_sideMission) then {
		["Side Mission", "CANCELED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
	};
	if (!alive _hvt || isNil _hvt) then {
		["Side Mission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
	};
};