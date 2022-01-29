extends StaticBody

export var impulse = 50

func _on_Area_body_entered(body):
	if body.name == 'Player':
		$Anim.play("bounce")
		body.play_anim("jump_idle_fast")
		body.jump_anim(true)
		body.y_velo += impulse
