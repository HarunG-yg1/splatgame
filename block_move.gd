class_name block_move extends block
@onready var block_state =  $".."

func Enter():
	guy1.sprite.play("block")
	timer = 0.4
	if statemachine.old_state == block_state:
		timer = block_state.timer
		consecutive_block = block_state.consecutive_block
	pass
	
func Process(_delta):
	guy1.move(guy1.direction,0.4)
	timer -= _delta
	if guy1.stun>0 and timer > 0.125:
		timer = 0
		guy1.stun = 0
		consecutive_block += 2
		if guy1.curr_attker != null:
			guy1.curr_attker.animfx.play("parried")

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
