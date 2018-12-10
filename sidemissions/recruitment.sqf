//Checks if sidemission in progress and exits else sets sidemission in progress and proceeds. 
if (salmon_sideMission) exitWith {
	["Side Mission", "ASSIGNED"] call BIS_fnc_taskHint;
};
salmon_sideMission = true; 

//Pick building.
_buildings = [];
_buildingList = [
	"Land_A_Mosque_big_hq_EP1",
	"Land_A_Mosque_big_addon_EP1",
	"Land_A_Mosque_small_1_EP1",
	"Land_A_Mosque_small_1_dam_EP1",
	"Land_A_Mosque_small_2_EP1",
	"Land_A_Mosque_small_2_dam_EP1"
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

//Spawn enemies.
_guardList = [
	"LOP_AM_OPF_Infantry_GL",
	"LOP_AM_OPF_Infantry_Rifleman_6",
	"LOP_AM_OPF_Infantry_Rifleman",
	"LOP_AM_OPF_Infantry_Rifleman_2",
	"LOP_AM_OPF_Infantry_Rifleman_4",
	"LOP_AM_OPF_Infantry_Rifleman_5"
];
for "_i" from 1 to 3+(round random 6) do {
	_guard = _group createUnit [selectRandom _guardList, getPos _building, [], 0, "NONE"];
};

//Move units into position. 
_nul = [getPos _building,units _group,14,0,[0,15],true,true] execvm "scripts\missions\shk_buildingpos.sqf";

//Add task.
[west,["Side Mission"],["Extremists are running recruitment in this area. Stop them.","Extremists",getpos _building],getpos _building,true,2,true,"kill",false] call BIS_fnc_taskCreate;

while {salmon_sideMission} do {
	sleep 10;
	if !(salmon_sideMission) then {
		["Side Mission", "CANCELED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
	};
	if ({alive _x} count units _group == 0) then {
		["Side Mission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
	};
};