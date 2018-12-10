//Checks if sidemission in progress and exits else sets sidemission in progress and proceeds. 
if (salmon_sideMission) exitWith {
	["Side Mission", "ASSIGNED"] call BIS_fnc_taskHint;
};
salmon_sideMission = true; 

//Choose building.
_buildings = [
	"Land_Ind_Coltan_Main_EP1",
	"Land_Shed_Ind02"
];
_buildingList = [];
{
	_list = [worldSize / 2, worldSize / 2, 0] nearObjects [_x, worldSize];
	_buildingList append _list;
} foreach _buildings;
_building = selectRandom _buildingList;

//Start timer of 10 seconds. If building that's whole can't be found within time
//Mission aborts due to no IED factory existing.
_time = serverTime + 10;
while {damage _building > 0.1} do {
	if (serverTime >= _time + 10) exitWith {systemChat "Bad intel! No IED factories left."};
	_building = selectRandom _buildingList;
	sleep 0.1;
};
if (damage _building > 0.1) exitWith {};

//Start mission itself.
_pos = getPos _building;
[west,["Side Mission"],["Recent intel has revealed the location of a nearby IED factory. Destroy it by any means necessary.","Destroy IED Factory",_pos],_pos,true,2,true,"destroy",false] call BIS_fnc_taskCreate;

//Misison completed when building has been destroyed!
while {salmon_sideMission} do {
	sleep 10;
	if !(salmon_sideMission) then {
		["Side Mission", "CANCELED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
	};
	if (damage _building > 0.8) then {
		["Side Mission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
	};
};