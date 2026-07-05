class_name crouch_move extends state_class
@onready var crouch_idle_state = $"../crouching"
@onready var move_state =  $"../move"
@onready var dash_state =  $"../dash"
@onready var jump_state = $"../jump"
@onready var slide_state = $"../slide"
var had_prior_vel : Vector2
func Enter():
	print("crouch move")
	
	had_prior_vel = guy1.velocity

	pass
func Process(_delta):
	guy1.move(guy1.direction,0.4)
	
	if had_prior_vel.length() > 100:
		print("crouch move to slide")
		return slide_state
	
	elif guy1.direction.length() == 0.0:
		return crouch_idle_state
	elif !guy1.crouch:
		return move_state
	elif guy1.run and !guy1.finish_run:
		guy1.crouch=false
		return dash_state 
	if guy1.jumping:
		guy1.crouch=false
		return jump_state

func Exit():
	pass
