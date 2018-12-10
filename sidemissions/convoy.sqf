//Checks if sidemission in progress and exits else sets sidemission in progress and proceeds. 
if (salmon_sideMission) exitWith {
	["Side Mission", "ASSIGNED"] call BIS_fnc_taskHint;
};
salmon_sideMission = true; 

//Pick start and end points.
_townList = nearestLocations [[worldSize / 2, worldsize / 2, 0], ["NameCity","NameCityCapital","NameVillage"], worldSize];
_town1 = selectRandom _townList;
_townList = _townList - [_town1];
_town2 = selectRandom _townList;
_start = [getPos _town1, 500] call BIS_fnc_nearestRoad;
_end = [getPos _town2, 500] call BIS_fnc_nearestRoad;

//Spawn vehicles and crew.
_group = createGroup [east, true];
_group setBehaviour "SAFE";
_group setSpeedMode "SLOW";
_vehicles = [];
_classes = [
	"LOP_ISTS_OPF_BTR60",
	"LOP_ISTS_OPF_M113_W",
	"LOP_ISTS_OPF_T34",
	"LOP_ISTS_OPF_ZSU234",
	"LOP_ISTS_OPF_T55",
	"LOP_ISTS_OPF_Landrover",
	"LOP_ISTS_OPF_Landrover_M2",
	"LOP_ISTS_OPF_Landrover_SPG9",
	"LOP_ISTS_OPF_Nissan_PKM",
	"LOP_AM_OPF_Landrover",
	"LOP_AM_OPF_Landrover_M2",
	"LOP_AM_OPF_Landrover_SPG9",
	"LOP_AM_OPF_Nissan_PKM",
	"LOP_AM_OPF_UAZ",
	"LOP_AM_OPF_UAZ_AGS",
	"LOP_AM_OPF_UAZ_Open",
	"LOP_AM_OPF_UAZ_SPG"
];
for "_i" from 1 to round random 6 do {
	_veh = createVehicle [selectRandom _classes, _start, [], 0, "NONE"];
	_vehicles pushBack _veh;
	createVehicleCrew _veh;
	_veh engineOn true;
	_dumGroup = group driver _veh;
	_veh forceFollowRoad true;
	{
		[_x] joinSilent _group;
	} forEach units _dumGroup;
};

//Create task. 
[west,["Side Mission"],["The enemy are moving a large number of vehicles, they will be leaving this area soon. Destination will be marked on your map shortly. Locate and destroy them.","Stop Convoy",getPos _town1],getPos _town1,true,2,true,"car",false] call BIS_fnc_taskCreate;

//Start convoy.
_group addWaypoint [_end, 0];
_sideMark = createMarker ["SideMark", getPos _town2];
_sideMark setMarkerShape "ICON";
_sideMark setMarkerColor "Default";
_sideMark setmarkertype "mil_end";
sleep 5;
_group setSpeedMode "NORMAL";

//Misison completed task has been completed!
while {salmon_sideMission} do {
	sleep 10;
    if !(salmon_sideMission) then {
		{
			deleteVehicle _x;
		} forEach units _group;
		{
			deleteVehicle _x;
		} forEach _vehicles;
		deleteMarker "SideMark";
		["Side Mission", "CANCELED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
    };
	if ({_x distance2d _end < 30} forEach _vehicles) then {
		["Side Mission", "FAILED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false;
		{
			deleteVehicle _x;
		} forEach units _group;
		{
			deleteVehicle _x;
		} forEach _vehicles;
		deleteMarker "SideMark";
    };
    if ({damage _x >0.8} forEach _vehicles) then {
		["Side Mission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
		deleteMarker "SideMark";
    };
};