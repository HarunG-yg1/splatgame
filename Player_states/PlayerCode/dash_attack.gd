class_name dash_attack extends attack

var prior_vel : Vector2

func Enter():
	guy1.velocity *= 0.5
	print("dashAttack")
	prior_attack_box_size = guy1.attack_shape.shape.size.x
	prior_attack_box_displace = guy1.attack_shape.position.x
	guy1.attack_shape.shape.size.x *= 1.6
	guy1.attack_shape.position.x -= 20
	
	if Input.is_action_pressed("aim_to_mouse"):
		prior_vel =  -(guy1.global_position - guy1.get_global_mouse_position()).normalized() * guy1.velocity.length()
		guy1.velocity = prior_vel
	elif guy1.curr_out_attked != null:
		prior_vel =  -(guy1.global_position - guy1.curr_out_attked.global_position).normalized() * guy1.velocity.length()
		guy1.velocity = prior_vel
	else:
		prior_vel = guy1.velocity

	speed_mod = 3
	guy1.curr_attk = 0
#	guy1.sprite.play("BasicATK")
	guy1.animfx.play("shineRed")
	timer = 0.6

	if RythmLoader.find_attkType(0):
		RythmLoader.setHit_attkType(0)
		guy1.i_time = 0.25


func hit_boxOn()->bool:
	return timer <=0.2 and  timer > 0.19
	
func attack_movement(delta):
	if hit_boxOn():
		#if Input.is_action_pressed("aim_to_mouse"):
	#		prior_vel =  -(guy1.global_position - guy1.get_global_mouse_position()).normalized() * guy1.velocity.length()
	#		guy1.velocity = prior_vel
	
		guy1.sprite.play("BasicATK")

	elif RythmLoader.find_attkType(0):
		RythmLoader.setHit_attkType(0)
		guy1.i_time = 0.25

	guy1.attack_box.look_at(guy1.position+guy1.velocity)
	#if guy1.direction.length() > 0.0:
	if !guy1.attack_shape.disabled:
		if (guy1.velocity.normalized()  -prior_vel.normalized()).length() > 1.4:
			print("vruh")
			guy1.velocity= guy1.velocity.normalized() * guy1.MAX_SPEED
		else:
			guy1.velocity = (prior_vel.normalized() + guy1.direction).normalized() * guy1.MAX_SPEED *speed_mod
		print("ze speed",speed_mod )
		
		if speed_mod > 0.2:
			speed_mod -= delta* 8
		else:
			speed_mod = 0.2
