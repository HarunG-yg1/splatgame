class_name block_move extends block
@onready var block_state =  $".."

func Enter():
	guy1.sprite.play("block")
	timer = 0.4
	if statemachine.old_state == block_state:
		timer = block_state.timer
		consecutive_block = block_state.consecutive_block
	if guy1.was_attk_time > 0.2 :
		
		guy1.stun = 0
		guy1.i_time = 0.25
		consecutive_block += 2
		guy1.animfx.play("parried")
	if Input.is_action_just_pressed("block"):
		print(guy1.was_attk_time )
	pass
	
func Process(_delta):
	guy1.move(guy1.direction,0.4)
	if Input.is_action_just_pressed("block"):
		guy1.sprite.play("block")
	timer -= _delta
	if guy1.was_attk_time > 0.2 and Input.is_action_just_pressed("block"):
		timer = 0.4
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
	
		



func Exit():
	if guy1.curr_attker != null and consecutive_block > 3:
		guy1.curr_attker.parried(guy1.global_position)
		consecutive_block = 0
	if !guy1.blocking:
		guy1.sprite.play("default")
	pass
