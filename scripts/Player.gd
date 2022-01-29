extends KinematicBody

export var JUMP = 35
export var SPEED = 100
export var MOVE_MULTI = 2.5
export var GRAVITY = 0.98
export var GRAVITY_SPEED = 1.2
export var MAX_FALL_SPEED = 50
export var y_sens := 1.0
export var x_sens := 1.0
export var joy_y_sens := 10
export var joy_x_sens := 10
export var MULTI_SPT = 4
export var END_PATH = 'res://scenes/Menu.tscn'
export var DEADZONE = 0.3

var move_vec = Vector3.ZERO
var can_end = false
var just_jumped = false
var y_velo = 0
var grounded = false
var last_input = ''
var j_count = 0
onready var jump_list = ['jump_run', 'jump_flip']
onready var anim = ''
onready var pause_pos = 0
onready var cam_basis_x := Vector3.ZERO
onready var cam_basis_z := Vector3.ZERO
onready var can_double_jmp := 0
onready var checkpoint := Vector3.ZERO
onready var movement := Vector3.ZERO
onready var ex_anim := false
onready var control_multi := 175

func _ready():
	checkpoint = translation
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	play_anim('idle')
	
func jump_anim(fast = false):
	if fast:
		$Anim.play("jump_fast")
		return
	$Anim.play("jump")
	
func fall():
	translation = checkpoint
	
func play_fanfare():
	pause_pos = $Music_player.get_playback_position()
	$Music_player.stop()
	$fanfare.play()
	
func show_big_alert(text, time=2):
	$big_alert.bbcode_text = str(text)
	$big_alert.visible = true
	$big_alert_timer.start(time)
	
func show_alert(text, time=5):
	$alert.bbcode_text = str(text)
	$alert.visible = true
	$alert_timer.start(time)
	
func coyote_grounding():
	if is_on_floor() or just_jumped:
		grounded = is_on_floor()
	else:
		$Timer.start()

func max_or_mid(boolean):
	return 1 if boolean else 0.25

func play_anim(anim):
	var current = $Mesh/animated_cheeswald/AnimationPlayer.current_animation
	if !(current == anim) and (('jump' in anim and move_vec.y > 0)or('idle' in anim or 'run' in anim or 'sit' in anim or ex_anim)):
		$Mesh/animated_cheeswald/AnimationPlayer.playback_speed = 1
		$Mesh/animated_cheeswald/AnimationPlayer.play(anim)
		
func double_jump():
	if Input.is_action_just_pressed("jump") and can_double_jmp>0 and !is_on_floor():
		y_velo += JUMP
		can_double_jmp -= 1
		play_anim('jump_idle')
		$Mesh/double_jump.emitting = true
		$jumpsfx.play()
	
func def_anim():
	if movement.x != 0 and movement.z != 0 and Input.is_action_pressed("sprint"):
		anim = 'run_fast'
	if ex_anim == false:
		if move_vec.x == 0 and move_vec.z == 0 and move_vec.y <= -MAX_FALL_SPEED/2:
			anim = 'idle'
		elif movement.x != 0 and movement.z != 0 and move_vec.y <= -MAX_FALL_SPEED/2:
			anim = 'run'
		if movement.x != 0 and movement.z != 0 and Input.is_action_pressed("sprint"):
			anim = 'run_fast'
		if grounded and just_jumped:
			$jumpsfx.play()
			anim = jump_list[randi()%jump_list.size()] if movement.x != 0 or movement.z != 0 else 'jump_idle'
		play_anim(anim)

