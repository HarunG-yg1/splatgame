class_name Enemy_State_Roam extends Enemy_State
##ref to what this state belongs to
@onready var timer = $"../../StateTimer"
@onready var attack_state  = $"../attack"
@onready var dir = $"../dir"
@onready var chasing =$"../chase"
@onready var runaway = $"../runAway"
@onready var stun_state = $"../stun"
var pos_recorder : float = 0.1
var prev_pos : Vector2

var range_chase := false
#what happens when player enters state
func init() -> void:
	pass
	
func Enter() ->void:
	print("roam" , enemy)
	range_chase = false
	timer.start(enemy.choose_randomly([2,4]))
	enemy.UpdateAnimation("walk")
	
	pass
	
#what happens when player enters state
func Exit() ->void:

	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:
	if enemy.stun > 0:
		print("penis")
		enemy.enemy_fov.get_child(0).disabled = true
		enemy.enemy_fov.get_child(1).disabled = true
		enemy.player = null
		enemy.chase = false
		return stun_state 
	if enemy is ranged:
		enemy.hitter2.rotation += deg_to_rad(0.5)
		if enemy.hitter2.get_collider() != null and  enemy.hitter2.get_collider() is Player and (enemy.global_position - enemy.hitter2.get_collider().global_position).length()>180:
			enemy.player =  enemy.hitter2.get_collider()
			enemy.chase = true
			range_chase = true
	if pos_recorder>0:
		pos_recorder-=_delta
	else:
		prev_pos = enemy.global_position
		pos_recorder = 0.1
	
	enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction/1.1).normalized()) * enemy.SPEED  , 0.1)
	
	if enemy.chase and chasing != null:
		if runaway != null and range_chase:
			return runaway
		return chasing
		
	elif  enemy.chase  and runaway != null:
		
		return runaway
	if timer.get_time_left() <= 0.01 or (prev_pos == enemy.global_position and pos_recorder<0.01):
		

		return dir
	
	return null
