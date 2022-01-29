extends Node

var Cheeses = 0
var cheeses_got = []
var joystick = false

const dialog_win_race = "[center]You defeated me! Wait for me take a [wave amp=50 freq=5]cheese[/wave] as a reward"
const dialog_lse_race = "[center]I won! You can try again pressing R / Triangle(Play) / X(Switch) / Y(Xbox)"
const got_cheese = '[wave amp=50 freq=5][rainbow freq=0.2 sat=10 val=20][center]YOU ATE A CHEESE!'
const fly_msg =  """[center][rainbow freq=0.2 sat=10 val=20]I BELIEVE I CAN FLY[/rainbow]
I ate this rotten cheese, and now my stomach works like an airplane turbine, maybe i can use it as propulsion to [wave amp=50 freq=5][color=yellow]jump in the air[/color][/wave]"""
