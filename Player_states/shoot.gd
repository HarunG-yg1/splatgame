class_name shoot extends attack


func Enter():


	print("Attack")
#	count += 1
#	guy1.curr_attk = 1
	guy1.sprite.play("AimShoot")
#	guy1.animfx.play("shineBlue")
	timer = 0.4
	
func Process(_delta):
	
	#print(guy1.out_attk_time)
	
	
	timer -= _delta
	if timer > 0:
		attack_movement(_delta)

	#if hit_boxOn():
	#	guy1.attack_shape.disabled = false 

	elif timer <= 0:
		
		if statemachine.old_state is not dash and statemachine.old_state is not jumpin and statemachine.old_state is not dive and statemachine.old_state is not block  and statemachine.old_state is not attack:
			
			return statemachine.old_state
		#return idle_state
		else:
			return idle_state 
		
	


	
func Exit():
	guy1.attack_shape.position.x = prior_attack_box_displace 
	guy1.attack_shape.shape.size.x = prior_attack_box_size
	
	guy1.is_shoot = false

func attack_movement(delta):
	if guy1.direction.length() > 0.0:
		guy1.move(guy1.direction,speed_mod)
	elif (guy1.velocity.length()) > 1 :

		guy1.velocity -= guy1.velocity/15  
		if abs(guy1.velocity.length()) < 1:
			guy1.velocity = Vector2(0,0)
