/*
TODO:
Make scud find random town, face it, target it, shoot taht shit
more detailed scud area
multiplae scuds
random aa
*/

//Checks if sidemission in progress and exits else sets sidemission in progress and proceeds. 
if (salmon_sideMission) exitWith {
	if !(isNil "task05") then {
		["Side Mission", "ASSIGNED"] call BIS_fnc_taskHint;
	};
};
salmon_sideMission = true; 

//Select location. 
_pos = [] call BIS_fnc_randomPos; 
_nPos = _pos isFlatEmpty [20, -1, 0.1, 15, 0, false, objNull]; 
while {count _nPos < 1} do { 
	_pos = [] call BIS_fnc_randomPos; 
	_nPos = _pos isFlatEmpty [20, -1, 0.1, 15, 0, false, objNull]; 
	if (_nPos isEqualTo []) then {} else { 
		if (_nPos distance vArsenal < 1500) then { 
			_nPos = []; 
		}; 
	}; 
};
_rPos = [_nPos select 0, _nPos select 1, 0];

//Create scud missile. 
_scud = createVehicle ["rhs_9k79", _rPos, [], 0, "NONE"];
_scud setPos getPos _scud;
_scud engineOn true; 
_sGroup = createGroup [east, true];
_gunner = _sGroup createUnit ["LOP_ISTS_OPF_Infantry_Rifleman_5", _rPos, [], 0, "NONE"];
_gunner moveInGunner _scud; 
_target = _scud getRelPos [3000, 0];

//Create AAA battery.
_aaaList = [
	"LOP_ISTS_OPF_Igla_AA_pod",
	"LOP_ISTS_OPF_Static_ZU23",
	"LOP_ISTS_OPF_ZSU234"
];
_aaa = createVehicle [selectRandom _aaaList, getPos _scud, [], 40, "NONE"];
createVehicleCrew _aaa;
_aaa engineOn true; 
_aGroup = group driver _aaa;
_aaa setDir random [100, 270, 360];

//Create guards.
_gGroup = createGroup [east, true];
_guardList = [
	"LOP_AM_OPF_Infantry_GL",
	"LOP_AM_OPF_Infantry_Rifleman_6",
	"LOP_AM_OPF_Infantry_Rifleman",
	"LOP_AM_OPF_Infantry_Rifleman_2",
	"LOP_AM_OPF_Infantry_Rifleman_4",
	"LOP_AM_OPF_Infantry_Rifleman_5"
];
for "_i" from 1 to 10 do {
	_guard = _gGroup createUnit [selectRandom _guardList, _rPos, [], 5, "NONE"];
};
_gGroup addWaypoint [getPos _scud, 0];
createGuardedPoint [east, [0,0], -1, _scud];
[_gGroup, 0] setWaypointType "GUARD";

//Create task. 
[west,["Side Mission"],["The enemy has gotten their hands on a scud missile. It's located somewhere around here. Destroy it, quick!","Scud Missile",_pos],_pos,true,2,true,"target",false] call BIS_fnc_taskCreate;

//Misison completed task has been completed!
while {salmon_sideMission} do {
	sleep 10;
    if !(salmon_sideMission) then {
		["Side Mission", "CANCELED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
		deleteVehicle _gunner;
		{
			deleteVehicle _x;
		} forEach units _aGroup + units _gGroup;
		deleteVehicle _aaa;
		deleteVehicle _scud;
    };
	if ({_gunner knowsAbout _x >= 2.5} forEach allPlayers) then {
		[_scud,1] spawn rhs_fnc_ss21_AI_prepare;
		[_scud, _target]spawn rhs_fnc_ss21_AI_launch;
	};
	if (magazinesAmmo _scud isEqualTo []) then {
		["Side Mission", "FAILED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
    };
    if (!alive _scud && salmon_sideMission) then {
		["Side Mission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
    };
};