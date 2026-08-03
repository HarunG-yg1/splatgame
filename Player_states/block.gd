class_name block extends state_class
@onready var idle_state = $"../idle"
@onready var move_state = $"../move"
@onready var jump_state = $"../jump"
@onready var dash_state = $"../dash"
@onready var attack_state = $"../attack"
@onready var stun_state = $"../stun"

var timer :=0.4
var consecutive_block := 0
func _init() -> void:
	for i in get_children():
		i.guy1 = self.guy1
		i.statemachine = self.statemachine

func Enter():
	guy1.sprite.play("block")
	
	if statemachine.old_state is attack:
		timer = 0.8
	else:
		timer = 0.4
		block_n_check_last_state()
	
	pass
	
func Process(_delta):
	
	guy1.move(guy1.direction,0.6)
	if (guy1.direction.length()) <= 0 and !guy1.jumping:

		guy1.velocity -= guy1.velocity/15  
		if abs(guy1.velocity.length()) < 1:
			guy1.velocity = Vector2(0,0)
	timer -= _delta
	
	if timer > 0.15 and timer < 0.4:
		block_n_check_last_state()


	if timer < 0 and !guy1.blocking:
		if consecutive_block > 1:
			consecutive_block -= 1
		
		

			
		if guy1.jumping:
			guy1.blocking = false
			return jump_state
			
		elif guy1.dashing:
			guy1.blocking = false
			return dash_state
		
		elif !guy1.blocking:
			return idle_state 
			
	elif guy1.stun_time > 0:
		return stun_state
func Exit():

	if guy1.curr_in_attker != null and consecutive_block > 8:
		guy1.curr_in_attker.parried(guy1,1.2,1.5)
		consecutive_block = 0
	if !guy1.blocking:
		guy1.sprite.play("block")
	pass

func block_n_check_last_state():
	if RythmLoader.find_attkType(Color.WHITE):
		timer = 0.4

		RythmLoader.setHit_attkType(Color.WHITE)
	#	
		consecutive_block += 2
		guy1.animfx.play("parried")
	if RythmLoader.find_attkType(Color.RED) and statemachine.old_state is dash:
		timer = 0.4

		RythmLoader.setHit_attkType(Color.RED)
		statemachine.last_defend = RythmLoader.add_color(Color.RED,statemachine.last_defend)
		guy1.i_time = 0.15
		consecutive_block += 2
		guy1.animfx.play("parried")
	
	elif RythmLoader.find_attkType(Color.BLUE) and statemachine.old_state is jumpin:
		timer = 0.4

		RythmLoader.setHit_attkType(Color.BLUE)
		statemachine.last_defend = RythmLoader.add_color(Color.BLUE,statemachine.last_defend)
		guy1.i_time = 0.15
		consecutive_block += 2
		guy1.animfx.play("parried")
	
	elif RythmLoader.find_attkType(Color.GREEN) and statemachine.old_state is slide:
		timer = 0.4

		RythmLoader.setHit_attkType(Color.GREEN)
		statemachine.last_defend = RythmLoader.add_color(Color.GREEN,statemachine.last_defend)
		guy1.i_time = 0.15
		consecutive_block += 2
		guy1.animfx.play("parried")
	
