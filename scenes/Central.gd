extends Spatial

var theme = preload("res://sounds/CentralTheme.mp3")

func _ready():
	$Player/Music_player.stream = theme
	$Player/Music_player.playing = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
