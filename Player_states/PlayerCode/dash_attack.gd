class_name dash_attack extends attack

var prior_vel : Vector2

func Enter():
	
	print("dashAttack")
	prior_attack_box_size = guy1.attack_shape.shape.size.x
	prior_attack_box_displace = guy1.attack_shape.position.x
	guy1.attack_shape.shape.size.x *= 1.6
	guy1.attack_shape.position.x -= 24
	

	speed_mod = 3.6
	guy1.curr_attk = 0

	guy1.animfx.play("shineRed")
	timer = 0.6

	if  RythmLoader.find_attkType(blood_puddle.puddle_colors.RED):
		RythmLoader.setHit_attkType(blood_puddle.puddle_colors.RED)
		guy1.i_time = 0.25

	if statemachine.last_defend == blood_puddle.puddle_colors.RED and  RythmLoader.find_attkType(blood_puddle.puddle_colors.NO_COLOR):
		RythmLoader.setHit_attkType(blood_puddle.puddle_colors.NO_COLOR)
		


func hit_boxOn()->bool:
	return timer <=0.2 and  timer > 0.19
	
func attack_movement(delta):
	if hit_boxOn():
		guy1.i_time = 0.2
		if Input.is_action_pressed("aim_to_mouse"):
			prior_vel =  -(guy1.global_position - guy1.get_global_mouse_position()).normalized() * guy1.velocity.length()
			guy1.velocity = prior_vel
	#
		else:
			prior_vel = guy1.velocity
	
		guy1.sprite.play("BasicATK")



	guy1.attack_box.look_at(guy1.position+guy1.velocity)

	if !guy1.attack_shape.disabled:
		
		if  RythmLoader.find_attkType(blood_puddle.puddle_colors.RED):
			RythmLoader.setHit_attkType(blood_puddle.puddle_colors.RED)
			

		if statemachine.last_defend == blood_puddle.puddle_colors.RED and  RythmLoader.find_attkType(blood_puddle.puddle_colors.NO_COLOR):
			RythmLoader.setHit_attkType(blood_puddle.puddle_colors.NO_COLOR)
		
		guy1.velocity = (prior_vel.normalized() + guy1.direction).normalized() * guy1.MAX_SPEED *speed_mod
		print("ze speed",speed_mod )
		
		if speed_mod > 0.2:
			speed_mod -= delta* 12
		else:
			speed_mod = 0.2
	else:
		guy1.move(guy1.direction,0.3)
