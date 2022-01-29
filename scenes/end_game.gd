extends Area

export var required : int = 5

func _on_end_game_body_entered(body):
	if body.name == "Player":
		if $"/root/Global".Cheeses < required:
			body.show_big_alert("[center][color=#cc425e]I´m starving! I need to eat "+ str(required)+" cheeses to continue my journey")
			body.show_alert("[center] collect at least "+str(required)+" cheeses and come back here to end the game")
		else:
			body.show_big_alert("[center][color=#cc425e]I ate "+ str($"/root/Global".Cheeses)+" cheeses, i think i can leave now")
			body.show_alert("[center] You collected "+str($"/root/Global".Cheeses)+" of 13, [color=yellow]press 'R' / Triangle(Play) / X(Switch) / Y(Xbox)[/color] to end the game")
			body.can_end = true

func _on_end_game_body_exited(body):
	if body.name == "Player":
		body.can_end = false
