extends KinematicBody


export var Mass : float = 1;
var GravPulls : Array;
var CollisionRadius : float = 1;
var MinGravDistance : float = 1;
var motion : Vector3;
var collisionPoint = null;
var OtherlaserDir = null;
export var LockingState : int = 0;

export var activated : bool = false
var oldActivated = false

var MouseON = false;

var allowedLocks4Click = [0, 1]

func _ready():
	get_node("../WinConditionHandler").AmountOfRecievers += 1;

func _physics_process(_delta):
	UpdateLight();
	motion *= 0.9;
	motion = move_and_slide(motion, Vector3.UP, true);
	if (!allowedLocks4Click.has(LockingState)):
		motion = Vector3.ZERO;
	$Lock.frame = LockingState;
	if (Input.is_action_just_pressed("Click") && MouseON == true):
		get_node("../PlayerSystem").changeSelected(self);

func LazerHit():
	activated = true;
	UpdateLight();

func ResetLight():
	activated = false;
	UpdateLight();

func UpdateLight():
	$OmniLight.visible = activated;
	if (activated == true && $AudioStreamPlayer.playing != true && oldActivated != activated):
		oldActivated = activated;
		$AudioStreamPlayer.pitch_scale = 1;
		$AudioStreamPlayer.play()
		get_node("../WinConditionHandler").Activated += 1;
	if (activated == false && $AudioStreamPlayer.playing != true && oldActivated != activated):
		oldActivated = activated;
		$AudioStreamPlayer.pitch_scale = 0.78;
		$AudioStreamPlayer.play()
		get_node("../WinConditionHandler").Activated -= 1;

func GravMove():
	if LockingState != 3:
		for i in GravPulls.size():
			if !test_move(self.transform, GravPulls[i]):
				motion += GravPulls[i];
			else:
				motion -= GravPulls[i];
	GravPulls.clear();


func _on_Reciever_mouse_entered():
	MouseON = true;


func _on_Reciever_mouse_exited():
	MouseON = false;


func _on_AudioStreamPlayer_finished():
	get_node("../WinConditionHandler").WinCheck();
