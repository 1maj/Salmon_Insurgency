//Checks if sidemission in progress and exits else sets sidemission in progress and proceeds. 
if (salmon_sideMission) exitWith {
	["Side Mission", "ASSIGNED"] call BIS_fnc_taskHint;
};
salmon_sideMission = true; 

//Pick area.
_areaList = nearestLocations [[worldSize / 2, worldsize / 2, 0], ["Hill","Mount","NameLocal"], worldSize];
_area = selectRandom _areaList;
_pos = getPos _area;

//Create task. 
[west,["Side Mission"],["Patrol to this point.","Patrol",_pos],_pos,true,2,true,"walk",false] call BIS_fnc_taskCreate;

//Misison completed task has been completed!
while {salmon_sideMission} do {
	sleep 10;
    if !(salmon_sideMission) then {
		["Side Mission", "CANCELED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
    };
    if ({_x distance2D getPos _area < 25} forEach allPlayers) then {
		["Side Mission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
    };
};