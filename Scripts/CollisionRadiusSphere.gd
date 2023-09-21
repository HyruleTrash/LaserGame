extends CSGSphere


func _ready():
	self.visible = false;
	get_node("../").CollisionRadius = radius;
