extends Node

var AmountOfRecievers = 0;
var Activated = 0;

func WinCheck():
	var t = Timer.new();
	t.set_wait_time(0.3);
	t.set_one_shot(true);
	self.add_child(t)
	t.start();
	yield(t, "timeout");
	if Activated >= AmountOfRecievers:
		get_node("../../").LoadLevel(1, 2);
	t.queue_free();
