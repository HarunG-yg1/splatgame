class_name jumpin extends state_class
@onready var idle_state =  $"../idle"
@onready var move_state = $"../move"
@onready var crouch_state = $"../crouching"
@onready var dash_state =  $"../dash"
@onready var block_state = $"../block"
@onready var aerial_attack_state = $"../air_attack"
@onready var shoot_state = $"../shoot"
func Enter():
	if RythmLoader.find_attkType(2):
		RythmLoader.setHit_attkType(2)
		guy1.i_time = 0.2
	#guy1.jump_vel = 0
	#guy1.i_time = 0.16
	guy1.velocity *= 0.75
	guy1.set_collision_mask_value(7,false)
	pass
	
func Process(_delta):

	guy1.move(guy1.direction,0.75)
	if RythmLoader.find_attkType(2) and  guy1.jump_vel <=0:
		RythmLoader.setHit_attkType(2)
		guy1.i_time = 0.2
	if !guy1.jumping:
		guy1.set_collision_mask_value(7,true)
		if guy1.crouch:
			return crouch_state
		return move_state
	elif guy1.dashing and guy1.jump_vel >=0:
		
		return dash_state
	elif guy1.blocking and  guy1.jump_vel >=0 and guy1.stun < 0.75:
		
		return block_state
	elif guy1.is_attack and guy1.jump_vel >=-20 :
		return aerial_attack_state

func Exit():
	if !guy1.crouch:
		guy1.jump_vel = 0
	pass
