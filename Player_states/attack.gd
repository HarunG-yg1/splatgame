class_name attack extends state_class

var count : int = 0

@onready var idle_state = $"../idle"
@onready var move_state = $"../move"
@onready var jump_state = $"../jump"
@onready var dash_state = $"../dash"

var timer :=0.4
var rec_enemy : Enemy
func _init() -> void:
	for i in get_children():
		i.guy1 = self.guy1
		i.statemachine = self.statemachine

func Enter():
	count += 1
	rec_enemy = guy1.curr_hitEnemy
	guy1.sprite.play("BasicATK")
	timer = 0.4
	

	if  first_con():
		timer = 0
		guy1.i_time = 0.2
		#print(count,"FUCK YOU",guy1.out_attk_time)
	#	guy1.animfx.play("parried")
		hurt_target()
				
	elif rec_enemy != null  and guy1.signal_attk and guy1.out_attk_time < rec_enemy.in_attk_time[rec_enemy.in_attk_time_index]*0.5:
		#print(count,"FUCK YOU WHY",guy1.out_attk_time)
		missed_target()
	else:
		print( guy1.out_attk_time ,"trugke")
		guy1.gun_has_timed = false
			


	pass
	
func Process(_delta):
	#print(guy1.out_attk_time)
	timer -= _delta


	print("nooo")

	if timer <= 0:
		
		if statemachine.old_state is not dash and statemachine.old_state is not jumpin and statemachine.old_state is not dive and statemachine.old_state is not block  and statemachine.old_state is not attack:
			
			return statemachine.old_state
		#return idle_state
		else:
			return idle_state 
		
		
	elif guy1.direction.length() > 0.0:
		guy1.move(guy1.direction)
	elif (guy1.velocity.length()) > 1:

		guy1.velocity -= guy1.velocity/15  
		if abs(guy1.velocity.length()) < 1:
			guy1.velocity = Vector2(0,0)

func Exit():
	guy1.is_attack = false
	guy1.signal_attk = false
	pass

func missed_target():
	print("oops")
	rec_enemy.in_attk_time_index = 0
	guy1.curr_hitEnemy.parried(guy1.global_position,1.5,-1.5)
	
	guy1.check_knockback.emit(false,rec_enemy)
	
	guy1.curr_hitEnemy = null

func hurt_target():
	if guy1.curr_hitEnemy != null:
			guy1.curr_hitEnemy.in_attk_time_index += 1
			guy1.curr_hitEnemy.damage(floor(guy1.velocity.length()/70)+1,guy1.global_position)
			guy1.curr_hitEnemy.parried(guy1.global_position,0.8,guy1.curr_hitEnemy.in_attk_time[guy1.curr_hitEnemy.in_attk_time_index])
			
			guy1.check_knockback.emit(true,rec_enemy)

				
				
			if rec_enemy.in_attk_time_index < rec_enemy.in_attk_time.size():
				guy1.out_attk_time = rec_enemy.in_attk_time[rec_enemy.in_attk_time_index]
			else:
				rec_enemy.in_attk_time_index = 0
				guy1.curr_hitEnemy.damage(floor(guy1.velocity.length()/70)+1,guy1.global_position)
				guy1.curr_hitEnemy.parried(guy1.global_position,1.5,1)
				guy1.check_knockback.emit(false,rec_enemy)
				guy1.curr_hitEnemy = null

func first_con()->bool:
	return guy1.signal_attk and guy1.same_guy and rec_enemy != null and guy1.out_attk_time < 0.2 and guy1.out_attk_time > -0.1
