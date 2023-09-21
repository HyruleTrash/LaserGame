extends Node2D

export var TurnSpeed = 3;
export var MoveSpeed = 4;
export var MouseSpeed = 2;
var Selected : Object = null;

func _physics_process(delta):
	if Selected != null:
		if Input.is_action_just_pressed("AltClick") && Selected.LockingState == 0:
			Selected.get_node("SelectionIcon").frame = int(!bool(Selected.get_node("SelectionIcon").frame));
		if Selected.get_node("SelectionIcon").frame == 0 && [0, 1].has(Selected.LockingState):
			if Input.is_action_pressed("Left"):
				Selected.rotation.y += TurnSpeed * delta;
			if Input.is_action_pressed("Right"):
				Selected.rotation.y -= TurnSpeed * delta;
		elif Selected.get_node("SelectionIcon").frame == 1 && Selected.LockingState == 0:
			if Input.is_action_pressed("Left"):
				Selected.translation.x -= MoveSpeed * delta;
			if Input.is_action_pressed("Right"):
				Selected.translation.x += MoveSpeed * delta;
			if Input.is_action_pressed("Up"):
				Selected.translation.z -= MoveSpeed * delta;
			if Input.is_action_pressed("Down"):
				Selected.translation.z += MoveSpeed * delta;
	if Input.is_action_pressed("ControllerAxisUP"):
		Input.warp_mouse_position(get_global_mouse_position() + (MouseSpeed * Input.get_joy_axis(0,2)))
	if Input.is_action_pressed("ControllerAxisDOWN"):
		Input.warp_mouse_position(get_global_mouse_position() + (MouseSpeed * Input.get_joy_axis(0,2)))
	if Input.is_action_pressed("ControllerAxisLEFT"):
		Input.warp_mouse_position(get_global_mouse_position() + (MouseSpeed * Input.get_joy_axis(0,3)))
	if Input.is_action_pressed("ControllerAxisRIGHT"):
		Input.warp_mouse_position(get_global_mouse_position() + (MouseSpeed * Input.get_joy_axis(0,3)))


func changeSelected(var NewSelection : Object):
	if Selected != null:
		Selected.get_node("SelectionIcon").visible = false;
	NewSelection.get_node("SelectionIcon").visible = true;
	Selected = NewSelection;
