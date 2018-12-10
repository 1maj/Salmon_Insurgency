//Checks if sidemission in progress and exits else sets sidemission in progress and proceeds. 
if (salmon_sideMission) exitWith {
	["Side Mission", "ASSIGNED"] call BIS_fnc_taskHint;
};
salmon_sideMission = true; 
_missionGiven = false;

//Pick building.
_buildings = [];
_buildingList = [
	"Land_House_K_7_dam_EP1",
	"Land_House_K_7_EP1",
	"Land_House_K_3_dam_EP1",
	"Land_House_K_3_EP1",
	"Land_House_K_6_dam_EP1",
	"Land_House_K_6_EP1",
	"Land_House_K_8_dam_EP1",
	"Land_House_K_8_EP1"
];
{
	_list = [worldSize / 2, worldsize / 2, 0] nearObjects [_x, worldSize];
	_buildings append _list;
} forEach _buildingList;
_building = selectRandom _buildings;

//Make enemy group.
_group = createGroup [civilian, true];
_group setBehaviour "SAFE";
_group setSpeedMode "Limited";

//Spawn HVT.
_contact = _group createUnit ["LOP_Tak_Civ_Random", _building, [], 0, "NONE"];

//Move units into position. 
_nul = [getPos _building,[_contact],14,0,[0,15],true,true] execvm "scripts\missions\shk_buildingpos.sqf";


//Select side mission he'll give you.
_nMission = selectRandom [
	["extremistRecruitment", "Religious leaders are using this mosque to recruit new memebers to the jihad."],
	["hvtRaid", "A local elder, loyal to the insurgents, is held up in this compound."],
	["ied", "I'm worried. There's an IED somewhere in this area!"],
	["iedFactory", "The insurgents are using this building to create makeshift explosives!"],
	["investigate", "I've heard of terrible crimes being committed in this area."],
	["scud", "The insurgents raided the old bunker yesterday. I saw a missile located here."],
	["sam", "I overheard insurgents speaking of a missile site here."],
	["vip", "Omar, the taxi driver, was told to drive a local warlord but refused. He's leaving this area soon."]
];
//Add task.
[west,["Side Mission"],["A local man has reached out for us to meet him at his home. Go talk to him.","Local Contact",getpos _building],getpos _building,true,2,true,"meet",false] call BIS_fnc_taskCreate;

while {salmon_sideMission} do {
	sleep 10;
	if !(salmon_sideMission) then {
		["Side Mission", "CANCELED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
		deleteVehicle _contact;
	};
	if (!alive _contact) then {
		["Side Mission", "FAILED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false;
    };
	if (alive _contact && {_x distance _contact < 5} forEach allPlayers) then {
		format["%1", _nMission select 1] remoteExec ["hint"];
		_missionGiven = true;
		["Side Mission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false;
	};	
};
if (_missionGiven) then {
	execVM (["scripts\missions\", _nMission select 0, ".sqf"] joinString "");
};