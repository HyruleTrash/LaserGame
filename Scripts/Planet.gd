extends KinematicBody


export var Mass : float = 1;
var GravPulls : Array;
var CollisionRadius : float = 1;
var MinGravDistance : float = 1;
var motion : Vector3;
var MouseON = false;
export var LockingState : int = 0;

var allowedLocks4Click = [0, 1]

func _physics_process(_delta):
	motion *= 0.9;
	motion = move_and_slide(motion, Vector3.UP, true);
	if (!allowedLocks4Click.has(LockingState)):
		motion = Vector3.ZERO;
	$Lock.frame = LockingState;
	if (Input.is_action_just_pressed("Click") && MouseON == true):
		get_node("../PlayerSystem").changeSelected(self);

func GravMove():
	if LockingState != 3:
		for i in GravPulls.size():
			if !test_move(self.transform, GravPulls[i]):
				motion += GravPulls[i];
			else:
				motion -= GravPulls[i];
	GravPulls.clear();


func _on_Planet_mouse_entered():
	MouseON = true;

func _on_Planet_mouse_exited():
	MouseON = false
