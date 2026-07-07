class_name crouch_move extends crouch_idle
@onready var crouch_idle_state = $".."


func Enter():
#	print("crouch move")
	
	

	pass
func Process(_delta):
	guy1.move(guy1.direction,0.4)
	

	if guy1.direction.length() == 0.0:
		return crouch_idle_state
	elif !guy1.crouch:
		return crouch_idle_state.move_state
	elif guy1.run and !guy1.finish_run:
		guy1.crouch=false
		return crouch_idle_state.dash_state
	if guy1.jumping:
		guy1.crouch=false
		return crouch_idle_state.jump_state
	elif guy1.signal_attk:
		return crouch_idle_state.attack_state

func Exit():
	pass
