class_name Enemy_State_Roam extends Enemy_State
##ref to what this state belongs to
@onready var timer = $"../../StateTimer"
@onready var attack_state  = $"../attack"
@onready var dir = $"../dir"
@onready var chasing =$"../chase"
@onready var runaway = $"../runAway"
var pos_recorder : float = 0.1
var prev_pos : Vector2
var result
#what happens when player enters state
func init() -> void:
	pass
	
func Enter() ->void:
#	print("roam")

	timer.start(enemy.choose_randomly([2,4]))
	enemy.UpdateAnimation("walk")
	
	pass
	
#what happens when player enters state
func Exit() ->void:

	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:
	if enemy.hitter is RayCast2D:
		enemy.hitter.rotation += deg_to_rad(0.1)
		if enemy.hitter.get_collider() != null and  enemy.hitter.get_collider() is Player:
			enemy.player =  enemy.hitter.get_collider()
			enemy.chase = true
			
	if pos_recorder>0:
		pos_recorder-=_delta
	else:
		prev_pos = enemy.global_position
		pos_recorder = 0.1
	
	enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction/1.1).normalized()) * enemy.SPEED  , 0.1)
	if enemy.chase and chasing != null:
	#	print("run bro")
		return chasing
		
	elif  enemy.chase  and runaway != null:
		print("run bro")
		return runaway
	if timer.get_time_left() <= 0.01 or (prev_pos == enemy.global_position and pos_recorder<0.01):
		

		return dir
	
	return null
