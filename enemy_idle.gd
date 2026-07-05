class_name Enemy_State_Idle extends Enemy_State
##ref to what this state belongs to
@onready var timer = $"../../StateTimer"
@onready var roam =$"../roam"
@onready var chasing =$"../chase"

#what happens when player enters state
func init() -> void:
	pass
func Enter() ->void:
	print("idle")
	timer.start(enemy.choose_randomly([0.5,1.5,2,1]))
	enemy.UpdateAnimation("idle")
	pass
	
#what happens when player enters state
func Exit() ->void:
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:
#	if enemy.direction != Vector2.ZERO:
#		return walk
	enemy.velocity = Vector2.ZERO
	if enemy.chase:
		return chasing
	if timer.get_time_left() <= 0.1:
		
		return roam
	return null
