class_name block extends state_class
@onready var idle_state = $"../idle"
@onready var move_state = $"../move"
@onready var jump_state = $"../jump"
@onready var dash_state = $"../dash"
@onready var attack_state = $"../attack"
@onready var block_move_state = $block_move
var timer :=0.4
var consecutive_block := 0
func _init() -> void:
	for i in get_children():
		i.guy1 = self.guy1
		i.statemachine = self.statemachine

func Enter():
	guy1.sprite.play("block")
	timer = 0.4

	if statemachine.old_state == block_move_state:
		timer = block_move_state.timer
		consecutive_block = block_move_state.consecutive_block
	if RythmLoader.find_attkType(1):
		guy1.stun = 0
		RythmLoader.setHit_attkType(1)
		timer = 0
		guy1.i_time = 0.1
		consecutive_block += 2
		guy1.animfx.play("parried")
	
	pass
	
func Process(_delta):
	guy1.move(guy1.direction,0.6)
	if (guy1.direction.length()) <= 0 and !guy1.jumping:

			guy1.velocity -= guy1.velocity/15  
			if abs(guy1.velocity.length()) < 1:
				guy1.velocity = Vector2(0,0)
	timer -= _delta

	if RythmLoader.find_attkType(1) and timer > 0.15:
		timer = 0
		guy1.stun = 0
		RythmLoader.setHit_attkType(1)
		guy1.i_time = 0.25
		consecutive_block += 2
		guy1.animfx.play("parried")

	if timer < 0:
		if consecutive_block > 1:
			consecutive_block -= 1
		guy1.blocking = false
		
	#	if guy1.signal_attk:
#			return attack_state
			
		if guy1.jumping:
			guy1.blocking = false
			return jump_state
			
		elif guy1.dashing:
			guy1.blocking = false
			return dash_state
		
		else:
			return idle_state 

func Exit():

	if guy1.curr_in_attker != null and consecutive_block > 8:
		guy1.curr_in_attker.parried(guy1,1.2,1.5)
		consecutive_block = 0
	if !guy1.blocking:
		guy1.sprite.play("default")
	pass
