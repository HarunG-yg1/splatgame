class_name dive extends slide
@onready var slide_parent_state = $".."
var slide_diving : = true

func Process(_delta):
	guy1.i_time = 1
	if slide_diving:
		guy1.sprite.look_at(guy1.velocity)
	#	print("sliding")
		prior_vel_dir *= 0.98
		guy1.velocity = (prior_vel_dir + guy1.direction*250).normalized() * 250
		if (guy1.velocity.normalized()  -prior_vel_dir.normalized()).length() > 1.4:
		#	print("ight stop")
			slide_diving = false
	
	else:
		guy1.move(guy1.direction)
		
	
	if !guy1.dive_in:
		guy1.jumping = true
		
		guy1.jump()
		return slide_parent_state.crouch_state.jump_state

	if guy1.jumping:
		guy1.dive_in = false
		return slide_parent_state.crouch_state.jump_state

func Exit():
	guy1.current_health += (guy1.arr_of_blood[0]+3)
	guy1.arr_of_blood.pop_front()
	guy1.health_changed.emit(guy1.current_health, guy1.max_health)
	guy1.i_time = 0.25
	guy1.sprite.visible = true
	guy1.crouch=false
	guy1.sprite.rotation=prior_rotation
	pass
