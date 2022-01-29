extends Button

func _process(delta):
	if Global.joystick:
		text = 'Play with Keyboard'
	else:
		text = 'Play with Joystick'

func _on_Button2_button_up():
	Global.joystick = !Global.joystick