func _input(event):
	if Global.joystick and event is InputEventJoypadMotion:
		if (Input.get_joy_axis(0,JOY_ANALOG_LY) > DEADZONE or Input.get_joy_axis(0,JOY_ANALOG_LY) < -DEADZONE) or (Input.get_joy_axis(0, JOY_ANALOG_LX) > DEADZONE or Input.get_joy_axis(0, JOY_ANALOG_LX) < -DEADZONE):
			move_vec = Input.get_joy_axis(0,JOY_ANALOG_LY)*cam_basis_z
			move_vec += Input.get_joy_axis(0, JOY_ANALOG_LX)*cam_basis_x
		else:
			move_vec = (Input.get_action_strength("ctrl_down") -Input.get_action_strength("ctrl_up"))*cam_basis_z
			move_vec += (Input.get_action_strength("ctrl_right")-Input.get_action_strength("ctrl_left"))*cam_basis_x
		move_vec = move_vec.normalized()*MOVE_MULTI
		
		$Pivot.rotation_degrees.x -= (event.get_action_strength("cam_down")-event.get_action_strength("cam_up"))*joy_x_sens
		$Pivot.rotation_degrees.y -= (event.get_action_strength("cam_right")-event.get_action_strength("cam_left"))*joy_y_sens
	elif event is InputEventMouseMotion:
		$Pivot.rotation_degrees.x -= event.relative.y * y_sens
		$Pivot.rotation_degrees.y -= event.relative.x * x_sens
	
	$Pivot.rotation_degrees.x = clamp($Pivot.rotation_degrees.x, -90, 90)
		
func can_jump():
	return true if y_velo <= -30 and y_velo >= -MAX_FALL_SPEED else false
	
func render_3d_ui():
	$cont/Cheeses.text = str(Global.Cheeses)
	var cheese_txtr = $cont/cheesprite/Viewport.get_texture()
	$cont/cheesprite.texture = cheese_txtr
	if can_double_jmp > 0:
		var rot_txtr = $cont2/rotcheesprite/Viewport.get_texture()
		$cont2/rotcheesprite.texture = rot_txtr
		$cont2.visible = true
		$cont2/Label.text = str(can_double_jmp)
	else:
		$cont2.visible = false

func _process(delta):
	cam_basis_z = Vector3($Pivot.transform.basis.z.x,0,$Pivot.transform.basis.z.z)
	cam_basis_x = Vector3($Pivot.transform.basis.x.x,0,$Pivot.transform.basis.x.z)
	if Input.is_action_pressed("Retry") and can_end:
		get_tree().change_scene(END_PATH)
	render_3d_ui()

func _physics_process(delta):
	if !Global.joystick:
		move_vec = (Input.get_action_strength("move_bwd") -Input.get_action_strength("move_fwd"))*cam_basis_z
		move_vec += (Input.get_action_strength("move_rgt")-Input.get_action_strength("move_lft"))*cam_basis_x
		move_vec = move_vec.normalized()*MOVE_MULTI
	coyote_grounding()
	just_jumped = true if grounded and Input.is_action_just_pressed("jump") and can_jump() else false
	double_jump()
	move_vec = move_vec.normalized()*delta*control_multi
	move_vec *= SPEED * MULTI_SPT if Input.is_action_pressed("sprint") else SPEED
	$Mesh/speed.emitting = Input.is_action_pressed("sprint") and (move_vec.x !=0 or move_vec.z != 0)
	move_vec.y = y_velo
	$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, atan2(move_vec.x, move_vec.z), delta*20) if !(move_vec.x == 0 and move_vec.z == 0) else $Mesh.rotation.y
	def_anim()
	movement = move_and_slide(move_vec, Vector3.UP, (get_floor_velocity()!= Vector3.ZERO))
	y_velo = y_velo-(GRAVITY*GRAVITY_SPEED) if !just_jumped else JUMP
	if just_jumped:
		jump_anim()
	y_velo = -MAX_FALL_SPEED if y_velo < -MAX_FALL_SPEED else y_velo
	$shadow/CSGCylinder2.visible = $shadow.get_hit_length() > 0

func _on_Timer_timeout():
	grounded = false

func _on_big_alert_timer_timeout():
	$big_alert.visible = false

func _on_alert_timer_timeout():
	$alert.visible = false

func _on_fanfare_finished():
	$Music_player.play()
	$Music_player.seek(pause_pos)

func _on_Area_body_entered(body):
	if body.name == 'MushHead':
		ex_anim = true
	else:
		ex_anim = false
