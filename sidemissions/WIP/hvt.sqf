//Checks if sidemission in progress and exits else sets sidemission in progress and proceeds. 
if (salmon_sideMission) exitWith {};
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
_hvt = _group createUnit ["LOP_TKA_Infantry_Officer", getpos _building, [], 0, "NONE"];

//Add task.
[west,["Side Mission"],["Intel suggest a local warlord is held up in a building located here. Move in and neutralise the man.","HVT Raid",getpos _building],getpos _building,true,2,true,"kill",false] call BIS_fnc_taskCreate;

while {salmon_sideMission} do {
	sleep 10;
	if !(salmon_sideMission) then {
		["Side Mission",true] call BIS_fnc_deleteTask;
	};
	if (!alive _hvt) then {
		systemChat "HVT KILLED NIGGA";
		["Side Mission",true] call BIS_fnc_deleteTask;
		salmon_sideMission	= false; 
	};
};