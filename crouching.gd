class_name crouch_idle extends state_class
@onready var idle_state =  $"../idle"
@onready var crouch_move_state = $"../crouch_move"
@onready var dash_state =  $"../dash"
@onready var jump_state = $"../jump"

func Enter():
	print("crouch")
	guy1.velocity = Vector2(0,0)
	
	pass
func Process(_delta):


	if guy1.direction.length() > 0.0:
		return crouch_move_state
	elif !guy1.crouch:
		return idle_state
	elif guy1.jumping:
		guy1.crouch = false
		return jump_state
	elif guy1.run and !guy1.finish_run:
		guy1.crouch = false
		return dash_state 

func Exit():
	pass
