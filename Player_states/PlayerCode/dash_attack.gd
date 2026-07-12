class_name dash_attack extends attack

var prior_vel : Vector2

func Enter():
	print("dashAttack")
	prior_attack_box_size = guy1.attack_shape.shape.size.x
	prior_attack_box_displace = guy1.attack_shape.position.x
	guy1.attack_shape.shape.size.x *= 2
	guy1.attack_shape.position.x -= 24
	if guy1.curr_out_attked == null:
		prior_vel = guy1.velocity#.normalized()
	else:
		prior_vel =  -(guy1.global_position - guy1.curr_out_attked.global_position).normalized() * guy1.velocity.length()
	
		guy1.velocity = prior_vel
	speed_mod = 3
	guy1.curr_attk = 0
	guy1.sprite.play("BasicATK")
	guy1.animfx.play("shineRed")
	timer = 0.4
	
func hit_boxOn()->bool:
	return timer <=0.4 and  timer > 0.38
	
func attack_movement(delta):
	guy1.attack_box.look_at(guy1.position+guy1.velocity)
	#if guy1.direction.length() > 0.0:
	if (guy1.velocity.normalized()  -prior_vel.normalized()).length() > 1.4:
		print("vruh")
		guy1.velocity= guy1.velocity.normalized() * guy1.MAX_SPEED
	else:
		guy1.velocity = (prior_vel.normalized() + guy1.direction).normalized() * guy1.MAX_SPEED *speed_mod
	print("ze speed",speed_mod )
	if speed_mod > 1:
		speed_mod -= delta* 16
	else:
		speed_mod = 1
