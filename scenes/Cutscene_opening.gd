extends Spatial

func _ready():
	$AnimationPlayer.play("scene")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://scenes/Central.tscn")
