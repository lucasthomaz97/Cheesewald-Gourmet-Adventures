extends Area

export var ch_name = 'cheese'

func _ready():
	for n in Global.cheeses_got:
		if n == ch_name:
			queue_free()

func _on_Cheese_body_entered(body):
	if body.name == 'Player':
		Global.Cheeses += 1
		body.show_big_alert(Global.got_cheese)
		Global.cheeses_got.append(ch_name)
		body.play_fanfare()
		queue_free()
