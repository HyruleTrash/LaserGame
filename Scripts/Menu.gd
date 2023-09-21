extends Control



func _on_Button_pressed():
	get_node("../").LoadLevel(1, 0)


func _on_Button2_pressed():
	get_node("../").PlaySound(0);
	get_tree().quit();

func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit();
