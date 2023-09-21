extends KinematicBody

# Mass of the object
export var Mass : float = 1;
# All gravitational pulls the object should have
var GravPulls : Array;
#Radius where another object shouldn't go further
var CollisionRadius : float = 1;
# the minimal amount of distance an object needs to be attracted
var MinGravDistance : float = 1;

# Lazer prefab
onready var Line : Object = preload("res://Scenes/Lazer.tscn");
# Object that holds all Lazers
var LazerHolder : Object;
# The object that was last hit with the Lazer
var Lasthit = null
# Starting Position of the Lazer
var LaserStart
var space_state
# Lazer On or Not
export var ShouldShootLaser : bool = false;
var motion : Vector3;
# If the mouse is on the Object or not
var MouseON = false;
# How the player can interact with it
export var LockingState : int = 0;

func _ready():
	LazerHolder = get_node("../LazerHolder")

func _physics_process(delta):
	if (ShouldShootLaser == true):
		Updatelazer();
	else:
		for x in LazerHolder.get_child_count():
			if LazerHolder.get_child(x).name.find("FirstLazer") != -1:
				LazerHolder.get_child(x).queue_free();
		if (Lasthit != null):
			if (Lasthit.name.find("Mirror") != -1 && Lasthit.name.find("WrongSide") == -1):
				Lasthit.LazerPropertys[0][1] = null;
				Lasthit.LazerPropertys[0][2] = null;
			if (Lasthit.has_method("Resetlazer")):
				Lasthit.Resetlazer();
			Lasthit = null;
	motion *= 0.9;
	motion = move_and_slide(motion, Vector3.UP, true);
	if (LockingState == 3):
		motion = Vector3.ZERO;
	$Lock.frame = LockingState;
	if (Input.is_action_just_pressed("Click") && MouseON == true):
		if (get_node("../PlayerSystem").Selected == self):
			ShouldShootLaser = !ShouldShootLaser;
			$AudioStreamPlayer.play();
		get_node("../PlayerSystem").changeSelected(self);

func Updatelazer():
	if (ShouldShootLaser == true):
		space_state = get_world().direct_space_state;
		LaserStart = $Forward.global_translation - self.translation;
		for x in LazerHolder.get_child_count():
			if LazerHolder.get_child(x).name.find("FirstLazer") != -1:
				LazerHolder.get_child(x).queue_free();
		
		var result = space_state.intersect_ray(LaserStart + self.translation, LaserStart * 100 + self.translation)
		if result:
			_draw3DLine(LaserStart + self.translation, result.position);
			if (result.collider != Lasthit && Lasthit != null):
				if (Lasthit.name.find("Mirror") != -1 && Lasthit.name.find("WrongSide") == -1):
					Lasthit.LazerPropertys[0][1] = null;
					Lasthit.LazerPropertys[0][2] = null;
				if (Lasthit.has_method("Resetlazer")):
					Lasthit.Resetlazer();
				Lasthit = result.collider;
			if (result.collider.has_method("LazerHit") && LazerHolder.MaxLazers > LazerHolder.get_child_count()):
				if (Lasthit != null && result.collider.name.find("Reciever") == -1 && Lasthit.name.find("Reciever") != -1):
					result.collider.ResetLight();
				Lasthit = result.collider;
				if (Lasthit.name.find("Mirror") != -1 && Lasthit.name.find("WrongSide") == -1):
					result.collider.LazerPropertys[0][1] = result.position;
					result.collider.LazerPropertys[0][2] = LaserStart;
					result.collider.LazerHit(0);
				else:
					result.collider.LazerHit();
		else:
			if (Lasthit != null):
				if (Lasthit.name.find("Reciever") != -1):
					Lasthit.ResetLight();
				if (Lasthit.name.find("Mirror") != -1 && Lasthit.name.find("WrongSide") == -1):
					Lasthit.LazerPropertys[0][1] = null;
					Lasthit.LazerPropertys[0][2] = null;
				if (Lasthit.has_method("Resetlazer")):
					Lasthit.Resetlazer();
				Lasthit = null;
			_draw3DLine(LaserStart + self.translation, LaserStart * 100 + self.translation);

func _draw3DLine(var Point1 : Vector3, var Point2 : Vector3):
	var LazerInstance = Line.instance();
	LazerInstance.name = "FirstLazer";
	LazerInstance.visible = true;
	LazerInstance.translation = Point1;
	LazerInstance.look_at_from_position(Point1, Point2, Vector3.UP);
	var temp = (Point2 - Point1);
	var middle : Vector3 = Point1 + (temp / 2);
	var distance = MyFunctions.Pythagoras(MyFunctions.Pythagoras(temp.x, temp.y), temp.z);
	LazerInstance.translation = middle;
	LazerInstance.scale.z = distance / 2;
	LazerHolder.add_child(LazerInstance);


func GravMove():
	if LockingState != 3:
		for i in GravPulls.size():
			if !test_move(self.transform, GravPulls[i]):
				motion += GravPulls[i];
			else:
				motion -= GravPulls[i];
	GravPulls.clear();


func _on_Laser_mouse_entered():
	MouseON = true;


func _on_Laser_mouse_exited():
	MouseON = false;
