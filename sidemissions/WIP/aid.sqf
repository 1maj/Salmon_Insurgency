/*FUCKING ANNOYING SHIT YO*/

_townList = nearestLocations [[worldSize / 2, worldsize / 2, 0], ["NameCity","NameCityCapital","NameVillage","NameLocal"], worldSize];
_town = selectRandom _townList;
_pos = getPos _town;
_civList = [
"C_journalist_F",
"C_Journalist_01_War_F",
"C_Man_Messenger_01_F",
"C_Man_Fisherman_01_F"
];
_civType = selectRandom _civList;
_civ = createVehicle [_civType, _pos, [], 50, ""];
[_civ, "Acts_CivilInjuredGeneral_1"] remoteExec ["switchMove", 0];
_trigger = createTrigger ["EmptyDetector",_civ];
_trigger setTriggerArea[5,5,0,false];
_trigger setTriggerActivation["WEST","PRESENT",false];
_trigger setTriggerStatements["this", "_civ joinSilent (thisList select 0); [_civ, ''] remoteExec ['switchMove', 0];", ""];
_trigger attachTo [_civ];

//Make mission with info about IED
[west,["Side Mission"],["Some stupid civilian thought it was a good idea to venture into a war zone. He's somewhere in this area. Go save him! (Mission is done when civilian is in base, alternatively fail if he dies)","Rescue Civie",_pos],_pos,true,2,true,"search",false] call BIS_fnc_taskCreate;

_sideMission = true;
_civDam = false;
while {_sideMission} do { 
	Sleep 5;
	if (!alive _civ) then {
		[_civ, ""] remoteExec ["switchMove", 0];
		systemChat "Side Mission failed!";
		["Side Mission",true] call BIS_fnc_deleteTask;
		deletevehicle _trigger;
		_sideMission = false;
	};
	if 	([_civ, "safeZone"] call CBA_fnc_inArea) then {
		systemChat "Side Mission complete! Civilian has been rescued";
		["Side Mission",true] call BIS_fnc_deleteTask;
		deletevehicle _trigger;
		_sideMission = false;
	};
	if (!_civDam && {_x distance _civ < 3000;} forEach allPlayers) then {
		_leg = selectRandom ["leg_l","leg_r"];
		_civ setDamage 0.4;
		[_civ] call ace_medical_fnc_handleDamage_advancedSetDamage;
		_civDam = true;
	};
};

if (true) exitWith {};

{
	_dist = _x distance _civ;
	
} forEach allPlayers;