extends Node

export var Levels : Array;
export var StartLevel : int = 0;
var Sounds : Array;

func LoadLevel(var i : int, var soundID : int):
	if soundID < Sounds.size() && soundID >= 0:
		Sounds[soundID].play()
	for j in self.get_child_count():
		self.remove_child(get_child(j));
	self.add_child(Levels[i].instance());

func _ready():
	Sounds.push_back(get_node("../Select"));
	Sounds.push_back(get_node("../StartLevel"));
	Sounds.push_back(get_node("../EndLevel"));
	LoadLevel(StartLevel, -1);

func PlaySound(var soundID : int):
	if soundID < Sounds.size() && soundID >= 0:
		Sounds[soundID].play()
