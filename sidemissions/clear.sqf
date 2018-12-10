//Checks if sidemission in progress and exits else sets sidemission in progress and proceeds. 
if (salmon_sideMission) exitWith {
	["Side Mission", "ASSIGNED"] call BIS_fnc_taskHint;
};
salmon_sideMission = true; 

//Pick area.
_areaList = nearestLocations [[worldSize / 2, worldsize / 2, 0], ["NameCity","NameCityCapital","NameMarine","NameVillage","NameLocal"], worldSize];
_area = selectRandom _areaList;
_pos = getPos _area;


//Create Marker.
private ["_sizeX", "_sizeY"];
_sizeX = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (className _area) >> "radiusA");
_sizeY = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (className _area) >> "radiusB");
_sideMark = createMarker ["SideMark", _pos];
_sideMark setMarkerSize [_sizeX, _sizeY];
_sideMark setMarkerShape "ELLIPSE";
_sideMark setMarkerColor "ColorRed";
_sideMark setMarkerBrush "DiagGrid";

//Get all markers in area.
_markers = allMapMarkers select {(getMarkerPos _x) inArea _sideMark};

//Create task.
[west,["Side Mission"],["This area right here. This area is very important to me. I dropped my engagement ring flying over it this morning. I need you to clear it so I can send in a cleanup team to find my ring. I only have 2 weeks left on this rotation!","Clear Area",_pos],_pos,true,2,true,"attack",false] call BIS_fnc_taskCreate;

//Misison completed task has been completed!
while {salmon_sideMission} do {
	_colourList = [];
	{
		_colour = markerColor _x;
		_index = _colourList pushBack _colour;
	} count _markers;
	sleep 10;
    if !(salmon_sideMission) then {
		["Side Mission", "CANCELED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
		deleteMarker "sideMark";
    };
    if !("colorRed" in _colourList) then {
		["Side Mission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		sleep 4;
        ["Side Mission",true] call BIS_fnc_deleteTask;
        salmon_sideMission= false; 
		deleteMarker "sideMark";
    };
};