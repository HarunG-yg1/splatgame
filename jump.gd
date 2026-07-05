class_name jumpin extends state_class
@onready var idle_state =  $"../idle"
@onready var move_state = $"../move"
@onready var dash_state =  $"../dash"

func Enter():
	print("jump")
	guy1.velocity *= 0.5
	pass
func Process(_delta):
	
	guy1.move(guy1.direction,0.5)
	
	if !guy1.jumping:
		return move_state
	elif guy1.run and !guy1.finish_run:
		return dash_state

func Exit():
	pass
