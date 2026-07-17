class_name aerial_attack extends attack
var changed_dir : bool = false
var prior_vel : Vector2

func Enter():
	guy1.jump()
	changed_dir = false
	prior_attack_box_size = guy1.attack_shape.shape.size.x
	prior_attack_box_displace = guy1.attack_shape.position.x
	guy1.attack_shape.shape.size.x *= 1.6
	guy1.attack_shape.position.x -= 20
	print("AirAttack")


	prior_vel = guy1.velocity 
	speed_mod = 3.6
	guy1.curr_attk = 2
	
	guy1.animfx.play("shineBlue")
	timer = 0.5
	if RythmLoader.find_attkType(blood_puddle.puddle_colors.BLUE):
		RythmLoader.setHit_attkType(blood_puddle.puddle_colors.BLUE)
		guy1.i_time = 0.25
	if statemachine.last_defend == blood_puddle.puddle_colors.BLUE and  RythmLoader.find_attkType(blood_puddle.puddle_colors.NO_COLOR):
		RythmLoader.setHit_attkType(blood_puddle.puddle_colors.NO_COLOR)


func hit_boxOn()->bool:
	return timer <=0.2 and  timer > 0.19
	
func attack_movement(delta):
	if hit_boxOn():
		guy1.i_time = 0.2
		guy1.sprite.play("BasicATK")
		if Input.is_action_pressed("aim_to_mouse"):
				prior_vel =  -(guy1.global_position - guy1.get_global_mouse_position()).normalized() * guy1.velocity.length()
				guy1.velocity = prior_vel

		else:
			prior_vel = guy1.velocity
		
	

	guy1.attack_box.look_at(guy1.position+guy1.velocity)
	if guy1.get_last_slide_collision() != null and guy1.get_last_slide_collision() != Enemy and !changed_dir:
	
	
		var temp_prior_vel = (prior_vel.normalized() + 2*guy1.get_last_slide_collision().get_normal()).normalized() * 400
		if( guy1.get_last_slide_collision().get_normal().x >0) :
			prior_vel.x = abs(temp_prior_vel.x)
		else:
			prior_vel.x = -abs(temp_prior_vel.x)
		if( guy1.get_last_slide_collision().get_normal().y >0) :
			prior_vel.y = abs(temp_prior_vel.y)
		else:
			prior_vel.y = -abs(temp_prior_vel.y)
		changed_dir = true
		
		guy1.velocity = prior_vel
		print(guy1.get_last_slide_collision().get_normal(),"privel1")
		print(prior_vel,"privel")
	if !guy1.attack_shape.disabled:

		if RythmLoader.find_attkType(blood_puddle.puddle_colors.BLUE) and timer > 0.09:
			RythmLoader.setHit_attkType(blood_puddle.puddle_colors.BLUE)
		if statemachine.last_defend == blood_puddle.puddle_colors.BLUE and  RythmLoader.find_attkType(blood_puddle.puddle_colors.NO_COLOR):
			RythmLoader.setHit_attkType(blood_puddle.puddle_colors.NO_COLOR)
			
		
		guy1.velocity = (prior_vel.normalized() + guy1.direction).normalized() * guy1.MAX_SPEED *speed_mod
		if speed_mod > 0.2:
			speed_mod -= delta* 16
		else:
			speed_mod = 0.2
	else:
		guy1.move(guy1.direction,0.4)
