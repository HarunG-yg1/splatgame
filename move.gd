class_name moving extends state_class
@onready var idle_state =  $"../idle"
@onready var block_state =  $"../block"
@onready var crouch_state = $"../crouching"
@onready var dash_state =  $"../dash"
@onready var jump_state = $"../jump"
var had_prior_vel : Vector2
func Enter():
	#print("move")
	pass
func Process(_delta):
	guy1.move(guy1.direction)
	if guy1.direction.length() == 0.0:
		return idle_state
	elif guy1.blocking:
		return block_state
	elif guy1.crouch:
		#print("fuck you")
		return crouch_state
	elif guy1.run and !guy1.finish_run:
		#print("bark")
		return dash_state 
	if guy1.jumping:
		return jump_state

func Exit():
	pass
