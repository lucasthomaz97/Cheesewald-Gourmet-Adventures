extends Path

export var dialog_fst = "[center]if you can get here, then you can race me! i'm Nikki the bird"
var raced = 0
var theme = preload("res://sounds/race theme.mp3")

func _ready():
	$PathFollow/Bird/AnimationPlayer.play("idle")

func _on_Area_body_entered(body):
	if body.name == 'Player' and raced == 0:
		body.show_alert(dialog_fst)
		body.get_node('Music_player').stream = theme
		body.get_node('Music_player').playing = true
		$PathFollow/Bird/AnimationPlayer.play("race")
		$PathFollow/Bird/AnimationPlayer.queue("idle")
		raced+=1
		
