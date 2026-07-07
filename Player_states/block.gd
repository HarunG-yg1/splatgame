class_name block extends state_class
@onready var idle_state = $"../idle"
@onready var move_state = $"../move"
@onready var jump_state = $"../jump"
@onready var dash_state = $"../dash"
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
	if Input.is_action_just_pressed("block"):
		print(guy1.was_attk_time )
	if statemachine.old_state == block_move_state:
		timer = block_move_state.timer
		consecutive_block = block_move_state.consecutive_block
	if guy1.was_attk_time > 0.2:
		guy1.stun = 0
		timer = 0
		guy1.i_time = 0.25
		consecutive_block += 2
		guy1.animfx.play("parried")
	pass
	
func Process(_delta):
	timer -= _delta
	if Input.is_action_just_pressed("block"):
		print(guy1.was_attk_time )
	if guy1.was_attk_time > 0.2 and Input.is_action_just_pressed("block") and timer >0.2:
		timer = 0
		guy1.stun = 0
		guy1.i_time = 0.25
		consecutive_block += 2
		
		guy1.animfx.play("parried")
	if timer < 0:
		if consecutive_block > 1:
			consecutive_block -= 1
		guy1.blocking = false
		return idle_state
		
		
	elif guy1.jumping:
		guy1.blocking = false
		return jump_state
		
	elif guy1.run and !guy1.finish_run:
		guy1.blocking = false
		return dash_state

	elif guy1.direction.length() > 0.0:
		return block_move_state
	elif (guy1.velocity.length()) > 1 and !guy1.jumping:

		guy1.velocity -= guy1.velocity/15  
		if abs(guy1.velocity.length()) < 1:
			guy1.velocity = Vector2(0,0)

func Exit():

	if guy1.curr_attker != null and consecutive_block > 3:
		guy1.curr_attker.parried(guy1.global_position)
		consecutive_block = 0
	if !guy1.blocking:
		guy1.sprite.play("default")
	pass
