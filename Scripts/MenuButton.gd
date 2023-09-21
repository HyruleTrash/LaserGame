extends Control

export var Scenemanagerdistance = "../../../../"

func _on_Button_pressed():
	get_node(Scenemanagerdistance).LoadLevel(0, 0);

func _input(event):
	if event.is_action_pressed("quit"):
		get_node("../../").LoadLevel(0);
