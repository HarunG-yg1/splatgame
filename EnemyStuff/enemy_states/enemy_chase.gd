class_name Enemy_State_Chase extends Enemy_State
##ref to what this state belongs to
@onready var runAway_state = $"../runAway"
@onready var timer = $"../../StateTimer"

@onready var idle_state =$"../idle"
@onready var attack_state = $"../attackMelee"
@onready var stun_state = $"../stun"
var time_on_player : float
func init() -> void:
	pass

#what happens when player enters state
func Enter() ->void:

	print("chase" , enemy)
	enemy.random_pt =  Vector2(randi_range(-10,10),randi_range(-10,10))


	timer.start(5)


func Exit() ->void:
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:

	if enemy.stun > 0 and timer.get_time_left() < 4:
		print("stunned haha")
		enemy.enemy_fov.get_child(0).disabled = true
		timer.stop()
		enemy.chase = false
		return stun_state
	else:
		enemy.stun = 0
	if enemy.player!= null and (enemy.global_position - enemy.player.global_position + enemy.random_pt ).length() > 160:
		
		if runAway_state != null:
			return runAway_state
		else:
			enemy.direction = enemy.chase_dir
	
	if enemy.player!= null and (enemy.global_position - enemy.player.global_position + enemy.random_pt).length() > 100:
	
		time_on_player -= _delta
		enemy.direction = enemy.chase_dir
	
	if enemy.player!= null and (enemy.secondary_vel.normalized() - (enemy.direction)).length() < 0.7  and (enemy.global_position - enemy.player.global_position).length() > 90:
		
		enemy.velocity =  lerp(enemy.velocity,(enemy.secondary_vel.normalized()) * enemy.SPEED * 1.2  ,0.6) 
	
	elif enemy.player!= null and (enemy.global_position - enemy.player.global_position + enemy.random_pt).length() > 90:
		
		time_on_player += _delta
		enemy.velocity =  lerp(enemy.velocity,((enemy.direction)) * enemy.SPEED * 1.2 ,0.6)
	
	else:
		
		if  enemy.player!= null and (enemy.global_position - enemy.player.global_position + enemy.random_pt).length() < 90:
		
			time_on_player += _delta
			
			if (enemy.global_position - enemy.player.global_position + enemy.random_pt).length() < 35:
			
				if ((enemy.secondary_vel).normalized() + (enemy.direction)).length() < 0.7:
					enemy.velocity =  lerp(enemy.velocity,enemy.secondary_vel.normalized() * enemy.SPEED * 0.5 , 0.1)
				else:
					enemy.velocity =  lerp(enemy.velocity,-enemy.direction * enemy.SPEED * 0.5 , 0.2)
			
			elif (enemy.global_position - enemy.player.global_position + enemy.random_pt).length() < 70:
			
				enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + Vector2(enemy.direction.y,enemy.direction.x)*1.05).normalized()) * enemy.SPEED * 0.5 , 0.2)
		
		if enemy.player!= null and time_on_player >= 0.25 and timer.get_time_left() < 4:
			

			return attack_state

	if timer.get_time_left() <= 0.1 || enemy.player == null:
		timer.stop()
		enemy.player = null
		enemy.chase = false
		enemy.enemy_fov.get_child(0).disabled = true
		return idle_state
		
	return null
