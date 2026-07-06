class_name dash extends state_class
@onready var idle_state =  $"../idle"
@onready var move_state = $"../move"
@onready var jump_state = $"../jump"
@onready var slide_state = $"../crouching"
var dash_window : float
var boost : float

func Enter():
	#print("dash")
	dash_window = 0.25
	boost = 5
	pass
func Process(delta):

	if dash_window > 0:
		guy1.move(guy1.direction,boost)
		boost -= delta * 16
		dash_window -= delta
	else:
		guy1.finish_run = true
		return move_state

	if guy1.crouch and dash_window < 0.1:

		guy1.finish_run = true
		return slide_state
	
func Exit():
	pass
