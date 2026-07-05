class_name Enemy_State_Chase extends Enemy_State
##ref to what this state belongs to
@onready var timer = $"../../StateTimer"
@onready var idle_state =$"../idle"

func init() -> void:
	pass

#what happens when player enters state
func Enter() ->void:
	#enemy.cardinal_direction = Vector2.ZERO
	timer.start(10)
	
	await get_tree().create_timer(1).timeout

	enemy.UpdateAnimation("walk")
	pass
	
#what happens when player enters state
func Exit() ->void:
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:

	enemy.velocity = enemy.chase_dir * enemy.SPEED * 1.8
	if abs(enemy.chase_dir.x) > abs(enemy.chase_dir.y):
		enemy.direction = Vector2(enemy.chase_dir.x,0).normalized()
	elif abs(enemy.chase_dir.x) <= abs(enemy.chase_dir.y):
		
		enemy.direction = Vector2(0,enemy.chase_dir.y).normalized()
	
	
	#print(enemy.direction)
	if enemy.SetDirection():
		enemy.AnimDirect()
		enemy.UpdateAnimation("walk")
	
	#enemy.AnimDirect()
	if timer.get_time_left() <= 0.1:
		enemy.player = null
		enemy.chase = false
		return idle_state
	return null
