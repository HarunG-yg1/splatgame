class_name Enemy_State_Chase extends Enemy_State
##ref to what this state belongs to
@onready var runAway_state = $"../runAway"
@onready var timer = $"../../StateTimer"
@onready var attk_timer = $"../../AttkCDTimer"
@onready var idle_state =$"../idle"
@onready var attack_state = $"../attackMelee"
@onready var stun_state = $"../stun"
var time_on_player : float
func init() -> void:
	pass

#what happens when player enters state
func Enter() ->void:
	enemy.stun = 0
	print("chase" , enemy)
	enemy.random_pt =  Vector2(randi_range(-10,10),randi_range(-10,10))
	enemy.velocity *= 0
	if timer.get_time_left() <= 0.1:
		timer.start(6)


func Exit() ->void:
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:

	if enemy.stun > 0 and timer.get_time_left() < 2:
		print("can attack")
		enemy.enemy_fov.get_child(0).disabled = true
		enemy.player = null
		enemy.chase = false
		return stun_state
	else:
		print( timer.get_time_left(), "time chase")
		enemy.stun = 0 
	if enemy.player!= null and (enemy.global_position - enemy.player.global_position + enemy.random_pt ).length() > 160:
		
		return runAway_state
	if enemy.player!= null and (enemy.global_position - enemy.player.global_position + enemy.random_pt).length() > 120:
		time_on_player -= _delta/5

		enemy.direction = enemy.chase_dir
	if enemy.player!= null and ((enemy.global_position - enemy.player.global_position + enemy.random_pt).normalized() - (enemy.direction)).length() < 0.7  and (enemy.global_position - enemy.player.global_position).length() > 80:
		#print("yoi")
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction/1.2 ).normalized()) * enemy.SPEED * 1.4  , 0.05) 
	elif enemy.player!= null and (enemy.global_position - enemy.player.global_position + enemy.random_pt).length() > 80:
		time_on_player += _delta
		
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction*4).normalized()) * enemy.SPEED * 1.4 , 0.05)
	else:
		
		if  enemy.player!= null and (enemy.global_position - enemy.player.global_position + enemy.random_pt).length() < 80:
			time_on_player += _delta
		enemy.velocity =  lerp(enemy.velocity, Vector2.ZERO,0.05)
		
		if enemy.player!= null and attk_timer.get_time_left() <= 0.1 and time_on_player > 0.5:
			attk_timer.start(5)
			return attack_state

	if timer.get_time_left() <= 0.1 || enemy.player == null:
		enemy.player = null
		enemy.chase = false
		enemy.enemy_fov.get_child(0).disabled = true
	#	enemy.enemy_fov.get_child(1).disabled = true
		return idle_state
	return null
