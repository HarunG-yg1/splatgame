class_name attack extends state_class

var count : int = 0

@onready var idle_state = $"../idle"
@onready var move_state = $"../move"
@onready var jump_state = $"../jump"
@onready var dash_state = $"../dash"
@onready var block_move_state = $block_move
var timer :=0.4
var rec_enemy : Enemy
func _init() -> void:
	for i in get_children():
		i.guy1 = self.guy1
		i.statemachine = self.statemachine

func Enter():
	count += 1
	rec_enemy = guy1.curr_hitEnemy
	guy1.sprite.play("Attack")
	timer = 0.4
	

	if  rec_enemy != null and guy1.out_attk_time < 0.2 and guy1.out_attk_time > -0.1  and timer > 0:
		timer = 0
		guy1.i_time = 0.2
		print(count,"FUCK YOU",guy1.out_attk_time)
	#	guy1.animfx.play("parried")
		if guy1.curr_hitEnemy != null:
			guy1.curr_hitEnemy.in_attk_time_index += 1
			guy1.curr_hitEnemy.damage(guy1.global_position,1)
			#guy1.curr_hitEnemy.parried(guy1.global_position)
			if rec_enemy.in_attk_time_index < rec_enemy.in_attk_time.size():
				guy1.out_attk_time = rec_enemy.in_attk_time[rec_enemy.in_attk_time_index]
			else:
				rec_enemy.in_attk_time_index = 0
	elif rec_enemy != null and timer > 0 and guy1.out_attk_time < rec_enemy.in_attk_time[rec_enemy.in_attk_time_index]*0.5:
		print(count,"FUCK YOU WHY",guy1.out_attk_time)
		guy1.curr_hitEnemy = null
			


	pass
	
func Process(_delta):
	#print(guy1.out_attk_time)
	timer -= _delta

	if  rec_enemy != null and guy1.out_attk_time < 0.4 and guy1.out_attk_time > -0.2  and Input.is_action_just_pressed("Attack") and timer > 0:
		timer = 0
		guy1.i_time = 0.2
		print(count,"FUCK YOU HERE",guy1.out_attk_time)
	#	guy1.animfx.play("parried")
		if guy1.curr_hitEnemy != null:
			guy1.curr_hitEnemy.in_attk_time_index += 1
			guy1.curr_hitEnemy.damage(guy1.global_position,1)
		#	guy1.curr_hitEnemy.parried(guy1.global_position)
			if rec_enemy.in_attk_time_index < rec_enemy.in_attk_time.size():
				guy1.out_attk_time = rec_enemy.in_attk_time[rec_enemy.in_attk_time_index]
			else:
				rec_enemy.in_attk_time_index = 0
		
	elif rec_enemy != null and timer > 0 and guy1.out_attk_time < rec_enemy.in_attk_time[rec_enemy.in_attk_time_index]*0.5 and Input.is_action_just_pressed("Attack") :
		print(count,"FUCK YOU HERE WHY",guy1.out_attk_time)
		guy1.curr_hitEnemy = null
			

	if timer <= 0:
		return idle_state
		
		
		
	elif guy1.direction.length() > 0.0:
		guy1.move(guy1.direction)
	elif (guy1.velocity.length()) > 1:

		guy1.velocity -= guy1.velocity/15  
		if abs(guy1.velocity.length()) < 1:
			guy1.velocity = Vector2(0,0)

func Exit():
	guy1.signal_attk = false
	pass
