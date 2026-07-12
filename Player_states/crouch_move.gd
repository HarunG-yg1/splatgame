class_name crouch_move extends crouch_idle
@onready var crouch_idle_state = $".."


func Enter():
#	print("crouch move")
	
	
	guy1.set_collision_mask_value(8,false)
	pass
func Process(_delta):
	guy1.move(guy1.direction,0.4)
	

	if guy1.direction.length() == 0.0:
		return crouch_idle_state
	elif !guy1.crouch:
		guy1.set_collision_mask_value(8,true)
		return crouch_idle_state.move_state
	elif guy1.dashing:
		guy1.set_collision_mask_value(8,true)
		guy1.crouch=false
		return crouch_idle_state.dash_state
	if guy1.jumping:
		guy1.set_collision_mask_value(8,true)
		guy1.crouch=false
		return crouch_idle_state.jump_state
	elif guy1.is_attack:
		return crouch_idle_state.attack_state
	elif guy1.is_shoot:
		return crouch_idle_state.shoot_state
	elif guy1.blocking:
		guy1.set_collision_mask_value(8,true)
		return crouch_idle_state.block_state

func Exit():
	pass
