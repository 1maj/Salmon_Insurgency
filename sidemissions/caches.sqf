/*
	Author: Green.

	Description:
	Spawns weapon caches on the map.

	Example:
	spawn salmon_fnc_caches;
*/

_buildings = [worldSize / 2, worldsize / 2] nearObjects ["house" ,worldSize];
_caches = [
	"Box_IED_Exp_F",
	"Box_Syndicate_WpsLaunch_F"
];
for "_i" from 1 to 10 do {
	_building = selectRandom _buildings;
	_buildings = _buildings - [_building];
	_positions = [_building] call BIS_FNC_BuildingPositions;
	while {_positions isEqualTo [] || _building distance vArsenal < 1500} do {
		_building = selectRandom _buildings;
		_buildings = _buildings - [_building];
		_positions = [_building] call BIS_FNC_BuildingPositions;
	};
	_pos = selectRandom _positions;
	_cache = createVehicle [selectRandom _caches, _pos, [], 0, "NONE"];
	if (!isDedicated) then {
		_mrk = createMarker [str _building, _cache];
		_mrk setMarkerShape "ICON";
		_mrk setMarkerColor "colorRed";
		_mrk setMarkerType "hd_dot";
	};
};