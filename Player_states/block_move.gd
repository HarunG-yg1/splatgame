class_name block_move extends block
@onready var block_state =  $".."

func Enter():
	guy1.sprite.play("block")
	timer = 0.4
	if statemachine.old_state == block_state:
		timer = block_state.timer
		consecutive_block = block_state.consecutive_block
	if guy1.in_attk_time > -0.11:
		timer = 0
		guy1.health_dec = 0
		guy1.stun = 0
		guy1.i_time = 0.25
		consecutive_block += 2
		guy1.animfx.play("parried")
	if Input.is_action_just_pressed("block"):
		print(guy1.in_attk_time )
	pass
	
func Process(_delta):
	guy1.move(guy1.direction,0.6)
#	if Input.is_action_just_pressed("block"):
	#	guy1.sprite.play("block")
	timer -= _delta
	if guy1.in_attk_time > -0.11 and Input.is_action_just_pressed("block") and timer >= 0:
		timer = 0
		guy1.health_dec = 0
		guy1.stun = 0
		guy1.i_time = 0.25
		consecutive_block += 2

		guy1.animfx.play("parried")

	if timer <= 0:
		if consecutive_block > 1:
			consecutive_block -= 1
		guy1.blocking = false
		return block_state.move_state
		
	elif guy1.jumping:
		guy1.blocking = false
		return block_state.jump_state
		
	elif guy1.run and !guy1.finish_run:
		guy1.blocking = false
		return block_state.dash_state

	elif guy1.direction.length() == 0.0:
		return block_state
	elif guy1.signal_attk:
		return block_state.attack_state
	
		
