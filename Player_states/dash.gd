class_name dash extends state_class
@onready var idle_state =  $"../idle"
@onready var dash_attack_state =  $"../dash_attack"
@onready var move_state = $"../move"
@onready var jump_state = $"../jump"
@onready var slide_state = $"../crouching"
@onready var block_state = $"../block"
var dash_window : float
var boost : float
var remove_endlag := false
func Enter():
	remove_endlag = false
	print("dash")
	dash_window = 0.25
	boost = 5
	guy1.stun = 0

	if  RythmLoader.find_attkType(blood_puddle.puddle_colors.RED):
		RythmLoader.setHit_attkType(blood_puddle.puddle_colors.RED)
		guy1.i_time = 0.25
		guy1.refund_dodge()
		remove_endlag = true


	pass
func Process(delta):
	if  RythmLoader.find_attkType(blood_puddle.puddle_colors.RED):
		RythmLoader.setHit_attkType(blood_puddle.puddle_colors.RED)
		guy1.refund_dodge()
		remove_endlag = true


	if dash_window > 0:
		guy1.move(guy1.direction,boost)
		boost -= delta * 16
		dash_window -= delta
	else:

		return move_state
		
	if guy1.is_attack and dash_window < 0.15:

		return dash_attack_state
	elif guy1.crouch and dash_window < 0.1:


		return slide_state
	elif remove_endlag and guy1.blocking and  dash_window <= 0.1:
		return block_state
	
	
func Exit():
	guy1.dashing = false
	pass
