class_name Enemy_State_Dir extends Enemy_State
##ref to what this state belongs to
@onready var stun_state = $"../stun"
@onready var idle_state = $"../idle"
var left = Vector2.LEFT
var right = Vector2.RIGHT
var up = Vector2.UP
var down = Vector2.DOWN
var move_list : Array = [left,right,up,down]
#var old_dir : Vector2 

func init() -> void:
	pass
#what happens when player enters state
func Enter() ->void:
	print("dir" , enemy)
	move_list.erase(enemy.direction)
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
	
	enemy.direction = enemy.choose_randomly(move_list)

	if move_list.size() < 2:
		move_list = [left,right,up,down]
	return idle_state
