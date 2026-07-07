class_name crouch_idle extends state_class
@onready var idle_state =  $"../idle"
@onready var move_state =  $"../move"
@onready var crouch_move_state = $"crouch_move"
@onready var slide_state = $"slide"
@onready var dash_state =  $"../dash"
@onready var jump_state = $"../jump"
var had_prior_vel : Vector2

func _init() -> void:
	for i in get_children():
		i.guy1 = self.guy1
		i.statemachine = self.statemachine

		for j in i.get_children():
			j.guy1 = self.guy1
			j.statemachine = self.statemachine


func Enter():
	
	had_prior_vel = guy1.velocity
	#print("crouch")
	
	
	
	pass
func Process(_delta):
	if !guy1.crouch:
		return idle_state
	elif guy1.jumping:
		guy1.crouch = false
		return jump_state
	elif guy1.run and !guy1.finish_run:
		guy1.crouch = false
		return dash_state 
	elif had_prior_vel.length() > 200:
	#	print("crouch to slide")
		return slide_state
	elif guy1.direction.length() > 0.0:
		return crouch_move_state
	elif (guy1.velocity.length()) > 1 and !guy1.jumping:

		guy1.velocity -= guy1.velocity/15  
		if abs(guy1.velocity.length()) < 1:
			guy1.velocity = Vector2(0,0)



func Exit():
	pass
