class_name aerial_attack extends attack

var prior_vel : Vector2

func Enter():
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
	timer = 0.4
	
func hit_boxOn()->bool:
	return timer <0.35 and  timer > 0.34
	
func attack_movement(delta):
	guy1.attack_box.look_at(guy1.position+guy1.velocity)
	if (guy1.velocity.normalized()  -prior_vel.normalized()).length() > 1.4:
		guy1.velocity= guy1.velocity.normalized() * guy1.MAX_SPEED  * speed_mod
	else:
		guy1.velocity = (prior_vel.normalized() + guy1.direction).normalized() * guy1.MAX_SPEED *speed_mod
	if speed_mod > 0.2:
		speed_mod -= delta* 8
	else:
		speed_mod = 0.2
