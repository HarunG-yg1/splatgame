class_name aerial_attack extends attack
var changed_dir : bool = false
var prior_vel : Vector2

func Enter():
	target = guy1.curr_out_attked
	guy1.curr_out_attked = null
	guy1.jump()
	changed_dir = false


	print("AirAttack")


	prior_vel = guy1.velocity 
	speed_mod = 3.6
	guy1.curr_attk = RythmLoader.add_color(Color.BLUE,guy1.curr_attk)
	guy1.animfx.modulate = guy1.curr_attk
	guy1.animfx.play("shine1")
	timer = 0.7
	if RythmLoader.find_attkType(Color.BLUE):
		RythmLoader.setHit_attkType(Color.BLUE)
		guy1.i_time = 0.25
	if  RythmLoader.check_similiar_colour(statemachine.last_defend,Color.BLUE) and  RythmLoader.find_attkType(Color.WHITE):
		RythmLoader.setHit_attkType(Color.WHITE)


func hit_boxOn()->bool:
	return timer <=0.45 and  timer > 0.44

func hit_boxOff()->bool:
	return timer <=0.2 and  timer > 0.19
func attack_movement(delta):
	if hit_boxOn():
		guy1.set_collision_layer_value(2,false)
		guy1.start_trail.emit(guy1)
		guy1.i_time = 0.2
		guy1.sprite.play("BasicATK")
		if Input.is_action_pressed("aim_to_mouse"):
				prior_vel =  -(guy1.global_position - guy1.get_global_mouse_position()).normalized() * guy1.velocity.length()
				guy1.velocity = prior_vel

		else:
			if guy1.follow_up_time <=0 || (target != null and ((target.global_position - guy1.global_position).normalized()-guy1.direction.normalized()).length() > 1.41):
				guy1.follow_up_time = 0
				prior_vel = guy1.velocity
			elif target != null:
				print("mooo")
				prior_vel = (target.global_position - guy1.global_position).normalized()*guy1.velocity.length()
		
	

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
	#	print(guy1.get_last_slide_collision().get_normal(),"privel1")
	#	print(prior_vel,"privel")
	if !guy1.attack_shape.disabled:

		if RythmLoader.find_attkType(Color.BLUE):
			RythmLoader.setHit_attkType(Color.BLUE)
			guy1.i_time = 0.25
		if  RythmLoader.check_similiar_colour(statemachine.last_defend,Color.BLUE) and  RythmLoader.find_attkType(Color.WHITE):
			RythmLoader.setHit_attkType(Color.WHITE)
			
		
		guy1.velocity = (prior_vel.normalized() + guy1.direction).normalized() * guy1.MAX_SPEED *speed_mod
		if speed_mod > 0.2:
			speed_mod -= delta* 16
		else:
			speed_mod = 0.2
	else:
		guy1.move(guy1.direction,0.4)
