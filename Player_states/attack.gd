class_name attack extends state_class


@onready var idle_state = $"../idle"
@onready var move_state = $"../move"
@onready var jump_state = $"../jump"
@onready var dash_state = $"../dash"
@onready var crouch_state = $"../crouching"
@onready var stun_state = $"../stun"
var hitspam_tol : int = 4
var hit_lag : float = -0.3
var start_up_lag : float = -0.2
var target : Enemy
var timer :=0.4
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
		
		guy1.sprite.play("BasicATK")
	else:
		guy1.sprite.play("BasicATK") # make this slower later
	timer = 0.4



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
	elif (timer <= start_up_lag and num_of_hits == 0) || (timer <= 0 and num_of_hits < hitspam_tol and num_of_hits > 0) || (timer <= hit_lag and num_of_hits >= hitspam_tol) || guy1.stun_time > 0:
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
	if num_of_hits > 0:
		return timer <= 0.25 and  timer > 0.24
	else:
	#e	print("start up time")
		return timer <= 0.25 + start_up_lag and  timer > 0.24 + start_up_lag

func hit_boxOff()->bool:
	if num_of_hits > 0:
		return timer <= 0.02 and  timer > 0.01
	else:
		return timer <= 0.02 + start_up_lag and  timer > 0.01  + start_up_lag

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
			
				guy1.velocity = -(guy1.global_position - guy1.get_global_mouse_position()).normalized() * 600
		#
			else:
				
				if guy1.follow_up_time <=0 || (target != null and ((target.global_position - guy1.global_position).normalized()-guy1.direction.normalized()).length() >= 1.5 and (guy1.global_position - target.global_position).length() < 100):
					guy1.follow_up_time = 0
					guy1.velocity = guy1.last_dir.normalized() * 600
				
				elif target != null:
					print("following")
					guy1.velocity = (target.global_position - guy1.global_position).normalized()*600
		else:
			guy1.move(guy1.direction,0.3,0.05)

func knockback(hitted_enemy : Enemy):
	if num_of_hits >= hitspam_tol:
		hitted_enemy.parried(guy1)
	else:
		hitted_enemy.parried(guy1,0.6,0.4)
