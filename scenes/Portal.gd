extends Spatial

export var destiny = ''
export var description = '[center]Portal: Go to ...'

func _on_Area_body_entered(body):
	if body.name == 'Player':
		get_tree().change_scene(destiny)

func _on_show_desc_body_entered(body):
	if body.name == 'Player':
		body.show_alert(description)
