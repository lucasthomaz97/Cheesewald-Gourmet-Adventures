extends Area

func _on_game_over_body_entered(body):
	if body.name == "Player":
		body.fall()
