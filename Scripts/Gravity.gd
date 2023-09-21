extends Node

export var Gravity : float = 9.8;
export var ForceMin : float = 0.1;
var ObjectsOfMass : Array;

func _physics_process(delta):
	for i in get_node("../").get_child_count():
		var ObjectOfMass = get_node("../").get_child(i);
		if  ObjectOfMass.is_in_group("ObjectOfMass"):
			ObjectsOfMass.push_back(ObjectOfMass);
	
	var HadCombinations : Array;
	for i in ObjectsOfMass.size():
		var ToClose = false;
		for j in ObjectsOfMass.size():
			var ThisCombination = [i, j];
			var OtherComi = [j, i];
			if (j != i && ToClose != true && !HadCombinations.has(ThisCombination) && !HadCombinations.has(OtherComi) && ObjectsOfMass[j].LockingState != 3 && ObjectsOfMass[i].LockingState != 3):
				HadCombinations.push_back(ThisCombination);
				if (ObjectsOfMass[j].get_node("SelectionIcon").frame == 0 || ObjectsOfMass[i].get_node("SelectionIcon").frame == 0):
					var temp = ObjectsOfMass[j].translation - ObjectsOfMass[i].translation;
					var distance = MyFunctions.Pythagoras(MyFunctions.Pythagoras(temp.x, temp.y), temp.z);
					if (distance < ObjectsOfMass[j].CollisionRadius || distance < ObjectsOfMass[i].CollisionRadius):
						ToClose = true;
					if (distance < ObjectsOfMass[j].MinGravDistance || distance < ObjectsOfMass[i].MinGravDistance):
						var Force = Gravity * ((ObjectsOfMass[i].Mass * ObjectsOfMass[j].Mass) / pow(distance, 2));
						var Motion = (Force / ObjectsOfMass[i].Mass) * delta;
						if Force > ForceMin:
							ObjectsOfMass[i].GravPulls.push_back(temp.normalized() *Motion);
							if (ObjectsOfMass[i].has_method("Updatelazer")):
								ObjectsOfMass[i].Updatelazer();
					
					
					var tempJ = ObjectsOfMass[i].translation - ObjectsOfMass[j].translation;
					var distanceJ = MyFunctions.Pythagoras(MyFunctions.Pythagoras(tempJ.x, tempJ.y), tempJ.z);
					if (distanceJ < ObjectsOfMass[i].CollisionRadius || distanceJ < ObjectsOfMass[j].CollisionRadius):
						ToClose = true;
					if (distanceJ < ObjectsOfMass[i].MinGravDistance || distanceJ < ObjectsOfMass[j].MinGravDistance):
						var ForceJ = Gravity * ((ObjectsOfMass[j].Mass * ObjectsOfMass[i].Mass) / pow(distanceJ, 2));
						var MotionJ = (ForceJ / ObjectsOfMass[j].Mass) * delta;
						if ForceJ > ForceMin:
							ObjectsOfMass[j].GravPulls.push_back(tempJ.normalized() * MotionJ);
							if (ObjectsOfMass[j].has_method("Updatelazer")):
								ObjectsOfMass[j].Updatelazer();
		if (ToClose != true):
			ObjectsOfMass[i].GravMove();
	ObjectsOfMass.clear();
