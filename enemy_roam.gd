class_name Enemy_State_Roam extends Enemy_State
##ref to what this state belongs to
@onready var timer = $"../../StateTimer"
#@onready var idle_state =$"../idle"
@onready var dir = $"../dir"
@onready var chasing =$"../chase"
var pos_recorder : float = 0.1
var prev_pos : Vector2
var result
#what happens when player enters state
func init() -> void:
	pass
	
func Enter() ->void:
	print("roam")
	timer.start(enemy.choose_randomly([2,4]))
	enemy.UpdateAnimation("walk")
	
	pass
	
#what happens when player enters state
func Exit() ->void:
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:
	if pos_recorder>0:
		pos_recorder-=_delta
	else:
		prev_pos = enemy.global_position
		pos_recorder = 0.1
	
	enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction/1.1).normalized()) * enemy.SPEED  , 0.1)
	if enemy.chase:
		return chasing
	if timer.get_time_left() <= 0.01 or (prev_pos == enemy.global_position and pos_recorder<0.01):
		

		return dir
	
	return null
