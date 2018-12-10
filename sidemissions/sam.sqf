//Checks if sidemission in progress and exits else sets sidemission in progress and proceeds. 
if (salmon_sideMission) exitWith {
	["Side Mission", "ASSIGNED"] call BIS_fnc_taskHint;
};
salmon_sideMission = true; 

//Pick area.
_hillList = nearestLocations [[worldSize / 2, worldsize / 2, 0], ["Hill","Mount","NameLocal"], worldSize];
_hill = selectRandom _hillList;
_pos = getPos _hill;
_ePos = _pos isFlatEmpty [20, -1, 0.05, 5, 0, false, objNull]; 
while {count _ePos < 1} do { 
	_hill = selectRandom _hillList;
	_pos = getPos _hill;
	_ePos = _pos isFlatEmpty [20, -1, 0.05, 5, 0, false, objNull]; 
};
_rPos = [_ePos select 0, _ePos select 1, 0];

//Create SAM site.
_sams = [];
_group = createGroup [east, true];
for "_i" from 1 to 2 do {
	_sam = createVehicle ["LOP_ISTS_OPF_Igla_AA_pod", _rPos, [], 5, "NONE"];
	_sams pushBack _sam;
	_sam setDir random [100, 270, 360];
	createVehicleCrew _sam;
	[driver _sam] joinSilent _group;
};


//Create task. 
[west,["Side Mission"],["Enemy SAM site located near this area.","Sam Site",_pos],_pos,true,2,true,"target",false] call BIS_fnc_taskCreate;

//Misison completed task has been completed!
while {salmon_sideMission} do {
	sleep 10;
    if !(salmon_sideMission) then {
		["Side Mission", "CANCELED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
    };
    if ({alive _x} count _sams == 0) then {
		["Side Mission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
    };
};