class_name slide extends state_class

@onready var crouch_move_state = $"../crouch_move"
@onready var move_state =  $"../move"
@onready var dash_state =  $"../dash"
@onready var jump_state = $"../jump"
var prior_rotation : float
var prior_vel_dir : Vector2
func Enter():
	
	prior_vel_dir = guy1.velocity.normalized()
	prior_rotation = guy1.sprite.rotation
	guy1.velocity*= 1.8

	pass
func Process(_delta):
	guy1.sprite.look_at(guy1.velocity)
	print("sliding")
	guy1.velocity += (-prior_vel_dir)*0.0015 + (guy1.direction-prior_vel_dir.normalized())*20
	if (guy1.velocity.normalized()  -prior_vel_dir).length() > 1.2:
		print("ight stop")
		guy1.velocity= guy1.velocity.normalized() * 100
		return crouch_move_state
	

	elif !guy1.crouch:
		return move_state
	elif guy1.run and !guy1.finish_run:
		
		return dash_state 
	if guy1.jumping:
		
		return jump_state

func Exit():
	guy1.crouch=false
	guy1.sprite.rotation=prior_rotation
	pass
