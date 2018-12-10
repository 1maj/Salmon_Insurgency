//Checks if sidemission in progress and exits else sets sidemission in progress and proceeds. 
if (salmon_sideMission) exitWith {
	["Side Mission", "ASSIGNED"] call BIS_fnc_taskHint;
};
salmon_sideMission = true; 

//Pick area.
_townList = nearestLocations [[worldSize / 2, worldsize / 2, 0], ["NameCity","NameCityCapital","NameVillage","NameLocal"], worldSize];
_town = selectRandom _townList;

//Get random pos in town for grave.
_pos = _town call BIS_fnc_randomPosTrigger;

//Spawn mass grave.
_grave = createVehicle ["Mass_grave", [_pos select 0, _pos select 1, 0], [], 25, ""];

//Create task.
[west,["Side Mission"],["There's reports of war crimes being committed in this area. Move in and investigate.","Investigate Crimes",getPos _town],getPos _town,true,2,true,"search",false] call BIS_fnc_taskCreate;


while {salmon_sideMission} do {
	sleep 5;
    if !(salmon_sideMission) then {
		["Side Mission", "CANCELED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
    };
	if ({_x distance _grave < 10} forEach allPlayers) then {
		["Side Mission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
	};
};