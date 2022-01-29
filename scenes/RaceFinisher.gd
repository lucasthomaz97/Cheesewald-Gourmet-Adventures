extends Area

var finished = 0
var can_retry = false
var player_finished = false
var player

func _physics_process(delta):
	if can_retry and Input.is_action_just_pressed("Retry"):
		get_tree().reload_current_scene()

func _on_RaceFinisher_body_entered(body):
	if body.name == 'Player' and finished==1:
		finished +=1
		body.show_alert(Global.dialog_lse_race)
		player = body
		can_retry = true
	elif body.name == 'Player' and finished==0:
		body.show_alert(Global.dialog_win_race)
		finished += 1
		player_finished = true
		player = body
	if body.name == 'Bird' and player_finished:
		body.bird_lose()
		finished += 1
	elif body.name == 'Bird' and finished==0:
		finished += 1
	elif body.name == 'Bird' and finished >= 2:
		print(body.name, finished)
		body.bird_lose()
		player.show_alert('[center] I need to be honest, i made a mistake! You are the actual winner, sorry and take your cheese')
	
