/*
TODO:
Check if pilots, tank crew etc online and adjust side missions.
IE: if (tanker on) then {_missions = _missions + _tank};
Optimise.
Ability to turn on/off loop midgame.
*/
salmon_sideMission = false; 
_missions = [
	"hvtRaid",
	"convoy",
	"vip",
	"sam",
	"ied",
	"iedFactory",
	"investigate",
	"scud",
	"meet",
	"recruitment",
	"meeting",
	"clear"
];
while {true} do {
	sleep 900;
	execVM (["scripts\missions\", selectRandom _missions, ".sqf"] joinString "");
};