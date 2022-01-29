extends KinematicBody

const cheese = preload("res://scenes/Cheese.tscn")
export var cheese_name = "Race"
	
func bird_lose():
	var ch = cheese.instance()
	ch.ch_name = cheese_name
	ch.translation.x = 1
	add_child(ch)
