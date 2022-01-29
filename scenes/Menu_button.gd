extends Button

export var go_to:String = ''
export var focus:bool = false

func _ready():
	if focus:
		grab_focus()

func _on_Button_button_down():
	get_tree().change_scene(go_to)
