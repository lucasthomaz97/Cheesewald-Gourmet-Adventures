extends Area

export var can_jump: int = 5
export var reload_time: int = 7

func _on_RottenCheese_body_entered(body):
	if body.name == 'Player':
		body.can_double_jmp += can_jump
		body.show_alert(Global.fly_msg)
		$CollisionShape.disabled = true
		$rot_cheese.visible = false
		$Timer.start(reload_time)

func _on_Timer_timeout():
	$CollisionShape.disabled = false
	$rot_cheese.visible = true
