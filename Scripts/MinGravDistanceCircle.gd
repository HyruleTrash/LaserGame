extends MeshInstance

export var VisibilityInGame = false;

func _ready():
	self.visible = VisibilityInGame;
	get_node("../").MinGravDistance = (scale.x + scale.y + scale.z)/3;
