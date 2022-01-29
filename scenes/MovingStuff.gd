extends Path

export var time = 10

func _ready():
	$AnimationPlayer.play('move'+str(time))
