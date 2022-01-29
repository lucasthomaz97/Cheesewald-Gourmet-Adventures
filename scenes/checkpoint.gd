extends Area

func _on_checkpoint_body_entered(body):
	if body.name == "Player":
		body.checkpoint = translation
