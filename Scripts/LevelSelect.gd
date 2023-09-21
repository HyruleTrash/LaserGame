extends Control

onready var Item = preload("res://Scenes/LevelSelectLevelItemUI.tscn")
var Levels
var BannedLevels = [0, 1];

func _ready():
	Levels = get_node("../").Levels;
	for i in Levels.size():
		if (!BannedLevels.has(i)):
			var temp = Item.instance();
			var temp2 = Levels[i].instance();
			temp.get_node("Button").text = temp2.name;
			temp.get_node("Button").connect("pressed", self, "_on_Button_pressed", [temp.get_node("Button").text]);
			$VBoxContainer.add_child(temp);

func _on_Button_pressed(var extra_arg_0 : String):
	for i in Levels.size():
		var temp2 = Levels[i].instance();
		if (!BannedLevels.has(i) && temp2.name == extra_arg_0):
			get_node("../").LoadLevel(i, 1);
