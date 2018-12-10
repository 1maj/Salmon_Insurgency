/*
TODO:
Add escort.
add more shit.
Make AI stop if shot at (cool helo ffv on vehicle will make it stop).
*/

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
/*
_group setBehaviour "SAFE";
_group setSpeedMode "SLOW";
_classes = [
	"LOP_AM_OPF_Landrover_M2",
	"LOP_AM_OPF_Nissan_PKM"
];
_escort = createVehicle [selectRandom _classes, _start, [], 0, "NONE"];
createVehicleCrew _escort;
_escort engineOn true;
_dGroup = group driver _escort;
_escort forceFollowRoad true;
{
	[_x] joinSilent _group;
} forEach units _dGroup;
*/
_veh = createVehicle ["C_Van_02_transport_F", _start, [], 0, "NONE"];
_driver = _group createUnit ["LOP_AM_OPF_Infantry_SL", _start, [], 0, "NONE"];
_driver moveInDriver _veh;
_vGroup = createGroup [east, true];
_vip = _vGroup createUnit ["LOP_Tak_Civ_Random", _start, [], 0, "NONE"];
_vip moveInCargo _veh;

//Create task. 
[west,["Side Mission"],["HVT moving in vehicle from this location shortly. Take him alive!","Grab HVT",getPos _town1],getPos _town1,true,2,true,"car",false] call BIS_fnc_taskCreate;

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
	sleep 5;
    if !(salmon_sideMission) then {
		deleteMarker "SideMark";
		["Side Mission", "CANCELED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
    };
    if (vehicle _vip == _veh && !alive driver _veh) then {
		unassignVehicle _vip;
		_vip action ["GetOut", _veh];
    };
	if ({_x distance _vip < 15} forEach allPlayers) then {
			[_vip, true] call ace_captives_fnc_setSurrendered;
	};
	if (_vip distance2d _end < 30 or !alive _vip) then {
		["Side Mission", "FAILED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false;
		deleteMarker "SideMark";
		deleteVehicle _hvt;
		deleteVehicle _veh;
    };
    if (_vip inArea "SafeZone") then {
		["Side Mission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
		deleteMarker "SideMark";
    };
};