class_name jumpin extends state_class
@onready var idle_state =  $"../idle"
@onready var move_state = $"../move"
@onready var crouch_state = $"../crouching"
@onready var dash_state =  $"../dash"
@onready var block_state = $"../block"
@onready var aerial_attack_state = $"../air_attack"
@onready var attack_state = $"../attack"
@onready var shoot_state = $"../shoot"
@onready var stun_state = $"../stun"
func Enter():

	guy1.velocity *= 0.75
	guy1.set_collision_mask_value(7,false)
	pass
	
func Process(_delta):

	guy1.move(guy1.direction,0.75)
	#if RythmLoader.find_attkType(Color.GREEN) and timer > 0:
		#RythmLoader.setHit_attkType(Color.GREEN)
	if RythmLoader.find_attkType(Color.BLUE) and guy1.jump_vel < 65 and  guy1.jump_vel > -65:
		RythmLoader.setHit_attkType(Color.BLUE)
		if guy1.i_time <= 0:
			guy1.i_time = 0.15

	if  RythmLoader.check_similiar_colour(statemachine.last_defend,Color.BLUE) and  RythmLoader.find_attkType(Color.WHITE) and guy1.jump_vel < 65 and  guy1.jump_vel > -65:
		RythmLoader.setHit_attkType(Color.WHITE)
	
	if !guy1.jumping:
		guy1.set_collision_mask_value(7,true)
		if guy1.crouch:
			return crouch_state
		return move_state
	elif guy1.stun_time > 0:
		return stun_state
	elif guy1.dashing and guy1.jump_vel >=0:
		
		return dash_state
	elif guy1.blocking and  guy1.jump_vel >=-25 and guy1.stun < 0.75:
		
		return block_state
	elif guy1.is_attack and guy1.jump_vel >=-20 :
		if RythmLoader.measure_similiar_color(guy1.curr_attk,Color.BLUE) < 1:
			
			return aerial_attack_state
		else:
			print(RythmLoader.measure_similiar_color(guy1.curr_attk,Color.BLUE),"vro")
			return attack_state
			
		
		

func Exit():

	pass
