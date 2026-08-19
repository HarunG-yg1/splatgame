class_name attack extends state_class


@onready var idle_state = $"../idle"
@onready var move_state = $"../move"
@onready var jump_state = $"../jump"
@onready var dash_state = $"../dash"
@onready var crouch_state = $"../crouching"
@onready var stun_state = $"../stun"
var hitspam_tol : int = 5
var hit_lag : float = -0.3

var target : Enemy
var timer : float
var num_of_hits : int = 0
var speed_mod : float= 1
var parent : bool = true


func _init() -> void:
	#hit_lag = player.hitlag
	#hitspam_tol = player.hitspam_tol
	for i in get_children():
		i.guy1 = self.guy1
		i.statemachine = self.statemachine

func Enter():
	guy1.velocity *= 0.25
	if guy1.statemachine.last_attk_time < 1:
		num_of_hits += 1
	else:
		num_of_hits  = 0
	guy1.statemachine.last_attk_time = -0.5
	target = guy1.curr_out_attked
	guy1.curr_out_attked = null

	
	print("Attack")

	guy1.curr_attk = RythmLoader.add_color(Color.WHITE,guy1.curr_attk)
	guy1.animfx.modulate = guy1.curr_attk
	guy1.animfx.play("shine1")
	if num_of_hits > 0:
		guy1.sprite.stop()
		guy1.sprite.play("BasicATK")
		timer = get_anim_length("BasicATK")
	else:
		guy1.sprite.stop()
		guy1.sprite.play("BasicATK_startlag")
		timer = get_anim_length("BasicATK_startlag")
	print("time", timer)

func get_anim_length(anim_name : String)->float:
	var sprite_frames : SpriteFrames = guy1.sprite.sprite_frames
	if !sprite_frames.has_animation(anim_name):
		return 0
	var accumm : float = 0
	for i : int in range(sprite_frames.get_frame_count(anim_name)):
		accumm += sprite_frames.get_frame_duration(anim_name,i)/sprite_frames.get_animation_speed(anim_name)
	return accumm
func Process(_delta):
	
	#print(guy1.out_attk_time)
	
	if guy1.stun_time > 0:
		return stun_state
	timer -= _delta

		
	#guy1.attack_box.look_at(guy1.global_position+guy1.last_dir)
	attack_movement(_delta)

	if hit_boxOn():
		guy1.attack_shape.disabled = false 
	if hit_boxOff():
		guy1.attack_shape.disabled = true
	elif (timer <= 0 and num_of_hits < hitspam_tol) || (timer <= hit_lag and num_of_hits >= hitspam_tol) || guy1.stun_time > 0:
		if num_of_hits >=  hitspam_tol:
			num_of_hits = 0
		#	print("endlag")

			

		elif statemachine.old_state is not dash and statemachine.old_state is not jumpin and statemachine.old_state is not dive and statemachine.old_state is not block  and statemachine.old_state is not attack:
			
			return statemachine.old_state
		else:
			if (statemachine.old_state is dash || statemachine.old_state is jumpin) and guy1.crouch:
			#	
				return crouch_state.slide_state
			return idle_state 
		
	

func hit_boxOn()->bool:
	
	return guy1.sprite.frame == 4


func hit_boxOff()->bool:
	if num_of_hits > 0:
		return guy1.sprite.frame == 6
	else:
		return guy1.sprite.frame == 8

func Exit():
	

	guy1.attack_shape.disabled = true
	guy1.is_attack = false
	guy1.set_collision_layer_value(2,true)


func attack_movement(delta):
	

	if guy1.attack_shape.disabled and timer > 0:

		guy1.move(guy1.direction,speed_mod)

	else:
		if hit_boxOn():
			if Input.is_action_pressed("aim_to_mouse"):
			
				guy1.velocity = -(guy1.global_position - guy1.get_global_mouse_position()).normalized() * 450
		#
			else:
				
				if guy1.follow_up_time <=0 || (target != null and ((target.global_position - guy1.global_position).normalized()-guy1.direction.normalized()).length() >= 1.5 and (guy1.global_position - target.global_position).length() < 100):
					guy1.follow_up_time = 0
					guy1.velocity = guy1.last_dir.normalized() * 450
				
				elif target != null:
					print("following")
					guy1.velocity = (target.global_position - guy1.global_position).normalized()*450
		else:
			guy1.move(guy1.direction,0.5,0.01)

func knockback(hitted_enemy : Enemy):
	if num_of_hits >= hitspam_tol:
		hitted_enemy.parried(guy1,0.85,1)
	else:
		hitted_enemy.parried(guy1,0.7,0.4)
