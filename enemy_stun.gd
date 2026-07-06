class_name Enemy_State_Stun extends Enemy_State
@onready var timer = $"../../StateTimer"
@onready var idle_state = $"../idle"


func init() -> void:
	pass
func Enter() ->void:
	print("idle")
	timer.start(enemy.stun*2)
	enemy.UpdateAnimation("idle")
	pass
	
#what happens when player enters state
func Exit() ->void:
	enemy.stun = 0
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:

	
	if (enemy.velocity.length()) > 1 :

		enemy.velocity -= enemy.velocity/45  
	elif abs(enemy.velocity.length()) < 1:
		enemy.velocity = Vector2(0,0)
	if timer.get_time_left() <= 0.1:
		
		return idle_state
	return null
