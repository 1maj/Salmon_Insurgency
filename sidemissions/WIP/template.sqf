//Checks if sidemission in progress and exits else sets sidemission in progress and proceeds. 
if (salmon_sideMission) exitWith {
	["Side Mission", "ASSIGNED"] call BIS_fnc_taskHint;
};
salmon_sideMission = true; 

###############
#!!!MISSION!!!#
###############
//Create task. 
[west,["Side Mission"],["INFO","NAME",_sideMark],_sideMark,true,2,true,"mine",false] call BIS_fnc_taskCreate;

//Misison completed task has been completed!
while {salmon_sideMission} do {
	sleep 10;
    if !(salmon_sideMission) then {
		["Side Mission", "CANCELED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
    };
	if (<Mission Failed>) then {
		["Side Mission", "FAILED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
    };
    if (<Mission Done>) then {
		["Side Mission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
    };
};