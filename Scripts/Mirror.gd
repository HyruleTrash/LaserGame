extends KinematicBody


export var Mass : float = 1;
var GravPulls : Array;
var CollisionRadius : float = 1;
var MinGravDistance : float = 1;

onready var Line : Object = preload("res://Scenes/Lazer.tscn");
var LazerHolder : Object;

#var Lasthit = null
#var collisionPoint = null;
#var OtherlaserDir = null;
#var ShootingLaser = false;
var LazerPropertys : Array;

export var ID = 1;

var motion : Vector3;
var MouseON = false;
export var LockingState : int = 0;
var ResettingLaser = false;

var allowedLocks4Click = [0, 1]


func _physics_process(_delta):
	motion *= 0.8;
	motion = move_and_slide(motion, Vector3.UP, true);
	Updatelazer();
	if (!allowedLocks4Click.has(LockingState)):
		motion = Vector3.ZERO;
	$Lock.frame = LockingState;
	if (Input.is_action_just_pressed("Click") && MouseON == true):
		get_node("../PlayerSystem").changeSelected(self);

func _ready():
	LazerHolder = get_node("../LazerHolder")
	var GroupMembers = get_tree().get_nodes_in_group("LazerShooter");
	for i in GroupMembers.size():
		LazerPropertys.push_back([null,null,null,false]);

func Updatelazer():
	for i in LazerPropertys.size():
		if (LazerPropertys[i][1] != null && LazerPropertys[i][2] != null):
			LazerHit(i);

func LazerHit(var i : int):
	if (ResettingLaser == false && LazerPropertys[i][1] != null && LazerPropertys[i][2] != null && LazerPropertys[i][3] == false):
		LazerPropertys[i][3] = true;
		
		var collisionPoint = LazerPropertys[i][1];
		var OtherlaserDir = LazerPropertys[i][2];
		
		var space_state = get_world().direct_space_state;
		OtherlaserDir = OtherlaserDir.normalized();
		ResetlazerALT();
		var normal = $Normal.translation;
		if (self.rotation.normalized() != Vector3(0,0,0)):
			normal = ($Normal.global_translation - self.translation).normalized();
			#normal = ($Normal.translation.rotated(self.rotation.normalized(), 1)).normalized();
			#normal = $Normal.translation.rotated(Vector3(0,1,0), self.rotation_degrees.y).normalized()
			#normal = $Normal.global_transform.origin.normalized()
		var endPos = (OtherlaserDir + (normal * -OtherlaserDir.dot(normal))*2) * 100;
		var result = space_state.intersect_ray(collisionPoint, endPos, [self])
		if result:
			_draw3DLine(collisionPoint, result.position, i);
			if (result.collider != LazerPropertys[i][0] && LazerPropertys[i][0] != null):
				if (LazerPropertys[i][0].name.find("Mirror") != -1 && LazerPropertys[i][0].name.find("WrongSide") == -1):
					LazerPropertys[i][0].LazerPropertys[ID][1] = null;
					LazerPropertys[i][0].LazerPropertys[ID][2] = null;
				if (LazerPropertys[i][0].has_method("Resetlazer")):
					LazerPropertys[i][0].Resetlazer();
				LazerPropertys[i][0] = result.collider;
			if (result.collider.has_method("LazerHit") && LazerHolder.MaxLazers > LazerHolder.get_child_count()):
				if (LazerPropertys[i][0] != null && result.collider.name.find("Reciever") == -1 && LazerPropertys[i][0].name.find("Reciever") != -1):
					result.collider.ResetLight();
				LazerPropertys[i][0] = result.collider;
				if (LazerPropertys[i][0].name.find("Mirror") != -1 && LazerPropertys[i][0].name.find("WrongSide") == -1):
					result.collider.LazerPropertys[ID][1] = result.position;
					result.collider.LazerPropertys[ID][2] = normal;
					result.collider.LazerHit(ID);
				else:
					result.collider.LazerHit();
		else:
			if (LazerPropertys[i][0] != null):
				if (LazerPropertys[i][0].name.find("Reciever") != -1):
					LazerPropertys[i][0].ResetLight();
				if (LazerPropertys[i][0].name.find("Mirror") != -1 && LazerPropertys[i][0].name.find("WrongSide") == -1):
					LazerPropertys[i][0].LazerPropertys[ID][1] = null;
					LazerPropertys[i][0].LazerPropertys[ID][2] = null;
				if (LazerPropertys[i][0].has_method("Resetlazer")):
					LazerPropertys[i][0].Resetlazer();
				LazerPropertys[i][0] = null;
			_draw3DLine(collisionPoint, endPos, i);
		LazerPropertys[i][3] = false;

func Resetlazer():
	for i in LazerPropertys.size():
		if (ResettingLaser == false):
			ResettingLaser = true;
			if (LazerPropertys[i][0] != null):
				if (LazerPropertys[i][0].name.find("Reciever") != -1):
					LazerPropertys[i][0].ResetLight();
				if (LazerPropertys[i][0].name.find("Mirror") != -1 && LazerPropertys[i][0].name.find("WrongSide") == -1):
					LazerPropertys[i][0].LazerPropertys[ID][1] = null;
					LazerPropertys[i][0].LazerPropertys[ID][2] = null;
				if (LazerPropertys[i][0].has_method("Resetlazer")):
					LazerPropertys[i][0].Resetlazer();
				LazerPropertys[i][0] = null;
			for x in LazerHolder.get_child_count():
				if LazerHolder.get_child(x).name.find(self.name + str(ID) + "_" + str(i)) != -1:
					LazerHolder.get_child(x).queue_free();
			ResettingLaser = false;

func ResetlazerALT():
	for i in LazerPropertys.size():
		if (ResettingLaser == false):
			ResettingLaser = true;
			for x in LazerHolder.get_child_count():
				if LazerHolder.get_child(x).name.find(self.name + str(ID) + "_" + str(i)) != -1:
					LazerHolder.get_child(x).queue_free();
			ResettingLaser = false;

func _draw3DLine(var Point1 : Vector3, var Point2 : Vector3, var i : int):
	var LazerInstance = Line.instance();
	LazerInstance.visible = true;
	LazerInstance.name += self.name + str(ID) + "_" + str(i);
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


func _on_Mirror_mouse_entered():
	MouseON = true;


func _on_Mirror_mouse_exited():
	MouseON = false;
