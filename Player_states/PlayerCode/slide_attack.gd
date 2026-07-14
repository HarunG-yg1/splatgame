class_name slide_attack extends attack

var prior_vel : Vector2
var changed_dir := false

	
func Enter():
	
	changed_dir = false
	prior_attack_box_size = guy1.attack_shape.shape.size.x
	prior_attack_box_displace = guy1.attack_shape.position.x
	guy1.attack_shape.shape.size.x *= 1.6
	guy1.attack_shape.position.x -= 24
	print("SlideAttack")
	
	guy1.velocity = guy1.velocity.normalized() * 450
	prior_vel = guy1.velocity
	
	guy1.curr_attk = 2
#	guy1.sprite.play("BasicATK")
	guy1.animfx.play("shineGreen")
	timer = 0.6

	if RythmLoader.find_attkType(2) and timer > 0:
		RythmLoader.setHit_attkType(2)
		guy1.i_time = 0.2

func hit_boxOn()->bool:
	return timer <=0.25 and  timer > 0.24
	
func attack_movement(delta):
	if hit_boxOn():
		if Input.is_action_pressed("aim_to_mouse"):
			prior_vel =  -(guy1.global_position - guy1.get_global_mouse_position()).normalized() * 600
			guy1.velocity = prior_vel
	#
		else:
			if guy1.direction.length() > 0:
				prior_vel = guy1.direction.normalized() * 600
			else:
				prior_vel = guy1.velocity.normalized() * 600

		guy1.sprite.play("BasicATK")

	elif RythmLoader.find_attkType(2) and timer > 0:
		RythmLoader.setHit_attkType(2)
		guy1.i_time = 0.2

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
		

	
	print("vroo")
	prior_vel *= 0.99
	guy1.velocity = (prior_vel + guy1.direction*150)


	
			
				
		
			
