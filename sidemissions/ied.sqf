//Checks if sidemission in progress and exits else sets sidemission in progress and proceeds. 
if (salmon_sideMission) exitWith {
	["Side Mission", "ASSIGNED"] call BIS_fnc_taskHint;
};
salmon_sideMission = true; 
private ["_iedPos"];

// IEDs
_iedList =
[
	"ACE_IEDLandBig_Range_Ammo", 
	"ACE_IEDLandSmall_Range_Ammo",
	"ACE_IEDUrbanBig_Range_Ammo",
	"ACE_IEDUrbanSmall_Range_Ammo",
	"ACE_IEDLandBig_Range_Ammo", 
	"ACE_IEDLandSmall_Range_Ammo",
	"ACE_IEDUrbanBig_Range_Ammo",
	"ACE_IEDUrbanSmall_Range_Ammo"
];
// Fakies
_fakieList =
[
	"Land_Garbage_square3_F", 
	"Land_Garbage_square5_F",
	"Land_Garbage_Line_F",
	"Land_Tyre_F"
];

//Pick street/market IED.
if (true) then {
//Chose road.
_list = [worldSize / 2, worldsize / 2, 0] nearRoads worldSize;
_road = selectRandom _list;
_dir = getDir _road;
_pos = getpos _road;
_posx = _pos select 0;
_posy = _pos select 1;
_tx = (_posx + (5.75 * sin(_dir)));
_ty = (_posy + (5.75 * cos(_dir)));
_iedPos = [_tx,_ty,0];
} else {
//Choose market.
_markets = [
	"Land_Market_stalls_01_EP1",
	"Land_Market_stalls_02_EP1",
	"Land_Market_shelter_EP1",
	"Land_Misc_Garb_Heap_EP1",
	"Land_Misc_Garb_3_EP1",
	"Land_Misc_Garb_4_EP1",
	"Land_Misc_Garb_Square_EP1",
	"Misc_TyreHeapEP1"
];
_marketList = [];
{
	_list = [worldSize / 2, worldSize / 2, 0] nearObjects [_x, worldSize];
	_marketList append _list;
} foreach _markets;
_market = selectRandom _marketList;
_iedPos = [[[getPos _market, 12]],[]] call BIS_fnc_randomPos;
};

//Create IED
_iedType = selectRandom _iedList;
_ied = createVehicle [_iedType, _iedPos, [], 0, ""];
_ied setDir (random 360);
_ied setPos getPos _ied;
	
//Reveal IED to the enemy and Civies
civilian revealMine _ied;
east revealMine _ied;
independent revealMine _ied;

//Adds some concealemnt to the IED
_fakieType = selectRandom _fakieList;
_fakie = createVehicle [_fakieType, getpos _ied, [], 0, ""];
_fakie setDir (random 360);
_fakie setPos getPosATL _fakie;

_sideMark = createMarker ["SideMark", _ied];
_sideMark setMarkerShape "ELLIPSE";
_sideMark setMarkerColor "ColorRed";
_sideMark setMarkerSize [50, 50];
_sideMark setMarkerBrush "DiagGrid";
_newMarkPos = _sideMark call BIS_fnc_randomPosTrigger;
"SideMark" setMarkerPos _newMarkPos;
_sideMark setMarkerSize [125, 125];

//Create Task.
[west,["Side Mission"],["There's an IED somewhere in this area. Neutralise it by any means possible.","Neutralise IED",_sideMark],_sideMark,true,2,true,"mine",false] call BIS_fnc_taskCreate;

//Remove IED in safezone
if ([_ied, "safeZone"] call CBA_fnc_inArea) then
{
deleteVehicle _ied;
deleteVehicle _fakie;
};

while {salmon_sideMission} do {
	sleep 10;
	if !(salmon_sideMission) then {
		deleteMarker _sideMark;
		["Side Mission", "CANCELED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
	};
	if (!alive _ied || isNil _ied) then {
		deleteMarker _sideMark;
		["Side Mission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
	};
};