class_name aerial_attack extends attack
var changed_dir : bool = false
var prior_vel : Vector2

func Enter():
	changed_dir = false
	prior_attack_box_size = guy1.attack_shape.shape.size.x
	prior_attack_box_displace = guy1.attack_shape.position.x
	guy1.attack_shape.shape.size.x *= 2
	guy1.attack_shape.position.x -= 20
	print("AirAttack")
	if Input.is_action_pressed("aim_to_mouse"):
		prior_vel =  -(guy1.global_position - guy1.get_global_mouse_position()).normalized()
		guy1.velocity = prior_vel* guy1.velocity.length()
	elif guy1.curr_out_attked == null:
		prior_vel = guy1.velocity.normalized()
	else:
		prior_vel = -(guy1.global_position - guy1.curr_out_attked.global_position).normalized()
		guy1.velocity = prior_vel* guy1.velocity.length()
		
	speed_mod = 3
	guy1.curr_attk = 2
	guy1.sprite.play("BasicATK")
	guy1.animfx.play("shineGreen")
	timer = 0.5
	
func hit_boxOn()->bool:
	return timer <=0.2 and  timer > 0.19
	
func attack_movement(delta):
	guy1.attack_box.look_at(guy1.position+guy1.velocity)
	if guy1.get_last_slide_collision() != null and guy1.get_last_slide_collision() != Enemy and !changed_dir:
	
	
		var temp_prior_vel = (prior_vel.normalized() + 2*guy1.get_last_slide_collision().get_normal()).normalized() * guy1.velocity.length()/1.5
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
		
	if (guy1.velocity.normalized()  -prior_vel.normalized()).length() > 1.4:
		guy1.velocity= guy1.velocity.normalized() * guy1.MAX_SPEED  * speed_mod
	else:
		guy1.velocity = (prior_vel.normalized() + guy1.direction).normalized() * guy1.MAX_SPEED *speed_mod
	if speed_mod > 0.2:
		speed_mod -= delta* 8
	else:
		speed_mod = 0.2
